<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/private/Get-BicepKeyVaultReferenceViolations.ps1
    folder: private
    name: get-bicep-key-vault-reference-violations
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-BicepKeyVaultReferenceViolations.ps1.md](docs/references/pwsh/catzc-azure-templates/private/Get-BicepKeyVaultReferenceViolations.ps1.md)"
---
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
