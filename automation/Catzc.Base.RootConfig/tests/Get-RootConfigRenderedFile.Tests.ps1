<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.RootConfig
    relatives:
      page: docs/references/automation/catzc-base-rootconfig/tests/Get-RootConfigRenderedFile.Tests.ps1.md
      source: automation/Catzc.Base.RootConfig/private/Get-RootConfigRenderedFile.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-RootConfigRenderedFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:render = {
            param($Entry) Get-RootConfigRenderedFile -Entry $Entry
        }
        $script:records = @(
            [pscustomobject]@{ Target = 'widgets/alpha/gadget.txt'; Content = "alpha`n" }
            [pscustomobject]@{ Target = 'widgets/beta/gadget.txt'; Content = "beta`n" }
        )
    }

    It 'turns a single-file generator''s string into one record for the entry''s target' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { "rendered`n" }
        $entry = [pscustomobject]@{ target = 'widget.txt'; generator = 'New-Widget' }
        $result = @(InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry)
        $result | Should -HaveCount 1
        $result[0].Target | Should -Be 'widget.txt'
        $result[0].Content | Should -BeExactly "rendered`n"
        Should -Invoke Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig -ParameterFilter { $Name -eq 'New-Widget' -and $Target -eq 'widget.txt' }
    }

    It 'passes a wildcard entry''s records through, one per file, in the generator''s order' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { $records }
        $entry = [pscustomobject]@{ target = 'widgets/*/gadget.txt'; generator = 'New-Widget' }
        $result = @(InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry)
        @($result.Target) | Should -Be @('widgets/alpha/gadget.txt', 'widgets/beta/gadget.txt')
        $result[1].Content | Should -BeExactly "beta`n"
    }

    It 'returns nothing for a wildcard entry whose generator renders no file' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { }
        $entry = [pscustomobject]@{ target = 'widgets/*/gadget.txt'; generator = 'New-Widget' }
        @(InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry) | Should -HaveCount 0
    }

    It 'accepts one record for a literal target that is the record''s own path' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { $records[0] }
        $entry = [pscustomobject]@{ target = 'widgets/alpha/gadget.txt'; generator = 'New-Widget' }
        (InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry).Content | Should -BeExactly "alpha`n"
    }

    It 'throws when a wildcard entry''s generator returns one string' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { "rendered`n" }
        $entry = [pscustomobject]@{ target = 'widgets/*/gadget.txt'; generator = 'New-Widget' }
        { InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry } | Should -Throw '*wildcard target needs one { Target; Content } record*'
    }

    It 'throws when a record does not match the entry''s target, case-sensitively' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { [pscustomobject]@{ Target = 'Widgets/alpha/gadget.txt'; Content = "x`n" } }
        $entry = [pscustomobject]@{ target = 'widgets/*/gadget.txt'; generator = 'New-Widget' }
        { InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry } | Should -Throw "*rendered 'Widgets/alpha/gadget.txt', which does not match*"
    }

    It 'throws when a literal target renders a file besides itself' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { $records }
        $entry = [pscustomobject]@{ target = 'widgets/alpha/gadget.txt'; generator = 'New-Widget' }
        { InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry } | Should -Throw '*does not match*'
    }

    It 'throws on output that is neither one string nor records' {
        Mock Invoke-RootConfigGenerator -ModuleName Catzc.Base.RootConfig { 'one', 'two' }
        $entry = [pscustomobject]@{ target = 'widget.txt'; generator = 'New-Widget' }
        { InModuleScope Catzc.Base.RootConfig $render -ArgumentList $entry } | Should -Throw '*must return one string or { Target; Content } records*'
    }
}
