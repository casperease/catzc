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
        # One module group exists, gizmos.widgets; the other is derived from the modules track, the folder holding .internal.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'contracts/catzc/0.1.0/gizmos.widgets')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root 'gizmos/.internal')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:root 'gizmos/.internal/Catzc.Internal.Types.psm1'), '')
    }

    It 'writes each module''s types, sorted by name, with their members, to types.json in its group' {
        $rows = @(& $script:write $script:surface)
        $rows | Should -HaveCount 2
        $rows.Written | Should -Be @($true, $true)
        $widgets = $rows | Where-Object Path -Like '*gizmos.widgets*types.json'
        $gadgets = $rows | Where-Object Path -Like '*gizmos.gadget_box*types.json'
        $text = [System.IO.File]::ReadAllText($widgets.Path)
        $text | Should -Not -Match "`r"
        $text.EndsWith("`n") | Should -BeTrue
        $json = $text | ConvertFrom-Json -AsHashtable
        $json.Keys | Should -Be @('//', 'types')
        @($json['types'].ForEach({ $_['name'] })) | Should -Be @('Catzc.Widgets.Cog', 'Catzc.Widgets.Widget')
        @($json['types'][1]['aliases']) | Should -Be @('Catzc.Widget')
        @($json['types'][1]['members'].ForEach({ "$($_['name']):$($_['kind'])" })) | Should -Be @('Name:property', 'Spin:method')
        # Prettier's form: every object one key per line, a string array that fits the width on one line.
        $text | Should -Match '(?m)^      "aliases": \["Catzc\.Widget"\],$'
        $text | Should -Match '(?m)^          "name": "Spin",$'
        @(([System.IO.File]::ReadAllText($gadgets.Path) | ConvertFrom-Json -AsHashtable)['types'].ForEach({ $_['name'] })) |
            Should -Be @('Catzc.GadgetBox.Gadget')
    }

    It 'stamps the "//" head with the warning, the regenerate command and the sha of the body without the stamp' {
        $rows = @(& $script:write $script:surface)
        $text = [System.IO.File]::ReadAllText(($rows | Where-Object Path -Like '*gizmos.widgets*types.json').Path)
        $stamp = ($text | ConvertFrom-Json -AsHashtable)['//']
        $stamp | Should -BeLike "catzc:`n  immutable:`n    warning: `"$((Get-Config -Config generated-head).warning)`"`n    regenerate: `". ./importer.ps1`"`n    with_body_sha: *"
        $body = [Catzc.Base.CodeMeta.PropertyHead]::Parse($text, '//').WithFacts([ordered]@{}, [ordered]@{})
        $body | Should -Not -BeLike '*"//"*'
        $stamp | Should -BeLike "*with_body_sha: *$([Catzc.Base.MarkdownMeta.MarkdownDocument]::HashOf($body))*"
    }

    It 'leaves a file alone when its surface did not move, and writes only the moved one when a member is added' {
        $null = & $script:write $script:surface
        @(& $script:write $script:surface).Written | Should -Be @($false, $false) -Because 'an equal surface leaves git clean'
        $moved = @($script:surface[0], $script:surface[1],
            [pscustomobject]@{ Name = 'Catzc.GadgetBox.Gadget'; Aliases = @(); Display = @('Name', 'Size')
                Members = @([pscustomobject]@{ Name = 'Open'; Kind = 'method' })
            })
        $rows = @(& $script:write $moved)
        ($rows | Where-Object Written).Path | Should -BeLike '*gizmos.gadget_box*'
        @(& $script:write $moved).Written | Should -Be @($false, $false)
    }

    Context 'argument-free, as Restore-Generated runs it' {
        BeforeAll {
            $script:modulesRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot))
            # The record is session-global and the session's own, so each case swaps in a fixture and puts the real one back.
            $script:withRecords = {
                param([hashtable] $Records, [scriptblock] $Body)
                $kept = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
                try {
                    Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value $Records
                    InModuleScope Catzc.Internal.Types $Body
                }
                finally {
                    Set-Variable -Name '__CatzcDeferredTypes' -Scope Global -Value $kept
                }
            }
        }

        It 'describes the build the import recorded for the modules root' {
            $records = @{ $script:modulesRoot = @{ Path = 'C:/widget/Catzc.Types.feed.dll'; Loaded = $true } }
            { & $script:withRecords $records {
                    Mock Get-TypesAssemblyManifest { throw "described:$Path" }
                    Write-TypesContract -RepositoryRoot 'C:/widget-root'
                } } | Should -Throw 'described:C:/widget/Catzc.Types.feed.dll'
        }

        It 'throws, naming the modules root, when the session recorded no build for it' {
            { & $script:withRecords @{ 'C:/gadget/pwsh' = @{ Path = 'C:/gadget/Catzc.Types.feed.dll' } } {
                    Write-TypesContract -RepositoryRoot 'C:/widget-root'
                } } | Should -Throw "*recorded no types assembly for '$($script:modulesRoot)'*"
        }

        It 'writes under the folder holding the modules root' {
            $expected = [System.IO.Path]::GetDirectoryName($script:modulesRoot)
            { & $script:withRecords @{} {
                    Mock Get-TypesAssemblyManifest { [pscustomobject]@{ Types = @([pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @(); Display = @(); Members = @() }) } }
                    Mock Get-TypesContractPath { throw "root:$RepositoryRoot" }
                    Write-TypesContract -Path 'C:/widget/Catzc.Types.feed.dll'
                } } | Should -Throw "root:$expected"
        }
    }

    It 'deletes the types.json of a module that builds no type, and its group when that leaves it empty' {
        $null = & $script:write $script:surface
        $rows = @(& $script:write @($script:surface[0], $script:surface[1]))
        ($rows | Where-Object Written).Path | Should -BeLike '*gizmos.gadget_box*types.json'
        Join-Path $script:root 'contracts/catzc/0.1.0/gizmos.gadget_box' | Should -Not -Exist
    }
}
