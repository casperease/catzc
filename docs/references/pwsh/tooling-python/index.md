# Catzc.Tooling.Python

The Python ecosystem module of the Tooling group. It owns the Python interpreter — provisioned by uv — and the Python tooling layered on it:
installing, invoking, and removing python and its uv-pip layer, and the tools Poetry and PySpark, each pinned to its locked version through
the generic engine in [Catzc.Tooling.Core](../tooling-core/index.md). It carries no engine of its own; it is the thin, Python-specific surface
over Core, and it installs through uv per [uv-python-handler](../../../drs/automation/uv-python-handler.md) and
[controlling-systemwide-deps](../../../drs/automation/controlling-systemwide-deps.md).

## Responsibilities

| Responsibility   | Area     | Name                                                                     |
| ---------------- | -------- | ------------------------------------------------------------------------ |
| responsibility:1 | runtime  | [Python runtime and pip](#responsibility1--python-runtime-and-pip)       |
| responsibility:2 | uv-tools | [uv-delivered Python tools](#responsibility2--uv-delivered-python-tools) |

### responsibility:1 — Python runtime and pip

The interpreter itself: provision the locked python with uv (`uv python install --default`) idempotently, run python and pip through the
asserted execution wrapper, uninstall the uv-managed interpreter, and hard-remove an unmanaged one. pip is exposed through uv (`uv pip`) —
the package manager the rest of this module installs libraries through — so its invocation lives here alongside the runtime that hosts it.

### responsibility:2 — uv-delivered Python tools

The tools layered on the interpreter — Poetry (dependency and packaging management, installed as an isolated `uv tool`) and PySpark (Spark
for python, installed into the interpreter with `uv pip install --system`) — each with the same install, invoke, and uninstall shape over
Core's engine, pinned to its locked version. They assume the runtime responsibility above is present (PySpark also asserts Java at invoke
time).

## What the module does

The module depends on [Catzc.Tooling.Core](../tooling-core/index.md) and only that module within the group. Every per-tool function is a thin
wrapper that hands its tool name to Core's engine, which reads `tools.yml` to find the locked version and the uv/pip identifier and then
installs, asserts, or removes idempotently. There is no Python-specific install logic outside that delegation.

The two responsibilities are the runtime and what rides on it. Responsibility 1 owns the interpreter and its `uv pip` layer — the package
manager responsibility 2 needs; responsibility 2 owns the tools, whether an isolated uv tool (Poetry) or a library installed into the
interpreter (PySpark). Splitting them keeps the dependency obvious: PySpark and Poetry presume python and uv are already converged. The same
functions run locally and in CI, with no separate provisioning path (see [cross-platform](../../../drs/automation/cross-platform.md)).

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                               | Function            |
| -------------------------------------------- | ------------------- |
| responsibility:1 — Python runtime and pip    | `Install-Python`    |
|                                              | `Invoke-Python`     |
|                                              | `Invoke-Pip`        |
|                                              | `Uninstall-Python`  |
|                                              | `Remove-Python`     |
| responsibility:2 — uv-delivered Python tools | `Install-Poetry`    |
|                                              | `Invoke-Poetry`     |
|                                              | `Uninstall-Poetry`  |
|                                              | `Install-PySpark`   |
|                                              | `Invoke-PySpark`    |
|                                              | `Uninstall-PySpark` |
