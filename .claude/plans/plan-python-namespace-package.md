---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: feature
  targets:
    [
      pwsh/Base.Languages/New-PythonProject.ps1,
      python/pyproject.toml,
      python/diagrams/pyproject.toml,
      docs/drs/automation/python/python-test-artifacts.md,
    ]
---

# Python namespace package: code imports catzc.diagrams

The diagram kit in `python/diagrams/` is a package, `catzc.diagrams`, run as `python -m catzc.diagrams.<tool>`; setuptools maps the import
name onto the short folder (DDR-TRACK-MODULENAMESPACE). Its default editable install hooks the import system at run time, which Python
follows and pyright does not, so the type check cannot resolve `catzc.diagrams` (23 reportMissingImports in the kit's tests). A strict
editable install, which pyright reads, runs the kit from a link tree under `build/`; the kit finds the repository through one resolver in
`module_paths.py` and reads its configs with a real YAML load, so only the install itself is left.

## Open steps

1. [ ] **A strict editable install with the package's data.** `New-PythonProject` renders the strict editable mode
       (`[tool.uv.config-settings-package]` on the workspace root, the mode a `build_backend` default on PythonConfig) and the package data
       (`configs/**/*`, `assets/**/*`, a default on PythonConfig) for each package member, so pyright reads the package through the static
       link tree while the kit's data reads resolve beside its code; the kit already finds the repository through `module_paths.REPO`. A C#
       and importer-path change, so it lands in one burst with a uv re-install. Check: `Test-PythonTypes` is at 0, and `Invoke-PythonTest`
       over the kit and `Test-Diagrams` pass.
