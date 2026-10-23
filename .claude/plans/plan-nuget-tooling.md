---
plan:
  status: active
  value: high
  reviewed: 2026-10-23
  class: feature
  targets: [pwsh/Catzc.Tooling.Toolchain, pwsh/Catzc.Base.TypesSystem/Build-AgentHook.ps1]
---

# NuGet tooling: NuGet belongs to the tooling modules, and no dotnet call contacts a package manager outside them

Every `dotnet publish`, `build` and `format` runs an implicit NuGet restore that reads the user-level `%APPDATA%\NuGet\NuGet.Config`, so the
hook builds (`Build-AgentHook`), `Invoke-BuildForVsCode` and `Invoke-DotnetFormat` have contacted nuget.org and a private feed with stored
credentials on every run; NuGet's credential plugin, started by that restore, held a publish's output open and made
`Build-AgentHook.Tests.ps1` flaky (catzc-27, 2026-10-23, plan-debt-full-run-failures).

## Why its value

The repository's dependencies are BCL or vendored; a package manager reached from outside the tooling system is an uncontrolled supply path
on a regulated devbox, and today it is reached silently on every import that builds a hook.

## Decided (the user, 2026-10-23)

- Nothing contacts a package manager outside the tooling system; `--source nuget.org` on a call is no fix (tried and reverted).
- NuGet is part of the tooling modules; dotnet already lives in `Catzc.Tooling.Toolchain` (`Install-Dotnet`, `Invoke-Dotnet`).
- The config that keeps dotnet offline is a generated file, never hand-written.
- Building the Claude extensions (the hooks) may later be allowed a package manager, but only through a tool that configures the allowed
  package managers, which does not exist yet; until then the allowed set is empty.

## Open steps

- [ ] Design, reported to the orchestrator before any edit: `Catzc.Tooling.Toolchain` owns NuGet: the generated repo-root `nuget.config`
      (package and audit sources cleared, committed, written by the tooling module rather than a hand-kept asset), its head carrier for XML
      (`file-carriers.yml`), and every in-tree `dotnet` restore path (`Build-AgentHook`, `Invoke-BuildForVsCode`, `Invoke-DotnetFormat`)
      routed through `Invoke-Dotnet`, which refuses to run while any package source is visible; and the target framework (`net10.0`, a
      literal in every `.csproj` today) declared once and tied to the SDK the tooling installs, so a framework change cannot start a
      reference-pack download (the user, 2026-10-23). No `dotnet` command runs while designing. (check: the design read against
      ADR-AUTO-PKGMGR and ADR-REPO-ROOTCFG by `drs-reviewer`)
- [ ] The design lands in one burst with a fresh import. (check: `Invoke-TestFile` on `Invoke-Dotnet.Tests.ps1` green with a case where a
      visible source stops the call, and `Build-AgentHook.Tests.ps1` green with a case where `dotnet nuget list source` from each hook
      folder lists none)
- [ ] The three `.cs` files left unformatted (`PathSet.cs`, `TimeoutsConfig.cs`, `VscodeSession.cs`; plan-debt-full-run-failures) are
      formatted once the step above lands. (check: `Test-Formatting -Path` at 0 on them)

## Open questions

- The user's: the tool that configures which package managers are allowed outside the tooling system (first candidate: NuGet for the hook
  builds), its config and its default; not designed yet.
