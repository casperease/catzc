Describe 'Catzc.Tooling.Inspiration.InspirationConfig' -Tag 'L0', 'logic', 'ADR-REPO-INSPIRE-DECLAREDINSPIRATION' {
    BeforeAll {
        function New-Entry {
            param(
                [string] $Id = 'widget',
                [string] $Root = '{workspace}/widget'
            )
            [ordered]@{ id = $Id; root = $Root; description = "The $Id inspiration." }
        }

        function Get-ViolationMessage {
            param($Raw)
            try {
                [void] [Catzc.Tooling.Inspiration.InspirationConfig]::new($Raw)
            }
            catch {
                return $_.Exception.InnerException.Message
            }
            throw 'expected the InspirationConfig constructor to throw'
        }

        function Get-RootViolation {
            param([string] $Root)
            Get-ViolationMessage ([ordered]@{ inspirations = @(New-Entry -Root $Root) })
        }
    }

    Context 'mapping' {
        It 'maps the entries in file order, with their paths' {
            $widget = New-Entry
            $widget['paths'] = @('docs', 'specs/widget')
            $config = [Catzc.Tooling.Inspiration.InspirationConfig]::new([ordered]@{ inspirations = @($widget, (New-Entry -Id 'gadget' -Root 'gadget/home')) })

            @($config.inspirations.id) | Should -Be @('widget', 'gadget')
            @($config.inspirations.root) | Should -Be @('{workspace}/widget', 'gadget/home')
            $config.inspirations[0].paths | Should -Be @('docs', 'specs/widget')
            $config.inspirations[1].paths.Count | Should -Be 0
        }

        It 'takes an explicit empty list as no inspirations' {
            $config = [Catzc.Tooling.Inspiration.InspirationConfig]::new([ordered]@{ inspirations = @() })
            $config.inspirations.Count | Should -Be 0
        }
    }

    Context 'the sensible default' {
        It 'is one eac entry anchored on the workspace' {
            $default = [Catzc.Tooling.Inspiration.InspirationConfig]::DefaultInspirations
            $default.Count | Should -Be 1
            $default[0].id | Should -Be 'eac'
            $default[0].root | Should -Be '{workspace}/eac'
        }

        It 'applies to an empty file' {
            $config = [Catzc.Tooling.Inspiration.InspirationConfig]::new($null)
            @($config.inspirations.id) | Should -Be @('eac')
        }

        It 'applies to an omitted or null inspirations key' {
            @([Catzc.Tooling.Inspiration.InspirationConfig]::new([ordered]@{}).inspirations.id) | Should -Be @('eac')
            @([Catzc.Tooling.Inspiration.InspirationConfig]::new([ordered]@{ inspirations = $null }).inspirations.id) | Should -Be @('eac')
        }
    }

    Context 'rejections' {
        It 'rejects a duplicate id' {
            Get-ViolationMessage ([ordered]@{ inspirations = @((New-Entry), (New-Entry)) }) | Should -BeLike "*entry 1 repeats the id 'widget'*"
        }

        It 'rejects an empty root' {
            Get-RootViolation '' | Should -BeLike "*entry 0 has no 'root'*"
        }

        It 'rejects a .. segment' {
            Get-RootViolation '{workspace}/../widget' | Should -BeLike "*has a '..' segment*"
        }

        It 'rejects a . segment' {
            Get-RootViolation 'widget/./gadget' | Should -BeLike "*has a '.' segment*"
        }

        It 'rejects a backslash' {
            Get-RootViolation '{workspace}\widget' | Should -BeLike '*contains a backslash*'
        }

        It 'rejects a drive letter' {
            Get-RootViolation 'C:/widget' | Should -BeLike '*has a drive letter*'
        }

        It 'rejects an absolute path' {
            Get-RootViolation '/srv/widget' | Should -BeLike '*is absolute*'
        }

        It 'rejects the bare anchor, an inner anchor, and an empty segment' {
            Get-RootViolation '{workspace}' | Should -BeLike '*names no folder under the anchor*'
            Get-RootViolation 'widget/{workspace}/gadget' | Should -BeLike "*has an anchor other than a leading '{workspace}/'*"
            Get-RootViolation 'widget//gadget' | Should -BeLike '*has an empty segment*'
        }

        It 'rejects an unknown entry key and an unknown top-level key' {
            $entry = New-Entry
            $entry['colour'] = 'blue'
            $message = Get-ViolationMessage ([ordered]@{ inspirations = @($entry); gadget = 1 })
            $message | Should -BeLike "*entry 0 has unknown key 'colour'*"
            $message | Should -BeLike "*unknown top-level key 'gadget'*"
        }

        It 'rejects an id that is not kebab-case, and a missing id and description' {
            Get-ViolationMessage ([ordered]@{ inspirations = @(New-Entry -Id 'Widget_One') }) | Should -BeLike "*id 'Widget_One' is not kebab-case*"
            $message = Get-ViolationMessage ([ordered]@{ inspirations = @([ordered]@{ root = 'widget' }) })
            $message | Should -BeLike "*entry 0 has no 'id'*"
            $message | Should -BeLike "*entry 0 has no 'description'*"
        }

        It 'rejects a path inside the root that is anchored, absolute or climbs out' {
            $entry = New-Entry
            $entry['paths'] = @('{workspace}/gadget', '/srv/gadget', '../gadget')
            $message = Get-ViolationMessage ([ordered]@{ inspirations = @($entry) })
            $message | Should -BeLike "*path '{workspace}/gadget' has an anchor*"
            $message | Should -BeLike "*path '/srv/gadget' is absolute*"
            $message | Should -BeLike "*path '../gadget' has a '..' segment*"
        }

        It 'rejects paths that is not a list, and inspirations that is not a list' {
            $entry = New-Entry
            $entry['paths'] = [ordered]@{ docs = 1 }
            Get-ViolationMessage ([ordered]@{ inspirations = @($entry) }) | Should -BeLike "*'paths' is not a list*"
            Get-ViolationMessage ([ordered]@{ inspirations = 'widget' }) | Should -BeLike "*'inspirations' is not a list*"
        }

        It 'rejects an entry that is not a mapping' {
            Get-ViolationMessage ([ordered]@{ inspirations = @('widget') }) | Should -BeLike '*entry 0 is not a mapping*'
        }
    }
}
