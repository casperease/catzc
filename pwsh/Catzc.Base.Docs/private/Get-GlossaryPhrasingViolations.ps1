<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-GlossaryPhrasingViolations.ps1
    folder: private
    name: get-glossary-phrasing-violations
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
    docs: "[Get-GlossaryPhrasingViolations.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-GlossaryPhrasingViolations.ps1.md)"
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
