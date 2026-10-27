---
plan:
  status: active
  value: high
  reviewed: 2026-10-27
  class: meta
  targets: [pwsh, docs/drs/automation]
---

# Network calls: every default path offline, every call site registered

[ADR-AUTO-NET](../../docs/drs/automation/network-calls.md) decides that no network call runs on a default path and that every call site is
one entry in `pwsh/Base.Execution/configs/network-calls.yml`. The registry carries four sites with trigger `default-path` and one
`package-install` site outside the tooling system; each step below fixes one of them, then the gate makes the registry binding.

## Open steps

- [ ] `pwsh/Base.Languages/Invoke-PythonTest.ps1`: set `UV_OFFLINE=1` beside `UV_PYTHON_DOWNLOADS=never` for the `uv sync` of a test run,
      so a cold cache fails with the remedy (an explicit install command that syncs the workspace online) instead of fetching from PyPI
      ([ADR-AUTO-NET-NODEFAULTPATH](../../docs/drs/automation/network-calls.md#rule-adr-auto-net-nodefaultpath)); its registry entry moves
      to `offline-guarded`. Check: `Invoke-PythonTest.Tests.ps1` asserts the variable is set during the sync and restored after.
- [ ] `pwsh/Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1`: the same `UV_OFFLINE=1` for the sync before `Test-PythonLint` and
      `Test-PythonTypes`, and pyright held to its installed copy (pyright's Python wrapper downloads its node package on first run); its
      entry moves to `offline-guarded`. Check: the module's `Invoke-PythonWorkspaceTool` test file asserts both.
- [ ] The online sync those two steps refer to: one tooling command (in `Tooling.Python`, beside `Install-PipTool`) that runs
      `uv sync --all-packages` with the network, registered as `package-install`, `on-request`. Check: its L0 test mocks `Invoke-Executable`
      and the registry test passes.
- [ ] `pwsh/Base.Languages/Invoke-GoTest.ps1`: set `GOPROXY=off` and `GOFLAGS=-mod=mod` beside `GOTOOLCHAIN=local`, so `go mod download`
      verifies the module offline (the generated `go.mod` files require nothing today); its entry moves to `offline-guarded`. Check:
      `Invoke-GoTest.Tests.ps1` asserts the variables during the run.
- [ ] `pwsh/Azure.Templates/tests/Deploy-Bicep.L3.Tests.ps1`: a live deploy is no test
      ([ADR-AUTO-NET-TESTSOFFLINE](../../docs/drs/automation/network-calls.md#rule-adr-auto-net-testsoffline)); move the check to an explicit
      command or pipeline step (the ephemeral-slot deploy) and delete the test file, with its registry entry. Check: `Test-NetworkCalls`
      (below) finds no test file in the registry, and the pipeline step names the command.
- [ ] `docs/drs/automation/retry-as-last-resort.md`: ADR-AUTO-RETRY-NEVERINTESTS lets an L3 test depend on external connectivity; align it
      with ADR-AUTO-NET-TESTSOFFLINE (a dependency is mocked, a live check is a command). Check: `Test-Links` and `Test-DrsRegistry` pass.
- [ ] `pwsh/Base.QualityGates/Build-EnglishDictionary.ps1`: `npx --yes cspell-trie@10` fetches a package outside the tooling system
      ([ADR-AUTO-PKGMGR-NUGETINTOOLINGONLY](../../docs/drs/automation/use-proper-package-managers.md#rule-adr-auto-pkgmgr-nugetintoolingonly));
      pin `cspell-trie` in `tools.yml`, install it with `Install-Cspell`, and call the installed binary with `Assert-Tool`. Check:
      `Build-EnglishDictionary.Tests.ps1` passes and the source holds no `npx --yes`.
- [ ] `pwsh/Base.Execution/Test-NetworkCalls.ps1`: the gate of
      [ADR-AUTO-NET-REGISTRYGATE](../../docs/drs/automation/network-calls.md#rule-adr-auto-net-registrygate): the network patterns as a
      `patterns` key of `network-calls.yml` (on `NetworkCallsConfig`, with its type test case), every match in a registered file, every
      registered file still matching, and every `default-path` site an issue. Check: its L0 test over `TestDrive:` fixtures (widget,
      gadget), then the gate on the tree reports exactly the sites still open above.
