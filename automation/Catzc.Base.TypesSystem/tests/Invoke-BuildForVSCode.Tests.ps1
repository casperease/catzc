Describe 'Invoke-BuildForVSCode' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.TypesSystem { $TestDrive }
        Mock Assert-PathExist -ModuleName Catzc.Base.TypesSystem { }
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $true }
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem {
            [pscustomobject]@{ ExitCode = 0; Full = 'Build succeeded.'; Output = 'Build succeeded.' }
        }
    }

    It 'runs dotnet build on Catzc.Types.csproj in the requested configuration' {
        Invoke-BuildForVSCode -Configuration Release | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -ParameterFilter {
            $Command -match 'dotnet build' -and $Command -match 'Catzc\.Types\.csproj' -and $Command -match '--configuration Release'
        }
    }

    It 'defaults to the Debug configuration' {
        Invoke-BuildForVSCode | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -ParameterFilter {
            $Command -match '--configuration Debug'
        }
    }

    It 'returns the project path by default' {
        Invoke-BuildForVSCode | Should -Match 'Catzc\.Types\.csproj$'
    }

    It 'with -PassThru returns the executable result instead of the path' {
        (Invoke-BuildForVSCode -PassThru).ExitCode | Should -Be 0
    }

    It 'throws an actionable error when dotnet is not on PATH' {
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $false }
        { Invoke-BuildForVSCode } | Should -Throw '*Install-Dotnet*'
    }

    It 'does not launch dotnet when the tool is missing' {
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $false }
        { Invoke-BuildForVSCode } | Should -Throw
        Should -Not -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem
    }
}
