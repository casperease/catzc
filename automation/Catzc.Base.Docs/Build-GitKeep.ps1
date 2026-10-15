<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/Build-GitKeep.ps1
    kind: function
    module: Catzc.Base.Docs
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-PWSH-PESTER#9
      - ADR-REPO-README
---
#>

<#
.SYNOPSIS
    Reproduces every .gitkeep from the one generic authored source — the writer behind the ".gitkeep files
    are generated, README-backed" contract.
.DESCRIPTION
    A new .gitkeep demands a reference article: its pointer to README.md is true only for readme-mapped folders.
    [comment:1](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment1)
.PARAMETER DryRun
    The same walk and compare run as a real run, so the report lists exactly the files a real run would rewrite.
    [comment:2](/docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md#comment2)
.PARAMETER Silent
    Silent wins over -Verbose: the status lines stay hidden even when verbose output is switched on.
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
    $text = [System.IO.File]::ReadAllText($sourcePath)
    $sourceRelative = ConvertTo-RepoRelativePath $sourcePath

    $repositoryRoot = Get-RepositoryRoot

    # The out/ root is checked but never descended into: its artifacts may carry fixture copies of .gitkeep.
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
        $content = Format-GeneratedFileHead -Text $text -Path $keep -Carrier placeholder -Generator Build-GitKeep -Source $sourceRelative -Tracked
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
