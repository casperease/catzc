<#
.SYNOPSIS
    Materialises each conventional folder's README.md as a filesystem link to its authored docs source — the
    writer behind the "READMEs are generated" contract.
.DESCRIPTION
    Reads the README registry (configs/readme.yml, via Get-Config -Config readme), expands its glob patterns
    against the filesystem (Get-ReadmeMappings), and for every resulting mapping ensures `<folder>/README.md`
    is a link to the authored `source` docs file (Set-FileLink, Catzc.Base.Files): the README IS the source,
    so there is no copy to drift, no banner to inject, and an edit through either path lands in the one
    authored file. Relative links inside the article resolve at the source's own location — the authored
    article under docs/ is the reading surface; the README path is a pointer to it.

    The README links are derived artifacts: gitignored (like the generated .psd1 manifests) and excluded from
    the markdown gate — the authored source under docs/references/ is what is checked. Idempotent and fast by
    construction, so the importer runs it on every load (see importer.ps1): a link that already resolves to
    its source is a no-op, and a stale artifact (the old generated copy, a wrong or orphaned link) is
    recreated with the running OS's best mechanism.

    See docs/adr/repository/generated-readmes.md and docs/adr/configuration/module-config-loading.md.
.PARAMETER Folder
    Materialise only the mapping whose target folder equals this repo-relative path (e.g.
    'automation/Catzc.Azure.DevOps'). Throws when it matches no mapping. Default: every mapping.
.PARAMETER DryRun
    Report what would change without touching the filesystem. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The per-README status lines are verbose-level — shown only when this function is run with -Verbose.
    -Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
    -Verbose on does not chatter during import).
.PARAMETER PassThru
    Return one result object per README ({ Folder, Source, Readme, Changed, DryRun }) instead of the paths.
.OUTPUTS
    [string[]] The paths to the README links (with -PassThru, one result object per README instead).
.EXAMPLE
    Build-Readme
    Ensures every mapped README is a link to its docs source.
.EXAMPLE
    Build-Readme -DryRun -PassThru
    Reports which mapped READMEs are stale without touching them.
.EXAMPLE
    Build-Readme 'automation/Catzc.Azure.DevOps'
    Materialises only that folder's README link.
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

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($mapping in $mappings) {
        $sourcePath = Resolve-RepoPath $mapping.source
        $readmePath = Resolve-RepoPath "$($mapping.folder)/README.md"

        # The README IS the source: verified or (re)created as a filesystem link by the one mechanism owner
        # (Set-FileLink, Catzc.Base.Files), which also asserts the source exists.
        $changed = Set-FileLink -Path $readmePath -Target $sourcePath -DryRun:$DryRun

        if (-not $Silent) {
            $verb = if ($changed -and $DryRun) {
                'would link'
            }
            elseif ($changed) {
                'linked'
            }
            else {
                'link current'
            }
            Write-Message "$($mapping.folder)/README.md $verb — to $($mapping.source)" -Verbose:$emitVerbose
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
