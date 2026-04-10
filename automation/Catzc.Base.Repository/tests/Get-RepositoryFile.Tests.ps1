Describe 'Get-RepositoryFile' -Tag 'L0', 'integrity' {
    It 'returns the normalized absolute path for a relative file' {
        $result = Get-RepositoryFile 'importer.ps1'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $env:RepositoryRoot 'importer.ps1')))
    }

    It 'returns a path that exists for a known file' {
        Test-Path (Get-RepositoryFile 'importer.ps1') | Should -BeTrue
    }

    It 'collapses a leading dot segment instead of leaking it into the result' {
        $result = Get-RepositoryFile './importer.ps1'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $env:RepositoryRoot 'importer.ps1')))
        $result | Should -Not -Match '[\\/]\.[\\/]'
    }

    It 'collapses a parent (..) segment' {
        $result = Get-RepositoryFile 'automation/../importer.ps1'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $env:RepositoryRoot 'importer.ps1')))
    }
}
