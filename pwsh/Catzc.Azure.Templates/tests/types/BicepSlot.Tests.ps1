<#
---
catzc:
  immutable:
    with_body_sha: "926c2d88dd96"
  edges:
    code: pwsh/Catzc.Azure.Templates/types/BicepSlot.cs
---
#>

Describe 'BicepSlot' -Tag 'L0', 'logic' {
    It 'takes its format from its config file: <File> is <Format>' -ForEach @(
        @{ File = 'C:\widget\configuration\dev.yml'; Format = 'yml' }
        @{ File = 'C:\widget\configuration\gadget\dev-001.bicepparam'; Format = 'bicepparam' }
    ) {
        $slot = [Catzc.Azure.Templates.BicepSlot]::new('dev', 'dev', '', 'widget-sub', '', $File)
        $slot.format | Should -BeExactly $Format
        $slot.file | Should -BeExactly $File
    }

    It 'keeps the empty slot and customer sentinels' {
        $slot = [Catzc.Azure.Templates.BicepSlot]::new('dev', 'dev', $null, 'widget-sub', $null, 'C:\widget\configuration\dev.yml')
        $slot.slot | Should -BeExactly ''
        $slot.customer | Should -BeExactly ''
    }

    It 'rejects a config file that is neither yml nor bicepparam, and a missing one' {
        { [Catzc.Azure.Templates.BicepSlot]::new('dev', 'dev', '', 'widget-sub', '', 'C:\widget\configuration\dev.json') } |
            Should -Throw '*must be a .yml or a .bicepparam config*'
        { [Catzc.Azure.Templates.BicepSlot]::new('dev', 'dev', '', 'widget-sub', '', '') } | Should -Throw '*BicepSlot.file is required*'
    }
}
