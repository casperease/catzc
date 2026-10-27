Describe 'Test-BicepResourceNames' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'
        $script:slotFile = Join-Path $TestDrive 'dev.yml'
        $script:entry = [Catzc.Azure.Templates.BicepNameEntry]::new('widgetName', @{ type = 'st' }, 'widget')
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        # A mock keeps Get-BicepTemplate's own -Name validation, so the fixture template is a known name.
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget' }
        Mock Get-BicepTemplate -ModuleName Catzc.Azure.Templates {
            [pscustomobject]@{
                name  = 'widget'
                names = @{ widgetName = $entry }
                slots = @([pscustomobject]@{ name = 'dev'; file = $slotFile })
            }
        }
        # The fixture descriptor is a plain object, so the mock drops the typed parameters it would not bind to.
        Mock Resolve-BicepDerivedNames -ModuleName Catzc.Azure.Templates -RemoveParameterType TemplateDescriptor, Slot {
            [ordered]@{ widgetName = 'deweuzctwdgtst' }
        }
    }

    It 'passes a slot that leaves every declared name to the namer' {
        Set-Content $slotFile "ParametersFile:`n  parameters:`n    gadgetSku:`n      value: small"
        $result = Test-BicepResourceNames -Template widget -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Facts['DeclaredNames'] | Should -Be 1
    }

    It 'refuses a slot that writes a declared name by hand' {
        Set-Content $slotFile "ParametersFile:`n  parameters:`n    widgetName:`n      value: hand-typed-widget"
        $result = Test-BicepResourceNames -Template widget -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("widget/dev: writes 'widgetName', a name the namer derives (options.yml names) — delete it from the slot")
    }

    It 'reports a declared name the namer cannot derive' {
        Set-Content $slotFile "ParametersFile:`n  parameters: {}"
        Mock Resolve-BicepDerivedNames -ModuleName Catzc.Azure.Templates -RemoveParameterType TemplateDescriptor, Slot { throw "template 'gadget' has no slot on subscription 'widget_sub'" }
        $result = Test-BicepResourceNames -Template widget -OutputFolder $out -PassThru
        $result.Issues | Should -Be @("widget/dev: a declared name does not derive — template 'gadget' has no slot on subscription 'widget_sub'")
    }
}

Describe 'BicepNameEntry' -Tag 'L0', 'logic' {
    It 'reads type, role, template and owner_slot, and refuses an unknown owner_slot, a long role or an unknown key' {
        $entry = [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetName', @{ type = 'rg'; role = 'gd'; template = 'gadget'; owner_slot = 'hub' }, 'widget')
        $entry.owner_slot | Should -Be 'hub'
        $entry.role | Should -Be 'gd'
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetName', @{ type = 'rg'; template = 'gadget'; owner_slot = 'spoke' }, 'widget') } |
            Should -Throw "*unknown owner_slot 'spoke' (allowed: hub)*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetName', @{ type = 'rg'; role = 'gadget' }, 'widget') } | Should -Throw "*role 'gadget' must be 2-3*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetName', @{ type = 'rg'; colour = 'blue' }, 'widget') } | Should -Throw "*unknown key 'colour'*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetName', @{ type = 'rg'; owner_slot = 'hub' }, 'widget') } | Should -Throw '*needs template*'
    }

    It 'reads a roles object entry and its keys_from, and refuses a bad role, an unknown key source, keys_from without roles, or role with roles' {
        $entry = [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetNames', @{ type = 'nsg'; keys_from = 'nsg_subnets'; roles = [ordered]@{ widget = 'wd'; gadget = 'gd' } }, 'widget')
        @($entry.roles.Keys) | Should -Be @('widget', 'gadget')
        $entry.keys_from | Should -Be 'nsg_subnets'
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetNames', @{ type = 'pa'; roles = @{ widget = 'widget' } }, 'widget') } | Should -Throw "* 'widget' must be 2-3 alphanumeric*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetNames', @{ type = 'nsg'; keys_from = 'subnets'; roles = @{ widget = 'wd' } }, 'widget') } | Should -Throw "*unknown keys_from 'subnets' (allowed: nsg_subnets)*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetNames', @{ type = 'nsg'; keys_from = 'nsg_subnets' }, 'widget') } | Should -Throw '*so it needs roles*'
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgetNames', @{ type = 'pa'; role = 'wd'; roles = @{ widget = 'wd' } }, 'widget') } | Should -Throw '*role and roles exclude each other*'
    }

    It 'reads an each entry and its item names, and refuses an unknown each, a stray key, an unknown from or role_from, or role with role_from' {
        $names = [ordered]@{ gadgetGroup = @{ type = 'rg' }; gadgetLink = @{ type = 'peer'; from = 'self'; role_from = 'customer_shortcode' } }
        $entry = [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'subscription'; names = $names }, 'widget')
        $entry.each | Should -Be 'subscription'
        $entry.item_names['gadgetGroup'].from | Should -Be 'item'
        $entry.item_names['gadgetLink'].from | Should -Be 'self'
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'region'; names = $names }, 'widget') } | Should -Throw "*unknown each 'region' (allowed: subscription)*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'subscription'; names = $names; type = 'rg' }, 'widget') } | Should -Throw "*holds only each and names, not 'type'*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'subscription'; names = @{ g = @{ type = 'rg'; from = 'hub' } } }, 'widget') } | Should -Throw "*unknown from 'hub' (allowed: item, self)*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'subscription'; names = @{ g = @{ type = 'rg'; role_from = 'region' } } }, 'widget') } | Should -Throw "*unknown role_from 'region' (allowed: customer_shortcode)*"
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ each = 'subscription'; names = @{ g = @{ type = 'rg'; role = 'gd'; role_from = 'customer_shortcode' } } }, 'widget') } | Should -Throw '*role and role_from exclude each other*'
        { [Catzc.Azure.Templates.BicepNameEntry]::new('gadgets', @{ type = 'rg'; names = $names }, 'widget') } | Should -Throw '*names belongs to an each entry*'
    }
}

Describe 'Test-BicepResourceNames (real templates)' -Tag 'L1', 'integrity' {
    It 'no shipped slot writes a name its template derives, and every declared name derives for every slot' {
        $result = Test-BicepResourceNames -PassThru -OutputFolder (Join-Path $TestDrive 'names')
        $result.Facts['DeclaredNames'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
