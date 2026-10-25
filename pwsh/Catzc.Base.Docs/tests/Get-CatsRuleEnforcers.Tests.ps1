<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Get-CatsRuleEnforcers' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $tests = Join-Path $script:repo 'widget-modules/Widget/tests'
        $vendor = Join-Path $script:repo 'widget-modules/.vendor/Gadget/tests'
        [void][System.IO.Directory]::CreateDirectory($tests)
        [void][System.IO.Directory]::CreateDirectory($vendor)
        # The citations are assembled from parts so this file's own -Tag scan (the real tree) never sees them as tags.
        $tagged = 'ADR-WIDGET-GADGET-' + 'TAG'
        $context = 'ADR-WIDGET-GADGET-' + 'CONTEXT'
        $data = 'ADR-WIDGET-GADGET-' + 'DATA'
        [System.IO.File]::WriteAllText((Join-Path $tests 'Widget.Tests.ps1'), @"
Describe 'widget' -Tag 'L0', 'logic', '$tagged' {
    Context 'gadget' -Tag:@('$context') {
        It 'holds' { '$data' | Should -Not -BeNullOrEmpty }
    }
}
"@)
        [System.IO.File]::WriteAllText((Join-Path $vendor 'Gadget.Tests.ps1'), "Describe 'gadget' -Tag '$('ADR-WIDGET-GADGET-' + 'VENDOR')' { }")

        function Reset-EnforcerCache {
            InModuleScope Catzc.Base.Docs { $script:catsRuleEnforcersCache = $null }
        }
    }

    BeforeEach {
        Reset-EnforcerCache
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'analyzer-drs-map' } {
            @{ analyzers = @{ 'Measure-Widget' = @('ADR-WIDGET-GADGET-TAG', 'ADR-WIDGET-GADGET-RULE') } }
        }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.Docs { Join-Path $script:repo 'widget-modules' }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.Docs {
            $Path.Substring($script:repo.Length + 1).Replace('\', '/')
        }
        $script:enforcers = InModuleScope Catzc.Base.Docs { Get-CatsRuleEnforcers }
    }

    AfterAll {
        Reset-EnforcerCache
    }

    It 'credits an analyzer rule from the analyzer map' {
        $script:enforcers['ADR-WIDGET-GADGET-RULE'].Analyzers | Should -Be @('Measure-Widget')
        $script:enforcers['ADR-WIDGET-GADGET-RULE'].Tests | Should -HaveCount 0
    }

    It 'credits a test file for each -Tag citation of Describe and Context, beside its analyzer' {
        $script:enforcers['ADR-WIDGET-GADGET-TAG'].Tests | Should -Be @('widget-modules/Widget/tests/Widget.Tests.ps1')
        $script:enforcers['ADR-WIDGET-GADGET-TAG'].Analyzers | Should -Be @('Measure-Widget')
        $script:enforcers['ADR-WIDGET-GADGET-CONTEXT'].Tests | Should -Be @('widget-modules/Widget/tests/Widget.Tests.ps1')
    }

    It 'ignores a citation-shaped string that is not a -Tag (AST, not text scan), and the vendored tree' {
        $script:enforcers.ContainsKey('ADR-WIDGET-GADGET-DATA') | Should -BeFalse
        $script:enforcers.ContainsKey('ADR-WIDGET-GADGET-VENDOR') | Should -BeFalse
        $script:enforcers.ContainsKey('L0') | Should -BeFalse
    }
}

Describe 'Get-CatsRuleEnforcers source-tree guard' -Tag 'L0', 'logic' {
    It 'refuses before reading anything when the session runs a built package' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { throw 'widget operates on the catzc source tree' }
        Mock Get-Config -ModuleName Catzc.Base.Docs { }
        { InModuleScope Catzc.Base.Docs { Get-CatsRuleEnforcers } } | Should -Throw '*source tree*'
        Should -Invoke Get-Config -ModuleName Catzc.Base.Docs -Times 0
    }
}
