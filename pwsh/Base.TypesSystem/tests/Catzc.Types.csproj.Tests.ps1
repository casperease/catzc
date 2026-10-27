# L1: runs dotnet msbuild over the template's own warning, so the cases follow the one living version of the check.
Describe 'Catzc.Types.csproj — stale types warning' -Tag 'L1', 'integrity' {
    BeforeAll {
        $template = Join-Path (Get-RepositoryRoot) 'pwsh/Base.TypesSystem/assets/Catzc.Types.csproj.xml'
        $warning = ([xml][System.IO.File]::ReadAllText($template)).SelectSingleNode("//Warning[contains(@Condition, '.compiled')]")
        $script:assets = Join-Path $TestDrive 'pwsh/.internal/assets'
        $script:compiled = Join-Path $TestDrive 'pwsh/.compiled'
        $script:project = Join-Path $script:assets 'Check.proj'
        [void][System.IO.Directory]::CreateDirectory($script:assets)
        [System.IO.File]::WriteAllText($script:project, "<Project><Target Name=`"Check`">$($warning.OuterXml)</Target></Project>")

        function script:Invoke-Check {
            & dotnet msbuild $script:project -t:Check -nologo -p:CatzcTypesHash=abc123 2>&1 | Out-String
        }
    }

    BeforeEach {
        if ([System.IO.Directory]::Exists($script:compiled)) {
            [System.IO.Directory]::Delete($script:compiled, $true)
        }
        [void][System.IO.Directory]::CreateDirectory($script:compiled)
    }

    It 'finds the warning in the template' {
        $warning | Should -Not -BeNullOrEmpty
    }

    It 'stays silent when the current-hash DLL is on disk' {
        [System.IO.File]::WriteAllText((Join-Path $script:compiled 'Catzc.Types.abc123.dll'), '')
        Invoke-Check | Should -Not -Match 'the loaded types are older than the sources'
    }

    It 'warns when only an older-hash DLL is on disk' {
        [System.IO.File]::WriteAllText((Join-Path $script:compiled 'Catzc.Types.old999.dll'), '')
        Invoke-Check | Should -Match 'the loaded types are older than the sources \(needs Catzc\.Types\.abc123\.dll\)'
    }
}
