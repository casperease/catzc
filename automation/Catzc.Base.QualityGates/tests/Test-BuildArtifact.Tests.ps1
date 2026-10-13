# Test-BuildArtifact is a quality gate (ADR-AUTO-TEST#35): each L0 case mocks the build, the child-pwsh probe, the
# source reads, and the formatter at the module boundary, and reads the collected issues; the report goes to
# $TestDrive. The integrity blocks that build and load the real tree call the gate from their own test files.
Describe 'Test-BuildArtifact' -Tag 'L0', 'logic' {
    BeforeAll {
        # A clean observation of a two-module build at <root>: every facet passes.
        function script:New-WidgetObservation {
            param([string] $BuildRoot, [string] $RepositoryRoot)
            [pscustomobject]@{
                ModulesRoot    = $BuildRoot
                RepositoryRoot = $RepositoryRoot
                Repository     = $RepositoryRoot
                RunMode        = 'build'
                Modules        = @(
                    [pscustomobject]@{ Name = 'Catzc.Base.Config'; Base = (Join-Path $BuildRoot 'Catzc.Base.Config'); Exported = @('Get-Widget'); Defined = @('Get-Widget', 'Resolve-Widget'); Instances = 1 }
                    [pscustomobject]@{ Name = 'Catzc.Gadget'; Base = (Join-Path $BuildRoot 'Catzc.Gadget'); Exported = @('Get-Gadget'); Defined = @('Get-Gadget'); Instances = 1 }
                )
                InternalBases  = @(Join-Path $BuildRoot '.internal')
                TypesAssembly  = 'Catzc.Types.abcd1234.dll'
                Accelerator    = 'Catzc.Module.Depm'
                HasConfig      = $true
                ConfigCount    = 2
                ConfigFailures = @()
                ModuleRoot     = (Join-Path $BuildRoot 'Catzc.Base.Config/configs/configs.yml')
                HelpSynopsis   = 'Gets a widget.'
                Private        = $false
                InModuleScope  = $true
            }
        }
    }

    BeforeEach {
        $script:repositoryRoot = [System.IO.Path]::GetFullPath((Join-Path $TestDrive 'repository'))
        $script:buildRoot = Join-Path $TestDrive 'build/Catzc/6.6.666'
        $script:observation = New-WidgetObservation -BuildRoot $script:buildRoot -RepositoryRoot $script:repositoryRoot
        $script:reportFolder = Join-Path $TestDrive 'build-artifact'

        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { }
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $script:repositoryRoot }
        Mock Import-InternalModule -ModuleName Catzc.Base.QualityGates { }
        Mock Get-CombinedTypeHash -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ CombinedHash = 'abcd1234' } }
        Mock Get-CommittedTypesDrift -ModuleName Catzc.Base.QualityGates { }
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ BuildRoot = $script:buildRoot; Modules = @('Catzc.Base.Config', 'Catzc.Gadget'); TypesHash = 'abcd1234' }
        }
        Mock Invoke-BuildArtifactProbe -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 0; Output = ''; Observed = $script:observation } }
        Mock Get-ModuleSourceFunctions -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'Catzc.Base.Config' } {
            [pscustomobject]@{ Public = @('Get-Widget'); Private = @('Resolve-Widget') }
        }
        Mock Get-ModuleSourceFunctions -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'Catzc.Gadget' } {
            [pscustomobject]@{ Public = @('Get-Gadget'); Private = @() }
        }
        Mock Format-Automation -ModuleName Catzc.Base.QualityGates { }
    }

    It 'passes a build every facet accepts, building once with the full vendor policy' -Tag 'ADR-AUTO-TEST#35' {
        { Test-BuildArtifact -OutputFolder $script:reportFolder } | Should -Not -Throw
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $VendorPolicy -eq 'full' }
        Should -Invoke Invoke-BuildArtifactProbe -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $ScopeModule -eq 'Catzc.Base.Config' }
        Should -Invoke Format-Automation -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $DryRun -and @($Path).Count -eq 3 }
    }

    It 'throws once listing every issue, each prefixed with its facet' -Tag 'ADR-AUTO-TEST#35' {
        Mock Get-CommittedTypesDrift -ModuleName Catzc.Base.QualityGates { 'automation/.compiled has pending git changes — commit it' }
        $script:observation.RunMode = 'source'
        Mock Format-Automation -ModuleName Catzc.Base.QualityGates { Join-Path $script:buildRoot 'Catzc.Gadget/Catzc.Gadget.psd1' }

        $thrown = { Test-BuildArtifact -OutputFolder $script:reportFolder } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-BuildArtifact failed: 3 issue(s)*'
        $thrown.Exception.Message | Should -BeLike '*`[types`] automation/.compiled has pending git changes*'
        $thrown.Exception.Message | Should -BeLike "*``[load``] the session runs in 'source' mode, not build mode*"
        $thrown.Exception.Message | Should -BeLike '*`[manifest`] Catzc.Gadget/Catzc.Gadget.psd1 is not formatter-stable*'
    }

    It 'returns the result with the built modules and types hash under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $result = Test-BuildArtifact -PassThru -OutputFolder $script:reportFolder
        $result.Subject | Should -Be 'build-artifact'
        $result.IssueCount | Should -Be 0
        $result.Modules | Should -Be 2
        $result.TypesHash | Should -Be 'abcd1234'
    }

    It 'turns each violation of a failed build into one issue' {
        Mock Build-Modules -ModuleName Catzc.Base.QualityGates { throw "Catzc build at 'x' is invalid:`nmissing build.json`nmodule 'Catzc.Gadget' is missing its manifest" }

        $result = Test-BuildArtifact -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            "[build] Catzc build at 'x' is invalid:"
            '[build] missing build.json'
            "[build] module 'Catzc.Gadget' is missing its manifest"
        )
        Should -Invoke Invoke-BuildArtifactProbe -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'reports a build that does not ship the full type set' {
        Mock Get-CombinedTypeHash -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ CombinedHash = 'ffff0000' } }

        $result = Test-BuildArtifact -Facet Manifest -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @("[build] the build's typesHash abcd1234 is not the source tree's ffff0000 — a build ships the full type set")
    }

    It 'reports a build that does not load, with the child output' {
        Mock Invoke-BuildArtifactProbe -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ ExitCode = 1; Output = 'widget exploded'; Observed = $null } }

        $result = Test-BuildArtifact -Facet Load -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @('[load] the build does not load in a fresh pwsh (exit 1): widget exploded')
    }

    It 'reports each load facet the session gets wrong' {
        $script:observation.Modules[1].Base = 'C:/elsewhere/Catzc.Gadget'
        $script:observation.Modules[1].Instances = 2
        $script:observation.TypesAssembly = 'Catzc.Types.0000.dll'
        $script:observation.ConfigFailures = @('widget: bad shape')
        $script:observation.Private = $true
        $script:observation.InModuleScope = $false

        $result = Test-BuildArtifact -Facet Load -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            "[load] Catzc.Gadget loads from 'C:/elsewhere/Catzc.Gadget', not the build root"
            '[load] Catzc.Gadget loads 2 times (Get-Module -All); a merged file never adds a same-named nested module'
            "[load] the session loads the types assembly 'Catzc.Types.0000.dll', not the build's Catzc.Types.abcd1234.dll"
            '[load] a shipped config does not load: widget: bad shape'
            '[load] a private function (Resolve-ConfigEntry) is exported'
            '[load] InModuleScope cannot enter Catzc.Base.Config'
        )
    }

    It 'reports parity drift between a built module and its source folder' {
        Mock Get-ModuleSourceFunctions -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Name -eq 'Catzc.Gadget' } {
            [pscustomobject]@{ Public = @('Get-Gadget', 'Set-Gadget'); Private = @('Resolve-Gadget') }
        }

        $result = Test-BuildArtifact -Facet Parity -PassThru -OutputFolder $script:reportFolder
        $result.Issues | Should -Be @(
            '[parity] Catzc.Gadget exports differ from its source folder (<= source only, => build only): <=Set-Gadget'
            '[parity] Catzc.Gadget private functions differ from its source folder (<= source only, => build only): <=Resolve-Gadget'
        )
    }

    It 'checks only the committed types without building when the types facet is selected alone' {
        $result = Test-BuildArtifact -Facet Types -PassThru -OutputFolder $script:reportFolder
        $result.IssueCount | Should -Be 0
        Should -Invoke Get-CommittedTypesDrift -ModuleName Catzc.Base.QualityGates -Times 1
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'passes the module selection through to the build' {
        Test-BuildArtifact -Module Catzc.Gadget -Facet Manifest -OutputFolder $script:reportFolder
        Should -Invoke Build-Modules -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Module -contains 'Catzc.Gadget' -and -not $ModuleProfile }
    }
}

