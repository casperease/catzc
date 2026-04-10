Describe 'Get-RepositoryFolder' -Tag 'L0', 'integrity' {
    It 'returns the normalized absolute path for a relative folder' {
        $result = Get-RepositoryFolder 'automation/Catzc.Base.Repository'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $env:RepositoryRoot 'automation/Catzc.Base.Repository')))
    }

    It 'returns a path that exists for a known folder' {
        Test-Path (Get-RepositoryFolder 'automation') | Should -BeTrue
    }

    It 'collapses a leading dot segment instead of leaking it into the result' {
        $result = Get-RepositoryFolder './automation'
        $result | Should -Be ([IO.Path]::GetFullPath((Join-Path $env:RepositoryRoot 'automation')))
        $result | Should -Not -Match '[\\/]\.[\\/]'
    }
}
