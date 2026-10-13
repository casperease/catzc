<#
.SYNOPSIS
    Generates each conventional folder's README.md from its authored docs source — the writer behind the
    "READMEs are generated" contract.
.DESCRIPTION
    Reads the README registry (configs/readme.yml, via Get-Config -Config readme), expands its glob patterns
    against the filesystem (Get-ReadmeMappings), and for every resulting mapping writes `<folder>/README.md`
    as a copy of the authored `source` docs file (Get-ReadmeContent): the source's relative links rebased to
    the README's folder, so every link works where the README is opened, under a line naming the source as
    the one place to edit.

    The READMEs are derived artifacts: gitignored (like the generated .psd1 manifests) and excluded from the
    markdown quality gate — the authored source under docs/references/ is what is checked. Idempotent and fast by
    construction, so the importer runs it on every load (see importer.ps1): Write-FileIfChanged rewrites a
    README only when its composed content differs (EOL-insensitively), and a rewrite is delete-then-write, so a
    README that is a filesystem link is severed and never written through into its source. It writes into the
    catzc source tree, so it runs in source mode only (Assert-SourceTree); a session running a built package
    stops with a named error.

    See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md) and
    [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md).
.PARAMETER Folder
    Generate only the mapping whose target folder equals this repo-relative path (e.g.
    'automation/Catzc.Azure.DevOps'). Throws when it matches no mapping. Default: every mapping.
.PARAMETER DryRun
    Report what would change without touching the filesystem. See
    [ADR-AUTO-DRYRUN](/docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md).
.PARAMETER Silent
    The per-README status lines are verbose-level — shown only when this function is run with -Verbose.
    -Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
    -Verbose on does not chatter during import).
.PARAMETER PassThru
    Return one result object per README ({ Folder, Source, Readme, Changed, DryRun }) instead of the paths.
.OUTPUTS
    [string[]] The paths to the READMEs (with -PassThru, one result object per README instead).
.EXAMPLE
    Build-Readme
    Brings every mapped README up to date with its docs source.
.EXAMPLE
    Build-Readme -DryRun -PassThru
    Reports which mapped READMEs are stale without touching them.
.EXAMPLE
    Build-Readme 'automation/Catzc.Azure.DevOps'
    Generates only that folder's README.
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

    # The READMEs live in the source tree's folders (automation/<Module>/README.md and the like).
    Assert-SourceTree

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
        $readmePath = Resolve-RepoPath "$($mapping.folder)/README.md"

        # Delete-then-write on a change (Write-FileIfChanged): a README that is still a filesystem link to its
        # source is severed, never written through.
        $changed = Write-FileIfChanged -Path $readmePath -Content (Get-ReadmeContent -Mapping $mapping) -DryRun:$DryRun

        if (-not $Silent) {
            $verb = if ($changed -and $DryRun) {
                'would generate'
            }
            elseif ($changed) {
                'generated'
            }
            else {
                'current'
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
