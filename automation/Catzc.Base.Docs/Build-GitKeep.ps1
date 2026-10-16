<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/Build-GitKeep.ps1
    name: build-git-keep
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md
    test: automation/Catzc.Base.Docs/tests/Build-GitKeep.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-PWSH-PESTER#9
      - ADR-REPO-README
  config:
    synopsis: |-
      Reproduces every .gitkeep from the one generic authored source — the writer behind the ".gitkeep files
      are generated, README-backed" contract.
    description: |-
      The folder is the registration: every .gitkeep in the repository (found by a filesystem walk that skips
      `.git` and the vendored modules) is a managed copy of this module's assets/gitkeep (located through
      Get-CatzcModuleRoot, so it resolves inside the loaded module in both run modes) — a generic text saying the file
      keeps its folder tracked and that the folder's story lives in its README.md. That pointer is honest
      because an integrity test requires every .gitkeep folder to be a readme-mapped target (a docs/references
      article Build-Readme copies in), so adding a .gitkeep anywhere demands its reference article — the gap
      finder for the reference docs.

      Idempotent and fast by construction, so the importer runs it on every load beside Build-Readme: writes go
      through Write-FileIfChanged (canonical output, EOL-insensitive compare, write only on drift). .gitkeep
      files are committed — tracking the folder is their whole job — so a source change lands as a reviewable
      diff across every location. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
    parameters:
      DryRun: |-
        Report what would change without writing any file. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
      Silent: |-
        The per-file status lines are verbose-level — -Silent suppresses them entirely, even under -Verbose
        (used by the importer tail).
      PassThru: Return one result object per .gitkeep ({ Path, Changed, DryRun }) instead of the paths.
    outputs: |-
      [string[]] The repo-relative paths of the managed .gitkeep files (with -PassThru, one result object per
      file instead).
    examples:
      - |-
        Build-GitKeep
        Reproduces every .gitkeep from the authored source.
      - |-
        Build-GitKeep -DryRun -PassThru
        Reports which .gitkeep files are stale without writing them.
---
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
        $content = Format-GeneratedFileHead -Text $text -Path $keep -Carrier placeholder -Generator Build-GitKeep -Source $sourceRelative -FileKind (Get-FileKind $keep)
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
