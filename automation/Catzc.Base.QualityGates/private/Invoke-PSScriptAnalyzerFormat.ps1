<#
.SYNOPSIS
    The psscriptanalyzer formatter engine: formats the given PowerShell files with the vendored analyzer's
    Invoke-Formatter and the .editorconfig rules, and returns the files it changed.
.DESCRIPTION
    One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
    Two steps per file, the same two VS Code's Format Document and save apply:

      1. Invoke-Formatter with the repository's one analyzer settings file — brace placement, indentation, whitespace,
         and hashtable alignment (the codeFormatting settings in vscode-settings.yml mirror the same rules);
      2. the .editorconfig rules Invoke-Formatter does not read — LF line endings, no trailing whitespace, one final
         newline ([ADR-REPO-FORMAT#3](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format3)).

    A file is written back as UTF-8 without a BOM only when the result differs, compared case-sensitively so a
    casing-only change counts. The vendored analyzer and its settings ship in the code tree, so both resolve from
    the code root ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1));
    the first use in a session imports the analyzer, which takes seconds and is announced.
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
        # First use this session pays the vendored-module import (several seconds) — announce it
        # ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/powershell/console-output-matters.md#rule-adr-auto-console10)).
        Write-Message 'Loading PSScriptAnalyzer (first use this session)...'
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
    }
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changed = [System.Collections.Generic.List[string]]::new()
    foreach ($path in $File) {
        $original = [System.IO.File]::ReadAllText($path)
        $text = Invoke-Formatter -ScriptDefinition $original -Settings $settingsPath
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
