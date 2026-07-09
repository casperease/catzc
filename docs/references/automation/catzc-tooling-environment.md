# Catzc.Tooling.Environment

The seam that prepares a process's environment before launching a child or external tool. It is the one sanctioned way to hand a secret to
an external consumer through the environment (ADR-AUTO-ENVVAR:7) and to expose committed config values as environment variables, so that
scattered ad-hoc `$env:TOKEN = $plaintext` writes are replaced by a single disciplined boundary. It owns `Write-EnvironmentSet` and the
private process-env write seam; it does **not** own config reading or addressing (that is [Catzc.Base.Config](catzc-base-config.md)'s
`Get-ConfigValue`) or the flattening of a config subtree (that is [Catzc.Base.Objects](catzc-base-objects.md)). The design is governed by
[environment-variables](../../adr/automation/environment-variables.md) and
[config-value-addressing](../../adr/configuration/config-value-addressing.md).

## Domains

| Domain   | Area    | Name                                                                     |
| -------- | ------- | ------------------------------------------------------------------------ |
| domain:1 | handoff | [Environment variable hand-off](#domain1--environment-variable-hand-off) |

### domain:1 — Environment variable hand-off

Setting a set of `$env:` variables for an external, child, or test process to read, from three unambiguous channels so intent is never
guessed. A `-Set` entry is either a `[SecureString]` (a secret) or a `global.<config>...` config address (a non-secret value, or a subtree
that fans out under its key as an env-normalized prefix); a `-Value` entry is an explicit non-secret literal. A bare string in `-Set` is
rejected, and two channels resolving to the same env var name throws — the caller cannot accidentally leak a literal as a secret or clobber
a value. Secrets are taken as `[SecureString]`, never logged or returned (masked `***`), and decrypted only at the assignment. Lifetime is
one of two mutually exclusive shapes: a scoped `-ScriptBlock` that snapshots, sets, invokes, and restores in a `finally` (the default), or
`-Persist` that leaves the variables set for the session or child.

## What the module does

The module exists so that the single legitimate reason to place a secret in `$env:` — an external tool whose contract is to read it there
(ADR-AUTO-ENVVAR:1) — flows through exactly one auditable function instead of bare assignments scattered across the codebase.
`ADR-AUTO-ENVVAR:6` forbids `$env:` as a secret _store_ that our own code reads back; `ADR-AUTO-ENVVAR:7` permits the disciplined _hand-off_
this module implements. A reviewer has one place to check that a secret is `SecureString` in, masked in logs, decrypted only at the
boundary, and scoped by default.

Its three input channels are typed and named apart so a value's intent is unmistakable (poka-yoke): a `[SecureString]` is always a secret, a
`global.…` string is always a config address, and a plain literal must travel through `-Value` — a bare string in `-Set` is an error, not a
guess. An address is resolved by `Get-ConfigValue`; a scalar becomes one variable, and a subtree flattens (via `ConvertTo-FlatSettingSet`)
under its map key as an env-normalized prefix — uppercased, with `.` turned to `_` and `[n]` to `_n`, so the `database` subtree under prefix
`DB` becomes `DB_HOST`, `DB_PORT`, `DB_OPTIONS_SSL`. Every resulting name is checked for collision across all channels before anything is
set, so a duplicate fails fast rather than letting one input silently win.

Lifetime defaults to scoped because a secret should not outlive the work that needs it: the scoped form snapshots each target's current
value (including "was unset"), sets all, invokes the block, and restores every target in a `finally` — a previously-unset variable is
removed again. `-Persist` is the explicit opt-out for a variable meant to last the session or reach a child process launched later. The
actual `$env:` writes go through a private seam (`Set-ProcessEnvironmentVariable`) so tests mock the boundary rather than mutating the real
process environment (mirroring `Set-EnvironmentPath`).

One cross-platform caveat travels with the contract: `[SecureString]` is DPAPI-encrypted only on Windows; on Linux and macOS .NET stores it
obfuscated, not encrypted (see [cross-platform](../../adr/automation/cross-platform.md)). The plaintext also necessarily lands in `$env:`
for the instant the external tool reads it. The value the seam guarantees is therefore the _contract_ — don't-log, don't-internalize,
decrypt-only-at-the-boundary, scoped-by-default — not at-rest cryptography.

The module is a member of the `Tooling` group with no intra-Tooling edges; it draws only on `Base` — `Get-ConfigValue` and
`ConvertTo-FlatSettingSet` for the address channel, `Write-Message` for masked logging, and the assertion library.

## Division

The module's single public function.

| Domain                                   | Function               |
| ---------------------------------------- | ---------------------- |
| domain:1 — Environment variable hand-off | `Write-EnvironmentSet` |
