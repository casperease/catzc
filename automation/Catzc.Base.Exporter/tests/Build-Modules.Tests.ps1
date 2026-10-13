Describe 'Build-Modules' -Tag 'L0', 'logic' {
    BeforeAll {
        # The engine (Catzc.Internal.Builder) is loaded on demand and is a mocked boundary here; a stub makes the
        # command exist for Mock when the engine module is not loaded in this session.
        $script:stubbedEngine = $false
        if (-not (Get-Command Invoke-ModuleBuild -ErrorAction Ignore)) {
            $null = New-Item -Path Function:\global:Invoke-ModuleBuild -Value {
                param([string[]] $Module, [string] $ModuleProfile, [string] $Version, [string] $VendorPolicy, [string] $Destination, [hashtable] $PackageMetadata, [switch] $DryRun)
                throw "stub, mocked in tests: $Module $ModuleProfile $Version $VendorPolicy $Destination $($PackageMetadata.Count) $DryRun"
            }
            $script:stubbedEngine = $true
        }
    }

    AfterAll {
        if ($script:stubbedEngine) {
            Remove-Item -Path Function:\global:Invoke-ModuleBuild
        }
    }

    BeforeEach {
        Mock Get-Config {
            [ordered]@{
                direct_install_version = '6.6.666'
                version                = '0.1'
                default_profile        = 'widget-set'
                vendor_policy          = 'runtime'
                module_guid            = '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
                package                = [ordered]@{
                    author = 'Test Author'; company = 'Test Co'; description = 'A test package.'
                    tags = @('widget', 'gadget'); project_uri = 'https://forge.example/widget'; license_uri = 'https://forge.example/widget/license'
                }
            }
        } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Config -eq 'exporter' }
        Mock Get-OutputRoot { (Join-Path $TestDrive 'out') } -ModuleName Catzc.Base.Exporter
        Mock Resolve-CatzcBuildVersion { '6.6.666' } -ModuleName Catzc.Base.Exporter
        Mock Import-InternalModule { } -ModuleName Catzc.Base.Exporter -ParameterFilter { $Name -eq 'Builder' }
        Mock Invoke-ModuleBuild {
            [pscustomobject]@{
                BuildRoot = "$Destination/Catzc/$Version"; Version = $Version; Modules = @('Catzc.Base.Widget', 'Catzc.Base.Gadget')
                TypesHash = 'abc12345'; ContentHash = ('0' * 64); FileCount = 12; DryRun = [bool] $DryRun
            }
        } -ModuleName Catzc.Base.Exporter
        Mock Assert-CatzcBundle { } -ModuleName Catzc.Base.Exporter
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
    }

    It 'builds exporter.yml defaults: default_profile, vendor_policy, the output root, the resolved version' {
        $result = Build-Modules
        Should -Invoke Import-InternalModule -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Name -eq 'Builder' }
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $ModuleProfile -eq 'widget-set' -and -not $Module -and $VendorPolicy -eq 'runtime' -and
            $Destination -eq (Join-Path (Join-Path $TestDrive 'out') 'automation/build') -and $Version -eq '6.6.666' -and -not $DryRun
        }
        $result.BuildRoot | Should -Be "$(Join-Path (Join-Path $TestDrive 'out') 'automation/build')/Catzc/6.6.666"
    }

    It 'hands the package identity from exporter.yml to the engine' {
        Build-Modules | Out-Null
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $PackageMetadata.Guid -eq '211b36c7-f7eb-4f3c-93f5-9132b535fa56' -and $PackageMetadata.Author -eq 'Test Author' -and
            $PackageMetadata.CompanyName -eq 'Test Co' -and $PackageMetadata.Description -eq 'A test package.' -and
            ($PackageMetadata.Tags -join ',') -eq 'widget,gadget' -and $PackageMetadata.ProjectUri -eq 'https://forge.example/widget' -and
            $PackageMetadata.LicenseUri -eq 'https://forge.example/widget/license'
        }
    }

    It 'passes explicit modules alone, without the default profile' {
        Build-Modules Catzc.Base.Widget | Out-Null
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            ($Module -join ',') -eq 'Catzc.Base.Widget' -and -not $ModuleProfile
        }
    }

    It 'passes modules and a profile together (the engine takes the closure of the union)' {
        Build-Modules -Module Catzc.Base.Widget -ModuleProfile gadget-set | Out-Null
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            ($Module -join ',') -eq 'Catzc.Base.Widget' -and $ModuleProfile -eq 'gadget-set'
        }
    }

    It 'honours explicit vendor policy, destination and version' {
        Build-Modules -VendorPolicy full -Destination 'Y:/elsewhere' -Version 1.2.3 | Out-Null
        Should -Invoke Resolve-CatzcBuildVersion -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Version -eq '1.2.3' }
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $VendorPolicy -eq 'full' -and $Destination -eq 'Y:/elsewhere'
        }
    }

    It 'verifies the build it wrote' {
        Build-Modules | Out-Null
        Should -Invoke Assert-CatzcBundle -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Path -eq "$(Join-Path (Join-Path $TestDrive 'out') 'automation/build')/Catzc/6.6.666"
        }
    }

    It 'fails when the self-check fails' {
        Mock Assert-CatzcBundle { throw 'Catzc build is invalid' } -ModuleName Catzc.Base.Exporter
        { Build-Modules } | Should -Throw -ExpectedMessage '*invalid*'
    }

    It '-DryRun passes through to the engine and skips the self-check' {
        $result = Build-Modules -DryRun
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $DryRun }
        Should -Invoke Assert-CatzcBundle -ModuleName Catzc.Base.Exporter -Times 0
        $result.DryRun | Should -BeTrue
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Would build Catzc 6.6.666 (2 modules*' }
    }

    It 'reports one summary line, and -Silent passes through to the version notice and suppresses it' {
        Build-Modules | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Built Catzc 6.6.666 (2 modules, 12 files, types abc12345)*' }
        Build-Modules -Silent | Out-Null
        Should -Invoke Resolve-CatzcBuildVersion -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Silent }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1
    }
}
