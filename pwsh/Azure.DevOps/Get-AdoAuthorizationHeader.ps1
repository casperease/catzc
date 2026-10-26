function Get-AdoAuthorizationHeader {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $ResourceUrl = '499b84ac-1321-427f-aa17-267ca6975798'
    )

    # Sources run in a fixed order, the pipeline's mapped system token first, and every caller takes its header here.
    if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {
        # The agent token is scoped to the org the pipeline runs in, so that org is proved to be the configured one.
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

    # The session must sit in the Entra directory that backs the org before a token is minted; tenant is a required key.
    Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant

    # The last source yields a token or says how to get one.
    $result = Invoke-AzCli "account get-access-token --resource $ResourceUrl --query accessToken -o tsv" -PassThru -NoAssert -Silent
    Assert-NotNullOrWhitespace $result.Output -ErrorText (
        'No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run Connect-AzCli with an Entra ID account.'
    )

    @{ 'Authorization' = "Bearer $($result.Output)" }
}
