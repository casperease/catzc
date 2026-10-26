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

1. [ ] The folder-to-full-name lookup lives once, in Base.Repository beside `Get-CatzcModuleRoot`, replacing `Get-ModuleFolderFullName`,
       `Resolve-ConfigEntry`'s manifest read and `Test-ShippedConfigs`' loaded-module map (PDR-ONELIVE; a chunk of its own, not the
       runners') (check: `Invoke-TestFile -Path pwsh/Base.Repository/tests` passes, and the old lookup's file is gone from
       Base.ModuleSystem).

## Open questions

- Should `Get-ModuleTestFolder` move from a private helper of Base.Languages into `LanguagesConfig.TestFolderOf` itself, taking the track,
  so no caller can pass a full name again? Recommendation: yes, once both runners use it; one resolution order, and the four call sites
  shrink to one.
