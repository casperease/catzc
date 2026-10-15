<#
.SYNOPSIS
    Renders .vscode/settings.json content from the vscode-settings registry — the glue that keeps the
    editor's behaviour in sync with the tooling.
.DESCRIPTION
    Reads the authored settings registry (configs/vscode-settings.yml, via Get-Config -Config vscode-settings — the...
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment1)
.PARAMETER ManagedTarget
    The managed root-config target paths to complete `search.exclude` with (repo-root-relative).
    [comment:2](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment2)
.PARAMETER MachineSetting
    Settings resolved on this machine at render time, added after the authored ones (an authored key wins).
    [comment:3](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment3)
.PARAMETER LanguageFormatter
    The editor formatter of each language, VS Code language id -> extension id, rendered as that language's...
    [ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)
    [comment:4](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment4)
.OUTPUTS
    [string] The rendered settings.json content (LF-joined; the writer canonicalises).
.EXAMPLE
    New-VSCodeSettings -ManagedTarget '/PSScriptAnalyzerSettings.psd1', 'importer.ps1'
#>
function New-VSCodeSettings {
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
    # Machine-resolved settings complete the authored ones, which win on a shared key; sorted, so the render is stable.
    # [comment:5](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment5)
    foreach ($key in ($MachineSetting.Keys | Sort-Object)) {
        if (-not $settings.Contains($key)) {
            $settings[$key] = $MachineSetting[$key]
        }
    }

    # Each language's editor formatter, merged into its [<id>] block (authored keys in the block win); sorted, so the...
    # [comment:6](/docs/references/automation/catzc-base-vscode/New-VSCodeSettings.ps1.md#comment6)
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

    $header = @(
        '// GENERATED FILE — do not edit. Single source of truth:'
        '//   automation/Catzc.Base.VSCode/configs/vscode-settings.yml (the authored settings + comments)'
        '//   automation/Catzc.Base.RootConfig/configs/rootconfig.yml (the injected search.exclude targets)'
        '//   automation/Catzc.Base.Languages/configs/languages.yml (each language''s editor formatter)'
        '// Regenerated on import by Build-RootConfig; edit the yml, not this file (VS Code reads the // header fine).'
    ) -join "`n"

    $header + "`n" + (ConvertTo-Json -InputObject $settings -Depth 12) + "`n"
}
