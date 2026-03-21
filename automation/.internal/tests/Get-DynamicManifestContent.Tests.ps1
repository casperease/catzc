Describe 'Get-DynamicManifestContent' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'produces byte-identical output for identical inputs (deterministic)' {
        $first = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/B.ps1', 'A.ps1') -FunctionToExport @('A') }
        $second = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/B.ps1', 'A.ps1') -FunctionToExport @('A') }
        $first | Should -BeExactly $second
    }

    It 'emits forward-slash paths and a single trailing newline' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('private/Get-Foo.ps1') -FunctionToExport @('Get-Foo') }
        $text | Should -Match 'private/Get-Foo\.ps1'
        $text | Should -Not -Match '\\'
        $text.EndsWith("`n") | Should -BeTrue
        $text.EndsWith("`n`n") | Should -BeFalse
    }

    It 'renders empty collections as @()' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('A.ps1') -FunctionToExport @('A') }
        $text | Should -Match 'CmdletsToExport   = @\(\)'
        $text | Should -Match 'VariablesToExport = @\(\)'
    }

    It 'exports every function as a wildcard under -ExportAll' {
        $text = InModuleScope Catzc.Internal.Bootstrap { Get-DynamicManifestContent -NestedModule @('A.ps1') -ExportAll }
        $text | Should -Match "FunctionsToExport = @\('\*'\)"
    }
}

Describe 'Get-DynamicManifestContent is formatter-stable' -Tag 'L2', 'integrity' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.internal/Catzc.Internal.Bootstrap.psm1') -Force
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        $script:settingsPath = Join-Path $env:RepositoryRoot 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'Invoke-Formatter leaves a generated manifest byte-for-byte unchanged' {
        # The published manifest is a versioned immutable artifact, so its canonical form must equal what the
        # repo formatter would produce — otherwise a later touch would re-format and churn the gold bytes.
        $text = InModuleScope Catzc.Internal.Bootstrap {
            Get-DynamicManifestContent -NestedModule @('private/Get-TestSkipReason.ps1', 'Test-Spelling.ps1') -FunctionToExport @('Test-Spelling')
        }
        $formatted = Invoke-Formatter -ScriptDefinition $text -Settings $settingsPath
        $formatted | Should -BeExactly $text
    }
}
