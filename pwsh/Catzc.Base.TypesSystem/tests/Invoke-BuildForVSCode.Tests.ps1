<#
---
catzc:
  immutable:
    with_body_sha: "5aca149f62c2"
  edges:
    code: pwsh/Catzc.Base.TypesSystem/Invoke-BuildForVsCode.ps1
---
#>

Describe 'Invoke-BuildForVsCode' -Tag 'L0', 'logic' {
    BeforeEach {
        # The guard is the boundary to the run mode; these cases exercise the build itself.
        Mock Assert-SourceTree -ModuleName Catzc.Base.TypesSystem { }
        Mock Get-CatzcModulesRoot -ModuleName Catzc.Base.TypesSystem { $TestDrive }
        Mock Assert-PathExist -ModuleName Catzc.Base.TypesSystem { }
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $true }
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem {
            [pscustomobject]@{ ExitCode = 0; Full = 'Build succeeded.'; Output = 'Build succeeded.' }
        }
    }

    It 'runs dotnet build on Catzc.Types.csproj in the configuration of bcl.yml' {
        Mock Get-Config -ModuleName Catzc.Base.TypesSystem { [Catzc.Base.Languages.BclConfig]::new([ordered]@{ configuration = 'Widget' }) }
        Invoke-BuildForVsCode | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -Times 1 -ParameterFilter {
            $Command -match 'dotnet build' -and $Command -match 'Catzc\.Types\.csproj' -and $Command -match '--configuration Widget'
        }
    }

    It 'defaults to the Debug configuration' {
        Invoke-BuildForVsCode | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem -ParameterFilter {
            $Command -match '--configuration Debug'
        }
    }

    It 'returns the project path by default' {
        Invoke-BuildForVsCode | Should -Match 'Catzc\.Types\.csproj$'
    }

    It 'with -PassThru returns the executable result instead of the path' {
        (Invoke-BuildForVsCode -PassThru).ExitCode | Should -Be 0
    }

    It 'throws an actionable error when dotnet is not on PATH' {
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $false }
        { Invoke-BuildForVsCode } | Should -Throw '*Install-Dotnet*'
    }

    It 'does not launch dotnet when the tool is missing' {
        Mock Test-Command -ModuleName Catzc.Base.TypesSystem { $false }
        { Invoke-BuildForVsCode } | Should -Throw
        Should -Not -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem
    }
}

Describe 'Invoke-BuildForVsCode — build mode' -Tag 'L0', 'logic' {
    It 'stops with a named error when the session runs a built package, before launching dotnet' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.Repository
        Mock Invoke-Executable -ModuleName Catzc.Base.TypesSystem { }
        { Invoke-BuildForVsCode } | Should -Throw '*Invoke-BuildForVsCode operates on the catzc source tree*'
        Should -Not -Invoke Invoke-Executable -ModuleName Catzc.Base.TypesSystem
    }
}
