<#
.SYNOPSIS
    The psscriptanalyzer formatter engine: formats the given PowerShell files with the vendored analyzer's
    Invoke-Formatter and the .editorconfig rules, and returns the files it changed.
.DESCRIPTION
    Invoke-Formatter ignores .editorconfig, so line endings, trailing space and the final newline are a second step.
    [ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2),
    [ADR-REPO-FORMAT#3](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format3),
    [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md#comment1)
.PARAMETER File
    Absolute paths of the PowerShell files to format.
.PARAMETER DryRun
    List the files that would change without writing them.
.OUTPUTS
    [string[]] Absolute paths of the files changed (or, under -DryRun, that would change).
#>
function Invoke-PSScriptAnalyzerFormat {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $File,

        [switch] $DryRun
    )

    if ($File.Count -eq 0) {
        return , [string[]] @()
    }
    if (-not (Get-Module PSScriptAnalyzer)) {
        # Without this line the several-second vendored analyzer import would look like a hang.
        # [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md#comment2)
        Write-Message 'Loading PSScriptAnalyzer (first use this session)...'
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
    }

    # The settings file's custom analysis rules play no part in formatting, but Invoke-Formatter loads them again on
    # every call (about 45 ms of each 55 ms file), so the formatter gets the same settings without them.
    $settings = @{}
    $declared = Import-PowerShellDataFile -LiteralPath (Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1')
    foreach ($name in $declared.Keys) {
        if ($name -ne 'CustomRulePath') {
            $settings[$name] = $declared[$name]
        }
    }

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($path in $File) {
        $original = [System.IO.File]::ReadAllText($path)
        $text = Invoke-Formatter -ScriptDefinition $original -Settings $settings
        $text = $text -replace "`r`n", "`n"         # end_of_line = lf
        $text = $text -replace '(?m)[ \t]+$', ''    # trim_trailing_whitespace = true
        $text = $text.TrimEnd("`n") + "`n"          # insert_final_newline = true
        # -cne: PowerShell's -ne is case-insensitive, so a casing-only change would otherwise look unchanged.
        if ($text -cne $original) {
            if (-not $DryRun) {
                [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
            }
            $changed.Add($path)
        }
    }

    , [string[]] $changed.ToArray()
}
