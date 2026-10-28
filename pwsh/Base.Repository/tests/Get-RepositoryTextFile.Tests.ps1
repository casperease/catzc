Describe 'Get-RepositoryTextFile' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($file in 'configs/widget.yml', 'configs/gadget.yml', 'configs/notes.md', 'configs/parts/deep.yml') {
            $full = Join-Path $script:root $file
            New-Item -ItemType Directory -Path (Split-Path $full -Parent) -Force | Out-Null
            Set-Content -LiteralPath $full -Value 'k: v' -NoNewline
        }
        $script:outside = Join-Path $TestDrive 'outside'
        New-Item -ItemType Directory -Path $script:outside -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $script:outside 'sprocket.yml') -Value 'k: v' -NoNewline
        $script:commit = @{
            Name = 'c' * 40
            Path = [string[]] @('configs/widget.yml', 'configs/sprocket.yml', 'configs/parts/deep.yml', 'configsx/widget.yml')
            Text = @{}
        }
        $script:full = { param($Relative) [System.IO.Path]::GetFullPath((Join-Path $script:root $Relative)) }
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Repository { Join-Path $TestDrive 'repo' }
    }

    It 'lists the folder''s own files on disk in ordinal order, filtered, and nothing for an absent folder' {
        Get-RepositoryTextFile 'configs' -Filter '*.yml' | Should -Be @((& $script:full 'configs/gadget.yml'), (& $script:full 'configs/widget.yml'))
        @(Get-RepositoryTextFile 'absent').Count | Should -Be 0
    }

    It 'lists the source''s files of the folder inside a source, never a deeper one or a sibling folder''s' {
        $listed = Use-RepositoryTextSource @script:commit -ScriptBlock { Get-RepositoryTextFile (Join-Path $script:root 'configs') -Filter '*.yml' }
        $listed | Should -Be @((& $script:full 'configs/sprocket.yml'), (& $script:full 'configs/widget.yml'))
    }

    It 'lists a folder outside the repository from disk inside a source too' {
        $listed = Use-RepositoryTextSource @script:commit -ScriptBlock { Get-RepositoryTextFile $script:outside }
        $listed | Should -Be @((Join-Path $script:outside 'sprocket.yml'))
    }
}
