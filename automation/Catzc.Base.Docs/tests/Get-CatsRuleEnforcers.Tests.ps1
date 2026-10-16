<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
    folder: tests
    name: get-cats-rule-enforcers-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-CatsRuleEnforcers' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'repo'
        $tests = Join-Path $script:repo 'automation/Widget/tests'
        $vendor = Join-Path $script:repo 'automation/.vendor/Gadget/tests'
        [void][System.IO.Directory]::CreateDirectory($tests)
        [void][System.IO.Directory]::CreateDirectory($vendor)
        # The citations are assembled from parts so this file's own -Tag scan (the real tree) never sees them as tags.
        $tagged = 'ADR-WI-TAG' + '#1'
        $context = 'ADR-WI-CTX' + '#2'
        $data = 'ADR-WI-DATA' + '#3'
        [System.IO.File]::WriteAllText((Join-Path $tests 'Widget.Tests.ps1'), @"
Describe 'widget' -Tag 'L0', 'logic', '$tagged' {
    Context 'gadget' -Tag:@('$context') {
        It 'holds' { '$data' | Should -Not -BeNullOrEmpty }
    }
}
"@)
        [System.IO.File]::WriteAllText((Join-Path $vendor 'Gadget.Tests.ps1'), "Describe 'gadget' -Tag 'ADR-WI-VENDOR#4' { }")

        function Reset-EnforcerCache {
            InModuleScope Catzc.Base.Docs { $script:catsRuleEnforcersCache = $null }
        }
    }

    BeforeEach {
        Reset-EnforcerCache
        Mock Assert-SourceTree -ModuleName Catzc.Base.Docs { }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'analyzer-adr-map' } {
            @{ analyzers = @{ 'Measure-Widget' = @('ADR-WI-TAG#1', 'ADR-WI-RULE#5') } }
        }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs -ParameterFilter { $Path -eq 'automation' } { Join-Path $script:repo 'automation' }
        Mock ConvertTo-RepoRelativePath -ModuleName Catzc.Base.Docs {
            $Path.Substring($script:repo.Length + 1).Replace('\', '/')
        }
        $script:enforcers = InModuleScope Catzc.Base.Docs { Get-CatsRuleEnforcers }
    }

    AfterAll {
        Reset-EnforcerCache
    }

    It 'credits an analyzer rule from the analyzer map' {
        $script:enforcers['ADR-WI-RULE#5'].Analyzers | Should -Be @('Measure-Widget')
        $script:enforcers['ADR-WI-RULE#5'].Tests | Should -HaveCount 0
    }

    It 'credits a test file for each -Tag citation of Describe and Context, beside its analyzer' {
        $script:enforcers['ADR-WI-TAG#1'].Tests | Should -Be @('automation/Widget/tests/Widget.Tests.ps1')
        $script:enforcers['ADR-WI-TAG#1'].Analyzers | Should -Be @('Measure-Widget')
        $script:enforcers['ADR-WI-CTX#2'].Tests | Should -Be @('automation/Widget/tests/Widget.Tests.ps1')
    }

    It 'ignores a citation-shaped string that is not a -Tag (AST, not text scan), and the vendored tree' {
        $script:enforcers.ContainsKey('ADR-WI-DATA#3') | Should -BeFalse
        $script:enforcers.ContainsKey('ADR-WI-VENDOR#4') | Should -BeFalse
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
