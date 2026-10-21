<#
---
catzc:
  immutable:
    with_body_sha: "3ed09a0ae68a"
  edges:
    test: pwsh/Catzc.Azure.DevOps/tests/Get-AdoAuthorizationHeader.Tests.ps1
    docs: "[Get-AdoAuthorizationHeader.ps1.md](docs/references/pwsh/catzc-azure-dev-ops/Get-AdoAuthorizationHeader.ps1.md)"
    cites:
      - ADR-ADO-AUTH
---
#>

function Get-AdoAuthorizationHeader {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $ResourceUrl = '499b84ac-1321-427f-aa17-267ca6975798'
    )

    if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {
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

    Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant

    $result = Invoke-AzCli "account get-access-token --resource $ResourceUrl --query accessToken -o tsv" -PassThru -NoAssert -Silent
    Assert-NotNullOrWhitespace $result.Output -ErrorText (
        'No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run Connect-AzCli with an Entra ID account.'
    )

    @{ 'Authorization' = "Bearer $($result.Output)" }
}
