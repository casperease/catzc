---
plan:
  status: active
  value: low
  reviewed: 2026-10-26
  class: feature
  targets: [pwsh/Base.Languages/Invoke-PythonTest.ps1]
---

# Debt Python tests: Invoke-PythonTest's module-name check refuses a kit module

`Invoke-PythonTest -Module diagrams` stops with "module 'diagrams' is not a pascal-dotted name, so it names no test folder", from
`LanguagesConfig.TestFolderOf`: a Python kit module such as `python/diagrams` is named by its folder, never pascal-dotted, so its tests run
only through `-Folder python/diagrams/tests` (found 2026-10-26, flow-lens step 3).

## Open steps

- [ ] `Invoke-PythonTest`: `-Module` also takes a kit module's folder name, resolving `python/<folder>/tests`, or the refusal names
      `-Folder` as the way to run it. Check: `Invoke-TestFile` on `pwsh/Base.Languages/tests/Invoke-PythonTest.Tests.ps1` with a case for a
      folder-named module.
