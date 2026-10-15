<#
.SYNOPSIS
    Reproduces every .gitkeep from the one generic authored source — the writer behind the ".gitkeep files
    are generated, README-backed" contract.
.DESCRIPTION
    The folder is the registration: every.gitkeep in the repository (found by a filesystem walk that skips `.git` and...
    [ADR-REPO-README](/docs/adr/repository/generated-readmes.md)
    [comment:1](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment1)
.PARAMETER DryRun
    Report what would change without writing any file.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:2](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment2)
.PARAMETER Silent
    The per-file status lines are verbose-level — -Silent suppresses them entirely, even under -Verbose (used by the...
    [comment:3](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment3)
.PARAMETER PassThru
    Return one result object per .gitkeep ({ Path, Changed, DryRun }) instead of the paths.
.OUTPUTS
    [string[]] The repo-relative paths of the managed .gitkeep files (with -PassThru, one result object per
    file instead).
.EXAMPLE
    Build-GitKeep
    Reproduces every .gitkeep from the authored source.
.EXAMPLE
    Build-GitKeep -DryRun -PassThru
    Reports which .gitkeep files are stale without writing them.
#>
function Build-GitKeep {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $sourcePath = Get-CatzcModuleRoot 'assets/gitkeep'
    Assert-PathExist $sourcePath
    $content = [System.IO.File]::ReadAllText($sourcePath)

    $repositoryRoot = Get-RepositoryRoot

    # Walk the tree for.gitkeep files, skipping git's own store and the vendored modules (not ours to manage).
    # [ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
    # [comment:4](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment4)
    $outputRoot = [System.IO.Path]::Combine($repositoryRoot, 'out')
    $found = [System.Collections.Generic.List[string]]::new()
    $stack = [System.Collections.Generic.Stack[string]]::new()
    $stack.Push($repositoryRoot)
    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()
        if ($directory -ne $outputRoot) {
            foreach ($subdirectory in [System.IO.Directory]::EnumerateDirectories($directory)) {
                $leaf = [System.IO.Path]::GetFileName($subdirectory)
                if ($leaf -in '.git', '.vendor') {
                    continue
                }
                $stack.Push($subdirectory)
            }
        }
        $keepPath = [System.IO.Path]::Combine($directory, '.gitkeep')
        if ([System.IO.File]::Exists($keepPath)) {
            $found.Add((ConvertTo-RepoRelativePath $keepPath))
        }
    }
    $found.Sort([System.StringComparer]::Ordinal)

    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($keep in $found) {
        $changed = Write-FileIfChanged (Resolve-RepoPath $keep) $content -DryRun:$DryRun

        if ($changed -and -not $Silent) {
            $verb = if ($DryRun) {
                'would write'
            }
            else {
                'wrote'
            }
            Write-Message "$verb $keep"
        }
        elseif ($emitVerbose -and -not $Silent) {
            Write-Verbose "unchanged: $keep"
        }

        if ($PassThru) {
            [pscustomobject]@{ Path = $keep; Changed = $changed; DryRun = [bool]$DryRun }
        }
        else {
            $keep
        }
    }

    $ret
}
