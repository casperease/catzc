Describe 'Export-BashModule' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'widget/run.sh', 'widget/lib/helper.sh', 'widget/scratch.sh') {
            $path = Join-Path $script:root $file
            $null = New-Item -ItemType Directory -Path (Split-Path $path) -Force
            [System.IO.File]::WriteAllBytes($path, [System.Text.Encoding]::UTF8.GetBytes("echo $file`n"))
        }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Languages { $script:root }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { -not $ExecutableOnly } { 'widget/run.sh', 'widget/lib/helper.sh', 'widget/tests/x_test.bats' }
        Mock Get-Config -ModuleName Catzc.Base.Languages { [pscustomobject]@{} | Add-Member -MemberType ScriptMethod -Name FolderOf -Value { 'tests' } -PassThru }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $ExecutableOnly } { 'widget/run.sh' }
        Mock Write-Message -ModuleName Catzc.Base.Languages { }
        $script:out = Join-Path $TestDrive "out-$([guid]::NewGuid().ToString('N'))"
    }

    It 'copies every tracked file byte for byte, keeping the relative layout' {
        $null = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        foreach ($file in 'run.sh', 'lib/helper.sh') {
            [System.IO.File]::ReadAllBytes((Join-Path $script:out $file)) |
                Should -Be ([System.IO.File]::ReadAllBytes((Join-Path $script:root "widget/$file")))
        }
    }

    It 'leaves an untracked file out of the package' {
        $null = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        Test-Path -LiteralPath (Join-Path $script:out 'scratch.sh') | Should -BeFalse
    }

    It 'leaves a tracked test file out of the package and the count' {
        $result = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        Test-Path -LiteralPath (Join-Path $script:out 'tests/x_test.bats') | Should -BeFalse
        $result.Files | Should -Be 2
    }

    It 'records the executable set as a sorted list in executables.json' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $ExecutableOnly } { 'widget/run.sh', 'widget/lib/helper.sh' }
        $null = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        [System.IO.File]::ReadAllText((Join-Path $script:out 'executables.json')) | Should -BeExactly "[`n  `"lib/helper.sh`",`n  `"run.sh`"`n]`n"
    }

    It 'records an empty list when no file is executable' {
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $ExecutableOnly } { }
        $result = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        [System.IO.File]::ReadAllText((Join-Path $script:out 'executables.json')) | Should -BeExactly "[]`n"
        $result.Executables | Should -Be 0
    }

    It 'returns the module, the destination and the counts' {
        $result = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget'
        $result.Destination | Should -BeExactly $script:out
        $result.Files | Should -Be 2
        $result.Executables | Should -Be 1
    }

    It 'takes the module as an absolute path under the repository' {
        $result = Export-BashModule -Module (Join-Path $script:root 'widget') -Destination $script:out -Silent
        $result.Module | Should -BeExactly 'widget'
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Languages -ParameterFilter { $Path -ceq 'widget' }
    }

    It 'gives identical bytes on a second export' {
        $first = Join-Path $script:out 'first'
        $second = Join-Path $script:out 'second'
        $null = Export-BashModule -Module 'widget' -Destination $first -Silent
        $null = Export-BashModule -Module 'widget' -Destination $second -Silent
        foreach ($file in 'run.sh', 'lib/helper.sh', 'executables.json') {
            [System.IO.File]::ReadAllBytes((Join-Path $first $file)) | Should -Be ([System.IO.File]::ReadAllBytes((Join-Path $second $file)))
        }
    }

    It 'sets the executable bit on the copy on a POSIX host' -Skip:$IsWindows {
        $null = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        ([System.IO.File]::GetUnixFileMode((Join-Path $script:out 'run.sh')) -band [System.IO.UnixFileMode]::UserExecute) |
            Should -Be ([System.IO.UnixFileMode]::UserExecute)
        ([System.IO.File]::GetUnixFileMode((Join-Path $script:out 'lib/helper.sh')) -band [System.IO.UnixFileMode]::UserExecute) |
            Should -Be 0
    }

    It 'says what it packaged unless silent' {
        $null = Export-BashModule -Module 'widget' -Destination $script:out
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 1 -Exactly
    }

    It 'says nothing when silent' {
        $null = Export-BashModule -Module 'widget' -Destination $script:out -Silent
        Should -Invoke Write-Message -ModuleName Catzc.Base.Languages -Times 0 -Exactly
    }
}
