# pwsh/Base.Timeouts/types/BoundedCommand.cs

The check of whether a command line runs inside a time limit, in each execution engine's grammar. It is the check behind the Bash hook's
background rule (`BashSafeguard`) and the per-engine fixture table (`tests/assets/engine-cases/bounded-command.yml`, loaded by
`Get-EngineCaseTable`).

## When a command is bounded

A command is bounded when its limit wraps all of it:

- **The POSIX engines:** a leading GNU `timeout [options] <duration>` around one command. A compound command (`&&`, `||`, `;`, `|`, a
  background `&`, a newline) would leave everything after its first command unbounded. A backtick runs a command substitution, so its content
  belongs to the one command.
- **pwsh:** one call to `Invoke-WithTimeout`, `Assert-CompletesWithin` or `Test-CompletesWithin` whose script block holds the work. The block
  may hold any number of statements, because the whole block is bounded. Without `-Seconds` the call takes its configured default, which is
  bounded too. `&` is the call operator (not a separator), a backtick escapes the next character, and `''` is a quote inside a single-quoted
  string.

The verdict is one of: `allow`, `no-limit`, `over-limit`, `compound`.

## The members

- `Check` gives the verdict for a command in an engine (`pwsh`, `bash`, `zsh`) against a limit in seconds; `requested` describes what the
  command asked for, for a log line. In it, a POSIX engine's one command is the command after the prefix, and pwsh's is the call itself at the
  top level (the block's own statements are inside the limit, so they never count).
- `TryParseBound` parses the engine's time-limit wrapper. bash: `timeout [options] <duration> <rest>`, with seconds the duration and body the
  rest. pwsh: `Invoke-WithTimeout [params] { <body> } [params]`, with seconds the `-Seconds` value or null for the configured default, and body
  the block's content. It returns false when the command is not wrapped.
- `IsSingleCommand` is true when the text is one command in the engine's grammar: no statement separator outside quotes and nested
  expressions. The POSIX engines' separators are `&&`, `||`, `;`, `|`, a background `&` and a newline (the `&` of `2>&1` or `&>` is a
  redirection). pwsh's are `&&`, `||`, `;`, `|` and a newline (a single `&` is the call operator).
- `IsPosix` is true when the engine bounds a call with a GNU `timeout` prefix, false when with a pwsh wrapper call. The engine and its time
  safeguard come from the model, declared once
  ([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce)); `Get`
  throws, naming the engines, for any other name.
