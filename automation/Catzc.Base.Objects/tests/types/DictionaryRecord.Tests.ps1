<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
    kind: test
---
#>

# DictionaryRecord — the shared base of the YAML-mirror records: a dictionary view over a derived record's own
# data properties, and the protected extraction helpers (Req / OptStr / StrArr / Flag) a derived constructor uses.
# Exercised through a probe record compiled by Add-Type against the loaded combined assembly, which also shows a
# type compiled later can derive from the base. Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'DictionaryRecord' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        if (-not ([System.Management.Automation.PSTypeName]'DictionaryRecordWidgetProbe').Type) {
            $assembly = [Catzc.Base.Objects.DictionaryRecord].Assembly.Location
            # Gadget is never assigned by the first constructor -> genuinely null. (Passing $null from PowerShell
            # would coerce to '', the [string] $null->'' pitfall, so that constructor leaves it unset.)
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
