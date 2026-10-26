# pwsh/Tooling.Provisioning/tests/Uninstall-DevBoxTools.Tests.ps1

The tests of `Uninstall-DevBoxTools`, pure orchestration: they assert that the command delegates to the per-tool uninstallers.
`Get-ToolInstallOrder` is mocked to a small, realistic order, a single-word key (`python`) and a multi-word key (`node_js`), and the real
per-tool uninstallers are mocked, so the dynamic-dispatch loop runs without touching the machine.

The multi-word case is the regression guard: the key must be mapped through `Get-ToolCommandSuffix` to its PascalCase command suffix
(`node_js` to `Uninstall-NodeJs`), or it silently never dispatches.
