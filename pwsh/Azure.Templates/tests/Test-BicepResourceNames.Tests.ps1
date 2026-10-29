# cspell:ignore widg gadg wdg nrt envfirst
Describe 'Test-BicepResourceNames' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:out = Join-Path $TestDrive 'out'
        $script:widgetFile = Join-Path $TestDrive 'widget.yml'
        $script:gadgetFile = Join-Path $TestDrive 'gadget.yml'
        $script:yml = [Catzc.Azure.Templates.BicepSlot]::YmlFormat
        $script:baseline = @'
ResourceGroup: widget-nrt-wdg-widg-rg
ParametersFile:
  parameters:
    widgetName:
      value: widget-nrt-wdg-widg-wd-cog
    widgetSkuName:
      value: Standard
    gadgetNames:
      value:
        first: widget-nrt-wdg-gadg-rg
    secret:
      reference:
        keyVault:
          id: /subscriptions/0000/resourceGroups/widget-nrt-wdg-gadg-rg/providers/Microsoft.KeyVault/vaults/widget-nrt-wdg-gadg-cog
        secretName: widget-secret
    networkSecurityGroupNames:
      value:
        front: widget-nrt-wdg-widg-fr-nsg
        back: widget-nrt-wdg-widg-bk-nsg
    legacyName:
      value: Hand-Typed
      naming_exception: kept for the gadget import
