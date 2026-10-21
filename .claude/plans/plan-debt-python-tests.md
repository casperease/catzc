---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1]
---

# Debt python tests: a Python module's own tests found without -Folder

`Invoke-PythonTest Catzc.Diagrams` without `-Folder` fails with "python/tests/catzc_diagrams/ does not exist" (catzc-e3, 2026-10-22),
because the kit keeps its tests in its own `python/catzc_diagrams/tests/`. ADR-AUTO-PY-MODULESBYLAYOUT places the black-box tests of the
engine under the holder, `<root>/tests/<module>/`, and a Python module is a folder the layout places, so the kit's own `tests/` is a layout,
not a stray: the workspace already lists `catzc_diagrams` as a member (`python/pyproject.toml`), and `Invoke-PythonTest.ps1:38` says the
folder is "a module's own tests/ or the holder's", while line 43 builds only the holder's path. No folder moves; the code catches up with
its comment. The chunk owns `Invoke-PythonTest.ps1`, its test file and its comment page.

## Open steps

1. [ ] `pwsh/Catzc.Base.Languages/Invoke-PythonTest.ps1:39-44`: with no `-Folder`, the test folder is the module's own
       `<python root>/<module folder>/tests/` when it exists on disk (the module folder named as `TestFolderOf('python', $Module)` names it,
       so the name is declared once), else the holder's `<python root>/tests/<module folder>/`; the workspace member follows as line 54
       already says; the page states the order, with one test case per layout. Check: `Invoke-TestFile` on
       `pwsh/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1`, and one live run of `Invoke-PythonTest Catzc.Diagrams` with no
       `-Folder` reports the kit's pytest result.
