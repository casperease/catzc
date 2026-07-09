# ADR: Prefer foreach over ForEach-Object

## Rules: ADR-AUTO-FOREACH

### Rule ADR-AUTO-FOREACH:1

Default to the `foreach` statement for all iteration: it has correct, predictable `return`/`break`/`continue` semantics and is faster.

- [The control flow trap](#the-control-flow-trap)
- [Performance](#performance)

### Rule ADR-AUTO-FOREACH:2

Use `ForEach-Object` only for single-expression pipeline transforms with no control flow keywords. If you need `if`, `return`, `break`,
`continue`, or `try`/`catch`, switch to `foreach`.

- [When ForEach-Object is appropriate](#when-foreach-object-is-appropriate)

### Rule ADR-AUTO-FOREACH:3

Never use `return`, `break`, or `continue` inside `ForEach-Object`; they do not do what they appear to. If you need control flow, rewrite as
`foreach`.

- [The control flow trap](#the-control-flow-trap)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-FOREACH:4

Treat `ForEach-Object -Parallel` as a concurrency primitive, not a faster loop: all variables need `$using:`, module functions are
unavailable, shared state needs thread-safe collections, errors are batched. Default to sequential `foreach`.

- [ForEach-Object -Parallel](#foreach-object--parallel)

## Context

PowerShell has two iteration mechanisms with almost identical names and completely different semantics:

- **`foreach` statement** — a language keyword. A compiled loop that iterates over a collection in memory.
- **`ForEach-Object` cmdlet** (alias `%`) — a pipeline cmdlet. Invokes a scriptblock for each item received from the pipeline.

They look interchangeable. They are not.

### The control flow trap

The `ForEach-Object` body is a **scriptblock**, not a loop body. The keywords `return`, `break`, and `continue` behave completely
differently inside a scriptblock than inside a loop:

| Keyword    | In `foreach` (expected)             | In `ForEach-Object` (surprise)                                                                                                                                  |
| ---------- | ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `return`   | Returns from the enclosing function | Exits the current scriptblock iteration only — like `continue` in a loop. The pipeline keeps running. The enclosing function does **not** return.               |
| `break`    | Exits the `foreach` loop            | Breaks the nearest **enclosing loop or switch**. If there is no enclosing loop, **terminates the entire script**. Does not "break out of ForEach-Object."       |
| `continue` | Skips to the next iteration         | Acts on the nearest **enclosing loop**. If there is no enclosing loop, behaves like `break` — terminates the script. Does not "skip to the next pipeline item." |

These are not edge cases — they are the designed semantics of scriptblocks. But they violate the expectations of anyone who reads
`ForEach-Object` as "a loop."

#### `return` does not return

```powershell
# BROKEN — return exits the scriptblock, not the function
function Get-FirstAdmin {
    $users | ForEach-Object {
        if ($_.IsAdmin) {
            return $_              # does NOT return from Get-FirstAdmin
        }
    }
    Write-Message 'No admin found'  # always executes — even when an admin was found
}
```

```powershell
# Correct — foreach return works as expected
function Get-FirstAdmin {
    foreach ($user in $users) {
        if ($user.IsAdmin) {
            return $user           # returns from Get-FirstAdmin
        }
    }
    Write-Message 'No admin found'
}
```

#### `break` does not break the pipeline

```powershell
# BROKEN — break affects the enclosing loop, not ForEach-Object
foreach ($file in $files) {
    Get-Content $file | ForEach-Object {
        if ($_ -match 'STOP') {
            break                  # breaks the outer foreach, not ForEach-Object
        }
    }
}
```

```powershell
# CATASTROPHIC — no enclosing loop, break terminates the script
$items | ForEach-Object {
    if ($_.IsBad) {
        break                      # kills the entire script
    }
}
```

#### `continue` does not skip to the next item

```powershell
# BROKEN — continue skips the outer loop iteration, not the pipeline item
foreach ($batch in $batches) {
    $batch.Items | ForEach-Object {
        if ($_.Skip) {
            continue               # skips to next $batch, not next item
        }
        Process-Item $_
    }
}
```

### Performance

`foreach` is significantly faster than `ForEach-Object`:

- **No pipeline overhead.** `ForEach-Object` participates in the pipeline machinery — parameter binding, steppable pipeline creation, and
  per-item scriptblock invocation. `foreach` is a compiled loop with none of this overhead.
- **No scriptblock invocation.** Each iteration of `ForEach-Object` invokes the scriptblock as a function call. `foreach` runs the body as
  inline code in the current scope.
- **No streaming cost.** `ForEach-Object` processes items one at a time from the pipeline. `foreach` operates on the full collection in
  memory, enabling better CPU cache utilization and eliminating per-item pipeline dispatching.

The performance difference is measurable — typically 3-10x for tight loops. For automation code where collections are small and already
materialized, this rarely matters in wall-clock time. But there is **no performance reason** to prefer `ForEach-Object` over `foreach`
unless streaming is specifically needed.

### When ForEach-Object is appropriate

`ForEach-Object` is the right choice when:

1. **Simple property access in a pipeline chain:**

   ```powershell
   $names = Get-ChildItem | ForEach-Object Name
   ```

2. **One-expression transforms in a pipeline:**

   ```powershell
   $paths = $items | Where-Object { $_.Enabled } | ForEach-Object { $_.Path }
   ```

3. **Formatting for display:**

   ```powershell
   $summary = $results | ForEach-Object { "$($_.Name): $($_.Status)" }
   ```

The common pattern: the body is a **single expression** with **no control flow**. If the body needs `if`, `return`, `break`, `continue`,
`try`/`catch`, or is more than one statement — use `foreach`.

### ForEach-Object -Parallel

PowerShell 7+ adds `ForEach-Object -Parallel`, which runs scriptblocks in separate runspaces. This introduces additional pitfalls beyond the
control flow issues:

- **No access to outer variables.** Each runspace gets its own scope. Outer variables must be passed explicitly via `$using:varName`.
  Forgetting `$using:` produces `$null` — no error, no warning.

  ```powershell
  # BROKEN — $config is $null in each runspace
  $config = Get-Config
  $items | ForEach-Object -Parallel {
      Install-Thing -Config $config       # $null — silent failure
  }

  # Correct
  $config = Get-Config
  $items | ForEach-Object -Parallel {
      Install-Thing -Config $using:config
  }
  ```

- **No access to module functions.** Functions imported by the module system are not available in parallel runspaces. You must re-import or
  pass scriptblocks explicitly.

  ```powershell
  # BROKEN — Write-Message is not defined in the parallel runspace
  $items | ForEach-Object -Parallel {
      Write-Message "Processing $_"       # throws: command not found
  }
  ```

- **No shared mutable state.** Each runspace has its own copy of variables. Mutating a `$using:` variable in one runspace does not affect
  others or the caller. Use thread-safe collections (`[System.Collections.Concurrent.ConcurrentBag[object]]`) if you need to aggregate
  results beyond pipeline output.

- **Error handling is different.** Errors in parallel runspaces are collected and re-thrown after all runspaces complete. You cannot
  `try`/`catch` individual item failures from the caller — you get them all at the end.

- **Throttle limit defaults to 5.** Without `-ThrottleLimit`, only 5 runspaces execute concurrently. For I/O-bound work (API calls, file
  downloads), increase this. For CPU-bound work, match it to `[Environment]::ProcessorCount`.

**Rule:** `ForEach-Object -Parallel` is a concurrency primitive, not a faster loop. Use it only when you have genuinely independent work
items and understand the runspace isolation model. Prefer sequential `foreach` as the default.

## Decision

Use the `foreach` statement for all iteration. Reserve `ForEach-Object` for simple one-expression transforms in pipeline chains where no
control flow is needed.

### How this is enforced

- **PSScriptAnalyzer custom rule `Measure-NoForEachObjectControlFlow`** (severity: Error) — flags `return`, `break`, and `continue` inside
  `ForEach-Object` scriptblocks.
- **Code review** — complex `ForEach-Object` bodies that should be `foreach` but lack control flow keywords are caught in review using this
  ADR as reference.

## Consequences

- All iteration with control flow uses `foreach`, eliminating the entire class of `return`/`break`/`continue` misbehavior bugs.
- `ForEach-Object` in the codebase is always a simple one-liner — easy to read, no hidden behavior.
- Developers accustomed to using `ForEach-Object` everywhere must learn to reach for `foreach` first. The PSScriptAnalyzer rule catches the
  dangerous cases automatically.
- `ForEach-Object -Parallel` usage requires deliberate design — no accidental use as a "faster loop."

## Dora explains

DORA research shows that correct language semantics and predictable control flow reduce debugging time and test failures. Using foreach for
iteration eliminates entire classes of bugs where control flow keywords behave unexpectedly in scriptblock contexts.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — correct control flow semantics reduce cognitive load and
  bugs.
- [Test automation](https://dora.dev/capabilities/test-automation/) — predictable iteration behavior enables reliable, non-flaky tests.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
