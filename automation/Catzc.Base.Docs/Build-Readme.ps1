<#
.SYNOPSIS
    Generates each conventional folder's README.md as a copy-in of its authored docs source — the writer
    behind the "READMEs are generated" contract.
.DESCRIPTION
    Reads the README copy-in registry (configs/readme.yml, via Get-Config -Config readme), expands its glob
    patterns against the filesystem (Get-ReadmeMappings), and for every resulting mapping copies the authored
    `source` docs file out to `<folder>/README.md`, injecting a standard "generated
    file" warning immediately after the source's first H1 title (prepended when the source has no H1). The
    warning names the exact source and renders as an intentional warning in GitHub, Azure DevOps, and VS Code
    (a portable blockquote — none of the three renders a common callout syntax).

    The generated READMEs are derived artifacts: gitignored (like the generated .psd1 manifests) and excluded
    from the markdown gate — the authored source under docs/references/ is what is checked. This function is
    the single source that keeps them current; never hand-edit a generated README.

    Idempotent and fast by construction, so the importer can run it on every load (see importer.ps1):
    output is canonical (UTF-8 no BOM, LF endings, single trailing newline), and a README is rewritten only
    when its composed content differs from what is on disk — compared EOL-insensitively (CR stripped), so a
    CRLF/LF flip never triggers a spurious rewrite. A clean tree is a true no-op.

    See docs/adr/repository/generated-readmes.md and docs/adr/automation/module-config-loading.md.
.PARAMETER Folder
    Regenerate only the mapping whose target folder equals this repo-relative path (e.g.
    'automation/Catzc.Azure.DevOps'). Throws when it matches no mapping. Default: every mapping.
.PARAMETER DryRun
    Report what would change without writing any file. The composed content is the same either way; -DryRun
    only skips the write. See docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The per-README status lines are verbose-level — shown only when this function is run with -Verbose.
    -Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
    -Verbose on does not chatter during import).
.PARAMETER PassThru
    Return one result object per README ({ Folder, Source, Readme, Changed, DryRun }) instead of the paths.
.OUTPUTS
    [string[]] The paths to the generated READMEs (with -PassThru, one result object per README instead).
.EXAMPLE
    Build-Readme
    Regenerates every mapped README from its docs source.
.EXAMPLE
    Build-Readme -DryRun -PassThru
    Reports which mapped READMEs are stale without writing them.
.EXAMPLE
    Build-Readme 'automation/Catzc.Azure.DevOps'
    Regenerates only that folder's README.
#>
function Build-Readme {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Folder,

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $config = Get-Config -Config readme

    $mappings = @(Get-ReadmeMappings -Config $config)
    if ($Folder) {
        $mappings = @($mappings | Where-Object { $_.folder -eq $Folder })
        if ($mappings.Count -eq 0) {
            throw "No README mapping targets folder '$Folder'. See configs/readme.yml."
        }
    }

    $repositoryRoot = Get-RepositoryRoot

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($mapping in $mappings) {
        $sourcePath = Resolve-RepoPath $mapping.source
        Assert-PathExist $sourcePath

        # Normalize the source to LF so composition and the on-disk compare are line-ending agnostic.
        $sourceText = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n", "`n" -replace "`r", "`n"

        # Rebase relative links so they resolve from the generated README's folder, not the source's.
        $sourceDirectory = ([System.IO.Path]::GetDirectoryName($mapping.source)) -replace '\\', '/'
        $sourceText = Update-MarkdownRelativeLink -Content $sourceText -SourceDirectory $sourceDirectory -TargetDirectory $mapping.folder -RepositoryRoot $repositoryRoot

        $sourceLines = $sourceText -split "`n"

        # The portable warning (single-quoted so the markdown code-span backticks stay literal); -f injects
        # the source path. Two blockquote lines, no blank between them (MD028), each within the 140-column
        # line-length limit (MD013).
        $bannerLine1 = '> ⚠️ **Warning — generated file.** This README is a copy-in of `{0}`. Any' -f $mapping.source
        $bannerLine2 = '> corrections to it are gitignored; edit that source and re-run `Build-Readme`.'
        $bannerBody = @($bannerLine1, $bannerLine2)

        # Inject the banner immediately after the first H1 title; prepend it when the source has no H1. The
        # banner controls its own spacing — exactly one blank line on each side — so drop any blank lines the
        # source already had right after the title, else the generated file would carry a double blank (MD012).
        $headingIndex = -1
        for ($i = 0; $i -lt $sourceLines.Count; $i++) {
            if ($sourceLines[$i] -match '^#\s') {
                $headingIndex = $i
                break
            }
        }
        if ($headingIndex -ge 0) {
            $before = @($sourceLines[0..$headingIndex])
            $rest = if ($headingIndex + 1 -lt $sourceLines.Count) {
                @($sourceLines[($headingIndex + 1)..($sourceLines.Count - 1)])
            }
            else {
                @()
            }
        }
        else {
            $before = @()
            $rest = @($sourceLines)
        }

        $skip = 0
        while ($skip -lt $rest.Count -and $rest[$skip] -eq '') {
            $skip++
        }
        $rest = if ($skip -lt $rest.Count) {
            @($rest[$skip..($rest.Count - 1)])
        }
        else {
            @()
        }

        $composedLines = if ($before.Count -gt 0) {
            $before + @('') + $bannerBody + @('') + $rest
        }
        else {
            $bannerBody + @('') + $rest
        }

        # Canonical text: LF joins, exactly one trailing newline.
        $content = (($composedLines -join "`n").TrimEnd("`n")) + "`n"

        $readmePath = Resolve-RepoPath "$($mapping.folder)/README.md"
        # Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
        # (Write-FileIfChanged, Catzc.Base.Files).
        $changed = Write-FileIfChanged -Path $readmePath -Content $content -DryRun:$DryRun

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
            Write-Message "$($mapping.folder)/README.md $verb — from $($mapping.source)" -Verbose:$emitVerbose
        }

        [pscustomobject]@{
            Folder  = $mapping.folder
            Source  = $mapping.source
            Readme  = $readmePath
            Changed = [bool] $changed
            DryRun  = [bool] $DryRun
        }
    }
    $ret = @($ret)

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Readme)
}
