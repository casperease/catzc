# Catzc.Tooling.Python

The Python ecosystem module of the Tooling group. It owns the Python interpreter and the pip-delivered tooling layered on it — installing,
invoking, and removing python and pip themselves, and the pip-installed tools Poetry and PySpark — each pinned to its locked version through
the generic engine in [Catzc.Tooling.Core](catzc-tooling-core.md). It carries no engine of its own; it is the thin, Python-specific surface
over Core, and it installs through pip per [use-proper-package-managers](../../adr/automation/use-proper-package-managers.md) and
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md).

## Domains

| Domain   | Area      | Name                                                               |
| -------- | --------- | ------------------------------------------------------------------ |
| domain:1 | runtime   | [Python runtime and pip](#domain1--python-runtime-and-pip)         |
| domain:2 | pip-tools | [Pip-installed Python tools](#domain2--pip-installed-python-tools) |

### domain:1 — Python runtime and pip

The interpreter itself: install the locked python idempotently, run python and pip through the asserted execution wrapper, uninstall the
managed install, and hard-remove an unmanaged one. pip is the package manager the rest of this module installs through, so its invocation
lives here alongside the runtime that provides it.

### domain:2 — Pip-installed Python tools

The tools that ride on pip — Poetry (dependency and packaging management) and PySpark (Spark for python) — each with the same install,
invoke, and uninstall shape over Core's engine, pinned to its locked version. They assume the runtime domain above is present.

## What the module does

The module depends on [Catzc.Tooling.Core](catzc-tooling-core.md) and only that module within the group. Every per-tool function is a thin
wrapper that hands its tool name to Core's engine, which reads `tools.yml` to find the locked version and the pip identifier and then
installs, asserts, or removes idempotently. There is no Python-specific install logic outside that delegation.

The two domains are the runtime and what rides on it. Domain 1 owns the interpreter and pip — the package manager domain 2 needs; domain 2
owns the tools that are themselves pip packages. Splitting them keeps the dependency obvious: PySpark and Poetry presume python and pip are
already converged. The same functions run locally and in CI, with no separate provisioning path (see
[cross-platform](../../adr/automation/cross-platform.md)).

## Division

The module's public functions, sorted into the domains above.

| Domain                                | Function            |
| ------------------------------------- | ------------------- |
| domain:1 — Python runtime and pip     | `Install-Python`    |
|                                       | `Invoke-Python`     |
|                                       | `Invoke-Pip`        |
|                                       | `Uninstall-Python`  |
|                                       | `Remove-Python`     |
| domain:2 — Pip-installed Python tools | `Install-Poetry`    |
|                                       | `Invoke-Poetry`     |
|                                       | `Uninstall-Poetry`  |
|                                       | `Install-PySpark`   |
|                                       | `Invoke-PySpark`    |
|                                       | `Uninstall-PySpark` |
