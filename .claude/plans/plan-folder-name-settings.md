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
- [ ] `Install-VendorModule` and the importer: read `.vendor` and `.internal` from the `pwsh-vendor` track's place and the internal module
      place in `module-types.yml`. Check: `Install-VendorModule.Tests.ps1`, then a fresh full import.

## Open questions

- Session learnings of 2026-10-25, proposed to shrink what the next session reads: should the `catzc-verify` capability gain one line ("a C#
  type edit that adds a call and its member lands in one Edit"), the test ADR one line on Pester's `<name>` title templates and quoted
  hyphenated hashtable keys, and the comments ADR one line on how a section anchors to its code line (about 80 characters, cut on a word,
  then `...`)?
