---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: fix
  targets: [pwsh/Base.Languages/Invoke-JavaScriptTest.ps1, pwsh/Base.Languages/Invoke-PythonTest.ps1]
---

# The JavaScript and Python test runners resolve a module's test folder through its track

`Invoke-GoTest` and `Invoke-BashTest` name a module's test folder from its folder, which drops the namespace its track declares, through the
private `Get-ModuleTestFolder` (DDR-TRACK-MODULENAMESPACE). `Invoke-JavaScriptTest` and `Invoke-PythonTest` still pass the module's full
name to `TestFolderOf`, so they spell the namespace into the folder (`catzc_base_repository` where the folder is `base_repository`).

## Open steps

1. [ ] `pwsh/Base.Languages/Invoke-PythonTest.ps1`: the test folder from `Get-ModuleTestFolder python $Module`, and the namespaced fixture
       folders in its tests renamed short (check: `Invoke-TestFile -Path pwsh/Base.Languages/tests/Invoke-PythonTest.Tests.ps1`, and
       `Invoke-PythonTest Catzc.Base.Repository` passes).
2. [ ] `pwsh/Base.Languages/Invoke-JavaScriptTest.ps1`: the same through `Get-ModuleTestFolder javascript $Module` (check:
       `Invoke-TestFile -Path pwsh/Base.Languages/tests/Invoke-JavaScriptTest.Tests.ps1`).

## Open questions

- Should the folder-to-full-name lookup live once, in a low module both Base.Config and Base.QualityGates reach, instead of three times
  (`Get-ModuleFolderFullName` in Base.ModuleSystem, `Resolve-ConfigEntry`'s manifest read, the loaded-module map in `Test-ShippedConfigs`)?
  Recommendation: yes, in Base.Repository beside `Get-CatzcModuleRoot`, which already maps the other way; PDR-ONELIVE.

- Should `Get-ModuleTestFolder` move from a private helper of Base.Languages into `LanguagesConfig.TestFolderOf` itself, taking the track,
  so no caller can pass a full name again? Recommendation: yes, once both runners use it; one resolution order, and the four call sites
  shrink to one.
