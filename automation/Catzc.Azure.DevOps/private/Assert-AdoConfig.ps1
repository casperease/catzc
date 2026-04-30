<#
.SYNOPSIS
    Validates configs/ado.yml and throws with all violations collected.
.DESCRIPTION
    Required shape (the coupling that binds this repo to one Azure DevOps org — the single source of
    truth for which org/tenant is the *correct* thing to be connected to):
      organization: the org REST URL (https://dev.azure.com/<org> or https://<org>.visualstudio.com)
      project:      default project (non-empty; may be URL-encoded)
      tenant:       Entra (Azure AD) tenant GUID backing the org — the directory every auth path must be
                    proven to target before Get-AdoAuthorizationHeader returns a header.

    Keys are snake_case (enforced by Assert-YmlNaming). Run on load by Get-Config (convention:
    Assert-<TitleCase(name)>Config). Mirrors Assert-AzureConfig (collect-all-then-throw).
.PARAMETER Config
    The parsed ado.yml (hashtable).
#>
function Assert-AdoConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Config
    )

    Assert-YmlNaming $Config

    $errors = [System.Collections.Generic.List[string]]::new()

    foreach ($key in 'organization', 'project', 'tenant') {
        if (-not $Config.Contains($key)) {
            $errors.Add("Missing required key: '$key'")
        }
    }
    if ($errors.Count -gt 0) {
        throw "ado configuration validation failed:`n$($errors -join "`n")"
    }

    if ("$($Config.organization)" -notmatch '^https://\S+$') {
        $errors.Add("organization '$($Config.organization)' is invalid (must be an https:// Azure DevOps org URL, e.g. https://dev.azure.com/<org>)")
    }
    if ([string]::IsNullOrWhiteSpace($Config.project)) {
        $errors.Add('project is empty')
    }
    if (-not (Test-IsGuid $Config.tenant)) {
        $errors.Add("tenant '$($Config.tenant)' is invalid (must be a GUID — the Entra tenant backing the org)")
    }

    if ($errors.Count -gt 0) {
        throw "ado configuration validation failed:`n$($errors -join "`n")"
    }
}
