<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-CommentScope.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PRIN-CONFIG#1
  config:
    synopsis: Lists the files whose long comments live in a comment page, each with its file language and page.
    description: |-
      The one scope Export-Comments, Build-CommentView and Test-Comments share, so the converter, the
      view and the gate can never disagree. It starts from the files Get-LinkScope lists (the tracked files, or the
      given -Path, minus every file the content tools leave as written) and keeps a file when its file language is one
      comments.yml names, comments.yml maps it to a page, and no comments.yml exclude glob matches it (tests and assets by
      default) ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
    parameters:
      RepositoryRoot: The repository root the paths are relative to.
      Path: Optional files or folders to limit the scope to.
    outputs: '[pscustomobject] { File, Extension, Language, Page } per file, in path order.'
---
#>

function Get-CommentScope {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $config = Get-Config -Config comments
    $languages = [System.Collections.Generic.HashSet[string]]::new([string[]] @($config.languages), [System.StringComparer]::OrdinalIgnoreCase)
    $candidates = @(Get-LinkScope -RepositoryRoot $RepositoryRoot -Path $Path | Sort-Object)

    # A folder -Path lists disk files: drop what git ignores (build output), keep new untracked files.
    $engineRoot = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd('\', '/')
    $loadedRoot = [System.IO.Path]::GetFullPath((Get-RepositoryRoot)).TrimEnd('\', '/')
    if ($engineRoot -ieq $loadedRoot -and $candidates.Count -gt 0) {
        $tracked = [System.Collections.Generic.HashSet[string]]::new([string[]] @(Get-GitTrackedPath '.'), [System.StringComparer]::Ordinal)
        $untracked = @($candidates | Where-Object { -not $tracked.Contains($_) })
        $ignored = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        $batchSize = 50
        for ($start = 0; $start -lt $untracked.Count; $start += $batchSize) {
            $batch = $untracked[$start..([Math]::Min($start + $batchSize, $untracked.Count) - 1)]
            $quoted = foreach ($file in $batch) {
                "`"$file`""
            }
            # Exit 0: some paths are ignored, 1: none are; anything else is a git failure.
            $result = Invoke-Executable "git -C `"$engineRoot`" -c core.quotepath=off check-ignore --no-index -- $($quoted -join ' ')" -PassThru -Silent -NoAssert
            if ($result.ExitCode -gt 1) {
                throw "Get-CommentScope: git check-ignore failed ($($result.ExitCode)): $($result.Errors)"
            }
            foreach ($line in @($result.Output -split "`r?`n" | Where-Object { $_ })) {
                $ignored.Add($line.Trim()) | Out-Null
            }
        }
        $candidates = @($candidates | Where-Object { -not $ignored.Contains($_) })
    }

    # The registry's own ForPath, once: a function call per file costs more than the lookup, and the language test is cheaper than the globs.
    $languageRegistry = Get-Config -Config languages
    foreach ($file in $candidates) {
        $language = $languageRegistry.ForPath($file)
        if (-not $language -or -not $languages.Contains($language.name)) {
            continue
        }
        if ($config.IsExcluded($file)) {
            continue
        }
        $page = $config.PageFor($file)
        if (-not $page) {
            continue
        }
        [pscustomobject]@{
            File      = $file
            Extension = [Catzc.Base.QualityGates.CommentLexer]::ExtensionOf($file)
            Language  = $language.name
            Page      = $page
        }
    }
}
