# PowerShell: ADO pipeline functions — the pwsh spelling of the ado credential and variable rules

The ado domain decides how a REST call selects and proves its credential and how a step sets a pipeline variable. This record holds the pwsh
spelling of those decisions: the two functions' signatures, parameters and behaviour.

## Rules: ADR-PWSH-ADOFUNC

### Rule ADR-PWSH-ADOFUNC-HEADERFUNCTION

**`Get-AdoAuthorizationHeader` returns the `Authorization` header as a hashtable and reads each credential from its environment variable.**
The in-pipeline token is read from the mapped `$env:SYSTEM_ACCESSTOKEN` and its org from `$env:SYSTEM_COLLECTIONURI`, the PAT from
`$env:AZURE_DEVOPS_PAT`, and the az CLI path proves its tenant with `Assert-AzCliConnected` before `Invoke-Executable` mints the token;
`-ResourceUrl` names the token's resource and defaults to the Azure DevOps resource id.

- [The header function](#the-header-function)

### Rule ADR-PWSH-ADOFUNC-VARIABLEFUNCTION

**`Set-AdoPipelineVariable -Name -Value` sets one variable, with `-IsOutput`, `-IsSecret` and `-SanitizeName` as switches.** It throws on a
blank name and on a name holding `.`, `-` or `'` unless `-SanitizeName` is passed, accepts an empty value (`[AllowEmptyString()]`), logs
through `Write-Message` with a secret shown as `***`, and is a no-op outside a pipeline.

- [The variable function](#the-variable-function)

## Context

The ado records state their rules for the ado pipeline and its REST API; the functions that carry them are pwsh. Their signatures change
with the code, so they live in the pwsh tier beside the other engine spellings, and the ado records cite them.

## Decision

### The header function

```powershell
function Get-AdoAuthorizationHeader {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        # Azure AD resource for az CLI token requests; defaults to the Azure DevOps resource ID.
        [string] $ResourceUrl = '499b84ac-1321-427f-aa17-267ca6975798'
    )

    if ((Test-IsRunningInPipeline) -and $env:SYSTEM_ACCESSTOKEN) {
        $collectionUri = "$env:SYSTEM_COLLECTIONURI".TrimEnd('/')
        $org = "$((Get-Config -Config ado).organization)".TrimEnd('/')
        if ($collectionUri -and $collectionUri -ne $org) {
            throw ("Pipeline collection '$collectionUri' does not match ado.yml organization '$org' — " +
                'refusing the agent token for a different org.')
        }
        return @{ 'Authorization' = "Bearer $env:SYSTEM_ACCESSTOKEN" }
    }

    if ($env:AZURE_DEVOPS_PAT) {
        $base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$env:AZURE_DEVOPS_PAT"))
        return @{ 'Authorization' = "Basic $base64" }
    }

    # Prove the az session is in the Entra directory backing the org before minting a token.
    Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant

    $result = Invoke-Executable "az account get-access-token --resource $ResourceUrl --query accessToken -o tsv" -PassThru -NoAssert -Silent
    Assert-NotNullOrWhitespace $result.Output -ErrorText (
        'No ADO token available. Set $env:AZURE_DEVOPS_PAT, or run Connect-AzCli with an Entra ID account.'
    )

    @{ 'Authorization' = "Bearer $($result.Output)" }
}
```

The resource `499b84ac-1321-427f-aa17-267ca6975798` is Azure DevOps's well-known resource id. An Azure Resource Manager path mirrors this
function with the resource `https://management.azure.com/` and the same per-source proof, rather than overloading it.

### The variable function

```powershell
function Set-AdoPipelineVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)] [string] $Name,
        [Parameter(Mandatory, Position = 1)] [AllowEmptyString()] [string] $Value,
        [switch] $IsOutput,
        [switch] $IsSecret,
        [switch] $SanitizeName
    )
    # ...
}
```

- Throws when `$Name` is null or whitespace.
- Throws when `$Name` holds `.`, `-` or `'`, and tells the caller to use underscores or pass `-SanitizeName`, which rewrites `.` and `-` to
  `_` and removes `'` instead.
- Emits the `##vso[task.setvariable]` command with the flags its switches set.
- Logs the name and value through `Write-Message`; with `-IsSecret` the value shows as `***`.
- Calls `Test-IsRunningInPipeline` and skips the emission outside a pipeline, with a verbose message, so a call site needs no guard.

## How this is enforced

- The custom analyzer rule `Measure-NoRawVsoCommand` (`pwsh/.scriptanalyzer/NoRawVsoCommand.psm1`) flags a string literal holding a raw
  `##vso[task.` command, so every variable goes through `Set-AdoPipelineVariable`.

## Consequences

- The ado records read as decisions about the ado pipeline and its API; a change of signature edits this record only.
