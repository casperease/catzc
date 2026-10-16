<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Exporter/tests/Build-Modules.Tests.ps1
    folder: tests
    name: build-modules-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-exporter/tests/Build-Modules.Tests.ps1.md
---
#>

Describe 'Build-Modules' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:stubbedEngine = $false
        if (-not (Get-Command Invoke-ModuleBuild -ErrorAction Ignore)) {
            $null = New-Item -Path Function:\global:Invoke-ModuleBuild -Value {
                param([string[]] $Module, [string] $ModuleProfile, [string] $Version, [string] $VendorPolicy, [string] $Destination, [string] $Bundle, [hashtable] $PackageMetadata, [switch] $DryRun)
                throw "stub, mocked in tests: $Module $ModuleProfile $Version $VendorPolicy $Destination $Bundle $($PackageMetadata.Count) $DryRun"
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
            [Catzc.Base.Exporter.ExporterConfig]::new([ordered]@{
                    direct_install_version = '6.6.666'
                    bundles                = [ordered]@{
                        widgets = [ordered]@{ profile = 'widget-set'; version = '0.1' }
                        gadgets = [ordered]@{ profile = 'gadget-set'; version = '2.3'; vendor_policy = 'full' }
                    }
                    default_bundle         = 'widgets'
                    module_guid            = '211b36c7-f7eb-4f3c-93f5-9132b535fa56'
                    package                = [ordered]@{
                        author = 'Test Author'; company = 'Test Co'; description = 'A test package.'
                        tags = @('widget', 'gadget'); project_uri = 'https://forge.example/widget'; license_uri = 'https://forge.example/widget/license'
                    }
                })
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
        Mock Assert-BundleFootprint { [pscustomobject]@{ Files = 12; Bytes = 1000 } } -ModuleName Catzc.Base.Exporter
        Mock Write-Message { } -ModuleName Catzc.Base.Exporter
    }

    It 'checks the build against its bundle''s footprint limits, and skips that on a dry run' {
        Build-Modules -Bundle gadgets | Out-Null
        Should -Invoke Assert-BundleFootprint -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $Bundle.name -eq 'gadgets' -and $Path -eq "$(Join-Path (Join-Path $TestDrive 'out') 'automation/built/gadgets')/Catzc/6.6.666"
        }
        Build-Modules -DryRun | Out-Null
        Should -Invoke Assert-BundleFootprint -ModuleName Catzc.Base.Exporter -Times 1
    }

    It 'does not measure an overridden build against the bundle''s limits (<Case>)' -ForEach @(
        @{ Case = 'explicit modules'; Overrides = @{ Module = 'Catzc.Base.Widget' } }
        @{ Case = 'another profile'; Overrides = @{ ModuleProfile = 'gadget-set' } }
        @{ Case = 'another vendor policy'; Overrides = @{ VendorPolicy = 'full' } }
    ) {
        Build-Modules @Overrides | Out-Null
        Should -Invoke Assert-BundleFootprint -ModuleName Catzc.Base.Exporter -Times 0
        Should -Invoke Assert-CatzcBundle -ModuleName Catzc.Base.Exporter -Times 1
    }

    It 'fails when the build outgrows its footprint limits' {
        Mock Assert-BundleFootprint { throw "Bundle 'widgets' outgrew its footprint limits" } -ModuleName Catzc.Base.Exporter
        { Build-Modules } | Should -Throw -ExpectedMessage '*outgrew its footprint limits*'
        Should -Invoke Assert-CatzcBundle -ModuleName Catzc.Base.Exporter -Times 0
    }

    It 'builds the default bundle: its profile, its vendor policy, its own output folder, the resolved version' {
        $result = Build-Modules
        Should -Invoke Import-InternalModule -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Name -eq 'Builder' }
        Should -Invoke Resolve-CatzcBuildVersion -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Bundle -eq 'widgets' }
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $ModuleProfile -eq 'widget-set' -and -not $Module -and $VendorPolicy -eq 'runtime' -and $Bundle -eq 'widgets' -and
            $Destination -eq (Join-Path (Join-Path $TestDrive 'out') 'automation/built/widgets') -and $Version -eq '6.6.666' -and -not $DryRun
        }
        $result.BuildRoot | Should -Be "$(Join-Path (Join-Path $TestDrive 'out') 'automation/built/widgets')/Catzc/6.6.666"
    }

    It 'builds a named bundle from its own profile, vendor policy, version line and folder' {
        Build-Modules -Bundle gadgets | Out-Null
        Should -Invoke Resolve-CatzcBuildVersion -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Bundle -eq 'gadgets' }
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter {
            $ModuleProfile -eq 'gadget-set' -and $VendorPolicy -eq 'full' -and $Bundle -eq 'gadgets' -and
            $Destination -eq (Join-Path (Join-Path $TestDrive 'out') 'automation/built/gadgets')
        }
    }

    It 'rejects a bundle exporter.yml does not declare' {
        { Build-Modules -Bundle sprockets } | Should -Throw -ExpectedMessage "*Unknown bundle 'sprockets'*widgets, gadgets*"
        Should -Invoke Invoke-ModuleBuild -ModuleName Catzc.Base.Exporter -Times 0
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
            $Path -eq "$(Join-Path (Join-Path $TestDrive 'out') 'automation/built/widgets')/Catzc/6.6.666"
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
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Would build Catzc widgets 6.6.666 (2 modules*' }
    }

    It 'reports one summary line, and -Silent passes through to the version notice and suppresses it' {
        Build-Modules | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Message -like 'Built Catzc widgets 6.6.666 (2 modules, 12 files, types abc12345)*' }
        Build-Modules -Silent | Out-Null
        Should -Invoke Resolve-CatzcBuildVersion -ModuleName Catzc.Base.Exporter -Times 1 -ParameterFilter { $Silent }
        Should -Invoke Write-Message -ModuleName Catzc.Base.Exporter -Times 1
    }
}
