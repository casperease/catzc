# cspell:ignore ndescription nlayer ninclude  -- the escape-sequence artifacts in the "…`nlayer:…" fixture strings
# The globset record: membership is include-minus-exclude unioned through compose (ADR-GLOBS:4/ADR-GLOBS:8),
# the marker path derives from the name (ADR-GLOBS:1), and the constructor gates the shape (kebab-case name,
# required description, a declared layer, include or compose present, no duplicate patterns).
Describe 'GlobSet' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:make = {
            param([string] $name = 'unit', [string[]] $include = @('src/**'), [string[]] $exclude = @())
            [Catzc.Base.Globs.GlobSet]::new($name, 'a test globset', 'scope', $include, $exclude, @(), @(), -1, $null)
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

    Context 'the marker path (ADR-GLOBS:1, ADR-GLOBS:9)' {
        It 'derives the marker path from the set name' {
            (& $script:make 'my-unit').MarkerPath | Should -Be '.sha-markers/my-unit.yml'
        }
    }

    Context 'the marker content (ADR-GLOBS:9)' {
        It 'renders the full definition canonically — fixed field order, LF-terminated, declared pattern order, quoted patterns' {
            $set = [Catzc.Base.Globs.GlobSet]::new('my-unit', 'a test globset', 'deployable-unit',
                @('src/**', 'importer.ps1'), @('**/*.md'), @('base'), @('Catzc.Base.Globs'), 2, 'cd-my-unit')
            $set.Representation | Should -Be (@(
                    'name: my-unit'
                    'description: a test globset'
                    'layer: deployable-unit'
                    'pipeline: cd-my-unit'
                    'verify:'
                    '  modules:'
                    '  - Catzc.Base.Globs'
                    '  level: 2'
                    'compose:'
                    '- base'
                    'include:'
                    "- 'src/**'"
                    "- 'importer.ps1'"
                    'exclude:'
                    "- '**/*.md'"
                ) -join "`n") + "`n"
        }

        It 'omits empty sections and changes exactly when the definition changes' {
            $set = & $script:make 'my-unit' @('src/**')
            $set.Representation | Should -Be "name: my-unit`ndescription: a test globset`nlayer: scope`ninclude:`n- 'src/**'`n"
            (& $script:make 'my-unit' @('src/**')).Representation | Should -Be $set.Representation
            (& $script:make 'my-unit' @('src/**', 'extra/**')).Representation | Should -Not -Be $set.Representation
        }

        It 'appends the durable SHA as the sha256 line, and requires it' {
            $set = & $script:make 'my-unit' @('src/**')
            $hash = 'a' * 64
            $set.MarkerContent($hash) | Should -Be ($set.Representation + "sha256: $hash`n")
            { $set.MarkerContent(' ') } | Should -Throw "*requires the durable SHA*"
        }

        It 'parses back as YAML carrying the definition and the sha256' {
            $set = [Catzc.Base.Globs.GlobSet]::new('my-unit', 'a test globset', 'deployable-unit',
                @('src/**'), @('**/*.md'), @(), @(), -1, 'cd-my-unit')
            $parsed = $set.MarkerContent(('a' * 64)) | ConvertFrom-Yaml
            $parsed.name | Should -Be 'my-unit'
            $parsed.include | Should -Be @('src/**')
            $parsed.exclude | Should -Be @('**/*.md')
            $parsed.sha256 | Should -Be ('a' * 64)
        }
    }

    Context 'the constructor gate' {
        It 'rejects <why>' -ForEach @(
            @{ why = 'a non-kebab name (uppercase)'; block = { [Catzc.Base.Globs.GlobSet]::new('MyUnit', 'd', 'scope', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a non-kebab name (underscore)'; block = { [Catzc.Base.Globs.GlobSet]::new('my_unit', 'd', 'scope', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a non-kebab name (leading dash)'; block = { [Catzc.Base.Globs.GlobSet]::new('-unit', 'd', 'scope', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a missing description'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', ' ', 'scope', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a missing layer'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', ' ', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'an unknown layer'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'lane', @('**'), @(), @(), @(), -1, $null) } }
            @{ why = 'neither include nor compose'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @(), @(), @(), @(), -1, $null) } }
            @{ why = 'a duplicate include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @('a/**', 'a/**'), @(), @(), @(), -1, $null) } }
            @{ why = 'a malformed include pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @('/lead'), @(), @(), @(), -1, $null) } }
            @{ why = 'a malformed exclude pattern'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @('**'), @('a//b'), @(), @(), -1, $null) } }
            @{ why = 'an out-of-range verify level'; block = { [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @('**'), @(), @(), @('M'), 4, $null) } }
        ) {
            $block | Should -Throw
        }

        It 'names the globset in a pattern error' {
            { [Catzc.Base.Globs.GlobSet]::new('my-unit', 'd', 'scope', @('/lead'), @(), @(), @(), -1, $null) } |
                Should -Throw "*globset 'my-unit'*"
        }

        It 'accepts a null exclude list as empty' {
            $set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'scope', @('**'), $null, @(), @(), -1, $null)
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
