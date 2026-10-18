<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/private/Get-GlossaryFormViolations.ps1
    folder: private
    name: get-glossary-form-violations
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-docs/private/Get-GlossaryFormViolations.ps1.md
    test: automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
    cites:
      - ADR-REPO-VOCAB#8
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
