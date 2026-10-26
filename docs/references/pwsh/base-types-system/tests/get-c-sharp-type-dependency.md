# pwsh/Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1

The tests of `Get-CSharpTypeDependency`, over fixture modules written into a temporary root.

## The fixture helper

`New-TypeModule` writes `<root>/<module>/types/<type>.cs` for each entry, and module names double as namespaces. It uses `[System.IO]`
rather than `New-Item` and `Set-Content`, about 0.1 ms against 20 ms a call
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)).
