Describe 'Get-WorldMapChangedPath' -Tag 'L0', 'logic' {
    It 'splits the NUL-separated porcelain into distinct paths in ordinal order, untracked and deleted files included' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Maps {
            [pscustomobject]@{ Output = " M widgets/b.ps1`0?? gadgets/new gadget.md`0D  widgets/a.ps1`0A  Widgets/c.ps1`0 M widgets/b.ps1`0" }
        }
        $paths = @(InModuleScope Catzc.Base.Maps { Get-WorldMapChangedPath })
        $paths | Should -Be @('Widgets/c.ps1', 'gadgets/new gadget.md', 'widgets/a.ps1', 'widgets/b.ps1')
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Maps -Times 1 -Exactly -ParameterFilter {
            $Command -like 'git *status --porcelain=v1 -z --untracked-files=all --no-renames' -and $Silent
        }
    }

    It 'returns nothing when the working tree is clean' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Maps { [pscustomobject]@{ Output = '' } }
        @(InModuleScope Catzc.Base.Maps { Get-WorldMapChangedPath }).Count | Should -Be 0
    }
}

Describe 'Get-WorldMapChangedPath — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'lists distinct repository-relative paths, without separators or quoting left in' {
        $paths = @(InModuleScope Catzc.Base.Maps { Get-WorldMapChangedPath })
        foreach ($path in $paths) {
            $path | Should -Not -Match '^\s|\x00|\\|^"'
        }
        @($paths | Select-Object -Unique).Count | Should -Be $paths.Count
    }
}
