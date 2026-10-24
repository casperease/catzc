Describe 'Test-PlaceRows' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:write = {
            param([string[]] $Rows, [string] $Counters)
            $folder = Join-Path $TestDrive 'minimaps/widget'
            New-Item -ItemType Directory -Path $folder -Force | Out-Null
            $json = [ordered]@{ id = 'code-locations'; place_rows = [ordered]@{ rows = $Rows; counters = $Counters } } | ConvertTo-Json -Depth 5
            Set-Content -LiteralPath (Join-Path $folder 'code-locations.json') -Value $json
        }
    }

    It 'reports nothing when every row is in the place normal form' {
        & $script:write @('docs', 'widgets / Widget / types') '2 places'
        @(Test-PlaceRows (Join-Path $TestDrive 'minimaps')) | Should -BeNullOrEmpty
    }

    It 'reports a row that kept the module prefix' {
        & $script:write @('widgets / Catzc.Widget / types') '1 place'
        @(Test-PlaceRows (Join-Path $TestDrive 'minimaps')) | Should -Match "row 'widgets / Catzc.Widget / types' is not in the place normal form"
    }

    It 'reports a counters line longer than the row budget' {
        & $script:write @('docs') ('x' * 41)
        @(Test-PlaceRows (Join-Path $TestDrive 'minimaps')) | Should -Match 'longer than 40 characters'
    }

    It 'says nothing for a folder that does not exist' {
        @(Test-PlaceRows (Join-Path $TestDrive 'nowhere')) | Should -BeNullOrEmpty
    }
}
