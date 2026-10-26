# pwsh/Base.Engines/types/ExecutionEngines.cs

The static home of the repository's execution engines: exactly three, pwsh, bash and zsh, declared once
([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md)).

## Names

Every list of engines in the codebase, such as config keys per shell, per-engine fixture columns or an engine argument's allowed values, is
`Names`. Adding or changing an engine is one edit here.

## zsh

zsh is the third engine, the default login shell on macOS, located through its `tools.yml` entry. It shares bash's POSIX quoting and its
importer entry, `importer.sh`, which runs under both.
