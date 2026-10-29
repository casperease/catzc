Describe 'ResourceTypesConfig' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:patterns = [ordered]@{
            wide  = [ordered]@{ separator = '-' }
            tight = [ordered]@{ separator = ''; limit = 12 }
        }
        $script:newConfig = {
            param($Types, $Patterns = $script:patterns)
            [Catzc.Azure.Templates.ResourceTypesConfig]::new([ordered]@{ patterns = $Patterns; types = $Types })
        }
    }

    It 'gives a type line the default pattern and charset, keeping what it declares' {
        $config = & $script:newConfig ([ordered]@{ cog = [ordered]@{ limit = 40 } }) ([ordered]@{ long = [ordered]@{ separator = '-' } })
        $config.types['cog'].pattern | Should -Be ([Catzc.Azure.Templates.ResourceTypesConfig]::DefaultPattern)
        $config.types['cog'].charset | Should -Be ([Catzc.Azure.Templates.ResourceTypesConfig]::DefaultCharset)
        $config.types['cog'].limit | Should -Be 40
        $config.types['cog'].ContainsKey('omit') | Should -BeFalse
    }

    It 'keeps the declared pattern, charset and omit, and the file order of types and patterns' {
        $config = & $script:newConfig ([ordered]@{
                gear = [ordered]@{ pattern = 'tight'; charset = '[a-z0-9]'; omit = @('org', 'role') }
                cog  = [ordered]@{ pattern = 'wide'; limit = 30 }
            })
        @($config.types.Keys) | Should -Be @('gear', 'cog')
        @($config.patterns.Keys) | Should -Be @('wide', 'tight')
        $config.types['gear'].charset | Should -Be '[a-z0-9]'
        $config.types['gear'].omit | Should -Be @('org', 'role')
        $config.types['gear'].ContainsKey('limit') | Should -BeFalse
        $config.patterns['tight'].separator | Should -Be ''
        $config.patterns['tight'].limit | Should -Be 12
        $config.patterns['wide'].ContainsKey('limit') | Should -BeFalse
    }

    It 'requires both maps' {
        { [Catzc.Azure.Templates.ResourceTypesConfig]::new($null) } | Should -Throw "*'patterns' is required*"
        { [Catzc.Azure.Templates.ResourceTypesConfig]::new(@{ patterns = $script:patterns }) } | Should -Throw "*'types' is required*"
    }

    It 'refuses <case>' -ForEach @(
        @{ case = 'an unknown top-level key'; raw = @{ widget = 1 }; message = "*unknown top-level key 'widget'*" }
        @{ case = 'a pattern without a separator'; raw = @{ patterns = @{ wide = @{ limit = 3 } }; types = @{ cog = @{ pattern = 'wide' } } }; message = '*patterns.wide: separator is required*' }
        @{ case = 'an unknown pattern key'; raw = @{ patterns = @{ wide = @{ separator = '-'; gadget = 1 } }; types = @{ cog = @{ pattern = 'wide'; limit = 3 } } }; message = "*patterns.wide: unknown key 'gadget'*" }
        @{ case = 'a pattern name that is not lowercase letters'; raw = @{ patterns = @{ 'Wide-1' = @{ separator = '-' } }; types = @{ cog = @{ limit = 3 } } }; message = '*patterns.Wide-1: a pattern name is lowercase letters*' }
        @{ case = 'an ident that is not 2-5 lowercase letters'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ widgets = @{ pattern = 'wide'; limit = 3 } } }; message = '*types.widgets: an ident is 2-5 lowercase letters*' }
        @{ case = 'an unknown type key'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ pattern = 'wide'; limit = 3; gadget = 1 } } }; message = "*types.cog: unknown key 'gadget'*" }
        @{ case = 'an undeclared pattern'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ pattern = 'gadget' } } }; message = "*types.cog: pattern 'gadget' is not declared*" }
        @{ case = 'the default pattern when it is not declared'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ limit = 3 } } }; message = "*types.cog: pattern 'long' is not declared*" }
        @{ case = 'a charset that is not one character class'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ pattern = 'wide'; limit = 3; charset = 'a-z' } } }; message = "*types.cog: charset 'a-z' must be one character class*" }
        @{ case = 'a limit beside a pattern that binds one'; raw = @{ patterns = @{ tight = @{ separator = ''; limit = 9 } }; types = @{ cog = @{ pattern = 'tight'; limit = 3 } } }; message = "*types.cog: the 'tight' pattern binds the limit*" }
        @{ case = 'no limit under a pattern without one'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ pattern = 'wide' } } }; message = "*types.cog: the 'wide' pattern has no limit*" }
        @{ case = 'a limit that is not a positive whole number'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = @{ pattern = 'wide'; limit = 0 } } }; message = '*types.cog: limit must be a positive whole number*' }
        @{ case = 'an omit that is not a list'; raw = @{ patterns = @{ tight = @{ separator = ''; limit = 9 } }; types = @{ cog = @{ pattern = 'tight'; omit = 'org' } } }; message = '*types.cog: omit must be a list*' }
        @{ case = 'an omit of the type component'; raw = @{ patterns = @{ tight = @{ separator = ''; limit = 9 } }; types = @{ cog = @{ pattern = 'tight'; omit = @('type') } } }; message = "*types.cog: omit names 'type'*" }
        @{ case = 'an empty omit'; raw = @{ patterns = @{ tight = @{ separator = ''; limit = 9 } }; types = @{ cog = @{ pattern = 'tight'; omit = @() } } }; message = '*types.cog: omit must name at least one component*' }
        @{ case = 'a type line that is not a mapping'; raw = @{ patterns = @{ wide = @{ separator = '-' } }; types = @{ cog = 'wide' } }; message = '*types.cog must be a mapping*' }
    ) {
        { [Catzc.Azure.Templates.ResourceTypesConfig]::new($raw) } | Should -Throw $message
    }
}
