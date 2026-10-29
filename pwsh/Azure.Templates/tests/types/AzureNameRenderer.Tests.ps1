# cspell:ignore gadge gadgadge wiweugadgear
Describe 'AzureNameRenderer' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:components = @{
            env        = 'widget'
            slot       = '2'
            region     = 'weu'
            org        = 'gad'
            short_name = 'gadge'
            customer   = ''
            role       = 'wid'
            type       = 'cog'
        }
        $script:order = @(@('env'), @('slot'), @('region'), @('org'), @('short_name'), @('customer'), @('role'), @('type'))
        $script:wide = @{ separator = '-' }
        $script:tight = @{ separator = ''; limit = 12 }
    }

    It 'joins the present components in order with the pattern separator, dropping an empty segment' {
        [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $script:order, @{ pattern = 'wide'; limit = 60 }, $script:wide) |
            Should -Be 'widget-2-weu-gad-gadge-wid-cog'
    }

    It 'follows the order it is given' {
        $order = @(@('type'), @('org'), @('short_name'), @('env'), @('region'))
        [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $order, @{ pattern = 'wide'; limit = 60 }, $script:wide) |
            Should -Be 'cog-gad-gadge-widget-weu'
    }

    It 'fuses the components of one segment into one part' {
        $order = @(@('org', 'short_name'), @('type'))
        [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $order, @{ pattern = 'wide'; limit = 60 }, $script:wide) |
            Should -Be 'gadgadge-cog'
    }

    It 'skips the components the type omits' {
        $spec = @{ pattern = 'wide'; limit = 60; omit = [string[]]@('org', 'role') }
        [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $script:order, $spec, $script:wide) |
            Should -Be 'widget-2-weu-gadge-cog'
    }

    It 'joins without a separator under a joined pattern' {
        $components = @{ env = 'wi'; region = 'weu'; short_name = 'gad'; type = 'gear' }
        [Catzc.Azure.Templates.AzureNameRenderer]::Render($components, $script:order, @{ pattern = 'tight' }, $script:tight) |
            Should -Be 'wiweugadgear'
    }

    It 'takes the pattern limit over the type limit' {
        [Catzc.Azure.Templates.AzureNameRenderer]::Limit($script:components, @{ pattern = 'tight'; limit = 40 }, $script:tight) | Should -Be 12
        [Catzc.Azure.Templates.AzureNameRenderer]::Limit($script:components, @{ pattern = 'wide'; limit = 40 }, $script:wide) | Should -Be 40
    }

    It 'refuses a name over the limit' {
        { [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $script:order, @{ pattern = 'wide'; limit = 10 }, $script:wide) } |
            Should -Throw "*'widget-2-weu-gad-gadge-wid-cog' (30 chars) exceeds the 'cog' limit of 10*"
    }

    It 'refuses a type with no limit under a pattern with none' {
        { [Catzc.Azure.Templates.AzureNameRenderer]::Render($script:components, $script:order, @{ pattern = 'wide' }, $script:wide) } |
            Should -Throw "*Type 'cog' (pattern 'wide') has no length limit*"
    }

    It 'joins over the limit when asked for the unbounded form' {
        [Catzc.Azure.Templates.AzureNameRenderer]::Join($script:components, $script:order, @{ pattern = 'wide'; limit = 10 }, $script:wide) |
            Should -Be 'widget-2-weu-gad-gadge-wid-cog'
    }

    It 'refuses a missing <name>' -ForEach @(
        @{ name = 'components'; index = 0 }
        @{ name = 'order'; index = 1 }
        @{ name = 'typeSpec'; index = 2 }
        @{ name = 'pattern'; index = 3 }
    ) {
        $arguments = [object[]]@($script:components, $script:order, @{ pattern = 'wide'; limit = 60 }, $script:wide)
        $arguments[$index] = $null
        { [Catzc.Azure.Templates.AzureNameRenderer]::Join($arguments[0], $arguments[1], $arguments[2], $arguments[3]) } | Should -Throw "*$name*"
    }

    It 'reads the components a type omits' {
        $omit = [Catzc.Azure.Templates.AzureNameRenderer]::Omit(@{ pattern = 'gear'; omit = [string[]]@('org', 'role') })
        @($omit) | Should -Be @('org', 'role')
    }

    It 'reads no omitted component from <case>' -ForEach @(
        @{ case = 'a type without omit'; spec = @{ pattern = 'gear' } }
        @{ case = 'a scalar omit'; spec = @{ pattern = 'gear'; omit = 'org' } }
        @{ case = 'a null omit'; spec = @{ pattern = 'gear'; omit = $null } }
    ) {
        [Catzc.Azure.Templates.AzureNameRenderer]::Omit($spec).Count | Should -Be 0
    }

    It 'refuses a missing typeSpec when reading the omitted components' {
        { [Catzc.Azure.Templates.AzureNameRenderer]::Omit($null) } | Should -Throw '*typeSpec*'
    }

    It 'renders the readable form under the long pattern' {
        [Catzc.Azure.Templates.AzureNameRenderer]::ComponentForm('long', 'widget', 'wi') | Should -Be 'widget'
    }

    It 'renders the shortcode under the restricted <pattern> pattern' -ForEach @(
        @{ pattern = 'cog' }
        @{ pattern = 'gear' }
    ) {
        [Catzc.Azure.Templates.AzureNameRenderer]::ComponentForm($pattern, 'gadget', 'ga') | Should -Be 'ga'
    }

    It 'renders an empty shortcode as given, leaving the refusal to the caller' {
        [Catzc.Azure.Templates.AzureNameRenderer]::ComponentForm('gear', 'gadget', '') | Should -BeNullOrEmpty
    }
}
