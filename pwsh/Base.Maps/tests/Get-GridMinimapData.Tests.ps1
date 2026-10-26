Describe 'Get-GridMinimapData' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:schema = [System.IO.File]::ReadAllText((Join-Path (Get-RepositoryRoot) 'contracts/catzc/0.1.0/catzc.base.maps/minimap.schema.json'))
    }

    It 'is the world map''s grid of the tree, lit with reasons by the files that cite a code, in the minimap contract' {
        $data = Get-GridMinimapData -Adr 'ADR-REPO-SLIDES'
        @($data.Axes | ForEach-Object Name) | Should -Be @('track', 'file_language')
        $data.Lit | Should -Not -BeNullOrEmpty
        @($data.Lit | Where-Object { $_.Reasons.Count -eq 0 }) | Should -BeNullOrEmpty
        Test-Json -Json $data.ToJson() -Schema $script:schema | Should -BeTrue
    }

    It 'draws the same grid on a world map built once and handed in' {
        Get-GridMinimapData -Adr 'ADR-REPO-SLIDES' -WorldMap (Get-WorldMap) -AsJson |
            Should -BeExactly (Get-GridMinimapData -Adr 'ADR-REPO-SLIDES' -AsJson)
    }
}
