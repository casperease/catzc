<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1
    folder: private
    name: get-glossary-form-violations
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
    test: pwsh/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
    docs: "[Get-GlossaryFormViolations.ps1.md](docs/references/pwsh/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md)"
    cites:
      - ADR-REPO-VOCAB-FAMILYFORMS
---
#>

function Get-GlossaryFormViolations {
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

    [string[]] [Catzc.Base.Docs.GlossaryScan]::Forms([Catzc.Base.Docs.GlossaryEntry[]] @($Entry), [string[]] @($TrackedFile), $Root, $SurfaceCache)
}
