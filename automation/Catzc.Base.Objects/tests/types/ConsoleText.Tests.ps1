<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Objects
    relatives:
      page: docs/references/automation/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
      source: automation/Catzc.Base.Objects/types/ConsoleText.cs
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---
#>

Describe 'ConsoleText' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {
    BeforeAll {
        if (-not ([System.Management.Automation.PSTypeName]'ConsoleTextWidgetProbe').Type) {
            # The combined assembly, plus System.Management.Automation for the [Hidden] probe property.
            $assemblies = [Catzc.Base.Objects.ConsoleText].Assembly.Location, [psobject].Assembly.Location
            Add-Type -ReferencedAssemblies $assemblies -TypeDefinition @'
using Catzc.Base.Objects;
public enum ConsoleTextGadgetKind { Small, Large }
public sealed class ConsoleTextWidgetProbe {
    public string   Name { get; set; }
    public string   Note { get; set; }
    public int      Size { get; set; }
    public ConsoleTextGadgetKind Kind { get; set; }
    public string[] Tags { get; set; }
    public System.Collections.IDictionary Map { get; set; }
    public ConsoleTextWidgetProbe Child { get; set; }
    [System.Management.Automation.Hidden] public string Secret { get; set; }
    public override string ToString() => this.ToConsoleString();
}
[ConsoleDisplay("Name")]
public sealed class ConsoleTextNamedProbe {
    public string Name { get; set; }
    public int    Size { get; set; }
    public override string ToString() => this.ToConsoleString();
}
public sealed class ConsoleTextRecordProbe : DictionaryRecord {
    public string Name { get; set; }
}
public sealed class ConsoleTextPlainProbe { public string Name { get; set; } }
public sealed class ConsoleTextThrowingProbe {
    public string Name { get { throw new System.InvalidOperationException("no"); } }
    public override string ToString() => this.ToConsoleString();
}
'@
        }
    }

    It 'renders the record convention with the bare type name and omits null properties' {
        $widget = [ConsoleTextWidgetProbe]@{ Name = 'widget'; Size = 3 }
        "$widget" | Should -Be 'ConsoleTextWidgetProbe { Name = widget, Size = 3, Kind = Small }'
        [string] $widget | Should -Be "$widget"
    }

    It 'renders an empty string as two quotes and escapes newlines onto one line' {
        $widget = [ConsoleTextWidgetProbe]@{ Name = ''; Note = "a`r`nb`nc" }
        "$widget" | Should -BeLike 'ConsoleTextWidgetProbe { Name = '''', Note = a\nb\nc, *'
    }

    It 'cuts a string longer than MaxTextLength and counts the rest' {
        $text = 'x' * ([Catzc.Base.Objects.ConsoleText]::MaxTextLength + 7)
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue($text) | Should -Be (('x' * [Catzc.Base.Objects.ConsoleText]::MaxTextLength) + '… (+7 chars)')
    }

    It 'renders a collection as [a, b], capped at MaxItems with the rest counted' {
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue([string[]]@('a', 'b')) | Should -Be '[a, b]'
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue([string[]]@(1..7)) | Should -Be '[1, 2, 3, 4, 5, … (+2)]'
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue([string[]]@()) | Should -Be '[]'
    }

    It 'renders a dictionary as { k = v }' {
        $map = [ordered]@{ gadget = 1 }
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue($map) | Should -Be '{ gadget = 1 }'
    }

    It 'renders dates as ISO 8601 and numbers invariantly' {
        $date = [datetime]::new(2026, 1, 2, 3, 4, 5, [System.DateTimeKind]::Utc)
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue($date) | Should -Be '2026-01-02T03:04:05.0000000Z'
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue(1.5) | Should -Be '1.5'
    }

    It 'renders only the [ConsoleDisplay] properties when the type names them' {
        "$([ConsoleTextNamedProbe]@{ Name = 'gadget'; Size = 9 })" | Should -Be 'ConsoleTextNamedProbe { Name = gadget }'
    }

    It 'renders the named properties only, and throws naming the type for an unknown one' {
        $widget = [ConsoleTextWidgetProbe]@{ Name = 'widget'; Size = 3 }
        [Catzc.Base.Objects.ConsoleText]::ToConsoleString($widget, [string[]]@('Size')) | Should -Be 'ConsoleTextWidgetProbe { Size = 3 }'
        { [Catzc.Base.Objects.ConsoleText]::ToConsoleString($widget, [string[]]@('Missing')) } |
            Should -Throw "*'ConsoleTextWidgetProbe' has no public readable property 'Missing'*"
    }

    It 'skips a [Hidden] property' {
        "$([ConsoleTextWidgetProbe]@{ Name = 'widget'; Secret = 'gadget' })" | Should -Not -BeLike '*Secret*'
    }

    It 'renders a nested object by its own ToString, and stops at MaxDepth so a cycle cannot recurse' {
        $outer = [ConsoleTextWidgetProbe]@{ Name = 'outer' }
        $inner = [ConsoleTextWidgetProbe]@{ Name = 'inner'; Child = $outer }
        $outer.Child = $inner
        "$outer" | Should -Be 'ConsoleTextWidgetProbe { Name = outer, Size = 0, Kind = Small, Child = ConsoleTextWidgetProbe { Name = inner, Size = 0, Kind = Small, Child = ConsoleTextWidgetProbe } }'
    }

    It 'renders a nested object without its own ToString as its bare type name' {
        [Catzc.Base.Objects.ConsoleText]::ToConsoleValue([ConsoleTextPlainProbe]@{ Name = 'widget' }) | Should -Be 'ConsoleTextPlainProbe'
    }

    It 'renders a throwing getter as ! plus the exception type name instead of throwing' {
        "$([ConsoleTextThrowingProbe]::new())" | Should -Be 'ConsoleTextThrowingProbe { Name = !InvalidOperationException }'
    }

    It 'gives every DictionaryRecord the rendering, without its view members' {
        "$([ConsoleTextRecordProbe]@{ Name = 'widget' })" | Should -Be 'ConsoleTextRecordProbe { Name = widget }'
    }

    It 'rejects a ConsoleDisplay attribute that names no property' {
        { [Catzc.Base.Objects.ConsoleDisplayAttribute]::new([string[]]@()) } | Should -Throw '*names at least one property*'
    }
}
