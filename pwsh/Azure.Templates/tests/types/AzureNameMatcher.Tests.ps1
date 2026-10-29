# cspell:ignore gdgt wdgt nrt sprock acmex wxyz zzzz ganrtzedwdgtgzgear envfirst typefirst nrtwdgtgear gearzedwdgtganrtx
Describe 'AzureNameMatcher' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:orders = @{
            envfirst  = @(@('env'), @('slot'), @('region'), @('org'), @('short_name'), @('customer'), @('role'), @('type'))
            typefirst = @(@('type'), @('org'), @('short_name'), @('customer'), @('env'), @('region'), @('slot'), @('role'))
        }
        $script:patterns = @{
            long  = @{ separator = '-' }
            snug  = @{ separator = '-'; limit = 24 }
            tight = @{ separator = ''; limit = 24 }
        }
        function script:New-Sets {
            param([hashtable] $Types)
            @{
                env        = @{ widget = 'wi'; gadget = 'ga' }
                customer   = @{ gizmo = 'gz' }
                slot       = @('01', 'x2')
                region     = @('nrt', 'wst')
                org        = @('zed')
                short_name = @('gdgt', 'wdgt')
                types      = $Types
                patterns   = $script:patterns
            }
        }
        $script:sets = New-Sets -Types @{ cog = @{ pattern = 'long' }; gear = @{ pattern = 'tight' } }
        $script:environmentFirst = $script:orders['envfirst']
    }

    It 'round-trips <identifier> under the <pattern> pattern and the <order> order' -ForEach @(
        foreach ($identifier in 'cog', 'gear') {
            foreach ($pattern in 'long', 'snug', 'tight') {
                foreach ($order in 'envfirst', 'typefirst') {
                    @{ identifier = $identifier; pattern = $pattern; order = $order }
                }
            }
        }
    ) {
        $types = @{ cog = @{ pattern = 'long' }; gear = @{ pattern = 'tight' } }
        $types[$identifier] = @{ pattern = $pattern }
        $sets = New-Sets -Types $types
        $readable = $pattern -eq 'long'
        foreach ($values in @(
                [ordered]@{ env = 'gadget'; slot = '01'; region = 'nrt'; org = 'zed'; short_name = 'wdgt'; customer = 'gizmo'; role = 'wid'; type = $identifier }
                [ordered]@{ env = 'widget'; slot = ''; region = 'wst'; org = 'zed'; short_name = 'gdgt'; customer = ''; role = ''; type = $identifier }
            )) {
            $tokens = @{}
            foreach ($key in $values.Keys) {
                $tokens[$key] = $values[$key]
            }
            if (-not $readable) {
                $tokens['env'] = $sets.env[$values.env]
                $tokens['customer'] = if ($values.customer) {
                    $sets.customer[$values.customer]
                }
                else {
                    ''
                }
            }
            $name = [Catzc.Azure.Templates.AzureNameRenderer]::Join($tokens, $script:orders[$order], $types[$identifier], $script:patterns[$pattern])
            $match = [Catzc.Azure.Templates.AzureNameMatcher]::Match($name, $identifier, $sets, $script:orders[$order])
            foreach ($key in $values.Keys) {
                $match[$key] | Should -Be $values[$key] -Because "$key of '$name'"
            }
        }
    }

    It 'skips the components the type omits' {
        $sets = New-Sets -Types @{ gear = @{ pattern = 'tight'; omit = @('org', 'customer', 'role') } }
        $match = [Catzc.Azure.Templates.AzureNameMatcher]::Match('ga01nrtwdgtgear', 'gear', $sets, $script:environmentFirst)
        $match.env | Should -Be 'gadget'
        $match.org | Should -Be ''
        $match.short_name | Should -Be 'wdgt'
    }

    It 'tries every type when no ident is given' {
        $match = [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-wdgt-cog', $null, $script:sets, $script:environmentFirst)
        $match.type | Should -Be 'cog'
    }

    It 'refuses a name that matches more than one canonical form' {
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gearzedwdgtganrtx2', 'gear', $script:sets, $script:orders['typefirst']) } |
            Should -Throw "*'gearzedwdgtganrtx2' is ambiguous: it matches 2 canonical forms*role=x2*slot=x2*"
    }

    It 'reads a customer shortcode where a role could sit as the customer only' {
        $match = [Catzc.Azure.Templates.AzureNameMatcher]::Match('ganrtzedwdgtgzgear', 'gear', $script:sets, $script:environmentFirst)
        $match.customer | Should -Be 'gizmo'
        $match.role | Should -Be ''
    }

    It 'refuses a role that equals a customer shortcode, naming the rule' -Tag 'ADR-AZ-NAMING-ROLENOTCUSTOMER' {
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-wdgt-gz-cog', 'cog', $script:sets, $script:environmentFirst) } |
            Should -Throw "*'gadget-nrt-zed-wdgt-gz-cog' matches no canonical form*role: leftover 'gz' equals a customer shortcode*"
    }

    It 'diagnoses a no-match <case> per part' -ForEach @(
        @{ case = 'env'; name = 'sprock-nrt-zed-wdgt-cog'; line = 'env: none of (gadget, widget) in the name' }
        @{ case = 'region'; name = 'gadget-sth-zed-wdgt-cog'; line = 'region: none of (nrt, wst) in the name' }
        @{ case = 'org'; name = 'gadget-nrt-xyz-wdgt-cog'; line = 'org: none of (zed) in the name' }
        @{ case = 'short_name'; name = 'gadget-nrt-zed-zzzz-cog'; line = 'short_name: none of (gdgt, wdgt) in the name' }
        @{ case = 'type'; name = 'gadget-nrt-zed-wdgt-gear'; line = 'type: none of (cog) in the name' }
        @{ case = 'slot'; name = 'gadget-zz9-nrt-zed-wdgt-cog'; line = 'role: no render of the other parts frames the name' }
        @{ case = 'customer'; name = 'gadget-nrt-zed-wdgt-acmex-cog'; line = "role: leftover 'acmex' is not" }
        @{ case = 'role'; name = 'gadget-nrt-zed-wdgt-wxyz-cog'; line = "role: leftover 'wxyz' is not" }
    ) {
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match($name, 'cog', $script:sets, $script:environmentFirst) } |
            Should -Throw "*'$name' matches no canonical form*$line*"
    }

    It 'names the parts it found in a no-match' {
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-zzzz-cog', 'cog', $script:sets, $script:environmentFirst) } |
            Should -Throw "*env: found 'gadget'*slot: absent*region: found 'nrt'*org: found 'zed'*customer: absent*type: found 'cog'*"
    }

    It 'refuses an unknown ident' {
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-wdgt-cog', 'sprocket', $script:sets, $script:environmentFirst) } |
            Should -Throw "*Unknown resource type 'sprocket' (known: *"
    }

    It 'refuses a type whose pattern is unknown' {
        $sets = New-Sets -Types @{ cog = @{ pattern = 'loose' } }
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-wdgt-cog', 'cog', $sets, $script:environmentFirst) } |
            Should -Throw "*Type 'cog' references unknown name pattern 'loose'*"
    }

    It 'refuses candidate sets without a <key> map' -ForEach @(
        @{ key = 'types' }
        @{ key = 'patterns' }
    ) {
        $sets = New-Sets -Types @{ cog = @{ pattern = 'long' } }
        $sets.Remove($key)
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match('gadget-nrt-zed-wdgt-cog', 'cog', $sets, $script:environmentFirst) } |
            Should -Throw "*The candidate sets hold no '$key' map*"
    }

    It 'refuses a missing <argument>' -ForEach @(
        @{ argument = 'name'; index = 0 }
        @{ argument = 'candidateSets'; index = 2 }
        @{ argument = 'order'; index = 3 }
    ) {
        $arguments = [object[]]@('gadget-nrt-zed-wdgt-cog', 'cog', $script:sets, $script:environmentFirst)
        $arguments[$index] = $null
        { [Catzc.Azure.Templates.AzureNameMatcher]::Match($arguments[0], $arguments[1], $arguments[2], $arguments[3]) } |
            Should -Throw "*$argument*"
    }
}
