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
editable install, which pyright reads, runs the kit from a link tree under `build/`, where every root derived from `__file__` parents points
into that tree; the step below removes that dependency first.

## Open steps

1. [ ] **The kit reads its yml configs with a real YAML load.** `drawio_png_base.kit_defaults` and any other hand-split reader of a kit yml
       go through the kit's one loader (`declaration_constants.load_yaml`, over the pinned pyyaml), so a scalar the formatter wraps onto
       indented continuation lines loads; no new package is fetched. Check: a wrapped `states:` scalar in a fixture drawio.yml loads to its
       one-line value, and `Invoke-PythonTest` over the kit passes.
2. [ ] **The kit finds the repository root through one resolver.** `module_paths.py` resolves the root from `RepositoryRoot` (the importer
       sets it), falling back to the nearest `.git` above the working folder, never from `__file__` parents; every `REPO` constant in the
       kit re-points to it. Then `New-PythonProject` renders the strict editable mode (`[tool.uv.config-settings-package]` on the workspace
       root, the mode a `build_backend` default on PythonConfig) and the package data (`configs/**/*`, `assets/**/*`, a default on
       PythonConfig), so pyright reads the package through the static link tree while the kit's data and root reads still resolve. Check:
       grep finds no `parents[` in `python/diagrams` outside `module_paths.py`, `Test-PythonTypes` is at 0, and `Invoke-PythonTest` over the
       kit passes.
