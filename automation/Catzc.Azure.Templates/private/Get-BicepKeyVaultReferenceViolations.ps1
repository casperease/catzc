<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepKeyVaultReferenceViolations.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the ways an ARM Key Vault reference in a parameters file is not well-formed.
.DESCRIPTION
    Only the reference shape is checked, never the secret, which the repository does not hold.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepKeyVaultReferenceViolations.ps1.md#comment1)
.PARAMETER Reference
    The `reference` object of a parameters-file entry.
.OUTPUTS
    [string[]] the violations; empty when the reference is well-formed.
#>
function Get-BicepKeyVaultReferenceViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)] [System.Text.Json.JsonElement] $Reference
    )

    if ($Reference.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
        return 'has a Key Vault reference that is not an object'
    }

    $violations = [System.Collections.Generic.List[string]]::new()

    $vaultIdText = ''
    $keyVault = [System.Text.Json.JsonElement]::new()
    $vaultId = [System.Text.Json.JsonElement]::new()
    if ($Reference.TryGetProperty('keyVault', [ref] $keyVault) -and $keyVault.ValueKind -eq [System.Text.Json.JsonValueKind]::Object) {
        if ($keyVault.TryGetProperty('id', [ref] $vaultId) -and $vaultId.ValueKind -eq [System.Text.Json.JsonValueKind]::String) {
            $vaultIdText = $vaultId.GetString()
        }
    }
    if ($vaultIdText -notmatch '^/subscriptions/.+/providers/Microsoft\.KeyVault/vaults/.+$') {
        $violations.Add('has a Key Vault reference whose keyVault.id is not a vault resource id (/subscriptions/…/providers/Microsoft.KeyVault/vaults/<name>)')
    }

    $secretNameText = ''
    $secretName = [System.Text.Json.JsonElement]::new()
    if ($Reference.TryGetProperty('secretName', [ref] $secretName) -and $secretName.ValueKind -eq [System.Text.Json.JsonValueKind]::String) {
        $secretNameText = $secretName.GetString()
    }
    if ([string]::IsNullOrWhiteSpace($secretNameText)) {
        $violations.Add('has a Key Vault reference without a secretName')
    }

    $secretVersion = [System.Text.Json.JsonElement]::new()
    if ($Reference.TryGetProperty('secretVersion', [ref] $secretVersion) -and $secretVersion.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
        $violations.Add('has a Key Vault reference whose secretVersion is not a string')
    }

    $violations
}
