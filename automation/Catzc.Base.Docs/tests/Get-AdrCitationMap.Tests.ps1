<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1
    folder: tests
    name: get-adr-citation-map-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#{3,5}
---
#>

Describe 'Get-AdrCitationMap' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $write = {
            param([string] $Relative, [string[]] $Lines)
            $full = Join-Path $script:root $Relative
            [System.IO.Directory]::CreateDirectory((Split-Path $full -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($full, ($Lines -join "`n"))
        }
        & $write 'docs/adr/index.md' @(
            '| Code | ADR |'
            '| ---- | --- |'
            '| `ADR-TST-WIDGET` | [widget-rules](widget/widget-rules.md) |'
            '| `ADR-TST-GADGET` | [gadget-rules](gadget/gadget-rules.md) |'
        )
        & $write 'docs/adr/widget/widget-rules.md' @('# Widget', '', '### Rule ADR-TST-WIDGET:1', '', 'One.', '', '### Rule ADR-TST-WIDGET:2', '', 'Two.')
        & $write 'docs/adr/gadget/gadget-rules.md' @('# Gadget', '', '### Rule ADR-TST-GADGET:1', '', 'One.')
        & $write 'docs/adr/widget/widget-notes.md' @('# Widget notes')
        & $write 'docs/adr/gadget/widget-notes.md' @('# Gadget notes')
        $script:map = Get-AdrCitationMap -RepositoryRoot $script:root
    }

    It 'maps each code to its repository-relative ADR path and declared rules' -Tag 'ADR-REPO-LINK#3' {
        $map.PathOf('ADR-TST-WIDGET') | Should -BeExactly 'docs/adr/widget/widget-rules.md'
        $map.HasRule('ADR-TST-WIDGET', 2) | Should -BeTrue
        $map.HasRule('ADR-TST-WIDGET', 3) | Should -BeFalse
        $map.CodeOf('docs/adr/gadget/gadget-rules.md') | Should -BeExactly 'ADR-TST-GADGET'
    }

    It 'derives the repository-rooted destination from the citation' -Tag 'ADR-REPO-LINK#3' {
        $map.Destination('ADR-TST-WIDGET', 2) | Should -BeExactly '/docs/adr/widget/widget-rules.md#rule-adr-tst-widget2'
        $map.Destination('ADR-TST-GADGET', $null) | Should -BeExactly '/docs/adr/gadget/gadget-rules.md'
    }

    It 'knows the domain prefix of its codes and rejects an unknown code' -Tag 'ADR-REPO-LINK#5' {
        $map.IsDomainCode('ADR-TST') | Should -BeTrue
        $map.HasCode('ADR-TST-SPROCKET') | Should -BeFalse
    }

    It 'resolves a unique file name and refuses an ambiguous one' -Tag 'ADR-REPO-LINK#3' {
        $map.PathOfSlug('gadget-rules') | Should -BeExactly 'docs/adr/gadget/gadget-rules.md'
        $map.PathOfSlug('widget-notes') | Should -BeNullOrEmpty
        $map.IsAmbiguousSlug('widget-notes') | Should -BeTrue
        $map.IsDocument('docs/adr/gadget/widget-notes.md') | Should -BeTrue
    }
}
