<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/tests/Get-Contract.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-Contract' -Tag 'L0', 'logic' {
    BeforeAll {
        function Add-Asset {
            param([string] $Relative, [string] $Content = 'widget: gadget')
            $file = Join-Path $script:root $Relative
            $null = New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetDirectoryName($file))
            [System.IO.File]::WriteAllText($file, $Content)
        }
    }

    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('n'))
        $null = New-Item -ItemType Directory -Force -Path $script:root
    }

    Context 'the tree' {
        It 'gives an empty result for an empty contracts folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/README.md' '# contracts'
            Add-Asset 'contracts/.gitkeep' ''
            @(Get-Contract -RepositoryRoot $script:root -Addressing full-path).Count | Should -Be 0
        }

        It 'gives an empty result when there is no contracts folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            @(Get-Contract -RepositoryRoot $script:root -Addressing full-path).Count | Should -Be 0
        }

        It 'parses the unit, version, module and path from the folders, in communication form' -Tag 'ADR-REPO-CONTRACT-LAYOUT', 'ADR-AUTO-PATH-COMMUNICATIONFORM' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml'

            $asset = Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{}
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.Unit | Should -Be 'widget'
            $asset.Version | Should -Be '0.0.0'
            $asset.Module | Should -Be 'Catzc.Gadget'
            $asset.Path | Should -Be 'flows/build.yml'
            $asset.AssetPath | Should -Be 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml'
            $asset.Target | Should -Be 'flows/build.yml'
        }

        It 'lists every unit and module in ordinal order' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/b.md'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/a.md'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/z.md'
            Add-Asset 'contracts/gadget/0.0.0/Catzc.Widget/c.md'

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path).AssetPath | Should -Be @(
                'contracts/gadget/0.0.0/Catzc.Widget/c.md'
                'contracts/widget/0.0.0/Catzc.Gadget/z.md'
                'contracts/widget/0.0.0/Catzc.Widget/a.md'
                'contracts/widget/0.0.0/Catzc.Widget/b.md'
            )
        }

        It 'throws on a version folder that is not a three-part version' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/v1/Catzc.Widget/a.md'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw "*'v1' is not a version folder*"
        }

        It 'throws on a file outside a module folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/gadget.md'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw "*'gadget.md' sits outside a module folder*"
        }

        It 'skips the .frozen record of a released version folder' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
            Add-Asset 'contracts/widget/1.0.0/Catzc.Widget/widget.md'
            Add-Asset 'contracts/widget/1.0.0/.frozen' '# record'
            (Get-Contract -Version 1.0.0 -RepositoryRoot $script:root -Addressing full-path).AssetPath |
                Should -Be 'contracts/widget/1.0.0/Catzc.Widget/widget.md'
        }

        It 'throws on a .frozen record in the draft, which is never frozen' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.md'
            Add-Asset 'contracts/widget/0.0.0/.frozen' '# record'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw "*'.frozen' sits outside a module folder*"
        }

        It 'throws on a file directly in a unit folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/gadget.md'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw "*'gadget.md' sits outside a version folder*"
        }
    }

    Context 'the selection' {
        BeforeEach {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.md'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/gadget.yml'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/gadget.yml.schema.json' '{}'
            Add-Asset 'contracts/widget/1.0.0/Catzc.Widget/widget.md'
            Add-Asset 'contracts/gadget/0.0.0/Catzc.Widget/widget.md'
            Add-Asset 'contracts/gadget/2.1.0/Catzc.Widget/widget.md'
        }

        It 'lists each unit''s 0.0.0 draft by default' -Tag 'ADR-AUTO-DEFAULT-ZEROARGUMENTCALL', 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
            $assets = Get-Contract -RepositoryRoot $script:root -Addressing full-path
            @($assets.Version | Sort-Object -Unique) | Should -Be @('0.0.0')
            @($assets.Unit | Sort-Object -Unique) | Should -Be @('gadget', 'widget')
            $assets.Count | Should -Be 4
        }

        It 'lists the given versions, wildcards allowed' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Version '1.0.0').AssetPath |
                Should -Be @('contracts/widget/1.0.0/Catzc.Widget/widget.md')
            @(Get-Contract -RepositoryRoot $script:root -Addressing full-path -Version *).Count | Should -Be 6
        }

        It 'lists the given unit' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract gadget -RepositoryRoot $script:root -Addressing full-path).AssetPath |
                Should -Be @('contracts/gadget/0.0.0/Catzc.Widget/widget.md')
        }

        It 'lists the given module' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Module Catzc.Gadget).Path |
                Should -Be @('gadget.yml', 'gadget.yml.schema.json')
        }

        It 'keeps the assets whose path or target matches -Path' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path 'gadget.yml').Path |
                Should -Be @('gadget.yml', 'gadget.yml.schema.json')
            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path '*.schema.json').Path |
                Should -Be @('gadget.yml.schema.json')
        }

        It 'gives nothing for a unit that does not exist' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            @(Get-Contract sprocket -RepositoryRoot $script:root -Addressing full-path).Count | Should -Be 0
        }
    }

    Context 'the kind, from the name alone' {
        It 'reads <Name> as <Kind>' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' -ForEach @(
            @{ Name = 'widget.yml'; Content = 'widget: gadget'; Kind = 'Fragment'; Target = 'widget.yml' }
            @{ Name = 'widget.md'; Content = ''; Kind = 'Presence'; Target = 'widget.md' }
            @{ Name = 'widget.md'; Content = "  `n`n"; Kind = 'Presence'; Target = 'widget.md' }
            @{ Name = 'widget.yml.schema.json'; Content = '{}'; Kind = 'Schema'; Target = 'widget.yml' }
            @{ Name = 'gadget.sample.json'; Content = '{}'; Kind = 'Sample'; Target = $null }
            @{ Name = 'gadget.sample.yml'; Content = ''; Kind = 'Sample'; Target = $null }
        ) {
            Add-Asset "contracts/widget/0.0.0/Catzc.Widget/$Name" $Content

            $asset = Get-Contract -RepositoryRoot $script:root -Addressing full-path
            $asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind] $Kind)
            $asset.Target | Should -Be $Target
        }

        It 'applies a schema to the sample payload of its name beside it, not to a real file' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.schema.json' '{}'

            $schema = Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path '*.schema.json'
            $schema.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Schema)
            $schema.Target | Should -Be 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.sample.json'
        }

        It 'applies a schema to the real file when the sample of its name sits in another folder' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/other/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/rest/gadget.schema.json' '{}'

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path '*.schema.json').Target | Should -Be 'rest/gadget'
        }

        It 'throws when a schema sits beside two sample payloads of its name' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.sample.yml' ''
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.schema.json' '{}'

            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw '*beside 2 sample payloads*'
        }
    }

    Context 'the direction' {
        It 'reads <Name> as <Direction> by convention' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' -ForEach @(
            @{ Name = 'widget.yml'; Content = 'widget: gadget'; Direction = 'DependedOn' }
            @{ Name = 'widget.md'; Content = ''; Direction = 'DependedOn' }
            @{ Name = 'widget.yml.schema.json'; Content = '{}'; Direction = 'DependedOn' }
            @{ Name = 'gadget.sample.json'; Content = '{}'; Direction = 'Provided' }
        ) {
            Add-Asset "contracts/widget/0.0.0/Catzc.Widget/$Name" $Content

            $asset = Get-Contract -RepositoryRoot $script:root -Addressing full-path
            $asset.Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection] $Direction)
            $asset.IsDirectionOverridden | Should -BeFalse
        }

        It 'reads a schema that applies to a sample payload as provided' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.schema.json' '{}'

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Path 'gadget.schema.json').Direction |
                Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
        }

        It 'lets the version''s contract.yml override one asset' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/gadget.yml'
            Add-Asset 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/gadget.sample.json: depended-on`n  Catzc.Widget/widget.yml: provided`n"

            $assets = Get-Contract -RepositoryRoot $script:root -Addressing full-path
            $assets.Count | Should -Be 3
            $byPath = @{}
            $assets | ForEach-Object { $byPath[$_.Path] = $_ }
            $byPath['gadget.sample.json'].Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection]::DependedOn)
            $byPath['gadget.sample.json'].IsDirectionOverridden | Should -BeTrue
            $byPath['widget.yml'].Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
            $byPath['widget.yml'].IsDirectionOverridden | Should -BeTrue
            $byPath['gadget.yml'].Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection]::DependedOn)
            $byPath['gadget.yml'].IsDirectionOverridden | Should -BeFalse
        }

        It 'applies a contract.yml only to its own version folder' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'
            Add-Asset 'contracts/widget/1.0.0/Catzc.Widget/widget.yml'
            Add-Asset 'contracts/widget/1.0.0/contract.yml' "direction:`n  Catzc.Widget/widget.yml: provided`n"

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path).Direction |
                Should -Be ([Catzc.Base.Contracts.ContractDirection]::DependedOn)
            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -Version 1.0.0).Direction |
                Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
        }

        It 'throws on a contract.yml entry that names no asset' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'
            Add-Asset 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/gadget.yml: provided`n"

            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw "*'Catzc.Widget/gadget.yml' is overridden, but no such asset exists*"
        }

        It 'throws on a contract.yml direction that is not provided or depended-on' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'
            Add-Asset 'contracts/widget/0.0.0/contract.yml' "direction:`n  Catzc.Widget/widget.yml: sideways`n"

            { Get-Contract -RepositoryRoot $script:root -Addressing full-path } | Should -Throw '*valid: provided, depended-on*'
        }
    }

    Context 'the target root' {
        It 'places each target under its module''s target root, and the others under the repository root' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml.schema.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.schema.json' '{}'
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/flows/build.yml'

            $assets = Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{ 'Catzc.Gadget' = '.gadget/ci' }
            $byPath = @{}
            $assets | ForEach-Object { $byPath[$_.AssetPath] = $_ }
            $byPath['contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml'].Target | Should -Be '.gadget/ci/flows/build.yml'
            $byPath['contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml.schema.json'].Target | Should -Be '.gadget/ci/flows/build.yml'
            $byPath['contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.schema.json'].Target |
                Should -Be 'contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.sample.json'
            $byPath['contracts/widget/0.0.0/Catzc.Gadget/rest/gadget.sample.json'].Target | Should -BeNullOrEmpty
            $byPath['contracts/widget/0.0.0/Catzc.Widget/flows/build.yml'].Target | Should -Be 'flows/build.yml'
        }

        It 'keeps an asset whose target, under its root, matches -Path' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Gadget/flows/build.yml'

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{ 'Catzc.Gadget' = '.gadget' } -Path '.gadget/flows/*').Path |
                Should -Be 'flows/build.yml'
        }

        It 'takes the target roots from the contracts config, keyed by the module''s normal form' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER', 'ADR-REPO-CONTRACT-LAYOUT' {
            Mock Get-Config { [Catzc.Base.Contracts.ContractsConfig]::new(@{ target_roots = @{ 'catzc.widget' = '.widget' } }) } -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'contracts' }
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/widget.yml'

            (Get-Contract -RepositoryRoot $script:root).Target | Should -Be '.widget/widget.yml'
        }

        It 'looks up a unit that keeps its source''s folder names by their normal form' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.WidgetGadget/widget.yml'

            (Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{ 'catzc.widget_gadget' = '.widget' }).Target | Should -Be '.widget/widget.yml'
        }

        It 'rejects a target root that is not a repository-relative folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'

            { Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{ 'Catzc.Widget' = '../gadget' } } |
                Should -Throw "*target root '../gadget' of 'Catzc.Widget'*"
        }
    }

    Context 'the addressing mode' {
        It 'takes the addressing from the contracts config, whose default is full-path' -Tag 'ADR-AUTO-DEFAULT-ONERESOLUTIONORDER', 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            Mock Get-Config { [Catzc.Base.Contracts.ContractsConfig]::new(@{}) } -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'contracts' }
            Add-Asset 'contracts/widget/0.0.0/Catzc.Widget/widget.yml'

            (Get-Contract -RepositoryRoot $script:root -TargetRoot @{}).Path | Should -Be 'widget.yml'
            Should -Invoke Get-Config -ModuleName Catzc.Base.Contracts -Times 1 -Exactly -ParameterFilter { $Config -eq 'contracts' }
        }

        It 'throws NotImplementedException for the declared mode <Mode>, before listing anything' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' -ForEach @(
            @{ Mode = 'manifest-glob' }
            @{ Mode = 'per-folder' }
        ) {
            Add-Asset 'contracts/widget/v1/Catzc.Widget/widget.yml'

            { Get-Contract -RepositoryRoot $script:root -Addressing $Mode } |
                Should -Throw -ExceptionType ([System.NotImplementedException]) -ExpectedMessage "*'$Mode' is declared but not built*"
        }

        It 'throws NotImplementedException when the config selects a mode that is not built' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            Mock Get-Config { [Catzc.Base.Contracts.ContractsConfig]::new(@{ addressing = 'manifest-glob' }) } -ModuleName Catzc.Base.Contracts -ParameterFilter { $Config -eq 'contracts' }

            { Get-Contract -RepositoryRoot $script:root } | Should -Throw -ExceptionType ([System.NotImplementedException])
        }

        It 'rejects a mode that is not declared, naming the declared ones' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            { Get-Contract -RepositoryRoot $script:root -Addressing gadget } | Should -Throw '*full-path, manifest-glob, per-folder*'
        }
    }

    Context 'a command contract' -Tag 'ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS' {
        BeforeEach {
            Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
                [pscustomobject]@{ name = 'Catzc.Widget'; root = 'widgets/Catzc.Widget'; languages = @('powershell') }
            }
        }

        It 'targets the command file, named in PowerShell''s function case, under the module root the one resolver gives, and is provided' {
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/get_widget.command.yml' 'parameters:'
            $asset = Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{}
            $asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Command)
            $asset.Target | Should -Be 'widgets/Catzc.Widget/Get-Widget.ps1'
            $asset.Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
            Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly
        }

        It 'resolves the module once for all its command contracts, and not at all without one' {
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/get_widget.command.yml' 'parameters:'
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/set_widget.command.yml' 'parameters:'
            Add-Asset 'contracts/widget/0.0.0/catzc.gadget/gadget.yml'
            @(Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{}).Count | Should -Be 3
            Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly -ParameterFilter { $Name -ceq 'Catzc.Widget' }
        }

        It 'throws on a command contract below a folder of the module' {
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/flows/get_widget.command.yml' 'parameters:'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{} } | Should -Throw '*sits directly in its module folder*'
        }

        It 'throws on a command contract whose file name is not in the normal form' {
            Add-Asset 'contracts/widget/0.0.0/catzc.widget/Get-Widget.command.yml' 'parameters:'
            { Get-Contract -RepositoryRoot $script:root -Addressing full-path -TargetRoot @{} } | Should -Throw "*the command 'Get-Widget' is not in the repository normal form, snake*"
        }
    }
}
