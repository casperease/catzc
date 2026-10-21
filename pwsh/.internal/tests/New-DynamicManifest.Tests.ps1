<#
---
catzc:
  immutable:
    with_body_sha: a553b55d20dd
  edges:
    cites:
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
---
#>

# The loader runs before the types load, so it cannot read the layout. This test holds it to the layout instead.
Describe 'New-DynamicManifest against the layout' -Tag 'L1', 'integrity', 'ADR-AUTO-MODULE-EXISTSBYLAYOUT' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.internal/Catzc.Internal.Bootstrap.psm1') -Force
    }

    AfterAll {
        Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction SilentlyContinue
    }

    It 'loads a .ps1 file exactly from the layout rows that hold functions, and from no other folder' {
        $module = Join-Path $TestDrive 'Catzc.Widget'
        $expected = [System.Collections.Generic.List[string]]::new()
        foreach ($row in (Get-Config -Config languages).layout) {
            $isFunctionRow = $row.role -like '*-function'
            if ($row.folder -eq '.') {
                if ($row.extensions -notcontains '.ps1') {
                    continue
                }
                $relative = "Get-$($row.role).ps1"
            }
            else {
                $relative = "$($row.folder)/Get-$($row.role).ps1"
            }
            New-Item -ItemType File -Path (Join-Path $module $relative) -Force | Out-Null
            if ($isFunctionRow) {
                $expected.Add($relative)
            }
        }
        $expected.Count | Should -BeGreaterThan 1

        $manifest = InModuleScope Catzc.Internal.Bootstrap -Parameters @{ Module = $module } { param($Module) New-DynamicManifest -ModulePath $Module }
        $loaded = (Import-PowerShellDataFile -Path $manifest).PrivateData.CatzcFiles
        $loaded | Sort-Object | Should -Be ($expected | Sort-Object)
    }
}
