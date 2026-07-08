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

    It 'a nuget export builds at the published version and packs, needing no root' {
        Mock Get-CatzcVersion { '0.1.0' } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Published }
        Mock Get-OutputRoot { $TestDrive } -ModuleName Catzc.Base.Exporter
        Mock New-CatzcNuGetPackage { [pscustomobject]@{ NuPkg = 'X'; FunctionCount = 3 } } -ModuleName Catzc.Base.Exporter
        Export-Catzc -To nuget -Silent | Out-Null
        Should -Invoke Build-Catzc -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Version -eq '0.1.0' }
        Should -Invoke New-CatzcNuGetPackage -ModuleName Catzc.Base.Exporter -Times 1
        Should -Invoke Install-Catzc -ModuleName Catzc.Base.Exporter -Times 0
    }
}

Describe 'Catzc nuget package install-and-load (walking skeleton)' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        Mock Get-OutputRoot { Join-Path $TestDrive 'out' } -ModuleName Catzc.Base.Exporter
        $pkg = Export-Catzc -To nuget -Silent

        # Save the package from a local repo into a TestDrive module path, then load it in a child pwsh the way
        # a consumer would (Install-PSResource then Import-Module Catzc) — proving the published package works.
        $repoName = 'catzc-test-' + [System.Guid]::NewGuid().ToString('N').Substring(0, 8)
        Register-PSResourceRepository -Name $repoName -Uri (Split-Path $pkg.NuPkg -Parent) -Trusted -Force
        $script:modules = Join-Path $TestDrive 'modules'
        [System.IO.Directory]::CreateDirectory($script:modules) | Out-Null
        try {
            Save-PSResource -Name Catzc -Version $pkg.Version -Repository $repoName -Path $script:modules -TrustRepository
        }
        finally {
            Unregister-PSResourceRepository -Name $repoName
        }

        $probe = Join-Path $TestDrive 'probe.ps1'
        $template = @'
$env:PSModulePath = 'MODULES_PLACEHOLDER' + [System.IO.Path]::PathSeparator + $env:PSModulePath
Import-Module Catzc
[pscustomobject]@{ Ver = (Get-CatzcVersion -Published); Tools = (Get-Config -Config tools).node_js.version; Name = (Get-AzureResourceName -Env dev -Region weu -Org fin -ShortName disco -Type rg); Modules = $env:CatzcModulesRoot } | ConvertTo-Json -Compress
'@
        [System.IO.File]::WriteAllText($probe, $template.Replace('MODULES_PLACEHOLDER', $script:modules))
        $script:loaded = pwsh -NoProfile -File $probe | ConvertFrom-Json
    }

    It 'installs as a PSResource and Import-Module Catzc loads the platform' {
        $script:loaded.Modules | Should -BeLike '*Catzc*0.1.0*automation'
        $script:loaded.Ver | Should -Be '0.1.0'
    }

    It 'resolves config and a real typed function from the installed package' {
        $script:loaded.Tools | Should -Be '24'
        $script:loaded.Name | Should -Be 'dev-weu-fin-disco-rg'
    }
}
