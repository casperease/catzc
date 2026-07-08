Describe 'Export-Catzc' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Build-Catzc { [pscustomobject]@{ Path = 'BUILT'; Version = '6.6.666' } } -ModuleName Catzc.Base.Exporter
        Mock Install-Catzc { [pscustomobject]@{ Root = $Root } } -ModuleName Catzc.Base.Exporter
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
    }

    It 'a disk export builds then installs to the root' {
        Export-Catzc -Root 'C:\work\target' -Silent | Out-Null
        Should -Invoke Build-Catzc -ModuleName Catzc.Base.Exporter -Times 1
        Should -Invoke Install-Catzc -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Root -eq 'C:\work\target' -and $Source -eq 'BUILT'
        }
    }

    It 'passes profile and vendor overrides through to the build' {
        Export-Catzc -Root 'C:\work\target' -ModuleProfile azure -VendorPolicy full -Silent | Out-Null
        Should -Invoke Build-Catzc -ModuleName Catzc.Base.Exporter -ParameterFilter {
            $ModuleProfile -eq 'azure' -and $VendorPolicy -eq 'full'
        }
    }

    It 'the nuget export is a disabled stub that does not build' {
        Export-Catzc -To nuget | Out-Null
        Should -Invoke Build-Catzc -ModuleName Catzc.Base.Exporter -Times 0
        Should -Invoke Install-Catzc -ModuleName Catzc.Base.Exporter -Times 0
    }
}
