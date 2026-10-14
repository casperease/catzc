# Format-Go with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): the
# Go test folders (Get-LanguageTestFolders), the tool probe (Resolve-ToolExecutable) finding a managed go beside a fixture
# gofmt in $TestDrive, and gofmt itself (Invoke-Executable). Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Format-Go' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:bin = Join-Path $TestDrive 'managed go/bin'
        $null = New-Item -ItemType Directory -Path $script:bin -Force
        $script:goPath = Join-Path $script:bin ($IsWindows ? 'go.exe' : 'go')
        $script:gofmt = Join-Path $script:bin ($IsWindows ? 'gofmt.exe' : 'gofmt')
        $null = New-Item -ItemType File -Path $script:goPath, $script:gofmt -Force
        $script:widget = Join-Path $TestDrive 'repo/go/tests/catzc-widget'
        $script:widgetFile = Join-Path $script:widget 'widget_test.go'
    }

    BeforeEach {
        $script:listed = $script:widgetFile
        $script:listExit = 0
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Language = 'go'; Module = 'Catzc.Widget'; Folder = $script:widget; Name = 'catzc-widget' }
            [pscustomobject]@{ Language = 'python'; Module = 'Catzc.Widget'; Folder = 'C:\widget\python\tests\catzc-widget'; Name = 'catzc-widget' }
        }
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'go' } {
            [pscustomobject]@{ Found = $true; VersionOk = $true; Path = $script:goPath; Version = '1.27.2'; Required = '1.27' }
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '* -l *' } {
            [Catzc.Base.Execution.CliResult]::new($script:listed, '', $script:listExit)
        }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Command -like '* -w *' } { }
    }

    It 'lists with gofmt -l over every Go test module, then rewrites exactly the listed files' {
        $changed = Format-Go
        $changed | Should -Be @([System.IO.Path]::GetFullPath($script:widgetFile))
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "`"$script:gofmt`" -l `"$script:widget`""
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "`"$script:gofmt`" -w `"$([System.IO.Path]::GetFullPath($script:widgetFile))`""
        }
    }

    It 'reports without writing under -DryRun' {
        $result = Format-Go -DryRun -PassThru
        $result.ChangedCount | Should -Be 1
        $result.DryRun | Should -BeTrue
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -like '* -w *' }
    }

    It 'writes nothing when every file is formatted' {
        $script:listed = ''
        @(Format-Go) | Should -HaveCount 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0 -ParameterFilter { $Command -like '* -w *' }
    }

    It 'needs no go when there are no Go test modules' {
        Mock Get-LanguageTestFolders -ModuleName Catzc.Base.QualityGates { }
        (Format-Go -PassThru).ChangedCount | Should -Be 0
        Should -Invoke Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -Times 0
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'throws with "Run Install-Go" when no go at the pin is found' {
        Mock Resolve-ToolExecutable -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Tool -eq 'go' } {
            [pscustomobject]@{ Found = $true; VersionOk = $false; Path = $script:goPath; Version = '1.24.4'; Required = '1.27' }
        }
        { Format-Go } | Should -Throw "*pin '1.27' (found: 1.24.4)*Run Install-Go*"
    }

    It 'refuses a file that is not .go before running gofmt, naming the generator' {
        $mod = Join-Path $TestDrive 'repo/go/tests/catzc-widget/go.mod'
        $null = New-Item -ItemType File -Path $mod -Force
        { Format-Go -Path $mod } | Should -Throw '*is not a .go file*Build-RootConfig*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'formats an explicit .go file' {
        $null = New-Item -ItemType File -Path $script:widgetFile -Force
        $null = Format-Go -Path $script:widgetFile
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Command -eq "`"$script:gofmt`" -l `"$script:widgetFile`""
        }
    }

    It 'throws with gofmt''s message when a source does not parse' {
        $script:listExit = 2
        { Format-Go } | Should -Throw '*gofmt could not read the Go files (exit 2)*'
    }
}
