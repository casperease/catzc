<#
---
catzc:
  derived:
    path: automation/.internal/tests/Get-TypesAssemblyManifest.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-TypesAssemblyManifest' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:space = 'Fixture' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:dll = Join-Path $TestDrive 'Catzc.Types.fixture.dll'
        $source = @"
namespace Catzc.Base.Objects {
    [System.AttributeUsage(System.AttributeTargets.All, AllowMultiple = true)]
    public sealed class PSTypeAliasAttribute : System.Attribute { public PSTypeAliasAttribute(string name) { } }
    [System.AttributeUsage(System.AttributeTargets.Class, Inherited = true)]
    public sealed class ConsoleDisplayAttribute : System.Attribute { public ConsoleDisplayAttribute(params string[] properties) { } }
}
namespace $($script:space) {
    public class Plain { }
    [Catzc.Base.Objects.PSTypeAlias("Fx.Widget")]
    [Catzc.Base.Objects.PSTypeAlias("Fx.Gizmo")]
    [Catzc.Base.Objects.ConsoleDisplay("Size", "Color")]
    public class Widget { }
    public class Gadget : Widget { }
    [Catzc.Base.Objects.ConsoleDisplay("Own")]
    public class Sprocket : Gadget { }
    public class Holder { public class Inner { } }
    internal class Hidden { }
}
"@
        Add-Type -TypeDefinition $source -OutputAssembly $script:dll -OutputType Library -WarningAction SilentlyContinue

        function script:Get-FixtureType ([string] $Name) {
            (Get-TypesAssemblyManifest -Path $script:dll).Types | Where-Object Name -EQ "$($script:space).$Name"
        }
    }

    It 'lists only public top-level types, sorted ordinally by name' {
        $names = @((Get-TypesAssemblyManifest -Path $dll).Types.Name | Where-Object { $_ -like "$($script:space).*" })
        $names | Should -Be @("$space.Gadget", "$space.Holder", "$space.Plain", "$space.Sprocket", "$space.Widget")
    }

    It 'gives a type with no attributes empty aliases and display' {
        $type = Get-FixtureType 'Plain'
        $type.Aliases.Count | Should -Be 0
        $type.Display.Count | Should -Be 0
    }

    It 'reads every PSTypeAlias name a type declares' {
        (Get-FixtureType 'Widget').Aliases | Should -Be @('Fx.Widget', 'Fx.Gizmo')
    }

    It 'reads the ConsoleDisplay properties in order' {
        (Get-FixtureType 'Widget').Display | Should -Be @('Size', 'Color')
    }

    It 'lets a derived type inherit the base display, through a chain' {
        (Get-FixtureType 'Gadget').Display | Should -Be @('Size', 'Color')
    }

    It 'prefers a type''s own display over the base''s' {
        (Get-FixtureType 'Sprocket').Display | Should -Be @('Own')
    }

    It 'does not inherit aliases' {
        (Get-FixtureType 'Gadget').Aliases.Count | Should -Be 0
    }

    It 'throws when the file does not exist' {
        { Get-TypesAssemblyManifest -Path (Join-Path $TestDrive 'missing.dll') } | Should -Throw '*does not exist*'
    }

    It 'never loads the assembly into the process' {
        Get-TypesAssemblyManifest -Path $dll | Out-Null
        @([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { -not $_.IsDynamic -and $_.GetType("$($script:space).Plain", $false) }).Count | Should -Be 0
    }
}
