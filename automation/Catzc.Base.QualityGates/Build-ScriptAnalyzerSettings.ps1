<#
.SYNOPSIS
    Generates the repository-root PSScriptAnalyzerSettings.psd1 as a copy-in of the authored analyzer config —
    the writer behind "the root analyzer settings are generated".
.DESCRIPTION
    PSScriptAnalyzer requires its settings file to be a literal hashtable, so the root file cannot be a thin
    "link" to the real config — it must physically contain the settings. To keep one source of truth, the
    authored config lives at automation/.internal/assets/PSScriptAnalyzerSettings.psd1 (committed, gate-checked)
    and this function copies it out to the repository root, prepending a generated-file header. The root copy
    exists so editors and an ad-hoc Invoke-ScriptAnalyzer run from the repository root pick up the same rules the
    gates use; the CustomRulePath entries stay repository-root-relative, so they resolve identically from root.

    The root copy is a derived artifact: gitignored (like the generated .psd1 manifests and README copy-ins) and
    excluded from the analyzer gate — Get-AutomationSourceFiles names only the .internal/assets source. This
    function is the single writer that keeps it current; never hand-edit the root copy — edit the source.

    Idempotent and fast by construction, so the importer runs it on every load (see importer.ps1): output is
    canonical (UTF-8 no BOM, LF endings, single trailing newline), and the file is rewritten only when its
    composed content differs from what is on disk — compared EOL-insensitively (CR stripped), so a CRLF/LF flip
    never triggers a spurious rewrite. A clean tree is a true no-op.

    See docs/adr/automation/powershell/powershell-formatting.md and
    docs/adr/repository/dedicated-output-directory.md.
.PARAMETER DryRun
    Report whether the root copy would change without writing it. The composed content is the same either way;
    -DryRun only skips the write. See docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The status line is verbose-level — shown only under -Verbose. -Silent suppresses it entirely (used by the
    importer tail so a -Verbose session does not chatter during import).
.PARAMETER PassThru
    Return a result object ({ Source, Settings, Changed, DryRun }) instead of the path string.
.OUTPUTS
    [string] The path to the generated root settings file (with -PassThru, the result object instead).
.EXAMPLE
    Build-ScriptAnalyzerSettings
    Regenerates the root PSScriptAnalyzerSettings.psd1 from the authored source.
.EXAMPLE
    Build-ScriptAnalyzerSettings -DryRun -PassThru
    Reports whether the root copy is stale without writing it.
#>
function Build-ScriptAnalyzerSettings {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $repositoryRoot = Get-RepositoryRoot

    # Single source of truth: the authored, committed, gate-checked analyzer config. The root copy is derived
    # from it (out-of-gate, gitignored).
    $sourcePath = Join-Path $repositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $sourcePath

    # Normalize the source to LF so composition and the on-disk compare are line-ending agnostic.
    $sourceText = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n", "`n" -replace "`r", "`n"

    # A generated-file header. PowerShell (and PSScriptAnalyzer's settings parser) treat '#' lines as comment
    # trivia before the hashtable literal, so the file still parses as settings. It names the single source.
    $header = @(
        '# GENERATED FILE — do not edit. Single source of truth:'
        '#   automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
        '# Regenerated on import by Build-ScriptAnalyzerSettings; gitignored. Edit the source, not this copy.'
        '# The root copy exists so editors and an ad-hoc Invoke-ScriptAnalyzer at the repo root use the same rules.'
        ''
    )

    # Canonical text: LF joins, exactly one trailing newline.
    $content = ((($header -join "`n") + $sourceText).TrimEnd("`n")) + "`n"

    $settingsPath = Join-Path $repositoryRoot 'PSScriptAnalyzerSettings.psd1'
    $existing = if (Test-Path $settingsPath) {
        [System.IO.File]::ReadAllText($settingsPath)
    }
    else {
        $null
    }
    # EOL-insensitive compare so a CRLF working tree never trips a rewrite (mirrors Build-Readme and the
    # compiled-type cache guard — see docs/adr/automation/caching.md).
    $existingNormalized = if ($null -ne $existing) {
        $existing -replace "`r", ''
    }
    else {
        $null
    }
    $changed = $content -cne $existingNormalized

    if (-not $DryRun -and $changed) {
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($settingsPath, $content, $utf8NoBom)
    }

    # The status line is verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue
    if (-not $Silent) {
        $verb = if ($DryRun) {
            if ($changed) {
                'would regenerate'
            }
            else {
                'already current'
            }
        }
        else {
            if ($changed) {
                'regenerated'
            }
            else {
                'unchanged'
            }
        }
        Write-Message "PSScriptAnalyzerSettings.psd1 (root) $verb — copy-in of the .internal/assets source" -Verbose:$emitVerbose
    }

    if ($PassThru) {
        return [pscustomobject]@{
            Source   = $sourcePath
            Settings = $settingsPath
            Changed  = [bool] $changed
            DryRun   = [bool] $DryRun
        }
    }

    $settingsPath
}
