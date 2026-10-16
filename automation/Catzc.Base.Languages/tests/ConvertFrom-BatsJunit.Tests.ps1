<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
    folder: tests
    name: convert-from-bats-junit-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'ConvertFrom-BatsJunit' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:report = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot 'assets/bats-widget.xml')
    }

    It 'returns one result per test, in report order, with the file path as package' {
        $results = @(InModuleScope Catzc.Base.Languages -Parameters @{ Text = $script:report } { param($Text) ConvertFrom-BatsJunit -Text $Text })
        @($results | ForEach-Object { "$($_.Package) $($_.Name)" }) | Should -Be @(
            'widget.bats widget spins'
            'widget.bats integrity: widget ships'
            'widget.bats widget waits'
            'nested/gadget.bats widget spins'
        )
    }

    It 'maps a failure to fail with its text, a skip to skip with its reason, and the rest to pass' {
        $results = @(InModuleScope Catzc.Base.Languages -Parameters @{ Text = $script:report } { param($Text) ConvertFrom-BatsJunit -Text $Text })
        @($results.Outcome) | Should -Be @('pass', 'fail', 'skip', 'pass')
        $results[1].Output | Should -BeLike '*line 7*widget output'
        $results[1].Category | Should -Be 'integrity'
        $results[2].Output | Should -Be 'no gadget'
        $results[0].DurationSeconds | Should -Be 0.134
    }

    It 'returns nothing for an empty report' {
        @(InModuleScope Catzc.Base.Languages { ConvertFrom-BatsJunit -Text '' }) | Should -HaveCount 0
    }

    It 'throws with the text of a case outside any .bats file' {
        $text = '<testsuites><testsuite><testcase classname="setup" name="widget"><failure>gadget broke</failure></testcase></testsuite></testsuites>'
        { InModuleScope Catzc.Base.Languages -Parameters @{ Text = $text } { param($Text) ConvertFrom-BatsJunit -Text $Text } } |
            Should -Throw '*failure outside any test*gadget broke*'
    }
}
