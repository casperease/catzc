<#
---
catzc:
  immutable:
    with_body_sha: "9b47b7762509"
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodeSettings.Tests.ps1
    docs: "[New-VSCodeSettings.ps1.md](docs/references/pwsh/catzc-base-vs-code/New-VSCodeSettings.ps1.md)"
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-ROOTCFG
---
#>

function New-VsCodeSettings {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $ManagedTarget = @(),

        [hashtable] $MachineSetting = @{},

        [System.Collections.IDictionary] $LanguageFormatter = @{}
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

    (ConvertTo-Json -InputObject $settings -Depth 12) + "`n"
}
