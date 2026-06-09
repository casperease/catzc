# Catzc.Tooling.Provisioning

The orchestration module of the Tooling group. It converges a whole development workstation to the complete locked tool set in dependency
order, reports and asserts the aggregate status of every tool, and keeps the machine clean of package managers the platform refuses to
depend on. It also ships two bespoke installers — Git and Postman — that do not fit Core's generic engine, and it owns the
`ToolStatus`/`ToolStatusKind` types its status report is built on. It is the layer over the per-tool surfaces in
[Catzc.Tooling.Core](catzc-tooling-core.md), [Catzc.Tooling.Python](catzc-tooling-python.md), [Catzc.Tooling.Node](catzc-tooling-node.md),
and [Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md). The rationale is in
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md) and
[idempotent-state-functions](../../adr/automation/idempotent-state-functions.md); the status types are native per
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md).

## Domains

| Domain   | Area          | Name                                                             |
| -------- | ------------- | ---------------------------------------------------------------- |
| domain:1 | orchestration | [Workstation orchestration](#domain1--workstation-orchestration) |
| domain:2 | hygiene       | [Workstation hygiene](#domain2--workstation-hygiene)             |
| domain:3 | bespoke       | [Bespoke tool installers](#domain3--bespoke-tool-installers)     |

### domain:1 — Workstation orchestration

The whole machine rather than one tool: install (and uninstall) the complete locked tool set in the order declared dependencies require,
report each tool's aggregate status — correct, usable-but-wrong-manager, wrong-version, missing, or unwanted — through the
`ToolStatus`/`ToolStatusKind` types (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)), and assert that status is
clean. This is the diagnostic and convergence layer over the per-tool engines.

### domain:2 — Workstation hygiene

Keeping the workstation free of what the platform will not depend on: removing Chocolatey — a package manager the estate refuses (see
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md)) — and clearing accumulated temporary files.

### domain:3 — Bespoke tool installers

Git and Postman, whose installers do not fit Core's config-driven engine and so are written by hand here. Each still exposes the same
install and uninstall shape as a managed tool, so it slots into the orchestration above and the status report sees it like any other.

## What the module does

The module depends on [Catzc.Tooling.Core](catzc-tooling-core.md) and the three ecosystem modules; it reaches their per-tool installers by
dynamic dispatch rather than a static call, so converging a workstation is just running the lifecycle for every tool in dependency order and
then reporting where reality diverges from the lock. The status report is the surface a human or an assertion reads to see at a glance what
needs installing, upgrading, or removing. Install and uninstall are dry-run-able so a run can be previewed before it mutates the machine
(see [prefer-dryrun-over-shouldprocess](../../adr/automation/powershell/prefer-dryrun-over-shouldprocess.md)). The same functions run
locally and in CI, with no separate provisioning script (see [cross-platform](../../adr/automation/cross-platform.md)).

Provisioning is also where the platform's package-manager support matters for enterprise and air-gapped networks, because the locked tools
must still install where the public registries are unreachable. The support is uneven by manager: apt-get has full Artifactory support, so
its repositories can be mirrored and pinned behind a private proxy; Homebrew is partial, in that bottle caching can be redirected with
`HOMEBREW_BOTTLE_DOMAIN` but formula metadata still resolves upstream; and winget has none, so the practical options are to store the
installers in a Generic repository and point at a private REST source, or to pre-install the tools in the base image.

## Division

The module's public functions, sorted into the domains above.

| Domain                               | Function                   |
| ------------------------------------ | -------------------------- |
| domain:1 — Workstation orchestration | `Install-DevBoxTools`      |
|                                      | `Uninstall-DevBoxTools`    |
|                                      | `Get-ToolsStatus`          |
|                                      | `Assert-DevBoxToolsStatus` |
| domain:2 — Workstation hygiene       | `Uninstall-Chocolatey`     |
|                                      | `Clear-TempFolders`        |
| domain:3 — Bespoke tool installers   | `Install-Git`              |
|                                      | `Uninstall-Git`            |
|                                      | `Install-Postman`          |
|                                      | `Uninstall-Postman`        |
