<#
---
catzc:
  immutable:
    with_body_sha: d7c6134e5769
---
#>

Describe 'Test-TypesAssemblyContent' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:space = 'Fixture' + [guid]::NewGuid().ToString('N').Substring(0, 8)
        $script:dll = Join-Path $TestDrive 'Catzc.Types.fixture.dll'
        $source = @"
namespace $($script:space) {
    public class Widget { public int Size { get; set; } }
    public class Gadget { public class Inner { } }
    internal class Hidden { }
}
"@
        Add-Type -TypeDefinition $source -OutputAssembly $script:dll -OutputType Library

        function script:Get-FixtureAssembly {
            [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { -not $_.IsDynamic -and $_.GetType("$($script:space).Widget", $false) }
        }
        function script:New-Expected {
            param([string[]] $Bases)
            @(foreach ($base in $Bases) {
                    [pscustomobject]@{ Module = $script:space; Base = $base }
                })
        }
    }

    It 'returns nothing when every expected type is declared' {
        Test-TypesAssemblyContent -Path $dll -Expected (New-Expected 'Widget', 'Gadget') | Should -BeNullOrEmpty
    }

    It 'throws the Import-CSharpTypes message when a type is missing' {
        { Test-TypesAssemblyContent -Path $dll -Expected (New-Expected 'Widget', 'Sprocket') } |
            Should -Throw "*Compiled C# types but '$($script:space).Sprocket' was not produced. $($script:space)/types/Sprocket.cs must declare a public class named 'Sprocket'*"
    }

    It 'does not count a non-public type' {
        { Test-TypesAssemblyContent -Path $dll -Expected (New-Expected 'Hidden') } | Should -Throw "*'$($script:space).Hidden' was not produced*"
    }

    It 'does not count a nested type as a top-level one' {
        { Test-TypesAssemblyContent -Path $dll -Expected (New-Expected 'Inner') } | Should -Throw "*'$($script:space).Inner' was not produced*"
    }

    It 'matches the namespace as well as the name' {
        $wrong = @([pscustomobject]@{ Module = 'Other.Space'; Base = 'Widget' })
        { Test-TypesAssemblyContent -Path $dll -Expected $wrong } | Should -Throw "*'Other.Space.Widget' was not produced*"
    }

    It 'throws when the file does not exist' {
        { Test-TypesAssemblyContent -Path (Join-Path $TestDrive 'missing.dll') -Expected (New-Expected 'Widget') } | Should -Throw '*does not exist*'
    }

    It 'never loads the assembly into the process' {
        Test-TypesAssemblyContent -Path $dll -Expected (New-Expected 'Widget', 'Gadget')
        @(Get-FixtureAssembly).Count | Should -Be 0
    }

    It 'leaves the file unlocked, so it can be deleted' {
        $copy = Join-Path $TestDrive 'Catzc.Types.copy.dll'
        [System.IO.File]::Copy($dll, $copy)
        Test-TypesAssemblyContent -Path $copy -Expected (New-Expected 'Widget')
        [System.IO.File]::Delete($copy)
        [System.IO.File]::Exists($copy) | Should -BeFalse
    }
}
