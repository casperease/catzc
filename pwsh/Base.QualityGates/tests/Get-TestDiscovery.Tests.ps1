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

Describe 'Get-TestDiscovery of a language test folder' -Tag 'L1', 'logic' {
    BeforeAll {
        $script:drive = $TestDrive
        $script:cachePath = [System.IO.Path]::Combine($TestDrive, 'out', 'cache', 'test-discovery.json')
        $script:folder = [System.IO.Path]::Combine($TestDrive, 'widgets', 'tests', 'python')
        $script:caseFile = [System.IO.Path]::Combine($script:folder, 'test_widget.py')
        [void][System.IO.Directory]::CreateDirectory($script:folder)
        [System.IO.File]::WriteAllText($script:caseFile, "def test_one():`n    pass`n`ndef test_two():`n    pass`n")
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { [System.IO.Path]::Combine($script:drive, 'out') }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:drive }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'python'; Folder = $script:folder; Module = 'Widget' }
        }
        # The bridge cannot discover here (its lister needs the mapped folder), so the discovery answers with bridge-shaped tests.
        Mock Invoke-Pester -ModuleName Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ Tag = [string[]]@(); IsRoot = $true; Parent = $null }
            $block = [pscustomobject]@{
                Tag = [string[]]@('L2'); IsRoot = $false; Parent = $root; ExpandedPath = 'python tests of Widget'
                BlockContainer = [pscustomobject]@{ Data = @{ TestFolder = $script:folder } }
            }
            $tests = foreach ($name in 'test_one [pwsh]', 'test_two [pwsh]') {
                [pscustomobject]@{
                    Tag = [string[]]@('logic'); Block = $block; ExpandedName = $name; ExpandedPath = "python tests of Widget.$name"
                    ScriptBlock = [pscustomobject]@{ File = 'Language.Bridge.ps1'; StartPosition = [pscustomobject]@{ StartLine = 80 } }
                }
            }
            [pscustomobject]@{ Tests = @($tests) }
        }
        $script:discover = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:folder } {
                param($Path)
                Get-TestDiscovery -TestPath $Path
            }
        }
    }

    It 'discovers the folder once and keeps the container folder on its rows' {
        $discovery = & $script:discover

        Should -Invoke Invoke-Pester -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -Scope It
        @($discovery.Tests).Count | Should -BeGreaterThan 0
        foreach ($test in $discovery.Tests) {
            $test.Block.BlockContainer.Data['TestFolder'] | Should -Be $script:folder
        }
        $keys = @((Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys)
        $keys | Should -HaveCount 1
        $keys[0] | Should -BeLike 'widgets/tests/python|*'
    }

    It 'reads the folder back from the cache and runs no Pester' {
        $first = & $script:discover
        $second = & $script:discover

        Should -Invoke Invoke-Pester -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly -Scope It
        @($second.Tests.ExpandedName) | Should -Be @($first.Tests.ExpandedName)
        foreach ($test in $second.Tests) {
            $test.Block.BlockContainer.Data['TestFolder'] | Should -Be $script:folder
        }
    }

    It 'discovers the folder again when one of its test files changed' {
        $before = @((& $script:discover).Tests).Count
        [System.IO.File]::AppendAllText($script:caseFile, "`ndef test_three():`n    pass`n")

        $discovery = & $script:discover

        Should -Invoke Invoke-Pester -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -Scope It
        @($discovery.Tests).Count | Should -Be $before
        @((Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys) | Should -HaveCount 1
    }
}

Describe 'Get-TestDiscovery — shipped assets/Language.Bridge.ps1' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    BeforeAll {
        $script:drive = $TestDrive
        $script:cachePath = [System.IO.Path]::Combine($TestDrive, 'out', 'cache', 'test-discovery.json')
        $script:folder = [System.IO.Path]::Combine($TestDrive, 'widgets', 'tests', 'python')
        [void][System.IO.Directory]::CreateDirectory($script:folder)
        [System.IO.File]::WriteAllText([System.IO.Path]::Combine($script:folder, 'test_widget.py'), "def test_one():`n    pass`n")
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { [System.IO.Path]::Combine($script:drive, 'out') }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:drive }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'python'; Folder = $script:folder; Module = 'Widget' }
        }
        Mock Invoke-Pester -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ Tests = @() } }
        $script:discover = {
            InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $script:folder } {
                param($Path)
                [void](Get-TestDiscovery -TestPath $Path)
            }
        }
        $script:folderKey = {
            (Get-Content -LiteralPath $script:cachePath -Raw | ConvertFrom-Json -AsHashtable).Keys | Select-Object -First 1
        }
    }

    It 'folds the digest of the shipped bridge into a language folder key' {
        $bridge = Get-CatzcModuleRoot 'assets/Language.Bridge.ps1' -Module Catzc.Base.QualityGates
        $bridge | Should -Exist
        $changed = [System.IO.Path]::Combine($TestDrive, 'Language.Bridge.changed.ps1')
        [System.IO.File]::WriteAllText($changed, [System.IO.File]::ReadAllText($bridge) + ' ')

        & $script:discover
        $realKey = & $script:folderKey

        Mock Get-CatzcModuleRoot -ModuleName Catzc.Base.QualityGates { $changed } -ParameterFilter { $ChildPath -eq 'assets/Language.Bridge.ps1' }
        & $script:discover
        $changedKey = & $script:folderKey

        $realKey | Should -BeLike 'widgets/tests/python|*'
        $changedKey | Should -BeLike 'widgets/tests/python|*'
        $changedKey | Should -Not -Be $realKey
    }
}
