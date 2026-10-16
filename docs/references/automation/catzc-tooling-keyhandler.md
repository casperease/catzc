---
catzc:
  immutable:
    with_body_sha: "0ac4c274fd5e"
    repo_status: clean
    path: docs/references/automation/catzc-tooling-keyhandler.md
    folder: docs/references/automation
    name: catzc-tooling-keyhandler
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/automation/devbox-pipeline-parity.md
      - docs/adr/automation/dry-run.md
      - docs/adr/automation/test-automation.md
      - docs/adr/configuration/module-config-loading.md
      - docs/references/automation/catzc-tooling-core.md
      - docs/references/automation/catzc-tooling-github.md
---

# Catzc.Tooling.KeyHandler

The PSReadLine key-binding module of the Tooling group. PSReadLine on Linux defaults to bash-style line editing, so a developer moving
between a Windows devbox and a Linux session (or CI) meets two different editing experiences for the same shell. This module carries the
Windows binding set as version-controlled config and replays it on Linux, so the interactive editing keys behave the same everywhere —
[devbox/pipeline parity](../../adr/automation/devbox-pipeline-parity.md) applied to the shell's own input handling. It installs nothing and
manages no external tool, so — like [Catzc.Tooling.Github](catzc-tooling-github.md) — it rests only on the `Base` group, not on
[Catzc.Tooling.Core](catzc-tooling-core.md).

## Responsibilities

| Responsibility   | Area    | Name                                                                           |
| ---------------- | ------- | ------------------------------------------------------------------------------ |
| responsibility:1 | capture | [Capture the Windows bindings](#responsibility1--capture-the-windows-bindings) |
| responsibility:2 | replay  | [Replay them on Linux](#responsibility2--replay-them-on-linux)                 |

### responsibility:1 — Capture the Windows bindings

`Save-PSReadLineKeyHandlerSet` serializes the active session's `Set-PSReadLineKeyHandler` bindings — key and function only, the pair the
replay consumes — to `configs/key-handler-bindings.yml`. It is the Windows-side authoring step: run it in the session whose editing
experience is the one to replicate, then commit the regenerated config. It writes canonically (UTF-8, LF, one trailing newline) through
`Write-FileIfChanged`, so re-capturing an unchanged session is a no-op.

### responsibility:2 — Replay them on Linux

`Import-PSReadLineKeyHandlerSet` applies the captured bindings on Linux, filtered to the functions the Linux PSReadLine build actually
supports (`configs/key-handler-supported.yml`) so a Windows-only function is dropped rather than throwing. The real apply path asserts
`$IsLinux` — replaying the Windows bindings on a Windows session would clobber its native handlers — and `-DryRun` returns the plan (which
bindings apply, which are skipped) on any platform without touching the session.

## What the module does

Both binding sets are the module's own config, read through the one config reader `Get-Config` and shape-validated on load by their C#
config types `KeyHandlerBindingsConfig` / `KeyHandlerSupportedConfig`
([module-config-loading](../../adr/configuration/module-config-loading.md)). The decision — which captured binding is supported on this
platform — is a pure function, `Select-SupportedKeyHandler`, split out from the side-effecting import so it is deterministic and unit-tested
on mocks rather than through a live PSReadLine session ([test-automation](../../adr/automation/test-automation.md) push-left). `Import-` is
the thin walking skeleton over it: read the two configs, classify, apply the supported ones. `-DryRun` follows
[dry-run](../../adr/automation/dry-run.md) — a capturable plan, no host narration.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                  | Function                         |
| ----------------------------------------------- | -------------------------------- |
| responsibility:1 — Capture the Windows bindings | `Save-PSReadLineKeyHandlerSet`   |
| responsibility:2 — Replay them on Linux         | `Import-PSReadLineKeyHandlerSet` |
| config                                          | `key-handler-bindings.yml`       |
|                                                 | `key-handler-supported.yml`      |
