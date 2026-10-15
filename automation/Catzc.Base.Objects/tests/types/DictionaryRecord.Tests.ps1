<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---
#>

# DictionaryRecord — the shared base of the YAML-mirror records: a dictionary view over a derived record's own data...
# [comment:1](/docs/references/automation/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md#comment1)
Describe 'DictionaryRecord' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        if (-not ([System.Management.Automation.PSTypeName]'DictionaryRecordWidgetProbe').Type) {
            $assembly = [Catzc.Base.Objects.DictionaryRecord].Assembly.Location
            # Gadget is never assigned by the first constructor -> genuinely null.
            # [comment:2](/docs/references/automation/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md#comment2)
            Add-Type -ReferencedAssemblies $assembly -TypeDefinition @'
public sealed class DictionaryRecordWidgetProbe : Catzc.Base.Objects.DictionaryRecord {
    public string   Name { get; }
    public string   Gadget { get; }
    public string[] Tags { get; }
    public bool     Enabled { get; }
    public DictionaryRecordWidgetProbe(string name, string[] tags) { Name = name; Tags = tags; }
    public DictionaryRecordWidgetProbe(System.Collections.IDictionary d) {
        Name = Req(d, "name");
        Gadget = OptStr(d, "gadget");
        Tags = StrArr(d, "tags");
        Enabled = Flag(d, "enabled");
    }
}
'@
        }
    }

    It 'Contains is true for a non-null property, false for a null one, an unknown one, or a base member' {
        $record = [DictionaryRecordWidgetProbe]::new('widget', @('x'))
        $record.Contains('Name') | Should -BeTrue
        $record.Contains('Gadget') | Should -BeFalse   # null value -> treated as absent
        $record.Contains('Missing') | Should -BeFalse
        $record.Contains('Keys') | Should -BeFalse     # base view member, not a data property
    }

    It 'the indexer returns the property value (or null for an unknown key)' {
        $record = [DictionaryRecordWidgetProbe]::new('widget', @())
        $record['Name'] | Should -Be 'widget'
        $record['Nope'] | Should -BeNullOrEmpty
    }

    It 'Keys lists only non-null data properties' {
        $keys = @([DictionaryRecordWidgetProbe]::new('widget', @('x')).Keys)
        $keys | Should -Contain 'Name'
        $keys | Should -Contain 'Tags'
        $keys | Should -Not -Contain 'Gadget'   # null
        $keys | Should -Not -Contain 'Keys'     # base member
    }

    It 'ToHashtable carries non-null data props and excludes null props and base members' {
        $hashtable = [DictionaryRecordWidgetProbe]::new('widget', @('x')).ToHashtable()
        $hashtable['Name'] | Should -Be 'widget'
        $hashtable.ContainsKey('Gadget') | Should -BeFalse   # null -> omitted
        $hashtable.ContainsKey('Keys') | Should -BeFalse     # base member
    }

    It 'the extraction helpers read a raw mapping in a derived constructor' {
        $record = [DictionaryRecordWidgetProbe]::new([ordered]@{ name = 'widget'; gadget = ' '; tags = 'one'; enabled = 'true' })
        $record.Name | Should -Be 'widget'
        $record.Gadget | Should -BeNullOrEmpty   # OptStr: whitespace -> null
        $record.Tags | Should -Be @('one')       # StrArr: a scalar -> one element
        $record.Enabled | Should -BeTrue         # Flag: parses a boolean string
    }

    It 'the base Req helper throws in a derived constructor when a required key is missing' {
        { [DictionaryRecordWidgetProbe]::new([ordered]@{ gadget = 'gizmo' }) } | Should -Throw '*name is required*'
    }
}
