Describe 'Get-TypesContractDrift' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
        $script:root = Join-Path $TestDrive 'repo'
        $script:contract = Join-Path $script:root 'contracts/catzc/0.1.0/pwsh.widgets/types.json'
        [System.IO.Directory]::CreateDirectory((Split-Path $script:contract)) | Out-Null
        $script:surface = @(
            [pscustomobject]@{ Name = 'Catzc.Widgets.Gadget'; Aliases = @(); Display = @('Name'); Members = @() },
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget'); Display = @()
                Members = @([pscustomobject]@{ Name = 'Spin'; Kind = 'method' })
            }
        )
        $script:writeContract = {
            param([string] $Path, [object[]] $Types)
            $json = ConvertTo-Json -InputObject @{ types = @($Types | ForEach-Object {
                        [ordered]@{ name = $_.Name; aliases = @($_.Aliases); display = @($_.Display)
                            members = @($_.Members | ForEach-Object { [ordered]@{ name = $_.Name; kind = $_.Kind } })
                        }
                    })
            } -Depth 5
            [System.IO.Directory]::CreateDirectory((Split-Path $Path)) | Out-Null
            [System.IO.File]::WriteAllText($Path, $json)
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
        & $script:writeContract $script:contract $script:surface
        @(& $script:drift) | Should -BeNullOrEmpty
    }

    It 'skips the "//" stamp: a stamp that says anything leaves the surface in agreement' {
        & $script:writeContract $script:contract $script:surface
        $text = [System.IO.File]::ReadAllText($script:contract)
        [System.IO.File]::WriteAllText($script:contract, $text.Insert($text.IndexOf('{') + 1, "`n  `"//`": `"catzc:\n  immutable:\n    warning: widget`","))
        ([System.IO.File]::ReadAllText($script:contract) | ConvertFrom-Json -AsHashtable).ContainsKey('//') | Should -BeTrue
        @(& $script:drift) | Should -BeNullOrEmpty
    }

    It 'names every added, removed and changed type, a changed member included, in one reason' {
        & $script:writeContract $script:contract @(
            [pscustomobject]@{ Name = 'Catzc.Widgets.Gadget'; Aliases = @(); Display = @('Name'); Members = @() },
            [pscustomobject]@{ Name = 'Catzc.Widgets.Sprocket'; Aliases = @(); Display = @(); Members = @() }
        )
        $script:surface = @($script:surface[0], $script:surface[1])
        $reasons = @(& $script:drift)
        $reasons | Should -HaveCount 1
        $reasons[0] | Should -BeLike '*pwsh.widgets/types.json differs*added `[Catzc.Widgets.Widget`], removed `[Catzc.Widgets.Sprocket`], changed `[`]*'

        & $script:writeContract $script:contract @($script:surface[0],
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget'); Display = @(); Members = @() })
        (& $script:drift) | Should -BeLike '*changed `[Catzc.Widgets.Widget`]*'
    }

    It 'reports a contract left over by a module that builds no type' {
        & $script:writeContract $script:contract $script:surface
        $stale = Join-Path $script:root 'contracts/catzc/0.1.0/pwsh.sprockets/types.json'
        & $script:writeContract $stale @()
        (& $script:drift) | Should -BeLike '*pwsh.sprockets/types.json names a module that builds no type*'
        Remove-Item -LiteralPath (Split-Path $stale) -Recurse
    }

    It 'reports a missing contract' {
        Remove-Item -LiteralPath $script:contract
        (& $script:drift) | Should -BeLike '*pwsh.widgets/types.json is missing*'
    }
}
