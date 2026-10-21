<#
---
catzc:
  immutable:
    with_body_sha: a52949917f3e
  edges:
    code: pwsh/Catzc.Base.Modules/types/Module.cs
    cites:
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
#>

# Rests on [ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel).
Describe 'Module' -Tag 'L0', 'logic', 'ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE' {
    It 'holds the identity it was given and copies its lists, so a caller''s array cannot change it' {
        $files = [string[]]@('Gadget.wdg', 'inner/Cog.wdg')
        $module = [Catzc.Base.Modules.Module]::new('Gadget', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Gadget', 'folder', $files, [string[]]@('widget-script'), [string[]]@('pwsh'), $null)
        $files[0] = 'changed'
        $module.name | Should -Be 'Gadget'
        $module.track | Should -Be 'widgets'
        $module.type | Should -Be 'widget-folder'
        $module.place | Should -Be 'widgetry'
        $module.root | Should -Be 'widgetry/Gadget'
        $module.shape | Should -Be 'folder'
        $module.files | Should -Be @('Gadget.wdg', 'inner/Cog.wdg')
        $module.languages | Should -Be @('widget-script')
        $module.engines | Should -Be @('pwsh')
        @($module.unplaced) | Should -HaveCount 0
    }

    It 'renders as console text, never as its type name' {
        $module = [Catzc.Base.Modules.Module]::new('Gadget', 'widgets', 'widget-folder', 'widgetry', 'widgetry/Gadget', 'folder', $null, $null, $null, $null)
        $module.ToString() | Should -Not -Be 'Catzc.Base.Modules.Module'
        $module.ToString() | Should -BeLike '*Gadget*'
    }
}
