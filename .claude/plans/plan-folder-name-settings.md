---
plan:
  status: active
  value: medium
  reviewed: 2026-10-25
  targets: [pwsh/.internal, pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Vendor]
---

# Folder names read their settings

ADR-REPO-FOLDERS-NAMESARESETTINGS and ADR-REPO-FOLDERS-DEFAULTCONFIGURATION (rewritten 2026-10-25 in
`docs/drs/repository/conventional-folders.md`): every folder name tooling relies on is a setting with the conventional name as its default,
read through one resolver. Some names are still literals in code, each spelling its setting's default.

## Open steps

- [ ] `New-DynamicManifest` (`pwsh/.internal/Catzc.Internal.Bootstrap.psm1`): read the private-function folder from the powershell
      language's `layout` (role `private-function`) through one resolver instead of the literal `'private'`. Check: a fresh full import,
      then the bootstrap module's tests.
- [ ] `Test-Automation`'s test-path helpers (`Get-TestAutomationTestPaths`, `Get-LanguageTestFolders`, `Get-ChangeTestFile`,
      `Get-ModuleSourceFile`, `ConvertTo-PesterRunTarget`): read the test folder from its setting instead of the literal `'tests'`. Check:
      each helper's test file.
- [ ] `Install-VendorModule`: read `.vendor` from the `pwsh-vendor` track's place in `module-types.yml`. Check:
      `Install-VendorModule.Tests.ps1`. The importer keeps its `pwsh/`, `.internal/` and `.vendor/` literals: conventional-folders.md
      (the bootstrapping paths "do not come from configuration") sanctions them, so they are not an open step.
