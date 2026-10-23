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

## Decided design (catzc-27's, taken by the user, 2026-10-23)

- The generators live in `Catzc.Base.Languages` beside `New-GoWorkspace` and `New-PythonProject` (the user, 2026-10-23): `Build-RootConfig`
  calls every generator from Base, so a Tooling generator would be a Base→Tooling edge; the two files are the C# language's project config,
  which switches NuGet off, while installing and running dotnet stays in `Catzc.Tooling.Toolchain`.
- `New-NuGetConfig` renders the repo-root `nuget.config` (package and audit sources cleared), registered in `rootconfig.yml` with
  `committed: true` (the C# Dev Kit restores before any import), on the `New-VsCodeSettings` precedent; its head rides a `nuget-config`
  carrier in `file-carriers.yml`.
- `New-DotnetBuildProps` renders a repo-root `Directory.Build.props` from `tools.yml`'s `dotnet.version` (the target framework, NuGet audit
  off); the `net10.0` literal leaves the four hook `.csproj` files and the types project.
- The layering holds (Base never depends on Tooling): the guard `Assert-DotnetOffline`, a file check with no process and no network, lives
  in `Catzc.Base.Execution`; `Build-AgentHook`, `Invoke-BuildForVsCode` and `Invoke-DotnetFormat` call it before every `dotnet` run, and it
  throws naming the file when the root config is missing, a source is not cleared, or a second `nuget.config` sits under the repository. The
  future allow-list plugs in there, empty today.

## Open steps

- [ ] The design lands in one burst with a fresh import. (check: `Invoke-TestFile` on `Assert-DotnetOffline.Tests.ps1` green with cases
      where a visible source and a stray `nuget.config` stop the call, `New-NuGetConfig.Tests.ps1` and `New-DotnetBuildProps.Tests.ps1`
      green, and `Build-AgentHook.Tests.ps1` green three times in a row with a case where `dotnet nuget list source` from each hook folder
      lists none)
- [ ] The three `.cs` files left unformatted (`PathSet.cs`, `TimeoutsConfig.cs`, `VscodeSession.cs`; plan-debt-full-run-failures) are
      formatted once the step above lands. (check: `Test-Formatting -Path` at 0 on them)

## Open questions

- The user's: the tool that configures which package managers are allowed outside the tooling system (first candidate: NuGet for the hook
  builds), its config and its default; not designed yet.
