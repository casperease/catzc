<#
.SYNOPSIS
    Returns an Authorization header for Azure DevOps REST API calls.
.DESCRIPTION
    Authentication sources, in priority order. Each is proven to target the configured org/tenant
    (ado.yml) before a header is returned — a credential alone never establishes "the right thing".
    1. Pipeline: $env:SYSTEM_ACCESSTOKEN — Bearer token, after asserting $env:SYSTEM_COLLECTIONURI
       matches ado.yml organization (the agent token is scoped to the org the pipeline runs in).
    2. PAT: $env:AZURE_DEVOPS_PAT — Basic auth. A PAT carries no ambient org signal; it is used only
       against ado.yml organization (every API URL is built from it), so it is bound to the configured
       org by construction.
    3. az CLI: asserts the session is in ado.yml's `tenant` (Assert-AzCliConnected), then runs
       az account get-access-token for the ADO resource — Bearer token.

    Returns a hashtable suitable for splatting into Invoke-RestMethod -Headers.
.PARAMETER ResourceUrl
    The Azure AD resource URL for az CLI token requests.
    Defaults to the Azure DevOps resource ID (499b84ac-1321-427f-aa17-267ca6975798).
.EXAMPLE
    $headers = Get-AdoAuthorizationHeader
    Invoke-RestMethod -Uri $url -Headers $headers
#>
function Get-AdoAuthorizationHeader {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $ResourceUrl = '499b84ac-1321-427f-aa17-267ca6975798'
    )

    if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {
        # The agent token is scoped to the org the pipeline runs in — prove that is the configured org.
        $collectionUri = "$env:SYSTEM_COLLECTIONURI".TrimEnd('/')
        $org = "$((Get-Config -Config ado).organization)".TrimEnd('/')
        if ($collectionUri -and $collectionUri -ne $org) {
            throw "Pipeline collection '$collectionUri' does not match ado.yml organization '$org' — refusing the agent token for a different org."
        }
        return @{ 'Authorization' = "Bearer $env:SYSTEM_ACCESSTOKEN" }
    }

    if ($env:AZURE_DEVOPS_PAT) {
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:AZURE_DEVOPS_PAT"))
        return @{ 'Authorization' = "Basic $base64" }
    }

    # Prove the az session is in the Entra directory that backs the org before minting a token.
    # (tenant is a required, validated key — Assert-AdoConfig guarantees it on load.)
    Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant

    $result = Invoke-Executable "az account get-access-token --resource $ResourceUrl --query accessToken -o tsv" -PassThru -NoAssert -Silent
    Assert-NotNullOrWhitespace $result.Output -ErrorText (
        'No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run Connect-AzCli with an Entra ID account.'
    )

    @{ 'Authorization' = "Bearer $($result.Output)" }
}
