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

- [ ] `.claude/skills/catzc-verify/SKILL.md`: one line, "a C# type edit that adds a call and its member lands in one Edit", merged within
      the capability's line roof (the user, 2026-10-25). Check: `Test-AgentDefinitions`.
- [ ] The test ADR (`docs/drs/automation/test-automation.md`): one line on Pester's `<name>` title templates and quoted hyphenated hashtable
      keys. Check: `Test-Links` on the page. The comments ADR line on anchoring is covered by the anchor rule of plan-drone-learnings.
