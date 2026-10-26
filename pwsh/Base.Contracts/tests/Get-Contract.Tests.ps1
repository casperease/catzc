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
        Mock Get-GitTrackedPath { 'gadgets/flows/a.yml', 'gadgets/flows/deep/b.yml', 'gadgets/other.yml', 'widget.yml', 'gadget.yml' } -ModuleName Catzc.Base.Contracts
    }

    Context 'the tree' {
        It 'gives an empty result for an empty contracts folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/README.md' '# contracts'
            Add-Asset 'contracts/.gitkeep' ''
            @(Get-Contract -RepositoryRoot $script:root).Count | Should -Be 0
        }

        It 'gives an empty result when there is no contracts folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            @(Get-Contract -RepositoryRoot $script:root).Count | Should -Be 0
        }

        It 'parses the root, version, group and path from the folders, in communication form' -Tag 'ADR-REPO-CONTRACT-LAYOUT', 'ADR-AUTO-PATH-COMMUNICATIONFORM' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/build.yml'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  gadgets/build.yml: ['gadget.yml']"

            $asset = Get-Contract -RepositoryRoot $script:root
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.Root | Should -Be 'widget'
            $asset.Version | Should -Be '0.1.0'
            $asset.Group | Should -Be 'gadgets'
            $asset.Path | Should -Be 'build.yml'
            $asset.AssetPath | Should -Be 'contracts/widget/0.1.0/gadgets/build.yml'
            $asset.Target | Should -Be 'gadget.yml'
        }

        It 'lists an asset directly in a version folder with no group' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.1.0/widget.md' ''
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  widget.md: ['widget.yml']"

            $asset = Get-Contract -RepositoryRoot $script:root
            $asset.Group | Should -Be ''
            $asset.AssetPath | Should -Be 'contracts/widget/0.1.0/widget.md'
        }

        It 'lists every root and group in ordinal order, the version folder''s own files first' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/b.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/gadgets/a.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/cogs/z.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/y.sample.json' '{}'
            Add-Asset 'contracts/gadget/0.1.0/cogs/c.sample.json' '{}'

            (Get-Contract -RepositoryRoot $script:root).AssetPath | Should -Be @(
                'contracts/gadget/0.1.0/cogs/c.sample.json'
                'contracts/widget/0.1.0/y.sample.json'
                'contracts/widget/0.1.0/cogs/z.sample.json'
                'contracts/widget/0.1.0/gadgets/a.sample.json'
                'contracts/widget/0.1.0/gadgets/b.sample.json'
            )
        }

        It 'throws on a version folder that is not a three-part version' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/v1/gadgets/a.sample.json' '{}'
            { Get-Contract -RepositoryRoot $script:root } | Should -Throw "*'v1' is not a version folder*"
        }

        It 'throws on a file directly in a root folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/gadget.md'
            { Get-Contract -RepositoryRoot $script:root } | Should -Throw "*'gadget.md' sits outside a version folder*"
        }

        It 'throws on a folder below a group, since the tree is at most root, version, group, asset' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/flows/a.sample.json' '{}'
            { Get-Contract -RepositoryRoot $script:root } | Should -Throw "*'flows' is a folder below a group*"
        }

        It 'skips the .frozen record of a released version folder' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
            Add-Asset 'contracts/widget/1.0.0/gadgets/widget.sample.json' '{}'
            Add-Asset 'contracts/widget/1.0.0/.frozen' '# record'
            (Get-Contract -Version 1.0.0 -RepositoryRoot $script:root).AssetPath |
                Should -Be 'contracts/widget/1.0.0/gadgets/widget.sample.json'
        }

        It 'throws on a .frozen record in the current version, which is never frozen' -Tag 'ADR-REPO-CONTRACT-RELEASEDIMMUTABLE' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/widget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/.frozen' '# record'
            { Get-Contract -RepositoryRoot $script:root } | Should -Throw "*'.frozen' sits in the current version*"
        }
    }

    Context 'the selection' {
        BeforeEach {
            Add-Asset 'contracts/widget/0.1.0/cogs/widget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.schema.json' '{}'
            Add-Asset 'contracts/widget/1.0.0/cogs/widget.sample.json' '{}'
            Add-Asset 'contracts/gadget/0.1.0/cogs/widget.sample.json' '{}'
            Add-Asset 'contracts/gadget/2.1.0/cogs/widget.sample.json' '{}'
        }

        It 'lists each root''s 0.1.0 current version by default' -Tag 'ADR-AUTO-DEFAULT-ZEROARGUMENTCALL', 'ADR-REPO-CONTRACT-CURRENTVERSION' {
            $assets = Get-Contract -RepositoryRoot $script:root
            @($assets.Version | Sort-Object -Unique) | Should -Be @('0.1.0')
            @($assets.Root | Sort-Object -Unique) | Should -Be @('gadget', 'widget')
            $assets.Count | Should -Be 4
        }

        It 'lists the given versions, wildcards allowed' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract -RepositoryRoot $script:root -Version '1.0.0').AssetPath |
                Should -Be @('contracts/widget/1.0.0/cogs/widget.sample.json')
            @(Get-Contract -RepositoryRoot $script:root -Version *).Count | Should -Be 6
        }

        It 'lists the given root' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract gadget -RepositoryRoot $script:root).AssetPath |
                Should -Be @('contracts/gadget/0.1.0/cogs/widget.sample.json')
        }

        It 'lists the given group' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            (Get-Contract -RepositoryRoot $script:root -Group gadgets).Path |
                Should -Be @('gadget.sample.json', 'gadget.schema.json')
        }

        It 'keeps the assets whose path or target matches -Path' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            (Get-Contract -RepositoryRoot $script:root -Path '*.schema.json').Path | Should -Be @('gadget.schema.json')
        }

        It 'gives nothing for a root that does not exist' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
            @(Get-Contract sprocket -RepositoryRoot $script:root).Count | Should -Be 0
        }
    }

    Context 'the kind, from the name alone' {
        It 'reads <Name> as <Kind>' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' -ForEach @(
            @{ Name = 'widget.yml'; Content = 'widget: gadget'; Kind = 'Fragment'; Target = 'widget.yml' }
            @{ Name = 'widget.md'; Content = ''; Kind = 'Presence'; Target = 'widget.yml' }
            @{ Name = 'widget.md'; Content = "  `n`n"; Kind = 'Presence'; Target = 'widget.yml' }
            @{ Name = 'widget.yml.schema.json'; Content = '{}'; Kind = 'Schema'; Target = 'widget.yml' }
            @{ Name = 'gadget.sample.json'; Content = '{}'; Kind = 'Sample'; Target = $null }
            @{ Name = 'gadget.sample.yml'; Content = ''; Kind = 'Sample'; Target = $null }
        ) {
            Add-Asset "contracts/widget/0.1.0/gadgets/$Name" $Content
            if ($Kind -ne 'Sample') {
                Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  gadgets/${Name}: ['widget.yml']"
            }

            $asset = Get-Contract -RepositoryRoot $script:root
            $asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind] $Kind)
            $asset.Target | Should -Be $Target
        }

        It 'applies a schema to the sample payload of its name beside it, not to a real file' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.1.0/rest/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/rest/gadget.schema.json' '{}'

            $schema = Get-Contract -RepositoryRoot $script:root -Path '*.schema.json'
            $schema.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Schema)
            $schema.Target | Should -Be 'contracts/widget/0.1.0/rest/gadget.sample.json'
        }

        It 'applies a schema to the files its applies_to entry names when the sample of its name sits in another group' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.1.0/other/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/rest/gadget.schema.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  rest/gadget.schema.json: ['gadget.yml']"

            (Get-Contract -RepositoryRoot $script:root -Path '*.schema.json').Target | Should -Be 'gadget.yml'
        }

        It 'throws when a schema sits beside two sample payloads of its name' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.sample.yml' ''
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.schema.json' '{}'

            { Get-Contract -RepositoryRoot $script:root } | Should -Throw '*beside 2 sample payloads*'
        }
    }

    Context 'the direction' {
        It 'reads an asset under the <Root> root as <Direction>, whatever its name' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' -ForEach @(
            @{ Root = 'catzc'; Direction = 'Provided' }
            @{ Root = 'widget'; Direction = 'DependedOn' }
        ) {
            Add-Asset "contracts/$Root/0.1.0/gadgets/widget.yml"
            Add-Asset "contracts/$Root/0.1.0/gadgets/gadget.sample.json" '{}'
            Add-Asset "contracts/$Root/0.1.0/contract.yml" "applies_to:`n  gadgets/widget.yml: ['widget.yml']"

            $assets = @(Get-Contract -RepositoryRoot $script:root)
            $assets.Count | Should -Be 2
            @($assets.Direction | Sort-Object -Unique) |
                Should -Be @([Catzc.Base.Contracts.ContractDirection] $Direction)
        }

        It 'refuses a direction in contract.yml, which a root now decides' -Tag 'ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "direction:`n  gadgets/gadget.sample.json: provided`n"

            { Get-Contract -RepositoryRoot $script:root } | Should -Throw "*unknown key 'direction'*"
        }
    }

    Context 'the version''s applies_to' {
        It 'expands an entry into one asset per tracked file its globs match' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            Add-Asset 'contracts/widget/0.1.0/flows/flow.yml.schema.json' '{"type":"object"}'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  flows/flow.yml.schema.json: ['gadgets/flows/**/*.yml']"

            $assets = @(Get-Contract -RepositoryRoot $script:root)
            $assets.Target | Should -Be @('gadgets/flows/a.yml', 'gadgets/flows/deep/b.yml')
            @($assets.Path | Sort-Object -Unique) | Should -Be @('flow.yml.schema.json')
        }

        It 'lists the tracked files once, and only when an entry asks' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/gadget.sample.json' '{}'
            @(Get-Contract -RepositoryRoot $script:root).Count | Should -Be 1
            Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Contracts -Times 0 -Exactly

            Add-Asset 'contracts/widget/0.1.0/gadgets/a.yml'
            Add-Asset 'contracts/widget/0.1.0/gadgets/b.yml'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  gadgets/a.yml: ['widget.yml']`n  gadgets/b.yml: ['gadget.yml']"
            @(Get-Contract -RepositoryRoot $script:root).Count | Should -Be 3
            Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Contracts -Times 1 -Exactly
        }

        It 'throws on an entry that matches no tracked file, names no asset, or names a sample, a command or a schema of a sample' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' -ForEach @(
            @{ Key = 'flows/flow.yml.schema.json'; Glob = 'nothing/*.yml'; Message = '*matches no tracked file*' }
            @{ Key = 'flows/gadget.yml.schema.json'; Glob = 'flows/*.yml'; Message = "*applies_to names 'flows/gadget.yml.schema.json', but no such asset*" }
            @{ Key = 'flows/widget.sample.json'; Glob = 'widget.yml'; Message = '*a Sample asset; only a schema, fragment or presence asset*' }
            @{ Key = 'flows/cog.schema.json'; Glob = 'widget.yml'; Message = '*a schema that applies to the sample payload beside it*' }
        ) {
            Add-Asset 'contracts/widget/0.1.0/flows/flow.yml.schema.json' '{"type":"object"}'
            Add-Asset 'contracts/widget/0.1.0/flows/widget.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/flows/cog.sample.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/flows/cog.schema.json' '{}'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  flows/flow.yml.schema.json: ['gadgets/flows/a.yml']`n  ${Key}: ['$Glob']"
            if ($Key -ceq 'flows/flow.yml.schema.json') {
                Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  ${Key}: ['$Glob']"
            }

            { Get-Contract -RepositoryRoot $script:root } | Should -Throw $Message
        }

        It 'throws on a fragment or a schema with no sample that applies_to does not name' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' -ForEach @(
            @{ Name = 'widget.yml' }
            @{ Name = 'widget.yml.schema.json' }
        ) {
            Add-Asset "contracts/widget/0.1.0/gadgets/$Name" '{}'
            { Get-Contract -RepositoryRoot $script:root } |
                Should -Throw "*'gadgets/$Name'*is not named in applies_to, so it binds no file*"
        }

        It 'reads a contract.yml only for its own version folder' -Tag 'ADR-REPO-CONTRACT-CONFIGUREDADDRESSING' {
            Add-Asset 'contracts/widget/0.1.0/gadgets/widget.yml'
            Add-Asset 'contracts/widget/0.1.0/contract.yml' "applies_to:`n  gadgets/widget.yml: ['widget.yml']"
            Add-Asset 'contracts/widget/1.0.0/gadgets/widget.yml'
            Add-Asset 'contracts/widget/1.0.0/contract.yml' "applies_to:`n  gadgets/widget.yml: ['gadget.yml']"

            (Get-Contract -RepositoryRoot $script:root -Version *).Target | Should -Be @('widget.yml', 'gadget.yml')
        }
    }

    Context 'a command contract' -Tag 'ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS' {
        BeforeEach {
            Mock -ModuleName Catzc.Base.Contracts Get-CatzcModule {
                [pscustomobject]@{ name = 'Catzc.Widget'; root = 'widgets/Catzc.Widget'; languages = @('powershell') }
            }
        }

        It 'targets the command file, named in PowerShell''s function case, under the module root the one resolver gives, and is provided' {
            Add-Asset 'contracts/catzc/0.1.0/catzc.widget/get_widget.command.yml' 'parameters:'
            $asset = Get-Contract -RepositoryRoot $script:root
            $asset.Kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind]::Command)
            $asset.Target | Should -Be 'widgets/Catzc.Widget/Get-Widget.ps1'
            $asset.Direction | Should -Be ([Catzc.Base.Contracts.ContractDirection]::Provided)
            Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly
        }

        It 'resolves the module once for all its command contracts, and not at all without one' {
            Add-Asset 'contracts/catzc/0.1.0/catzc.widget/get_widget.command.yml' 'parameters:'
            Add-Asset 'contracts/catzc/0.1.0/catzc.widget/set_widget.command.yml' 'parameters:'
            Add-Asset 'contracts/catzc/0.1.0/catzc.gadget/gadget.sample.json' '{}'
            @(Get-Contract -RepositoryRoot $script:root).Count | Should -Be 3
            Should -Invoke -ModuleName Catzc.Base.Contracts Get-CatzcModule -Times 1 -Exactly -ParameterFilter { $Name -ceq 'Catzc.Widget' }
        }

        It 'throws on a command contract with no group, since the group names its module' {
            Add-Asset 'contracts/catzc/0.1.0/get_widget.command.yml' 'parameters:'
            { Get-Contract -RepositoryRoot $script:root } | Should -Throw '*sits in its module''s group folder*'
        }

        It 'throws on a command contract whose file name is not in the normal form' {
            Add-Asset 'contracts/catzc/0.1.0/catzc.widget/Get-Widget.command.yml' 'parameters:'
            { Get-Contract -RepositoryRoot $script:root } |
                Should -Throw "*the command 'Get-Widget' is not in the repository normal form, snake*"
        }
    }
}
