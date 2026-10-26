Describe 'Get-PathModule' -Tag 'L0', 'logic', 'DDR-TRACK-ONETECHSTACK' {
    BeforeAll {
        $script:types = [Catzc.Base.Variants.ModuleTypesConfig]::new(@{
                module_types = [ordered]@{
                    'widget-folder' = [ordered]@{
                        definition = 'A widget folder.'
                        places     = @(
                            @{ root = 'widgetry'; name = 'folder' }
                            @{ root = 'widgetry/.core'; name = 'folder'; prefix = 'Widget.Core.' }
                        )
                    }
                    'widget-file'   = [ordered]@{ definition = 'A widget file.'; places = @(@{ root = 'widgetry/.core'; name = 'file'; extension = 'wdg' }) }
                    'widget-tool'   = [ordered]@{ definition = 'A widget tool.'; places = @(@{ root = '.gizmo'; name = 'root' }) }
                }
            })
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'module-types' } { $script:types }
    }

    It 'returns the module and its type for a file placed in one' {
        $module = Get-PathModule 'widgetry/Gadget/private/Cog.ps1'
        $module | Should -BeOfType [Catzc.Base.Variants.PathModule]
        $module.name | Should -BeExactly 'Gadget'
        $module.type | Should -BeExactly 'widget-folder'
    }

    It 'names a module from a psm1-like single file and from a prefixed folder' {
        (Get-PathModule 'widgetry/.core/Widget.Core.Kit.wdg').name | Should -BeExactly 'Widget.Core.Kit'
        (Get-PathModule 'widgetry/.core/tests/Cog.ps1').name | Should -BeExactly 'Widget.Core.Tests'
    }

    It 'names a tool folder by itself' {
        $module = Get-PathModule '.gizmo/settings.json'
        $module.name | Should -BeExactly '.gizmo'
        $module.type | Should -BeExactly 'widget-tool'
    }

    It 'accepts a backslash path' {
        (Get-PathModule 'widgetry\Gadget\Cog.ps1').name | Should -BeExactly 'Gadget'
    }

    It 'places a path no module type places in no module, and returns nothing' -ForEach @(
        @{ Path = 'papers/guide.md' }
        @{ Path = 'widgetry/Cog.ps1' }
        @{ Path = 'widgetry/.hidden/Cog.ps1' }
        @{ Path = 'importer.ps1' }
        @{ Path = '' }
    ) {
        @(Get-PathModule $Path).Count | Should -Be 0
    }
}

Describe 'Get-PathModule on the shipped module-types registry' -Tag 'L0', 'logic', 'DDR-TRACK-ONETECHSTACK' {
    It 'places a file in the module, and the module type, its folder names' -ForEach @(
        @{ Path = "$(Get-CatzcModulesFolder)/Catzc.Base.Variants/Get-Track.ps1"; Name = 'Catzc.Base.Variants'; Type = 'pwsh-folder' }
        @{ Path = "$(Get-CatzcModulesFolder)/.internal/Catzc.Internal.Types.psm1"; Name = 'Catzc.Internal.Types'; Type = 'pwsh-psm1' }
        @{ Path = "$(Get-CatzcModulesFolder)/.internal/tests/Assert-CatzcRunModeExclusive.Tests.ps1"; Name = 'Catzc.Internal.Tests'; Type = 'pwsh-folder' }
        @{ Path = "$(Get-CatzcModulesFolder)/.internal/assets/obj/Debug/x.cs"; Name = 'Catzc.Internal.Assets'; Type = 'pwsh-folder' }
        @{ Path = '.claude/agents/catzc-drone.md'; Name = '.claude'; Type = 'settings' }
        @{ Path = '.github/README.md'; Name = '.github'; Type = 'settings' }
        @{ Path = '.cspell/adr.txt'; Name = '.cspell'; Type = 'settings' }
        @{ Path = '.github/workflows/ci-pwsh.yml'; Name = 'workflows'; Type = 'pipeline' }
        @{ Path = '.ado/pipelines/cd-apex.yaml'; Name = 'pipelines'; Type = 'pipeline' }
        @{ Path = 'python/tests/catzc_base_repository/test_repository.py'; Name = 'python'; Type = 'python' }
        @{ Path = 'go/tests/catzcbaserepository/repository_test.go'; Name = 'go'; Type = 'go' }
        @{ Path = 'bash/tests/catzc-base-repository/repository.bats'; Name = 'bash'; Type = 'bash' }
        @{ Path = 'python/pyproject.toml'; Name = 'python'; Type = 'python' }
        @{ Path = 'python/Widget.Gadget/gadget.py'; Name = 'Widget.Gadget'; Type = 'python' }
        @{ Path = 'go/Widget.Gadget/gadget.go'; Name = 'Widget.Gadget'; Type = 'go' }
        @{ Path = 'bash/Widget.Gadget/gadget.sh'; Name = 'Widget.Gadget'; Type = 'bash' }
        @{ Path = 'infrastructure/templates/sample/main.bicep'; Name = 'sample'; Type = 'bicep' }
        @{ Path = 'infrastructure/modules/storage.bicep'; Name = 'storage'; Type = 'bicep' }
    ) {
        $module = Get-PathModule $Path
        $module.name | Should -BeExactly $Name
        $module.type | Should -BeExactly $Type
    }

    It 'places a documentation page, a contract, and a root file in no module' -ForEach @(
        @{ Path = 'docs/drs/index.md' }
        @{ Path = 'contracts/catzc/0.1.0/contract.yml' }
        @{ Path = 'importer.ps1' }
        @{ Path = "$(Get-CatzcModulesFolder)/.vendor/Pester/Pester.psd1" }
        @{ Path = "$(Get-CatzcModulesFolder)/.scriptanalyzer/Rule.psm1" }
    ) {
        @(Get-PathModule $Path).Count | Should -Be 0
    }
}
