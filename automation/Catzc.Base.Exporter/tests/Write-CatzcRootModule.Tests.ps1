Describe 'Write-CatzcRootModule' -Tag 'L0', 'logic' {
    It 'writes Catzc.psm1 that boots the one importer in -Bundle mode' {
        InModuleScope Catzc.Base.Exporter {
            $dir = Join-Path $TestDrive ([System.Guid]::NewGuid())
            [System.IO.Directory]::CreateDirectory($dir) | Out-Null
            $path = Write-CatzcRootModule -Path $dir -Version '1.2.3'
            [System.IO.Path]::GetFileName($path) | Should -Be 'Catzc.psm1'
            $text = [System.IO.File]::ReadAllText($path)
            $text | Should -BeLike '*Invoke-Importer -Bundle*'
            $text | Should -BeLike "*CatzcModulesRoot = Join-Path *PSScriptRoot 'automation'*"
        }
    }

    It 'defaults RepositoryRoot to the caller cwd (a Gallery install has no root importer)' {
        InModuleScope Catzc.Base.Exporter {
            $dir = Join-Path $TestDrive ([System.Guid]::NewGuid())
            [System.IO.Directory]::CreateDirectory($dir) | Out-Null
            $path = Write-CatzcRootModule -Path $dir -Version '1.2.3'
            $text = [System.IO.File]::ReadAllText($path)
            $text | Should -BeLike '*if (-not $env:RepositoryRoot)*'
            $text | Should -BeLike '*Get-Location*'
        }
    }
}
