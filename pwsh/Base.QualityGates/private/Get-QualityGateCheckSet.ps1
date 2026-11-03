function Get-QualityGateCheckSet {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $present = Get-PresentLanguageName

    $folders = @{}
    $checks = [System.Collections.Generic.List[string]]::new()
    foreach ($language in Get-FileLanguage) {
        if ($present -notcontains $language.name) {
            continue
        }
        foreach ($check in $language.checks) {
            # A folder-governing check runs only where the folder its check_scopes address names exists.
            if ($language.check_scopes -and $language.check_scopes.ContainsKey($check)) {
                $address = $language.check_scopes[$check]
                if (-not $folders.ContainsKey($address)) {
                    $folders[$address] = [System.IO.Directory]::Exists((Resolve-RepoPath "$(Get-ConfigValue -Address $address)"))
                }
                if (-not $folders[$address]) {
                    continue
                }
            }
            if (-not $checks.Contains($check)) {
                $checks.Add($check)
            }
        }
    }
    [string[]] @($checks)
}
