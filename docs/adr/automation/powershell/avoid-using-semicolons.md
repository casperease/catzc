# ADR: Avoid using semicolons

## Rules: ADR-NOSEMI

### Rule ADR-NOSEMI:1

Never use trailing semicolons; statements end at the newline. A `;` at the end of a line with nothing after it is dead C#/dotnet syntax.

- [The two patterns](#the-two-patterns)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-NOSEMI:2

Single-line chaining is allowed: `$x = 1; $y = 2` on one line chains two statements. The rule targets the habit of ending every line with
`;`, not concise single-line expressions.

- [The two patterns](#the-two-patterns)

### Rule ADR-NOSEMI:3

`for` loop headers are exempt: `for ($i = 0; $i -lt $n; $i++)` requires semicolons as syntactic separators.

- [The two exceptions](#the-two-exceptions)

### Rule ADR-NOSEMI:4

Inline hash table literals are exempt: `@{ A = 1; B = 2 }` is idiomatic PowerShell.

- [The two exceptions](#the-two-exceptions)

## Context

PowerShell does not require semicolons.

Statements are separated by newlines.

Despite this, semicolons appear frequently in PowerShell code written by developers coming from C#, JavaScript, or other C-family languages.

They add visual noise and signal that the author is thinking in a different language.

### The two patterns

**Trailing semicolons** — line terminators left over from C# habits:

```powershell
# Wrong — semicolons are noise
$config = Get-Config;
$name = $config.Name;
Write-Message $name;
```

```powershell
# Correct
$config = Get-Config
$name = $config.Name
Write-Message $name
```

**Statement chaining on a single line** — permitted when it improves readability for short, related statements:

```powershell
# OK — short related assignments chained on one line
$inner = $Width - 2; "╰$('─' * $inner)╯"

# OK — compact switch branches
'Curved' { $inner = $Width - 2; "╰$('─' * $inner)╯" }
```

```powershell
# Wrong — trailing semicolons (statement terminators, not chaining)
$a = 1;
$b = 2;
```

The distinction: a semicolon followed by another statement on the same line is chaining (allowed).

A semicolon at the end of a line is a trailing terminator (forbidden).

### The two exceptions

**`for` loop headers** — The `for` statement uses semicolons as syntactic separators. This is required — there is no alternative syntax:

```powershell
for ($i = 0; $i -lt 10; $i++) {
    # ...
}
```

**Inline hash table literals** — Semicolons separate entries in single-line hash tables. This is idiomatic PowerShell:

```powershell
$obj = [PSCustomObject]@{ Name = 'test'; Value = 42 }
```

Multi-line hash tables use newlines instead and do not need semicolons:

```powershell
$obj = [PSCustomObject]@{
    Name  = 'test'
    Value = 42
}
```

Both exceptions are structural — the semicolons serve as syntactic separators, not statement terminators.

## Decision

Never use semicolons as trailing statement terminators.

Semicolons are permitted for chaining statements on a single line, in `for` loop headers, and in inline hash table literals.

### How this is enforced

- **PSScriptAnalyzer built-in rule `PSAvoidSemicolonsAsLineTerminators`** — catches trailing semicolons. Enabled in
  `PSScriptAnalyzerSettings.psd1`.

## Consequences

- Code reads as idiomatic PowerShell, not transliterated C#.
- Every statement is on its own line — easier to read, debug, blame, and diff.
- Developers with C# habits get immediate feedback from the linter rather than accumulating semicolons over time.
- The `for` loop exception is narrow and unambiguous — no judgment calls needed.

## Dora explains

DORA's research on code maintainability shows that reducing syntactic noise and following language idioms correlates with faster code review
cycles and fewer defects. Semicolon-free PowerShell code reads as idiomatic, lowers cognitive load, and improves team velocity.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — idiomatic syntax reduces cognitive load and review friction.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — clear, consistent code patterns serve as
  self-documentation.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
