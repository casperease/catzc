<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Docs
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md
      test: automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
    adrs:
      - ADR-REPO-VOCAB#{2,5}
  config:
    synopsis: Lists the uses of avoided phrasings within each glossary source's scope (check G4) — one message per use.
    description: |-
      An avoided phrasing blurs a defined term, so prose within its source's scope never uses it
      ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)). For every source whose
      `checks` include `avoid`,
      this reads the tracked files its `scope` matches and its `exclude` does not
      ([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)), on the text
      surfaces its `surfaces` name:
        - markdown — the prose of `*.md` files: fenced code blocks are skipped;
        - comments — PowerShell comments that are not comment-based help;
        - help — comment-based help (a block comment holding .SYNOPSIS or .DESCRIPTION);
        - messages — the static text of the strings passed to `throw`, `Write-Message`, `Write-Warning`,
          `Write-Error`, and `Write-Host`, and of any `-ErrorText` or `-Because` value; an expandable string
          contributes its literal text only.
      PowerShell files (`*.ps1`, `*.psm1`) are read through the parser, never by regex. A phrase matches
      case-insensitively, as whole words, with any whitespace between its words (so a wrapped line still counts).
      A mention — the phrase inside backticks, "double" or “curly” quotes, within one paragraph — is exempt, so the
      vocabulary can talk about itself. Globs are the repository's one glob dialect (Catzc.Base.Globs.GlobPattern).

      Private helper for the glossary checks; not exported.
    parameters:
      Entry: The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
      TrackedFile: The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
      Root: The directory the tracked files are relative to. Defaults to the repository root.
      SurfaceCache: |-
        The text surfaces already read, keyed by tracked file, each value the file's Catzc.Base.Docs.GlossarySegment array
        (Catzc.Base.Docs.GlossaryProse): a file read once is not read again. Test-Glossary hands the
        same table to this check and to the forms check (G6, Get-GlossaryFormViolations), which read the same surfaces of
        the same files under the same root, so one run reads each file's prose once. Defaults to an empty table.
    outputs: |-
      [string[]] One message per use — `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)` — in file then
      line order; empty when prose avoids every avoided phrasing.
    examples:
      - Get-GlossaryPhrasingViolations
---
#>

function Get-GlossaryPhrasingViolations {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [AllowEmptyCollection()]
        [Catzc.Base.Docs.GlossaryEntry[]] $Entry = (Get-Glossary),

        [AllowEmptyCollection()]
        [string[]] $TrackedFile = @(Get-GitTrackedPath '.'),

        [string] $Root = (Get-RepositoryRoot),

        [hashtable] $SurfaceCache = @{}
    )

    [string[]] [Catzc.Base.Docs.GlossaryScan]::Phrasing([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
