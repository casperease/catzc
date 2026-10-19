# ADR: State-changing functions must be idempotent

## Rules: ADR-AUTO-IDEM

### Rule ADR-AUTO-IDEM-CHECKBEFOREACTING

Check before acting. Before creating, installing, or modifying, check whether the desired state already exists; if it does, return early or
silently succeed.

- [Idempotency patterns](#idempotency-patterns)
- [Idempotent in practice](#idempotent-in-practice)

### Rule ADR-AUTO-IDEM-ALREADYDONEISFINE

Prefer graceful handling of "already exists" or "already removed". A function that throws on a no-op re-run is still idempotent, but guard
clauses with early returns make re-runs seamless and spare callers from handling expected errors.

- [Idempotent in practice](#idempotent-in-practice)

### Rule ADR-AUTO-IDEM-OVERWRITENOTAPPEND

Prefer overwrite over append. Write the whole desired content rather than adding to what is there, `PUT` not `POST`, create-or-update over
create-only. Appending is inherently non-idempotent.

- [Idempotency patterns](#idempotency-patterns)

### Rule ADR-AUTO-IDEM-RETURNRESULTINGSTATE

Return the resulting state. An idempotent function returns the same result whether it did work or short-circuited — `New-ServicePrincipal`
returns the SP object whether it created it or found it already present.

- [Idempotent in practice](#idempotent-in-practice)

### Rule ADR-AUTO-IDEM-DOCUMENTCONTRACT

Document the idempotency contract. A function's help states that it is idempotent, and notes when it wraps a non-idempotent external
command.

- [Where it applies](#where-it-applies)

## Context

Automation code gets re-run. Scripts crash halfway and get restarted. CI pipelines retry failed stages. Developers run `Install-DevBoxTools`
after pulling changes even though half the tools are already installed. A colleague runs a setup script not knowing someone already ran it
on the shared build agent.

If state-changing functions are not idempotent, re-runs cause one of three problems:

1. **Failure on duplicate.** `New-AzResourceGroup` throws because the group already exists. The script stops, the user has to figure out
   whether to delete and retry or skip and continue. A five-minute setup becomes a thirty-minute debugging session.

2. **Silent duplication.** `Add-DnsRecord` adds a second identical record. Nothing fails, but the system now has duplicate state that causes
   subtle issues later — intermittent DNS resolution to the wrong IP, duplicate entries in config files, double-charged resources.

3. **Inconsistent state.** `Set-Config` writes a file, but the function also creates a directory. On re-run the directory creation succeeds
   (already exists) but the file write uses different defaults because the function assumed it was starting from scratch. The system is now
   in a state that no single run would produce.

Idempotent functions eliminate all three. Running them once or five times produces the same system state. Re-runs are always safe.

### Idempotent in practice

`What idempotent means in practice`

A function is idempotent when calling it N times with the same arguments leaves the system in the same state as calling it once. The
function may do work on the first call and skip it on subsequent calls, or it may overwrite the same state each time — either approach is
valid as long as the end state is identical.

A function that throws is still idempotent if the system state is unchanged by the failed call. `Remove-Thing` throwing "not found" is
idempotent — the thing is still absent either way. Whether a function throws or returns cleanly is an error-handling concern, not an
idempotency concern. That said, graceful handling (guard clause + early return) is preferred because it makes re-runs seamless.

The examples are pseudo-code; the pwsh spellings are [idempotent-state-mechanics](pwsh/idempotent-state-mechanics.md).

```text
# IDEMPOTENT — checks before acting
function Install-Poetry():
    config = Get-ToolConfig("Poetry")
    if Test-Command(config.command):
        # Already installed — verify version and return
        Assert-ToolVersion("Poetry")
        return
    Invoke-Pip("install " + config.pip_package + "==" + config.version + ".*")
    Assert-Command(config.command)

# IDEMPOTENT — overwrites to desired state regardless of current state
function Set-ProjectConfig(version, environment, config_path):
    write_file(config_path, to_json({ version, environment }))

# NOT IDEMPOTENT — appends on every call
function Set-ProjectConfig(config, config_path, log_path):
    append_file(log_path, "configured at " + now())
    write_file(config_path, to_json(config))

# IDEMPOTENT but ungraceful — throws if already exists
function New-ServicePrincipal(app_id):
    run("az ad sp create --id " + app_id)    # throws if SP already exists — system state is unchanged

# IDEMPOTENT and graceful — checks existence first (preferred)
function New-ServicePrincipal(app_id):
    existing = parse_json(run("az ad sp show --id " + app_id))
    if existing: return existing
    return parse_json(run("az ad sp create --id " + app_id))
```

### Where it applies

`Which functions this applies to`

| Category                  | Idempotent? | Why                                                             |
| ------------------------- | ----------- | --------------------------------------------------------------- |
| `Install-*`               | **Must be** | Re-running setup is the most common scenario                    |
| `Set-*`, `Update-*`       | **Must be** | Writing the same desired state twice must not corrupt           |
| `New-*`                   | **Must be** | Must check existence before creating; return existing if found  |
| `Remove-*`, `Uninstall-*` | **Must be** | Removing something already gone must leave state unchanged      |
| `Assert-*`, `Test-*`      | **Must be** | Pure checks, no state change                                    |
| `Get-*`                   | By contract | The `Get-` verb must not modify state, so re-reads are safe     |
| `Write-*`                 | Naturally   | Output/logging functions produce output on every call by design |

**A note on `Invoke-*` wrappers.** The thin wrappers themselves (`Invoke-Executable`, `Invoke-Python`, `Invoke-Poetry`) assert their
preconditions and then pass through — for example `Invoke-Python` guards with `Assert-NotNullOrWhitespace` on its arguments and
`Assert-Tool` before invoking. Those asserts protect against bad calls; they do not control what the underlying command does, so the
wrappers cannot guarantee idempotency on their own. The calling function is responsible for ensuring idempotency — but that does not always
mean adding extra checks. If the underlying tool already guarantees idempotency (winget skips already-installed packages, a whole-file write
overwrites to the same result), lean on that contract instead of adding redundant guards. Know the tools you wrap — _unnecessary_ checks are
waste, not safety.

### Idempotency patterns

`Common patterns for achieving idempotency`

**Check-then-act.** Query the current state, compare to desired state, only act if they differ. This is the most common pattern for
`Install-*` and `New-*` functions.

**Overwrite to desired state.** Do not read current state — just write the desired state unconditionally. This is simpler and avoids race
conditions. Works well for `Set-*` functions that write files or set configuration values.

**Upsert.** Use APIs that support create-or-update semantics. Many Azure and cloud APIs have upsert endpoints or `--only-show-errors` flags
that suppress "already exists" errors. Prefer these over separate check-then-create logic when available.

**Guard clause with early return.** At the top of the function, check whether the desired state already exists and return immediately if so.
This is the simplest pattern and makes the idempotency visible in the first few lines.

```text
function Install-Tool(tool, config):
    # Guard: already installed at the right version? Done.
    if Test-Command(config.command) and Test-ToolVersion(tool):
        return
    # ... actual installation logic ...
```

## Decision

All state-changing functions (`Install-*`, `Set-*`, `New-*`, `Remove-*`, `Update-*`) must be idempotent. Running them multiple times with
the same arguments must produce the same system state as running them once.

### The language layer

`How each engine writes the patterns`

The rules above hold for every execution engine. How one engine writes them — which of its commands overwrite and which append, what a
switch that redoes the work means, how both paths of a function return the same result, and where the contract is written — is the language
layer for that engine. For pwsh it is [idempotent-state-mechanics](pwsh/idempotent-state-mechanics.md) (`ADR-PWSH-IDEM`).

## Consequences

- Scripts can be safely re-run after partial failures without cleanup.
- CI pipeline retries work without manual intervention.
- `Install-DevBoxTools` can be run on every shell startup or after every pull without wasting time or breaking state.
- Setup instructions simplify to "run this script" — no "but only if you haven't already" caveats.
- Functions become more predictable: same inputs always produce the same system state, regardless of starting state.
