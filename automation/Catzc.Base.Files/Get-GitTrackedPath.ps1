<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/Get-GitTrackedPath.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Files
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md
      test: automation/Catzc.Base.Files/tests/Get-GitTrackedPath.Tests.ps1
    adrs:
      - ADR-AUTO-CACHE#9
      - ADR-AUTO-TRACKED
      - ADR-PWSH-CACHE#4
  config:
    synopsis: Returns the subset of the given repository paths that git tracks.
    description: |-
      The one place catzc answers `git ls-files -- <paths>`
      ([ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)): every tracked file at or under the given paths, as a
      repo-relative, '/'-separated path ('.' is the whole repository). A path git does not track (new, ignored,
      or absent) contributes nothing, so "is this file under version control?" is a membership test on the
      result. A tracked file deleted from the working tree is still listed — it is still in the index.

      No git process runs: plain `git ls-files` is exactly the index's entry list, so the index file
      (Get-GitIndexPath) is read in-process ([Catzc.Base.Git.GitIndex]). The parsed index is cached per index
      path, keyed on the SHA-256 of its bytes — the key is recomputed from the file on every call, so a
      `git add`/commit/checkout mid-session re-keys it and the answer always matches the index on disk.
    parameters:
      Path: The literal repository-relative, '/'-separated paths (files or folders) to look up; '.' for all.
      ExecutableOnly: |-
        Return only the tracked files stored executable (git mode 100755) — the bit bash needs to run a script
        directly. Read from the same index, in the same order and form.
    outputs: '[string]'
    examples:
      - Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs/glossary.yml'
      - Get-GitTrackedPath 'automation/Catzc.Base.Docs/configs', 'docs/adr'
      - Get-GitTrackedPath '.'
      - 'Get-GitTrackedPath ''automation'' -ExecutableOnly   # the tracked files under automation/ stored as 100755'
---
#>

function Get-GitTrackedPath {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Path,

        [switch] $ExecutableOnly
    )

    $indexPath = Get-GitIndexPath
    if (-not [System.IO.File]::Exists($indexPath)) {
        # A fresh `git init` with nothing added has no index yet: nothing is tracked.
        return
    }

    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:gitIndexCache')) {
        $script:gitIndexCache = @{}
    }

    $content = [System.IO.File]::ReadAllBytes($indexPath)
    $index = $script:gitIndexCache[$indexPath]
    if ($null -eq $index -or $index.ContentHash -ne [Catzc.Base.Git.GitIndex]::HashContent($content)) {
        $index = [Catzc.Base.Git.GitIndex]::Parse($content)
        $script:gitIndexCache[$indexPath] = $index
    }
    if ($ExecutableOnly) {
        return $index.ExecutableUnder($Path)
    }
    $index.Under($Path)
}
