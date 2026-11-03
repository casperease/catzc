Describe 'Get-ModuleShippedFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:shipped = {
            param($Module, $ExecutableOnly)
            InModuleScope Catzc.Base.Languages -Parameters @{ Module = $Module; ExecutableOnly = $ExecutableOnly } {
                param($Module, $ExecutableOnly)
                Get-ModuleShippedFile -Module $Module -ExecutableOnly:$ExecutableOnly
            }
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Languages { [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name FolderOf -Value { 'tests' } -PassThru }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages {
            'widget/run.sh', 'widget/lib/helper.sh', 'widget/tests/x_test.sh', 'widget/tests/lib/y_test.sh', 'widget/testsuite.sh', 'gadget/run.sh'
        }
    }

    It 'returns the tracked files relative to the module' {
        $files = & $script:shipped 'widget' $false
        $files | Should -Contain 'run.sh'
        $files | Should -Contain 'lib/helper.sh'
    }

    It 'leaves out every file under the test folder' {
        $files = & $script:shipped 'widget' $false
        $files | Should -Not -Contain 'tests/x_test.sh'
        $files | Should -Not -Contain 'tests/lib/y_test.sh'
    }

    It 'keeps a file whose name only starts with the test folder name' {
        & $script:shipped 'widget' $false | Should -Contain 'testsuite.sh'
    }

    It 'leaves out a path outside the module' {
        & $script:shipped 'widget' $false | Should -Not -Contain 'gadget/run.sh'
    }

    It 'passes the executable switch to the tracked-path read' {
        $null = & $script:shipped 'widget' $true
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $ExecutableOnly }
    }

    It 'returns an empty array when nothing is tracked' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages { }
        @(& $script:shipped 'widget' $false).Count | Should -Be 0
    }
}
