<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1
    kind: private-function
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-VOCAB#2
      - ADR-REPO-VOCAB#5
---
#>

<#
.SYNOPSIS
    Lists the uses of avoided phrasings within each glossary source's scope (check G4) — one message per use.
.DESCRIPTION
    A phrase in backticks or quotes is a mention and exempt, so the vocabulary can talk about itself.
.PARAMETER Entry
    The merged glossary, as Get-Glossary returns it. Defaults to the repository's glossary.
.PARAMETER TrackedFile
    The repo-relative, '/'-separated tracked files to consider. Defaults to every file git tracks.
.PARAMETER Root
    The directory the tracked files are relative to. Defaults to the repository root.
.PARAMETER SurfaceCache
    Test-Glossary shares one table with the forms check, so a run reads each file's prose only once.
.OUTPUTS
    [string[]] One message per use — `<file>:<line> says "<phrase>" — say "<say>" (<defined_by>)` — in file then
    line order; empty when prose avoids every avoided phrasing.
.EXAMPLE
    Get-GlossaryPhrasingViolations
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

    # The scan is compiled and fills the surface cache once, then matches every avoided phrasing over its scope.
    # [comment:3](/docs/references/automation/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md#comment3)
    [string[]] [Catzc.Base.Docs.GlossaryScan]::Phrasing([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
