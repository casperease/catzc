Describe 'Write-TypesContract' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
        $script:write = {
            param([object[]] $Types)
            InModuleScope Catzc.Internal.Types -Parameters @{ Types = $Types; Root = $script:root } {
                param($Types, $Root)
                # The mock reads the surface from the module's script scope, where this scope hands it.
                $script:mockedTypes = $Types
                Mock Get-TypesAssemblyManifest { [pscustomobject]@{ Types = $script:mockedTypes } }
                Write-TypesContract -Path 'C:/widget/Catzc.Types.0badc0de.dll' -RepositoryRoot $Root
            }
        }
        $script:surface = @(
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget'); Display = @('Name')
                Members = @([pscustomobject]@{ Name = 'Name'; Kind = 'property' }, [pscustomobject]@{ Name = 'Spin'; Kind = 'method' })
            },
            [pscustomobject]@{ Name = 'Catzc.Widgets.Cog'; Aliases = @(); Display = @(); Members = @() },
            [pscustomobject]@{ Name = 'Catzc.GadgetBox.Gadget'; Aliases = @(); Display = @('Name', 'Size'); Members = @() }
        )
    }

    BeforeEach {
        # One module group exists, pwsh.widgets; the other is derived from the modules track, the folder holding .internal.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'contracts/catzc/0.1.0/pwsh.widgets')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'pwsh/.internal')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:root 'pwsh/.internal/Catzc.Internal.Types.psm1'), '')
    }

    It 'writes each module''s types, sorted by name, with their members, to types.json in its group' {
        $rows = @(& $script:write $script:surface)
        $rows | Should -HaveCount 2
        $rows.Written | Should -Be @($true, $true)
        $widgets = $rows | Where-Object Path -Like '*pwsh.widgets*types.json'
        $gadgets = $rows | Where-Object Path -Like '*pwsh.gadget_box*types.json'
        $text = [System.IO.File]::ReadAllText($widgets.Path)
        $text | Should -Not -Match "`r"
        $text.EndsWith("`n") | Should -BeTrue
        $json = $text | ConvertFrom-Json -AsHashtable
        $json.Keys | Should -Be @('types')
        @($json['types'].ForEach({ $_['name'] })) | Should -Be @('Catzc.Widgets.Cog', 'Catzc.Widgets.Widget')
        @($json['types'][1]['aliases']) | Should -Be @('Catzc.Widget')
        @($json['types'][1]['members'].ForEach({ "$($_['name']):$($_['kind'])" })) | Should -Be @('Name:property', 'Spin:method')
        # Prettier's form: every object one key per line, a string array that fits the width on one line.
        $text | Should -Match '(?m)^      "aliases": \["Catzc\.Widget"\],$'
        $text | Should -Match '(?m)^          "name": "Spin",$'
        @(([System.IO.File]::ReadAllText($gadgets.Path) | ConvertFrom-Json -AsHashtable)['types'].ForEach({ $_['name'] })) |
            Should -Be @('Catzc.GadgetBox.Gadget')
    }

    It 'leaves a file alone when its surface did not move, and writes only the moved one when a member is added' {
        $null = & $script:write $script:surface
        @(& $script:write $script:surface).Written | Should -Be @($false, $false) -Because 'an equal surface leaves git clean'
        $moved = @($script:surface[0], $script:surface[1],
            [pscustomobject]@{ Name = 'Catzc.GadgetBox.Gadget'; Aliases = @(); Display = @('Name', 'Size')
                Members = @([pscustomobject]@{ Name = 'Open'; Kind = 'method' })
            })
        $rows = @(& $script:write $moved)
        ($rows | Where-Object Written).Path | Should -BeLike '*pwsh.gadget_box*'
        @(& $script:write $moved).Written | Should -Be @($false, $false)
    }

    It 'deletes the types.json of a module that builds no type, and its group when that leaves it empty' {
        $null = & $script:write $script:surface
        $rows = @(& $script:write @($script:surface[0], $script:surface[1]))
        ($rows | Where-Object Written).Path | Should -BeLike '*pwsh.gadget_box*types.json'
        Join-Path $script:root 'contracts/catzc/0.1.0/pwsh.gadget_box' | Should -Not -Exist
    }
}
