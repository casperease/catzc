BeforeAll {
    Import-InternalModule TestKit
    Import-InternalModule Builder
}

Describe 'Get-BuildSourceStamp' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive 'widget-repo'
        [System.IO.Directory]::CreateDirectory($script:root) | Out-Null
        $script:inputs = @('widgets/Widget/', 'widgets/.internal/', 'widgets/Widget.Root/configs/widget.yml')
        $script:tracked = [ordered]@{
            'widgets/Widget/Get-Widget.ps1'             = 'abc123'
            'widgets/Widget/tests/Get-Widget.Tests.ps1' = 'abc124'
            'widgets/Gadget/Get-Gadget.ps1'             = 'abc125'
            'widgets/.internal/Widget.Builder.psm1'     = 'abc126'
            'widgets/Widget.Root/configs/widget.yml'    = 'abc127'
            'widgets/Widget.Root/configs/gadget.yml'    = 'abc128'
            'docs/widget.md'                            = 'abc129'
        }
        # Stamps the listed index entries; a path in Changed carries another object id.
        $script:stamp = {
            param([System.Collections.IDictionary] $Changed = @{})
            $lines = @(foreach ($path in $script:tracked.Keys) {
                    $id = $Changed.Contains($path) ? $Changed[$path] : $script:tracked[$path]
                    "100644 $id 0`t$path"
                }) -join "`n"
            InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Lines = $lines; InputPath = $script:inputs } {
                Mock Invoke-Executable {
                    $listed = if ($Command -like '*ls-files -s') {
                        $Lines
                    }
                    else {
                        ''
                    }
                    [pscustomobject] @{ ExitCode = 0; Output = $listed; Errors = '' }
                }
                Get-BuildSourceStamp -RepositoryRoot $Root -Selection 'gadgets|1.0.0|widget' -InputPath $InputPath
            }
        }
    }

    It 'stamps the same tree the same' {
        $first = & $script:stamp
        $second = & $script:stamp
        $first | Should -Not -BeNullOrEmpty
        $second | Should -Be $first
    }

    It 'keeps the stamp when a file outside the inputs changes: <Case>' -ForEach @(
        @{ Case = 'another module'; Path = 'widgets/Gadget/Get-Gadget.ps1' }
        @{ Case = 'a docs file'; Path = 'docs/widget.md' }
        @{ Case = 'a test of a selected module'; Path = 'widgets/Widget/tests/Get-Widget.Tests.ps1' }
        @{ Case = 'a file beside a listed file'; Path = 'widgets/Widget.Root/configs/gadget.yml' }
    ) {
        $before = & $script:stamp
        $after = & $script:stamp @{ $Path = 'fff999' }
        $after | Should -Be $before
    }

    It 'moves the stamp when an input changes: <Case>' -ForEach @(
        @{ Case = 'a selected module file'; Path = 'widgets/Widget/Get-Widget.ps1' }
        @{ Case = 'an internal file'; Path = 'widgets/.internal/Widget.Builder.psm1' }
        @{ Case = 'a listed file'; Path = 'widgets/Widget.Root/configs/widget.yml' }
    ) {
        $before = & $script:stamp
        $after = & $script:stamp @{ $Path = 'fff999' }
        $after | Should -Not -Be $before
    }

    It 'throws when no input is named' -ForEach @(
        @{ Case = 'omitted'; Named = $null }
        @{ Case = 'empty'; Named = @() }
        @{ Case = 'blank'; Named = @('') }
    ) {
        InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Named = $Named } {
            Mock Invoke-Executable { [pscustomobject] @{ ExitCode = 0; Output = ''; Errors = '' } }
            $arguments = @{ RepositoryRoot = $Root; Selection = 'gadgets|1.0.0|widget' }
            if ($null -ne $Named) {
                $arguments.InputPath = $Named
            }
            { Get-BuildSourceStamp @arguments } | Should -Throw '*stamped from the files it reads*none was given*'
            Should -Invoke Invoke-Executable -Times 0 -Exactly
        }
    }

    It 'throws naming the <Listing> listing when git exits non-zero for it' -ForEach @(
        @{ Listing = 'modified'; Failing = '*ls-files -m' }
        @{ Listing = 'untracked'; Failing = '*ls-files --others*' }
    ) {
        InModuleScope Catzc.Internal.Builder -Parameters @{ Root = $script:root; Failing = $Failing; Listing = $Listing } {
            Mock Invoke-Executable {
                $failed = $Command -like $Failing
                [pscustomobject] @{ ExitCode = [int] $failed; Output = ''; Errors = $(if ($failed) {
                            'widget listing failed'
                        }
                        else {
                            ''
                        })
                }
            }
            { Get-BuildSourceStamp -RepositoryRoot $Root -Selection 'gadgets|1.0.0|widget' -InputPath 'widgets/Widget/' } | Should -Throw "*cannot list the $Listing files*widget listing failed*"
        }
    }
}
