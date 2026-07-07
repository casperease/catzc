# Catzc.Tooling.KeyHandler

The PSReadLine key-binding module of the Tooling group. PSReadLine on Linux defaults to bash-style line editing, so a developer moving
between a Windows devbox and a Linux session (or CI) meets two different editing experiences for the same shell. This module carries the
Windows binding set as version-controlled config and replays it on Linux, so the interactive editing keys behave the same everywhere —
[devbox/pipeline parity](../../adr/principles/devbox-pipeline-parity.md) applied to the shell's own input handling. It installs nothing and
manages no external tool, so — like [Catzc.Tooling.Github](catzc-tooling-github.md) — it rests only on the `Base` group, not on
[Catzc.Tooling.Core](catzc-tooling-core.md).

## Domains

| Domain   | Area    | Name                                                                   |
| -------- | ------- | ---------------------------------------------------------------------- |
| domain:1 | capture | [Capture the Windows bindings](#domain1--capture-the-windows-bindings) |
| domain:2 | replay  | [Replay them on Linux](#domain2--replay-them-on-linux)                 |

### domain:1 — Capture the Windows bindings

`Save-PSReadLineKeyHandlerSet` serializes the active session's `Set-PSReadLineKeyHandler` bindings — key and function only, the pair the
replay consumes — to `configs/key-handler-bindings.yml`. It is the Windows-side authoring step: run it in the session whose editing
experience is the one to replicate, then commit the regenerated config. It writes canonically (UTF-8, LF, one trailing newline) through
`Write-FileIfChanged`, so re-capturing an unchanged session is a no-op.

### domain:2 — Replay them on Linux

`Import-PSReadLineKeyHandlerSet` applies the captured bindings on Linux, filtered to the functions the Linux PSReadLine build actually
supports (`configs/key-handler-supported.yml`) so a Windows-only function is dropped rather than throwing. The real apply path asserts
`$IsLinux` — replaying the Windows bindings on a Windows session would clobber its native handlers — and `-DryRun` returns the plan (which
bindings apply, which are skipped) on any platform without touching the session.

## What the module does

Both binding sets are the module's own config, read through the one config reader `Get-Config` and shape-validated on load by the private
convention validators `Assert-KeyHandlerBindingsConfig` / `Assert-KeyHandlerSupportedConfig`
([module-config-loading](../../adr/automation/module-config-loading.md)). The decision — which captured binding is supported on this
platform — is a pure function, `Select-SupportedKeyHandler`, split out from the side-effecting import so it is deterministic and unit-tested
on mocks rather than through a live PSReadLine session ([test-automation](../../adr/automation/test-automation.md) push-left). `Import-` is
the thin walking skeleton over it: read the two configs, classify, apply the supported ones. `-DryRun` follows
[prefer-dryrun-over-shouldprocess](../../adr/automation/powershell/prefer-dryrun-over-shouldprocess.md) — a capturable plan, no host
narration.

## Division

The module's public functions, sorted into the domains above.

| Domain                                  | Function                         |
| --------------------------------------- | -------------------------------- |
| domain:1 — Capture the Windows bindings | `Save-PSReadLineKeyHandlerSet`   |
| domain:2 — Replay them on Linux         | `Import-PSReadLineKeyHandlerSet` |
