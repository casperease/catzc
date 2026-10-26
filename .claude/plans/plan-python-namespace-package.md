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

After `plan-module-namespace.md`, the diagram kit lives in `python/diagrams/`, and its namespace lives only in its manifest
(`[project] name = "catzc-diagrams"`). Today it is a script folder: there is no `__init__.py`, its manifest has `package = false` and no
build backend, its modules import each other flat (`import edge_rules`), and its tools run by path
(`python python/diagrams/declaration.py put …`). This plan makes it a real package under the python track's namespace, so code imports
`catzc.diagrams`, while the folder keeps its short name (DDR-TRACK-MODULENAMESPACE). It starts only once the tree is green after the folder
moves.

## Open steps

1. [ ] **A build backend that maps the namespace.** `New-PythonProject` writes a build backend into a module's manifest that maps the import
       name onto the short folder (setuptools `package-dir = {"catzc.diagrams" = "."}`, or an equivalent the locked toolchain offers), and
       sets `package = true`. The import name comes from the python track's namespace and the module folder through the resolver, not a
       literal. Check: `New-PythonProject.Tests.ps1` covers the mapping for a widget module, and `Test-GeneratedFiles` passes.
2. [ ] **Package imports.** Each flat sibling import in the kit (`import edge_rules`, `import minimaps`, …) becomes a relative import, one
       module at a time, with an `__init__.py` added. Check: `ruff` and `pyright` clean over the kit.
3. [ ] **Entry points instead of script paths.** Each `python python/diagrams/<tool>.py` call becomes `python -m catzc.diagrams.<tool>` or a
       declared entry point, in the callers (skills, agents, pwsh wrappers, usage lines), one file at a time. Check: `Test-Links` on the
       edited files, and a grep for `python/diagrams/.*\.py` in call sites returns nothing.
4. [ ] **The import holds from outside the folder.** After the uv editable install,
       `uv run --project python python -c "import catzc.diagrams"` from the repository root succeeds. Check: that command exits 0, and
       `Invoke-PythonTest` over the kit suite passes.
