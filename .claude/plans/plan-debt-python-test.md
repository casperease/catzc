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
- [ ] A new kit module is importable only after `uv sync --reinstall-package catzc-diagrams` (the kit's strict editable install links files
      one by one), and `Invoke-Executable -WorkingDirectory` takes no relative path inside a burst: `Invoke-PythonTest` reinstalls the kit
      when a module under `python/diagrams/` has no link in its build copy, and `Invoke-Executable` resolves a relative working directory
      against the repository root. Check: `Invoke-TestFile` on `pwsh/Base.Languages/tests/Invoke-PythonTest.Tests.ps1` and
      `pwsh/Base.Execution/tests/Invoke-Executable.Tests.ps1`, each with a case for the new path.
