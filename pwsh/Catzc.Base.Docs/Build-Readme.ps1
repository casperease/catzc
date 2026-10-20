<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/Build-Readme.ps1
    name: build-readme
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Build-Readme.Tests.ps1
    docs: "[Build-Readme.ps1.md](docs/references/pwsh/catzc-base-docs/Build-Readme.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-CONF-LOADING
      - ADR-REPO-README
---
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

    # The READMEs live in the source tree's folders (pwsh/<Module>/README.md and the like).
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