'@
        $script:check = {
            param([string] $Text)
            Set-Content -LiteralPath $script:widgetFile -Value $Text
            Test-BicepResourceNames -Template widget -OutputFolder $script:out -PassThru
        }
    }

    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { }
        Mock Get-BicepTemplateNames -ModuleName Catzc.Azure.Templates { 'widget', 'gadget' }
        Mock Get-BicepTemplate -ModuleName Catzc.Azure.Templates {
            $short = @{ widget = 'widg'; gadget = 'gadg' }[$Name]
            $file = @{ widget = $widgetFile; gadget = $gadgetFile }[$Name]
            [pscustomobject]@{
                name       = $Name
                short_name = $short
                slots      = @([pscustomobject]@{
                        name = $Name; environment = 'widget'; customer = $null; slot = $null; subscription = 'widget_sub'; file = $file; format = $yml
                    })
            }
        }
        Mock Get-BicepNameCandidateSet -ModuleName Catzc.Azure.Templates {
            @{
                env        = [ordered]@{ widget = 'wi'; gadget = 'ga' }
                slot       = [string[]] @()
                region     = [string[]] @('nrt')
                org        = [string[]] @('wdg')
                short_name = [string[]] @('gadg', 'widg')
                customer   = [ordered]@{ gizmo = 'gz' }
            }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'resource-types' } {
            [pscustomobject]@{ not_names = @('SkuName', 'SubnetName') }
        }
        Mock Get-Config -ModuleName Catzc.Azure.Templates -ParameterFilter { $Config -eq 'network' } {
            [pscustomobject]@{
                subscriptions  = @{ widget_sub = @{ subnets = [ordered]@{ front = @{}; back = @{}; gateway = @{} } } }
                no_nsg_subnets = @('gateway')
            }
        }
        Mock Get-Naming -ModuleName Catzc.Azure.Templates { 'envfirst' }
        Mock Get-AzureNameOrderSet -ModuleName Catzc.Azure.Templates {
            [ordered]@{ envfirst = @(@('env'), @('slot'), @('region'), @('org'), @('short_name'), @('customer'), @('role'), @('type')) }
        }
        Mock Get-AzureResourceTypeSet -ModuleName Catzc.Azure.Templates {
            [ordered]@{ cog = @{ pattern = 'long' }; rg = @{ pattern = 'long' }; nsg = @{ pattern = 'long' } }
        }
        Mock Get-AzureNamePatternSet -ModuleName Catzc.Azure.Templates { [ordered]@{ long = @{ separator = '-' } } }
    }

    It 'passes a slot whose names match, counting the names, the foreign ones and the exception' -Tag 'ADR-AZ-NAMING-EXCEPTIONENTRY' {
        $result = & $script:check $script:baseline
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Names'] | Should -Be 7
        $result.Facts['Foreign'] | Should -Be 3
        $result.Facts['Exceptions'] | Should -Be 1
    }

    It 'refuses <case>' -ForEach @(
        @{
            case    = 'a wrong type ident'
            from    = 'widget-nrt-wdg-widg-wd-cog'
            to      = 'widget-nrt-wdg-widg-wd-cg'
            message = "widget/widget: widgetName: Name 'widget-nrt-wdg-widg-wd-cg' matches no canonical form*type: none of (cog, nsg, rg) in the name*"
        }
        @{
            case    = 'a foreign short_name whose owner has no slot there'
            from    = 'first: widget-nrt-wdg-gadg-rg'
            to      = 'first: gadget-nrt-wdg-gadg-rg'
            message = "widget/widget: gadgetNames.first: 'gadget-nrt-wdg-gadg-rg' belongs to template 'gadget' (short_name 'gadg'), which has no slot at env 'gadget', customer '', slot ''"
        }
        @{
            case    = 'a wrong environment'
            from    = 'widget-nrt-wdg-widg-wd-cog'
            to      = 'gadget-nrt-wdg-widg-wd-cog'
            message = "widget/widget: widgetName: 'gadget-nrt-wdg-widg-wd-cog' has env 'gadget' where the file has 'widget', and template 'widget' has no slot at env 'gadget', customer '', slot ''"
        }
        @{
            case    = 'a wrong customer'
            from    = 'widget-nrt-wdg-widg-wd-cog'
            to      = 'widget-nrt-wdg-widg-gizmo-wd-cog'
            message = "widget/widget: widgetName: 'widget-nrt-wdg-widg-gizmo-wd-cog' has customer 'gizmo' where the file has '', and template 'widget' has no slot at env 'widget', customer 'gizmo', slot ''"
        }
        @{
            case    = 'a missing NSG key'
            from    = "        back: widget-nrt-wdg-widg-bk-nsg`n"
            to      = ''
            message = "widget/widget: networkSecurityGroupNames lacks subnet 'back' of subscription 'widget_sub'"
        }
        @{
            case    = 'a resource group typo in an Azure resource ID'
            from    = 'resourceGroups/widget-nrt-wdg-gadg-rg'
            to      = 'resourceGroups/widget-nrt-wdg-gadg-gr'
            message = "widget/widget: ParametersFile.parameters.secret.reference.keyVault.id (resource group): Name 'widget-nrt-wdg-gadg-gr' matches no canonical form*"
        }
    ) {
        $text = ($script:baseline -replace "`r", '').Replace($from, $to)
        $text | Should -Not -Be ($script:baseline -replace "`r", '')
        $result = & $script:check $text
        $result.IssueCount | Should -Be 1 -Because ($result.Issues -join "`n")
        $result.Issues[0] | Should -BeLike $message
    }

    It 'reports an NSG key that is not a subnet taking an NSG' {
        $result = & $script:check (($script:baseline -replace "`r", '').Replace('back: widget-nrt-wdg-widg-bk-nsg', "back: widget-nrt-wdg-widg-bk-nsg`n        gateway: widget-nrt-wdg-widg-gw-nsg"))
        $result.Issues | Should -Be @("widget/widget: networkSecurityGroupNames has 'gateway', not a subnet of subscription 'widget_sub' that takes an NSG")
    }

    It 'skips a key ending in a not_names suffix and a leaf under no Name key' {
        $text = "ParametersFile:`n  parameters:`n    widgetSubnetName:`n      value: Not A Name`n    gadgets:`n      value:`n      - label: Free Text`n        gadgetName: widget-nrt-wdg-widg-gd-cog`n"
        $result = & $script:check $text
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Names'] | Should -Be 1
    }
}

Describe 'Test-BicepResourceNames (real templates)' -Tag 'L1', 'integrity' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Write-Message -ModuleName Catzc.Azure.Templates { }
    }

    It 'checks the names of every shipped slot and finds no issue' {
        $result = Test-BicepResourceNames -OutputFolder (Join-Path $TestDrive 'out') -PassThru
        $result.Facts['Names'] | Should -BeGreaterThan 0
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