Describe 'Get-CommittedTypesDrift' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'automation/.compiled')) | Out-Null
        Mock Import-InternalModule -ModuleName Catzc.Base.QualityGates { }
        Mock Get-CombinedTypeHash -ModuleName Catzc.Base.QualityGates { [pscustomobject]@{ CombinedHash = 'abcd1234' } }
        Mock Test-GitPathChanged -ModuleName Catzc.Base.QualityGates { $false }
    }

    It 'reports nothing for exactly the current, committed assembly' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'automation/.compiled/Catzc.Types.abcd1234.dll'), 'widget')
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            @(Get-CommittedTypesDrift -RepositoryRoot $Root) | Should -BeNullOrEmpty
        }
    }

    It 'reports a stale assembly and pending git changes' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'automation/.compiled/Catzc.Types.0000ffff.dll'), 'widget')
        Mock Test-GitPathChanged -ModuleName Catzc.Base.QualityGates { $true }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            $reasons = @(Get-CommittedTypesDrift -RepositoryRoot $Root)
            $reasons | Should -HaveCount 2
            $reasons[0] | Should -BeLike 'automation/.compiled/Catzc.Types.0000ffff.dll is not the current assembly Catzc.Types.abcd1234.dll*'
            $reasons[1] | Should -BeLike 'automation/.compiled has pending git changes*'
        }
    }

    It 'reports more than one assembly' {
        [System.IO.File]::WriteAllText((Join-Path $script:root 'automation/.compiled/Catzc.Types.abcd1234.dll'), 'widget')
        [System.IO.File]::WriteAllText((Join-Path $script:root 'automation/.compiled/Catzc.Types.0000ffff.dll'), 'gadget')
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Root = $script:root } {
            Get-CommittedTypesDrift -RepositoryRoot $Root | Should -BeLike 'automation/.compiled holds 2 Catzc.Types.*.dll*'
        }
    }
}

