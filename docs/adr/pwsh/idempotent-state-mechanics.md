---
catzc:
  derived:
    path: docs/adr/pwsh/idempotent-state-mechanics.md
    kind: adr
    body_sha: "2b0b2d9c8f9f"
    defines:
      - ADR-PWSH-IDEM#{1-6}
    adrs:
      - ADR-AUTO-IDEM
      - ADR-AUTO-REMOVE#4
    links:
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/automation/idempotent-state-functions.md#where-it-applies
      - docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4
      - docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param3
      - docs/adr/pwsh/pester-testing.md#gotchas
---

# ADR: Idempotent state mechanics — the PowerShell layer over idempotent-state-functions

## Rules: ADR-PWSH-IDEM

### Rule ADR-PWSH-IDEM:1

A pwsh function overwrites the state it owns (ADR-AUTO-IDEM#3): it writes a file with `Set-Content`, `Out-File` without `-Append`, `>`, or
`[System.IO.File]::WriteAllText`, never with `Add-Content`, `Out-File -Append`, `>>`, or `[System.IO.File]::AppendAllText`. A log the
function writes on purpose on every call is output, not state, and is the one place an append belongs.

- [Overwrite, not append](#overwrite-not-append)

### Rule ADR-PWSH-IDEM:2

A list-valued setting — `$env:PATH`, `$env:PSModulePath`, a list in a config the function writes — is extended only after a membership check
(ADR-AUTO-IDEM#1): split it on its separator (`[System.IO.Path]::PathSeparator` for a path list), add the entry only when `-notcontains`
says it is absent, and write the whole value back. An unguarded `"$env:PATH;$dir"` adds one more copy on every re-run.

- [List-valued settings](#list-valued-settings)

### Rule ADR-PWSH-IDEM:3

A pwsh function knows which built-in commands are idempotent and leans on them (ADR-AUTO-IDEM#1, ADR-AUTO-IDEM#2):
`New-Item -ItemType Directory -Force` and `[System.IO.Directory]::CreateDirectory` return the folder whether or not it exists, while
`New-Item -ItemType File -Force` empties an existing file, so a create-if-missing file guards with `Test-Path -LiteralPath` first. A removal
of something that may already be gone checks with `Test-Path -LiteralPath` and returns early.

- [Idempotent built-ins](#idempotent-built-ins)

### Rule ADR-PWSH-IDEM:4

On a state function, `-Force` is the one `[switch]` that skips the check before acting (ADR-AUTO-IDEM#1) and redoes the work — an
`Install-<Tool> -Force` replaces an install at the wrong version or rebuilds one that is present. Without it, a re-run that finds the
desired state changes nothing. On a destructive `Remove-*`, `-Force` is the confirmation of ADR-AUTO-REMOVE#4 instead, and its help says so.

- [The -Force switch](#the--force-switch)

### Rule ADR-PWSH-IDEM:5

Both paths of a pwsh state function return the same result (ADR-AUTO-IDEM#4): the early `return $existing` and the end of the work path emit
the same type, declared in `[OutputType()]`, and a function that returns nothing emits nothing on either path. Every incidental output on
the work path — a `New-Item` result, an `ArrayList.Add` index, a tool's stdout — is discarded (`$null = …`), because pwsh sends every
uncaptured value to the pipeline.

- [One result on both paths](#one-result-on-both-paths)

### Rule ADR-PWSH-IDEM:6

The idempotency contract of ADR-AUTO-IDEM#5 is written in the function's comment-based help: its `.DESCRIPTION` states that the function is
idempotent and names a non-idempotent command it wraps, and a `.PARAMETER Force` says what the switch redoes.

- [The contract in the help](#the-contract-in-the-help)

## Context

[idempotent-state-functions](../automation/idempotent-state-functions.md) (`ADR-AUTO-IDEM`) decides that every state-changing function is
idempotent: check before acting, prefer graceful handling, overwrite rather than append, return the resulting state, and document the
contract. Those rules hold for every execution engine. PowerShell adds its own ways to get each one wrong: cmdlets that look alike but
differ on a re-run, a `-Force` that means different things on different commands, and a pipeline that returns every value a function forgets
to capture. This ADR is the PowerShell layer under the doctrine.

### Overwrite, not append

The file cmdlets come in pairs that differ only in what a second call does. `Set-Content` and `Out-File` replace the file with the desired
content, so the second call leaves the file as the first did; `Add-Content` and `Out-File -Append` add to it, so the second call leaves a
second copy. The redirection operators follow the same split (`>` replaces, `>>` appends), and so do the .NET calls
(`[System.IO.File]::WriteAllText` against `AppendAllText`). A function that owns a file's content uses the replacing form and builds the
whole content before it writes.

A log is the exception by design: a line per run is what a log is for, and the `Write-*` functions produce output on every call. What
matters is that the appended file is never read back as state.

### List-valued settings

A path list is the state a re-run most often duplicates. An install that appends its folder to `$env:PATH` unguarded adds one more copy on
every run, and the list grows until a lookup slows or a limit is hit. The guard is a membership check on the split list, then one write of
the whole value:

```powershell
$entries = $env:PATH -split [System.IO.Path]::PathSeparator
if ($entries -notcontains $scriptsDir) {
    $env:PATH = "$env:PATH$([System.IO.Path]::PathSeparator)$scriptsDir"
}
```

The same holds for `$env:PSModulePath`, and for any list a function writes into a config file: read, check, write the whole list.

### Idempotent built-ins

Some built-ins already converge, and a function leans on them rather than adding a guard of its own
([idempotent-state-functions](../automation/idempotent-state-functions.md#where-it-applies) calls redundant checks waste).
`New-Item -ItemType Directory -Force` returns the existing folder instead of throwing, and `[System.IO.Directory]::CreateDirectory` does the
same without the cmdlet's cost. The same switch on a file is not a create-if-missing: `New-Item -ItemType File -Force` replaces an existing
file with an empty one, so a function that must keep an existing file checks `Test-Path -LiteralPath` first.

`Remove-Item` throws when the path is already gone. A removal that may run twice checks first and returns early, the guard clause of
ADR-AUTO-IDEM#2, so the second run is a silent success and a different failure — a locked file, a denied access — still throws.

### The -Force switch

`-Force` names the one way to ask a state function to act when its check says there is nothing to do. `Install-UvVenvTool -Force` rebuilds
the venv even when the tool is present at the pinned version; without the switch the function finds the tool and returns. The default stays
the idempotent path, and the switch is opt-in behaviour, so it is a `[switch]`
([parameter-design](parameter-design.md#rule-adr-pwsh-param3)).

A destructive verb uses the same name for a different job: on `Remove-<Tool>`, `-Force` confirms the removal, and without it the function
reports its plan ([tool-removal-lifecycle](../automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)). The two meanings never meet on
one function, and each function's help states which one it has (ADR-PWSH-IDEM#6).

### One result on both paths

A pwsh function returns everything it does not capture. The work path of a state function calls more commands than the short-circuit path,
and each one that emits — `New-Item`, `ArrayList.Add`, a native tool — adds a value to the result. A caller that gets one object from the
second run and three from the first has a function that is idempotent in the system and not in its output. So the work path discards what it
does not mean to return, and both paths end in the same declared result:

```powershell
function New-Expedition {
    [OutputType([Catzc.Discovery.Expedition])]
    param([string] $Name)
    $existing = Get-Expedition -Name $Name
    if ($existing) { return $existing }
    $null = New-Item -ItemType Directory -Path (Get-ExpeditionFolder $Name) -Force
    Get-Expedition -Name $Name
}
```

### The contract in the help

A reader learns a function's contract from `Get-Help`, so the contract is in the comment-based help: the `.DESCRIPTION` says the function is
idempotent, and names a wrapped command that is not (an `az … create` that throws on a duplicate). A function with `-Force` says in
`.PARAMETER Force` what the switch redoes or confirms.

## Decision

pwsh state functions overwrite with the replacing cmdlets, extend a list only after a membership check, lean on the built-ins that converge,
keep `-Force` as the one switch that redoes the work, return the same declared result on both paths, and state the contract in their
comment-based help.

### How this is enforced

- **Code review** checks a new state function against these rules: the replacing cmdlet, the membership check, the guard, the `-Force`
  meaning, and the help.
- **Tests** assert idempotency on the boundary rather than on fake state: they seed the already-present state and assert that the writer was
  never called ([pester-testing](pester-testing.md#gotchas)).

## Consequences

- A re-run of any state function leaves the same files, the same lists, and the same result, whatever ran before it.
- `-Force` reads the same on every installer, and a reader of the help knows which meaning a function gives it.
- The cost is a guard or a discard in places pwsh would otherwise accept silently; the rules name each one so a reviewer looks for it.
