Describe 'Write-TypesContract' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Types.psm1') -Force
        $script:root = Join-Path $TestDrive 'repo'
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
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget'); Display = @('Name') },
            [pscustomobject]@{ Name = 'Catzc.Gadgets.Gadget'; Aliases = @(); Display = @('Name', 'Size') }
        )
    }

    AfterAll {
        Remove-Module Catzc.Internal.Types -Force -ErrorAction SilentlyContinue
    }

    It 'writes the surface, sorted by name, with no hash, to the contract under the catzc root' {
        $first = & $script:write $script:surface
        $first.Written | Should -BeTrue
        $first.Path | Should -BeLike '*contracts*catzc*0.1.0*catzc.internal.types*types.sample.json'
        $text = [System.IO.File]::ReadAllText($first.Path)
        $text | Should -Not -Match "`r"
        $text.EndsWith("`n") | Should -BeTrue
        $json = $text | ConvertFrom-Json -AsHashtable
        $json.Keys | Should -Be @('types')
        @($json['types'].ForEach({ $_['name'] })) | Should -Be @('Catzc.Gadgets.Gadget', 'Catzc.Widgets.Widget')
        @($json['types'][1]['aliases']) | Should -Be @('Catzc.Widget')
        # One type per line, between the opening and closing lines of the file.
        @($text.TrimEnd("`n") -split "`n") | Should -HaveCount 6
        @($text -split "`n" | Where-Object { $_ -like '    {"name":*' }) | Should -HaveCount 2
    }

    It 'leaves the file alone when the surface did not move, and writes once when an alias is added' {
        $null = & $script:write $script:surface
        (& $script:write $script:surface).Written | Should -BeFalse -Because 'an equal surface leaves git clean'
        $moved = @(
            [pscustomobject]@{ Name = 'Catzc.Widgets.Widget'; Aliases = @('Catzc.Widget',
                    'Catzc.Sprocket'); Display = @('Name')
            },
            $script:surface[1]
        )
        (& $script:write $moved).Written | Should -BeTrue
        (& $script:write $moved).Written | Should -BeFalse
    }
}
