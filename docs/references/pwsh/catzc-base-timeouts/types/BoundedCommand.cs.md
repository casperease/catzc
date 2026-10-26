# pwsh/Base.Timeouts/types/BoundedCommand.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Whether a command line runs inside a time limit, in each execution engine's grammar — the check behind the Bash
hook's background rule (BashSafeguard) and the per-engine fixture table
(tests/assets/engine-cases/bounded-command.yml, loaded by Get-EngineCaseTable).

A command is bounded when its limit wraps all of it:
  - the POSIX engines: a leading GNU `timeout [options] <duration>` around ONE command — a compound command (&&, ||, ;, |, a
    background &, a newline) would leave everything after its first command unbounded. A backtick runs a command
    substitution, so its content belongs to the one command.
  - pwsh: ONE call to Invoke-WithTimeout, Assert-CompletesWithin or Test-CompletesWithin whose script block holds
    the work; the block may hold any number of statements, because the whole block is bounded. Without -Seconds the
    call takes its configured default, which is bounded too. & is the call operator (not a separator), a backtick
    escapes the next character, and '' is a quote inside a single-quoted string.
The verdict is one of: allow, no-limit, over-limit, compound.
```

## comment:2

Above `public static string Check(string command, string engine, int limitSeconds,...`, written with `//`.

```text
The verdict for a command in an engine (pwsh | bash | zsh) against a limit in seconds. requested describes what
the command asked for, for a log line.
```

## comment:3

Above `if (!IsSingleCommand(posix ? body : command, engine))`, written with `//`.

```text
a POSIX engine: the one command after the prefix; pwsh: the call itself at the top level (the block's own
statements are inside the limit, so they never count).
```

## comment:4

Above `public static bool TryParseBound(string command, string engine, out double?...`, written with `//`.

```text
Parses the engine's time-limit wrapper. bash: `timeout [options] <duration> <rest>`, with seconds the duration
and body the rest. pwsh: `Invoke-WithTimeout [params] { <body> } [params]`, with seconds the -Seconds value or
null for the configured default, and body the block's content. False when the command is not wrapped.
```

## comment:5

Above `public static bool IsSingleCommand(string text, string engine)`, written with `//`.

```text
True when the text is one command in the engine's grammar: no statement separator outside quotes and nested
expressions. The POSIX engines' separators: &&, ||, ;, |, a background &, newline (the & of 2>&1 or &> is a
redirection). pwsh separators: &&, ||, ;, |, newline (a single & is the call operator).
```

## comment:6

Above `private static bool IsPosix(string engine)`, written with `//`.

```text
True when the engine bounds a call with a GNU `timeout` prefix (the POSIX engines), false when with a pwsh wrapper call.
The engine and its time safeguard come from the model, declared once
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](/docs/drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce)); Get throws, naming the
engines, for any other name.
```
