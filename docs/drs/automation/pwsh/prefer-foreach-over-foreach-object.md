# PowerShell: Prefer foreach over ForEach-Object

## Rules: ADR-PWSH-FOREACH

### Rule ADR-PWSH-FOREACH-STATEMENTDEFAULT

Default to the `foreach` statement for all iteration: it has correct, predictable `return`/`break`/`continue` semantics and is faster.

- [The control flow trap](#the-control-flow-trap)
- [Performance](#performance)

### Rule ADR-PWSH-FOREACH-OBJECTFORTRANSFORMS

Use `ForEach-Object` only for single-expression pipeline transforms with no control flow keywords. If you need `if`, `return`, `break`,
`continue`, or `try`/`catch`, switch to `foreach`. Never use `return`, `break`, or `continue` inside `ForEach-Object`; they do not do what
they appear to.

- [When ForEach-Object fits](#when-foreach-object-fits)
- [The control flow trap](#the-control-flow-trap)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-FOREACH-PARALLELISCONCURRENCY

Treat `ForEach-Object -Parallel` as a concurrency primitive, not a faster loop: all variables need `$using:`, module functions are
unavailable, shared state needs thread-safe collections, errors are batched. Default to sequential `foreach`.

- [ForEach-Object -Parallel](#foreach-object--parallel)

## Context

PowerShell has two iteration mechanisms with almost identical names and completely different semantics:

- **`foreach` statement** — a language keyword. A compiled loop that iterates over a collection in memory.
- **`ForEach-Object` cmdlet** (alias `%`) — a pipeline cmdlet. Invokes a scriptblock for each item received from the pipeline.

### The control flow trap

The `ForEach-Object` body is a **scriptblock**, not a loop body. The keywords `return`, `break`, and `continue` behave completely
differently inside a scriptblock than inside a loop:

- **`return`**: in `foreach` it returns from the enclosing function. In `ForEach-Object` it exits the current scriptblock iteration only,
  like `continue` in a loop: the pipeline keeps running, and the enclosing function does **not** return.
- **`break`**: in `foreach` it exits the loop. In `ForEach-Object` it breaks the nearest **enclosing loop or switch**; if there is no
  enclosing loop, it **terminates the entire script**. It does not "break out of ForEach-Object."
- **`continue`**: in `foreach` it skips to the next iteration. In `ForEach-Object` it acts on the nearest **enclosing loop**; if there is no
  enclosing loop, it behaves like `break` and terminates the script. It does not "skip to the next pipeline item."

These are the designed semantics of scriptblocks, not edge cases, and they break the expectations of anyone who reads `ForEach-Object` as a
loop.

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

#### `break`

```text
`break` does not break the pipeline
```

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

#### `continue`

```text
`continue` does not skip to the next item
```

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
  inline code in the scope of the code that contains it.
- **No streaming cost.** `ForEach-Object` processes items one at a time from the pipeline. `foreach` operates on the full collection in
  memory, enabling better CPU cache utilization and eliminating per-item pipeline dispatching.

The difference is typically 3-10x for tight loops. On small, materialized collections it rarely matters in wall-clock time, but there is
**no performance reason** to prefer `ForEach-Object` unless streaming is needed.

### When ForEach-Object fits

`When ForEach-Object is appropriate`

`ForEach-Object` is the right choice when:

1. **Simple property access in a pipeline chain:**

   ```powershell
   $names = Get-ChildPath $path -Directory | ForEach-Object { [System.IO.Path]::GetFileName($_) }
   ```

2. **One-expression transforms in a pipeline:**

   ```powershell
   $paths = $items | Where-Object { $_.Enabled } | ForEach-Object { $_.Path }
   ```

3. **Formatting for display:**

   ```powershell
   $summary = $results | ForEach-Object { "$($_.Name): $($_.Status)" }
   ```

Each body is a **single expression** with **no control flow**; a body of more than one statement is a `foreach`.

### ForEach-Object -Parallel

`ForEach-Object -Parallel` runs scriptblocks in separate runspaces, with pitfalls beyond the control flow ones:

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

- **No access to module functions.** Functions imported by the module system are not available in parallel runspaces; the body re-imports
  them or receives scriptblocks explicitly.

  ```powershell
  # BROKEN — Write-Message is not defined in the parallel runspace
  $items | ForEach-Object -Parallel {
      Write-Message "Processing $_"       # throws: command not found
  }
  ```

- **No shared mutable state.** Each runspace has its own copy of variables. Mutating a `$using:` variable in one runspace does not affect
  others or the caller. Aggregating results beyond pipeline output takes a thread-safe collection
  (`[System.Collections.Concurrent.ConcurrentBag[object]]`).

- **Error handling is different.** Errors in parallel runspaces are collected and re-thrown after all runspaces complete, so the caller
  cannot `try`/`catch` one item's failure; it gets them all at the end.

- **Throttle limit defaults to 5.** I/O-bound work (API calls, file downloads) raises `-ThrottleLimit`; CPU-bound work matches it to
  `[Environment]::ProcessorCount`.

## Decision

Use the `foreach` statement for all iteration. Reserve `ForEach-Object` for simple one-expression transforms in pipeline chains where no
control flow is needed.

### How this is enforced

- **PSScriptAnalyzer custom rule `Measure-NoForEachObjectControlFlow`** (severity: Error) — flags `return`, `break`, and `continue` inside
  `ForEach-Object` scriptblocks.
- **Code review** — a multi-statement `ForEach-Object` body without control flow keywords is rejected against this record.

## Consequences

- All iteration with control flow uses `foreach`, eliminating the entire class of `return`/`break`/`continue` misbehavior bugs.
- `ForEach-Object` in the codebase is always a simple one-liner — easy to read, no hidden behavior.
- Developers accustomed to using `ForEach-Object` everywhere must learn to reach for `foreach` first. The PSScriptAnalyzer rule catches the
  dangerous cases automatically.
- `ForEach-Object -Parallel` usage requires deliberate design — no accidental use as a "faster loop."
