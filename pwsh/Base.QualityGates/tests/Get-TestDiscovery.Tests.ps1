Describe 'Get-TestDiscovery' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:drive = $TestDrive
        $script:cachePath = [System.IO.Path]::Combine($TestDrive, 'out', 'cache', 'test-discovery.json')
        $script:widgetFile = [System.IO.Path]::Combine($TestDrive, 'tests', 'Widget.Tests.ps1')
        $script:gadgetFile = [System.IO.Path]::Combine($TestDrive, 'tests', 'Gadget.Tests.ps1')
        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::Combine($TestDrive, 'tests'))
        [System.IO.File]::WriteAllText($script:widgetFile, @'
Describe 'WidgetFixture' -Tag 'L0', 'logic' {
    It 'one' -Tag 'ADR-AUTO-CACHE-STATICCONFIGREADS' { throw 'discovery must never execute a test body' }
    Context 'inner' -Tag 'extra' {
        It 'two' { throw 'discovery must never execute a test body' }
    }
}
'@)
        [System.IO.File]::WriteAllText($script:gadgetFile, @'
Describe 'GadgetFixture' -Tag 'L1', 'integrity' {
    It 'three' { throw 'discovery must never execute a test body' }
}
'@)
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { [System.IO.Path]::Combine($script:drive, 'out') }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:drive }
        Mock Invoke-Pester -ModuleName Catzc.Base.QualityGates {
            & (Get-Command Invoke-Pester -Module Pester -CommandType Function) -Configuration $Configuration
        }
        $script:discover = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = [System.IO.Path]::Combine($script:drive, 'tests') } {
                param($Path)
                Get-TestDiscovery -TestPath $Path
            }
        }
    }

    It 'discovers every test in the given folders without running any' {
        $discovery = & $script:discover

        # The throwing bodies prove nothing ran, so SkipRun held.
        $discovery.Tests | Should -HaveCount 3
        @($discovery.Tests.Result) | Should -Be @('NotRun', 'NotRun', 'NotRun')
        ($discovery.Tests | Where-Object ExpandedName -eq 'one' | Select-Object -First 1).Block.Tag | Should -Contain 'L0'
    }

    It 'carries the properties the readers use, with their types' {
        $discovery = & $script:discover
        $one = $discovery.Tests | Where-Object ExpandedName -eq 'one' | Select-Object -First 1
        $two = $discovery.Tests | Where-Object ExpandedName -eq 'two' | Select-Object -First 1

        $one.Tag | Should -Be @('ADR-AUTO-CACHE-STATICCONFIGREADS')
        $one.Tag | Should -BeOfType [string]
        $one.ExpandedPath | Should -Be 'WidgetFixture.one'
        $one.ScriptBlock.File | Should -Be $script:widgetFile
        $one.ScriptBlock.StartPosition.StartLine | Should -BeOfType [int]
        $one.ScriptBlock.StartPosition.StartLine | Should -Be 2
        $one.Block.IsRoot | Should -BeFalse
        $one.Block.Parent.IsRoot | Should -BeTrue
        $two.ExpandedPath | Should -Be 'WidgetFixture.inner.two'
        $two.Block.Tag | Should -Be @('extra')
        $two.Block.Parent.Tag | Should -Be @('L0', 'logic')
        $two.Block.Parent.Parent.IsRoot | Should -BeTrue
    }

    It 'writes the cache keyed on path and content digest' {
        [System.IO.File]::Exists($script:cachePath) | Should -BeTrue
        $keys = @((Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys)
        $keys | Should -HaveCount 2
        $widgetDigest = [Catzc.Base.Globs.DurableHash]::HashFile($script:widgetFile)
        $keys | Should -Contain "tests/Widget.Tests.ps1|$widgetDigest"
    }

    It 'reads an unchanged file back and runs no Pester discovery' {
        $first = & $script:discover
        $before = [System.IO.File]::GetLastWriteTimeUtc($script:cachePath)

        $second = & $script:discover

        Should -Invoke Invoke-Pester -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly -Scope It
        @($second.Tests.ExpandedPath) | Should -Be @($first.Tests.ExpandedPath)
        @($second.Tests.Tag | ForEach-Object { $_ }) | Should -Be @($first.Tests.Tag | ForEach-Object { $_ })
        [System.IO.File]::GetLastWriteTimeUtc($script:cachePath) | Should -Be $before
    }

    It 'discovers only the file whose content changed' {
        $oldKeys = @((Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys)
        [System.IO.File]::AppendAllText($script:gadgetFile, "`nDescribe 'GadgetMore' -Tag 'L0', 'logic' { It 'four' { } }`n")

        $discovery = & $script:discover

        Should -Invoke Invoke-Pester -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -Scope It -ParameterFilter {
            @($Configuration.Run.Path.Value).Count -eq 1 -and @($Configuration.Run.Path.Value) -contains $script:gadgetFile
        }
        @($discovery.Tests.ExpandedName) | Should -Contain 'four'
        $keys = @((Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys)
        $keys | Should -HaveCount 2
        $keys | Where-Object { $_ -in $oldKeys } | Should -HaveCount 1
    }

    It 'rebuilds an unreadable cache file' {
        [System.IO.File]::WriteAllText($script:cachePath, '{ not json')

        $discovery = & $script:discover

        $discovery.Tests | Should -HaveCount 4
        { Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable } | Should -Not -Throw
    }
}
