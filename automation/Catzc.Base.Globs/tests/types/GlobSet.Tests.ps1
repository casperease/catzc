# The globset record: membership is decided by the scan program — an ordered +/- rule list, last-match-wins
# ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)), flattened through compose with
# own-rules-last
# ([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)); and the constructor guards the
# shape (kebab-case name, required description, a layer declared, include or compose present, no duplicate
# patterns).
Describe 'GlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([string] $name = 'unit', [string[]] $include = @('src/**'), [string[]] $exclude = @())
            [Catzc.Base.Globs.GlobSet]::new($name, 'a test globset', 'loose-fileset', $include, $exclude, @(), @(), -1, $null)
        }
    }

    Context 'membership (ADR-FLOW-CD-GLOBS:4)' {
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

    Context 'batch selection over a tracked-file list' {
        It 'SelectMembers returns the matching paths, ordinal-sorted (case-sensitive)' {
            $set = & $script:make 'unit' @('src/**') @('src/gen/**')
            $set.SelectMembers([string[]] @('src/b.cs', 'src/gen/x.cs', 'other/a.cs', 'src/B.cs', 'src/a.cs')) |
                Should -Be @('src/B.cs', 'src/a.cs', 'src/b.cs')
        }

        It 'SelectOwnMembers returns the paths OwnMatches selects, ordinal-sorted' {
            $set = & $script:make 'unit' @('src/**') @('src/gen/**')
            $set.SelectOwnMembers([string[]] @('src/b.cs', 'src/gen/x.cs', 'src/a.cs')) | Should -Be @('src/a.cs', 'src/b.cs')
        }

        It 'returns an empty array for an empty list and rejects a null one' {
            $set = & $script:make
            @($set.SelectMembers([string[]] @())).Count | Should -Be 0
            { $set.SelectMembers($null) } | Should -Throw -ExpectedMessage '*tracked*'
        }
    }

    Context 'the constructor guard' {
        It 'rejects <why>' -ForEach @(
            @{ why = 'a non-kebab name (uppercase)'; block = { [Catzc.Base.Globs.GlobSet]::new('MyUnit', 'd', 'loose-fileset', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a non-kebab name (underscore)'; block = { [Catzc.Base.Globs.GlobSet]::new('my_unit', 'd', 'loose-fileset', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a non-kebab name (leading dash)'; block = { [Catzc.Base.Globs.GlobSet]::new('-unit', 'd', 'loose-fileset', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a missing description'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', ' ', 'loose-fileset', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a missing layer'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', ' ', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'an unknown layer'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'lane', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'neither include nor compose'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @(), @(), @(), @(), -1, $null) } }
            @{ why = 'a duplicate include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('a/**', 'a/**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a malformed include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('/lead'), @(), @(), @(), -1, $null) } }
            @{ why = 'a malformed exclude pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('**'), @('a//b'), @(), @(), -1, $null) } }
            @{ why = 'an out-of-range verify level'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('**'), @(), @(), @('M'), 4, $null) } }
        ) {
            $block | Should -Throw
        }

        It 'names the globset in a pattern error' {
            { [Catzc.Base.Globs.GlobSet]::new('my-unit', 'd', 'loose-fileset', @('/lead'), @(), @(), @(), -1, $null) } |
                Should -Throw "*globset 'my-unit'*"
        }

        It 'accepts a null exclude list as empty' {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('**'), $null, @(), @(), -1, $null)
            $set.Exclude.Count | Should -Be 0
            $set.Matches('a.txt') | Should -BeTrue
        }

        It "accepts the 'module' layer — the derived layer is valid on the type, rejected only in the declared registry" {
            ([Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'module', @('automation/M/**'), @(), @(), @(), -1, $null)).Layer |
                Should -Be 'module'
        }

        It 'accepts a compose-only set (membership resolved by the registry)' {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'deployable-unit', @(), @(), @('base'), @(), -1, $null)
            $set.Compose | Should -Be @('base')
            $set.Matches('anything.txt') | Should -BeFalse
        }
    }
}
