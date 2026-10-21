<#
---
catzc:
  immutable:
    with_body_sha: c21f62ab8ffb
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
    docs: "[Get-GlossaryPhrasingViolations.ps1.md](../../../docs/references/pwsh/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md)"
    cites:
      - ADR-REPO-VOCAB-GLOSSARYSOURCE
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
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
