<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/New-VSCodeSettings.ps1.md"
  header: "generated"
---
#>

function New-VsCodeSettings {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $ManagedTarget = @(),

        [hashtable] $MachineSetting = @{},

        [System.Collections.IDictionary] $LanguageFormatter = @{},

        # The repository's filters, name to the include/exclude sets each claims by, in lamp order (Get-RepositoryFilter).
        [System.Collections.IDictionary] $Filter = @{},

        # The settings file on disk, read for the rows another writer owns (the carried settings of vscode-settings.yml).
        [string] $CurrentPath = (Join-Path (Get-RepositoryRoot) '.vscode/settings.json')
    )

    $config = Get-Config -Config vscode-settings

    # The typed registry is the cached, read-only config: render from a copy of its settings.
    $settings = [ordered]@{}
    foreach ($key in $config.settings.Keys) {
        $settings[$key] = $config.settings[$key]
    }
    foreach ($key in ($MachineSetting.Keys | Sort-Object)) {
        if (-not $settings.Contains($key)) {
            $settings[$key] = $MachineSetting[$key]
        }
    }

    foreach ($id in ($LanguageFormatter.Keys | Sort-Object)) {
        $key = "[$id]"
        $block = [ordered]@{}
        if ($settings.Contains($key)) {
            foreach ($setting in $settings[$key].Keys) {
                $block[$setting] = $settings[$key][$setting]
            }
        }
        if (-not $block.Contains('editor.defaultFormatter')) {
            $block['editor.defaultFormatter'] = $LanguageFormatter[$id]
        }
        $settings[$key] = $block
    }

    # Complete search.exclude with the managed targets — authored keys win, injected keys append in order.
    $exclude = [ordered]@{}
    if ($settings.Contains('search.exclude')) {
        foreach ($glob in $settings['search.exclude'].Keys) {
            $exclude[$glob] = $settings['search.exclude'][$glob]
        }
    }
    foreach ($target in $ManagedTarget) {
        if (-not $exclude.Contains($target)) {
            $exclude[$target] = $true
        }
    }
    $settings['search.exclude'] = $exclude

    if ($Filter.Count -gt 0) {
        $filters = [ordered]@{}
        foreach ($name in $Filter.Keys) {
            $filters[$name] = @($Filter[$name])
        }
        $settings['catzc.trackLamps.filters'] = $filters
    }

    if ($config.carried.Count -gt 0 -and (Test-Path -LiteralPath $CurrentPath)) {
        $text = (Get-Content -LiteralPath $CurrentPath -Raw) -replace '(?m)^\s*//.*$', ''
        $current = if ([string]::IsNullOrWhiteSpace($text)) {
            @{}
        }
        else {
            ConvertFrom-Json -InputObject $text -AsHashtable
        }
        foreach ($key in $config.carried.Keys) {
            $owner = $config.carried[$key]
            $owned = @(if ($current.ContainsKey($owner)) {
                    $current[$owner]
                })
            if ($owned.Count -eq 0) {
                continue
            }
            $merged = [ordered]@{}
            if ($settings.Contains($key)) {
                foreach ($row in $settings[$key].Keys) {
                    $merged[$row] = $settings[$key][$row]
                }
            }
            $rows = if ($current.ContainsKey($key)) {
                $current[$key]
            }
            else {
                @{}
            }
            foreach ($row in $owned) {
                if (-not $merged.Contains($row) -and $rows.ContainsKey($row)) {
                    $merged[$row] = $rows[$row]
                }
            }
            $settings[$key] = $merged
            $settings[$owner] = $owned
        }
    }

    $json = ConvertTo-Json -InputObject (Resolve-LampPaletteShade -InputObject $settings) -Depth 12
    # A {python.<key>} token names a folder of the python config, read only when a value names one.
    if ($json.Contains('{python.')) {
        $python = Get-Config -Config python
        $json = [regex]::Replace($json, '\{python\.([a-z_]+)\}', { param($m) $python.($m.Groups[1].Value) })
    }
    $json + "`n"
}
