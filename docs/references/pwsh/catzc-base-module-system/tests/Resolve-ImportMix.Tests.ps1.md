# pwsh/Base.ModuleSystem/tests/Resolve-ImportMix.Tests.ps1

The tests of the private `Resolve-ImportMix`. The fixture languages layout has a widget language that owns the module root and a gadget
language that owns `gizmos/`, while `assets/` and `tests/` are the shared rows.
