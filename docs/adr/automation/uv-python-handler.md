# ADR: uv is the standard Python handler; tools install user-space

## Rules: ADR-UVPY

### Rule ADR-UVPY:1

uv is the single handler for Python: the `python` interpreter is provisioned by `uv python install <version> --default`, which installs a
uv-managed CPython and writes the global `python`/`python3` shims into uv's user tool-bin. No system package manager (winget, brew, apt)
installs Python.

- [Why uv](#why-uv)

### Rule ADR-UVPY:2

A Python-based CLI installs through uv in one of two shapes, declared in `tools.yml`: a standalone CLI (Azure CLI, Poetry) installs as an
**isolated tool** (`uv tool install`, keyed by `uv_tool`), so its dependency graph never touches any other environment; a package that must
stay **importable** (PySpark) installs **into** the uv-managed Python (`uv pip install --system`, keyed by `pip_package`), so `import`
works.

- [Two install shapes](#two-install-shapes)

### Rule ADR-UVPY:3

No tool in the standard toolchain requires Administrator. uv installs entirely in user space, so a developer without elevation provisions
the full toolchain. A machine-scope package manager is not an install path for these tools.

- [User-space, no admin](#user-space-no-admin)

### Rule ADR-UVPY:4

The pin is authoritative, with one devbox relaxation. `Assert-ToolVersion` and `Test-Tool` accept the locked `version`; outside a CI
pipeline they also accept an optional `devbox_version` prefix, so a devbox runs a functional off-pin tool for local work. A pipeline session
ignores `devbox_version` and enforces `version` alone, keeping promotion deterministically locked.

- [The devbox lever](#the-devbox-lever)

### Rule ADR-UVPY:5

uv installs executables into the user tool-bin (`~/.local/bin`). Provisioning ensures that directory is on the persistent PATH (uv's own
`update-shell`), and the session janitor (`Sync-SessionTools`) keeps it resolvable each session, so a uv-installed CLI is found without a
shell restart mid-work.

- [Keeping uv tools on PATH](#keeping-uv-tools-on-path)

## Context

The toolchain provisions a developer workstation with a locked set of CLIs — Python, the Azure CLI, Poetry, PySpark, and the Node/JVM tools.
The question this ADR answers is how the **Python-family** tools are installed. The others keep their native user-scope package managers
(winget on Windows, brew on macOS); Python and the CLIs written in Python are handled by uv.

### Why uv

A single, fast, statically-linked binary (uv) resolves and installs Python and Python-based CLIs on every platform, in user space, with
reproducible version pins. It removes three problems that a system-package-manager or system-`pip` approach carries:

- **Admin.** The official Azure CLI on Windows is a machine-scope MSI that demands elevation. uv installs the same CLI in user space, so a
  locked-down enterprise devbox provisions it without Administrator (see [User-space, no admin](#user-space-no-admin)).
- **Version coupling.** A system-`pip` install of a CLI ties that CLI to whatever Python is on PATH and drops the CLI's dependency tree into
  the shared interpreter. uv gives each standalone CLI its own isolated environment with its own managed Python, so upgrading one tool
  cannot break another.
- **Determinism.** uv resolves an exact interpreter and package set from the pin in `tools.yml`, identically on a devbox and in CI.

The Azure CLI is still preferred over the Az PowerShell modules for all Azure work ([prefer-az-cli](powershell/prefer-az-cli.md)); this ADR
only changes how that CLI is installed, not that it is the chosen tool.

### Two install shapes

The distinction is whether the tool is used as a **command** or as an **importable library**:

- **Isolated tool** (`uv_tool`) — the tool is a self-contained CLI (Azure CLI, Poetry). `uv tool install` builds it a private environment
  and exposes only its executables. Its packages are invisible to, and unbreakable by, everything else.
- **Into the managed Python** (`pip_package`, installed with `uv pip install --system`) — the tool is a library the interpreter must import
  (PySpark: `import pyspark`). It installs into the uv-provisioned Python so both its CLI and its importable module resolve. Its version is
  read from installed package metadata, not by importing the package.

Which shape a tool uses is data in `tools.yml`; the generic engine (`Install-UvTool` / `Install-PipTool`) picks the mechanism.

### User-space, no admin

Every Python-family install lands under the user profile — the uv tool-bin and uv's managed-Python data dir. Nothing writes to a
machine-wide location, so nothing prompts for elevation. This is the decisive reason the Azure CLI moved off its machine-scope MSI: a
developer who cannot elevate must still be able to run `az`. The same holds on Linux, where the alternative (the official apt script) needs
root.

### The devbox lever

Pins exist so that every devbox and CI agent runs the same toolchain. But a devbox is sometimes one release behind and still perfectly
usable for local pre-commit work, and forcing an immediate upgrade is friction with no safety benefit locally. A tool may therefore declare
a `devbox_version` — a second accepted prefix that applies only outside a CI pipeline. The pipeline path (`Test-IsRunningInPipeline`)
ignores it and holds the single locked `version`, so nothing off-pin can reach master. The lever is a deliberate, temporary relaxation a
maintainer tunes toward the pin, not a second permanent version.

### Keeping uv tools on PATH

uv writes tool executables to one user directory (`~/.local/bin`). Two mechanisms keep that directory usable: provisioning runs uv's
`update-shell` once to add it to the persistent PATH, and the post-import janitor `Sync-SessionTools` reconciles the session PATH on every
load so a freshly-installed tool resolves without restarting the shell. A tool installed outside the installer layer is reported, never
fought.

## Decision

Provision Python with `uv python install --default`, and install Python-based CLIs user-space via uv — isolated tools for standalone CLIs,
`uv pip install --system` for importable libraries — with no Administrator requirement anywhere, an authoritative pin plus a CI-strict
`devbox_version` lever, and the uv tool-bin kept on PATH by provisioning and the session janitor.

## Consequences

- A developer without Administrator provisions the entire toolchain, including the Azure CLI, on Windows and Linux.
- Each standalone Python CLI is isolated, so tool upgrades do not interact; the one importable library (PySpark) shares the managed Python
  by design.
- The locked `version` governs CI; a devbox may run an off-pin functional tool through `devbox_version` without weakening promotion.
- uv-installed tools resolve in every session once the tool-bin is on PATH; the session janitor makes that self-healing.
- The toolchain depends on uv itself being present and pinned — uv is provisioned first (its dependents declare `depends_on: uv`).

## Dora explains

User-space Python provisioning via uv removes admin barriers, isolates tool dependencies, and ensures deterministic, reproducible versions.
This enables self-service infrastructure provisioning while maintaining strict version control for CI/CD.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — user-space uv-managed Python enables provisioning
  without elevation and scales to organizations with strict access policies.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — locked Python versions ensure identical toolchains across
  devbox and CI; `devbox_version` relaxation applies only locally, keeping promotion deterministic.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — isolated tool environments and self-healing PATH make
  Python-based CLIs self-service and maintainable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