Describe 'Get-ModuleSourceFunctions' -Tag 'L0', 'logic' {
    It 'reads the public and private function names from the module folder' {
        $automation = Join-Path $TestDrive 'automation'
        foreach ($file in 'Catzc.Gadget/Set-Gadget.ps1', 'Catzc.Gadget/Get-Gadget.ps1', 'Catzc.Gadget/private/Resolve-Gadget.ps1') {
            $path = Join-Path $automation $file
            [System.IO.Directory]::CreateDirectory((Split-Path $path -Parent)) | Out-Null
            [System.IO.File]::WriteAllText($path, '')
        }
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Automation = $automation } {
            $source = Get-ModuleSourceFunctions -AutomationRoot $Automation -Name 'Catzc.Gadget'
            $source.Public | Should -Be @('Get-Gadget', 'Set-Gadget')
            $source.Private | Should -Be @('Resolve-Gadget')
        }
    }

    It 'returns empty sets for a module with no private folder' {
        $automation = Join-Path $TestDrive 'bare'
        [System.IO.Directory]::CreateDirectory((Join-Path $automation 'Catzc.Widget')) | Out-Null
        InModuleScope Catzc.Base.QualityGates -Parameters @{ Automation = $automation } {
            $source = Get-ModuleSourceFunctions -AutomationRoot $Automation -Name 'Catzc.Widget'
            @($source.Public).Count | Should -Be 0
            @($source.Private).Count | Should -Be 0
        }
    }
}
