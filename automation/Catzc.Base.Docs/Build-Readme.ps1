<#
.SYNOPSIS
    Generates each conventional folder's README.md from its authored docs source — the writer behind the
    "READMEs are generated" contract.
.DESCRIPTION
    Reads the README registry (configs/readme.yml, via Get-Config -Config readme), expands its glob patterns against...
    [ADR-REPO-README](/docs/adr/repository/generated-readmes.md),
    [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Build-Readme.ps1.md#comment1)
.PARAMETER Folder
    Generate only the mapping whose target folder equals this repo-relative path (e.g.
    [comment:2](/docs/references/automation/catzc-base-docs/Build-Readme.ps1.md#comment2)
.PARAMETER DryRun
    Report what would change without touching the filesystem.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:3](/docs/references/automation/catzc-base-docs/Build-Readme.ps1.md#comment3)
.PARAMETER Silent
    The per-README status lines are verbose-level — shown only when this function is run with -Verbose.
    [comment:4](/docs/references/automation/catzc-base-docs/Build-Readme.ps1.md#comment4)
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

        # Delete-then-write on a change (Write-FileIfChanged): a README that is still a filesystem link to its source...
        # [comment:5](/docs/references/automation/catzc-base-docs/Build-Readme.ps1.md#comment5)
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
