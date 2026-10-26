# pwsh/Base.Execution/types/CliResult.cs

The captured result of running an external command: stdout and stderr kept separate, plus convenience views derived from them.

## Consistency

The constructor owns the derivation, so the result can never be in an inconsistent state: the views always agree with `Output` and `Errors`.

## Bytes

`Bytes` holds the exact stdout bytes of a binary run (`Invoke-Executable -AsBytes`). It is null for a text run, whose stdout is `Output`,
and a binary run's `Output` is empty, since its stdout is not text.
