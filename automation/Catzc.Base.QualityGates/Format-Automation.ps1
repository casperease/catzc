<#
.SYNOPSIS
    Auto-formats automation PowerShell files using the repo's PSScriptAnalyzer settings.
.DESCRIPTION
    Runs Invoke-Formatter — the same engine VS Code's PowerShell extension uses for "Format
    Document" — over the automation files in place, one file at a time. The formatting rules are
    read straight from PSScriptAnalyzerSettings.psd1, so the result matches what you get formatting
    in the editor. Logic is never changed; only whitespace, indentation, brace placement, and casing
    are touched. Files are written back as UTF-8 without a BOM (repo convention).

    Hashtable key/value pairs are vertically aligned, matching VS Code's "Format Document"
    (powershell.codeFormatting.alignPropertyValuePairs). This is driven by the psd1's
    PSAlignAssignmentStatement rule, which pairs with PSUseConsistentWhitespace's
    IgnoreAssignmentOperatorInsideHashTable = $true so the aligned spaces are not flagged. Editor,
    Format-Automation, and the analyzer therefore agree on aligned '='.
.PARAMETER Path
    One or more files or directories to format. Defaults to the canonical gated set (Get-AutomationSourceFiles):
    module root *.ps1, private/, tests/, the .internal and .scriptanalyzer infrastructure folders (bootstrap,
    TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config.
.PARAMETER DryRun
    Report which files would change without writing them. The returned list of changed files is the
    same in either mode (observable by return value); -DryRun simply skips the write. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.OUTPUTS
    [string[]] The paths of the files that changed (or, under -DryRun, would change).
.EXAMPLE
    Format-Automation
    Formats the whole automation tree.
.EXAMPLE
    Format-Automation -DryRun
    Returns which files would change without writing them.
.EXAMPLE
    Format-Automation -Path ./automation/Catzc.Base.QualityGates
    Formats just one module.
#>
function Format-Automation {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [switch] $DryRun
    )

    if (-not (Get-Module PSScriptAnalyzer)) {
        # First use this session pays the vendored-module import (several seconds) — announce it (ADR-CONSOLE:10).
        Write-Message 'Loading PSScriptAnalyzer (first use this session)...'
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
    }

    $settingsPath = Join-Path $env:RepositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
    $files = [System.Collections.Generic.List[string]]::new()

    if ($Path) {
        foreach ($item in $Path) {
            if (Test-Path -Path $item -PathType Container) {
                Get-ChildItem -Path $item -Recurse -Include '*.ps1', '*.psm1' -File |
                    ForEach-Object { $files.Add($_.FullName) }
            }
            else {
                $files.Add((Resolve-Path -Path $item).Path)
            }
        }
    }
    else {
        # The canonical gated set — shared with Test-ScriptAnalyzer and the L2 analyzer test so they cannot
        # drift. Includes the .internal/.scriptanalyzer infrastructure folders, the root importer.ps1, and
        # authored .psd1 config; excludes .vendor, .compiled, and generated manifests.
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    # Announce the loop before entering it (ADR-CONSOLE:10): formatting the whole gated set runs Invoke-Formatter
    # per file over hundreds of files, and only CHANGED files print below — so a clean run is otherwise
    # silent for the entire pass and looks hung.
    $announceVerb = if ($DryRun) {
        'Checking'
    }
    else {
        'Formatting'
    }
    Write-Message "$announceVerb $($files.Count) PowerShell file(s) with PSScriptAnalyzer..."

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changedFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        $original = [System.IO.File]::ReadAllText($file)

        # Layer 1 — the PSScriptAnalyzer formatting rules from the psd1 (brace placement, indentation,
        # whitespace, and hashtable alignment). This is exactly what VS Code's "Format Document" runs.
        $text = Invoke-Formatter -ScriptDefinition $original -Settings $settingsPath

        # Layer 2 — the .editorconfig rules the editor applies on save. Invoke-Formatter does NOT read
        # .editorconfig, so we apply it here to match VS Code. Mirrors the root .editorconfig
        # [*] / [*.{ps1,psm1,psd1}] sections. The trailing-whitespace trim also clears the stray space
        # Invoke-Formatter leaves when it moves a closing brace onto its own line.
        $text = $text -replace "`r`n", "`n"         # end_of_line = lf
        $text = $text -replace '(?m)[ \t]+$', ''    # trim_trailing_whitespace = true
        $text = $text.TrimEnd("`n") + "`n"          # insert_final_newline = true

        # -cne (case-SENSITIVE) is required: PowerShell's -ne is case-insensitive, so a casing-only
        # change would otherwise look unchanged and be skipped.
        if ($text -cne $original) {
            if (-not $DryRun) {
                [System.IO.File]::WriteAllText($file, $text, $utf8NoBom)
            }
            $changedFiles.Add($file)
            $verb = if ($DryRun) {
                'would format'
            }
            else {
                'formatted'
            }
            Write-Message "${verb}: $file"
        }
    }

    $summaryVerb = if ($DryRun) {
        'would change'
    }
    else {
        'changed'
    }
    Write-Message "Done. $($changedFiles.Count) of $($files.Count) file(s) $summaryVerb."

    $changedFiles.ToArray()
}
