# The globset record: membership is include-minus-exclude (ADR-GLOBS:4), the trigger path derives from the
# name (ADR-GLOBS:1), and the constructor gates the shape (kebab-case name, required description, non-empty
# include, no duplicate patterns).
Describe 'GlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([string] $name = 'unit', [string[]] $include = @('src/**'), [string[]] $exclude = @())
            [Catzc.Base.Globs.GlobSet]::new($name, 'a test globset', $include, $exclude)
        }
    }

    Context 'membership (ADR-GLOBS:4)' {
        It 'belongs when any include matches and no exclude does' {
            $set = & $script:make 'unit' @('src/**', 'importer.ps1') @('**/*.md')
            $set.Matches('src/a.cs') | Should -BeTrue
            $set.Matches('importer.ps1') | Should -BeTrue
            $set.Matches('src/docs/readme.md') | Should -BeFalse
            $set.Matches('other/a.cs') | Should -BeFalse
        }

        It 'excludes win over includes' {
            $set = & $script:make 'unit' @('**') @('**')
            $set.Matches('anything.txt') | Should -BeFalse
        }
    }

    Context 'the trigger path (ADR-GLOBS:1)' {
        It 'derives the trigger path from the set name' {
            (& $script:make 'my-unit').TriggerPath | Should -Be '.triggers/my-unit.sha256'
        }
    }

    Context 'the constructor gate' {
        It 'rejects <why>' -ForEach @(
            @{ why = 'a non-kebab name (uppercase)'; block = { [Catzc.Base.Globs.GlobSet]::new('MyUnit', 'd', @('**'), @()) } }
            @{ why = 'a non-kebab name (underscore)'; block = { [Catzc.Base.Globs.GlobSet]::new('my_unit', 'd', @('**'), @()) } }
            @{ why = 'a non-kebab name (leading dash)'; block = { [Catzc.Base.Globs.GlobSet]::new('-unit', 'd', @('**'), @()) } }
            @{ why = 'a missing description'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', ' ', @('**'), @()) } }
            @{ why = 'an empty include list'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', @(), @()) } }
            @{ why = 'a duplicate include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', @('a/**', 'a/**'), @()) } }
            @{ why = 'a malformed include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', @('/lead'), @()) } }
            @{ why = 'a malformed exclude pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', @('**'), @('a//b')) } }
        ) {
            $block | Should -Throw
        }

        It 'names the globset in a pattern error' {
            { [Catzc.Base.Globs.GlobSet]::new('my-unit', 'd', @('/lead'), @()) } |
                Should -Throw "*globset 'my-unit'*"
        }

        It 'accepts a null exclude list as empty' {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', @('**'), $null)
            $set.Exclude.Count | Should -Be 0
            $set.Matches('a.txt') | Should -BeTrue
        }
    }
}
