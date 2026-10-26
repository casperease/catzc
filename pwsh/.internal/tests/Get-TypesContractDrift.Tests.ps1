Describe 'Get-TypesContractDrift' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
        $script:root = Join-Path $TestDrive 'repo'
        $script:contract = Join-Path $script:root 'contracts/catzc/0.1.0/catzc.internal.types/types.sample.json'
        [System.IO.Directory]::CreateDirectory((Split-Path $script:contract)) | Out-Null
        $script:surface = @(
            [pscustomobject]@{ Name = 'Catzc.Gadgets.Gadget'; Aliases = @(); Display = @('Name') },
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget'); Display = @() }
        )
        $script:writeContract = {
            param([object[]] $Types)
            $json = ConvertTo-Json -InputObject @{ types = @($Types | ForEach-Object { [ordered]@{ name = $_.Name; aliases = @($_.Aliases); display = @($_.Display) } }) } -Depth 4
            [System.IO.File]::WriteAllText($script:contract, $json)
        }
        $script:drift = {
            InModuleScope Catzc.Internal.Types -Parameters @{ Types = $script:surface; Root = $script:root } {
                param($Types, $Root)
                # The mock reads the surface from the module's script scope, where this scope hands it.
                $script:mockedTypes = $Types
                Mock Get-TypesAssemblyManifest { [pscustomobject]@{ Types = $script:mockedTypes } }
                @(Get-TypesContractDrift -Path 'C:/widget/Catzc.Types.abcd1234.dll' -RepositoryRoot $Root)
            }
        }
    }

    It 'reports nothing while the committed contract is the build''s surface' {
        & $script:writeContract $script:surface
        @(& $script:drift) | Should -BeNullOrEmpty
    }

    It 'names every added, removed and changed type in one reason' {
        & $script:writeContract @(
            [pscustomobject]@{ Name = 'Catzc.Gadgets.Gadget'; Aliases = @(); Display = @('Name', 'Size') },
            [pscustomobject]@{ Name = 'Catzc.Sprockets.Sprocket'; Aliases = @(); Display = @() }
        )
        $reasons = @(& $script:drift)
        $reasons | Should -HaveCount 1
        $reasons[0] | Should -BeLike '*added `[Catzc.Widgets.Widget`], removed `[Catzc.Sprockets.Sprocket`], changed `[Catzc.Gadgets.Gadget`]*'
    }

    It 'reports a missing contract' {
        Remove-Item -LiteralPath $script:contract
        (& $script:drift) | Should -BeLike '*types.sample.json is missing*'
    }
}
