<#
---
catzc:
  derived:
    path: automation/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.TypesSystem
    relatives:
      page: docs/references/automation/catzc-base-typessystem/tests/Test-ConsoleReadyType.Tests.ps1.md
      source: automation/Catzc.Base.TypesSystem/private/Test-ConsoleReadyType.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Test-ConsoleReadyType' -Tag 'L0', 'logic' {
    BeforeAll {
        if (-not ([System.Management.Automation.PSTypeName]'ConsoleReadyWidgetProbe').Type) {
            Add-Type -TypeDefinition @'
public sealed class ConsoleReadyWidgetProbe { public string Name { get; set; } }
public struct ConsoleReadyGadgetProbe { public int Size; }
public abstract class ConsoleReadyBaseProbe { }
public static class ConsoleReadyStaticProbe { }
'@
        }
    }

    It 'fails a class or struct that keeps the inherited ToString' {
        InModuleScope Catzc.Base.TypesSystem {
            Test-ConsoleReadyType -Type ([ConsoleReadyWidgetProbe]) | Should -BeFalse
            Test-ConsoleReadyType -Type ([ConsoleReadyGadgetProbe]) | Should -BeFalse
        }
    }

    It 'passes a type that overrides ToString' {
        InModuleScope Catzc.Base.TypesSystem {
            Test-ConsoleReadyType -Type ([System.Version]) | Should -BeTrue
        }
    }

    It 'exempts the kinds never held as a value: enum, interface, abstract, static, attribute, exception, delegate' {
        InModuleScope Catzc.Base.TypesSystem {
            foreach ($type in [System.DayOfWeek], [System.IDisposable], [ConsoleReadyBaseProbe], [ConsoleReadyStaticProbe],
                [System.ObsoleteAttribute], [System.InvalidOperationException], [System.Action]) {
                Test-ConsoleReadyType -Type $type | Should -BeTrue -Because $type.Name
            }
        }
    }
}
