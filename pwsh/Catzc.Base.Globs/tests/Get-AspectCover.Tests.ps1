Describe 'Get-AspectCover' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:set = {
            param([string] $Name, [string[]] $Include, [string[]] $Exclude = @())
            [Catzc.Base.Globs.GlobSet]::new($Name, 'd', 'module', $Include, $Exclude, @(), @(), -1, $null)
        }
        $script:aspects = [ordered]@{
            live  = @(& $script:set 'widget-live' @('mods/Widget/*.ps1', 'mods/Widget/private/**'))
            tests = @(& $script:set 'widget-tests' @('mods/Widget/**') @('mods/Widget/*.ps1', 'mods/Widget/private/**'))
        }
        $script:files = @(
            'mods/Widget/Get-Widget.ps1'
            'mods/Widget/private/Read-Widget.ps1'
            'mods/Widget/tests/Get-Widget.Tests.ps1'
            'mods/Widget/tests/types/Gadget.Tests.ps1'
            'mods/Widget/README.md'
            'docs/gadget.md'
        )
    }

    It 'covers a folder whose every file is in the aspect with the folder alone' {
        $cover = Get-AspectCover -File $script:files -AspectSet $script:aspects
        $cover['tests'] | Should -Contain 'mods/Widget/tests'
        $cover['tests'] | Should -Not -Contain 'mods/Widget/tests/types'
        $cover['live'] | Should -Contain 'mods/Widget/private'
    }

    It 'names a file itself when its folder also holds files of another aspect' {
        $cover = Get-AspectCover -File $script:files -AspectSet $script:aspects
        $cover['live'] | Should -Contain 'mods/Widget/Get-Widget.ps1'
        $cover['tests'] | Should -Contain 'mods/Widget/README.md'
        $cover['live'] | Should -Not -Contain 'mods/Widget'
    }

    It 'leaves a file no aspect claims in no cover' {
        $cover = Get-AspectCover -File $script:files -AspectSet $script:aspects
        @($cover['live']) + @($cover['tests']) | Where-Object { $_ -like 'docs*' } | Should -BeNullOrEmpty
    }

    It 'covers a whole top-level folder when it holds only one aspect' {
        $cover = Get-AspectCover -File @('gadgets/tests/a.Tests.ps1', 'gadgets/tests/b.Tests.ps1') -AspectSet ([ordered]@{
                tests = @(& $script:set 'gadget-tests' @('gadgets/**'))
            })
        $cover['tests'] | Should -Be @('gadgets')
    }
}

Describe 'Get-AspectCover — the real repository' -Tag 'L1', 'integrity', 'source-only' {
    It 'covers every tracked file under a folder module''s tests folder by a tests path' {
        $cover = Get-AspectCover
        $modules = Get-CatzcModulesFolder
        # The internal modules under a dot folder carry no aspect sets, so their tests lie in no aspect.
        $testFiles = @(Get-TrackedFile).Where({ $_ -like "$modules/*/tests/*" -and $_ -notlike "$modules/.*" })
        $testFiles.Count | Should -BeGreaterThan 0
        foreach ($path in $testFiles) {
            @($cover['tests']).Where({ $path -ceq $_ -or $path.StartsWith("$_/", [System.StringComparison]::Ordinal) }).Count |
                Should -BeGreaterThan 0 -Because "$path lies in a module's tests folder"
        }
    }
}
