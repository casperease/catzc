<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/tests/types/TrackTypesConfig.Tests.ps1
    folder: tests/types
    name: track-types-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-DSGN-TRACKTYPE#1
---
#>

Describe 'TrackTypesConfig' -Tag 'L0', 'logic', 'ADR-DSGN-TRACKTYPE#1' {
    BeforeAll {
        function script:New-Config {
            param($Types, $Vendors)
            $raw = [ordered]@{}
            if ($null -ne $Types) {
                $raw['track_types'] = $Types
            }
            if ($null -ne $Vendors) {
                $raw['vendors'] = $Vendors
            }
            [Catzc.Base.Variants.TrackTypesConfig]::new($raw)
        }

        $script:config = New-Config ([ordered]@{
                'widget-works' = [ordered]@{ definition = 'A deployable cluster of widgets.'; role = 'deployable'; admits = @('widget-folder', 'widget-file') }
                'gadget-shelf' = [ordered]@{
                    definition = 'A holder of gadget settings.'; role = 'holder'; admits = @()
                    git = [ordered]@{ attributes = @('catzc-gadget'); why = 'Gadgets wait here unchecked.' }
                }
            }) ([ordered]@{ gizmo = [ordered]@{ definition = 'The gizmo platform.' } })
    }

    Context 'reading' {
        It 'keeps the track types in declared order with their role and admitted module types' {
            @($script:config.types.id) | Should -Be @('widget-works', 'gadget-shelf')
            $script:config.TypeOf('widget-works').role | Should -BeExactly 'deployable'
            @($script:config.TypeOf('widget-works').admits) | Should -Be @('widget-folder', 'widget-file')
            @($script:config.TypeOf('gadget-shelf').admits).Count | Should -Be 0
        }

        It 'reads the git attributes a track type gives its places, and none when it declares none' {
            @($script:config.TypeOf('gadget-shelf').gitAttributes) | Should -Be @('catzc-gadget')
            $script:config.TypeOf('gadget-shelf').gitWhy | Should -BeExactly 'Gadgets wait here unchecked.'
            @($script:config.TypeOf('widget-works').gitAttributes).Count | Should -Be 0
            $script:config.TypeOf('widget-works').gitWhy | Should -BeNullOrEmpty
        }

        It 'finds a vendor by id and answers null for an undeclared track type or vendor' {
            $script:config.VendorOf('gizmo').definition | Should -BeExactly 'The gizmo platform.'
            $script:config.VendorOf('sprocket') | Should -BeNullOrEmpty
            $script:config.TypeOf('sprocket') | Should -BeNullOrEmpty
        }
    }

    Context 'validation' {
        It 'refuses an unknown top-level key' {
            { [Catzc.Base.Variants.TrackTypesConfig]::new([ordered]@{ gizmos = @{} }) } | Should -Throw '*unknown key ''gizmos''*'
        }

        It 'refuses a role outside the closed set' {
            { New-Config ([ordered]@{ 'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'owner' } }) } | Should -Throw '*invalid role ''owner''*'
        }

        It 'refuses a track type without a definition' {
            { New-Config ([ordered]@{ 'widget-works' = [ordered]@{ role = 'holder' } }) } | Should -Throw '*needs a definition*'
        }

        It 'refuses an unknown key on a track type and on a vendor' {
            { New-Config ([ordered]@{ 'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder'; class = 'core' } }) } | Should -Throw '*unknown key ''class''*'
            { New-Config $null ([ordered]@{ gizmo = [ordered]@{ definition = 'The gizmo platform.'; root = 'gizmo' } }) } | Should -Throw '*unknown key ''root''*'
        }

        It 'refuses a module type admitted twice' {
            { New-Config ([ordered]@{ 'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder'; admits = @('widget-folder', 'widget-folder') } }) } | Should -Throw '*admitted twice*'
        }

        It 'refuses a name that is not lowercase words joined by a dash' {
            { New-Config ([ordered]@{ 'Widget_Works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder' } }) } | Should -Throw '*lowercase words*'
        }

        It 'refuses a git block without attributes or without a why, and an attribute with whitespace' {
            { New-Config ([ordered]@{ 'gadget-shelf' = [ordered]@{ definition = 'A gadget holder.'; role = 'holder'; git = [ordered]@{ why = 'Unchecked.' } } }) } |
                Should -Throw '*at least one attribute*'
            { New-Config ([ordered]@{ 'gadget-shelf' = [ordered]@{ definition = 'A gadget holder.'; role = 'holder'; git = [ordered]@{ attributes = @('catzc-gadget') } } }) } |
                Should -Throw '*needs a why*'
            { New-Config ([ordered]@{ 'gadget-shelf' = [ordered]@{ definition = 'A gadget holder.'; role = 'holder'; git = [ordered]@{ attributes = @('catzc gadget'); why = 'Unchecked.' } } }) } |
                Should -Throw '*one token without whitespace*'
        }

        It 'refuses admits that is not a list' {
            { New-Config ([ordered]@{ 'widget-works' = [ordered]@{ definition = 'A widget cluster.'; role = 'holder'; admits = 'widget-folder' } }) } | Should -Throw '*admits must be a list*'
        }
    }
}
