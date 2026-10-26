# pwsh/Base.Execution/types/ExecutableProbe.cs

One executable's existence check, as `Find-Executable` records it: where the executable was found and how, the version it reports against
the required one, how long each step took, and the session actor the check ran as. `Resolve-ToolExecutable` returns one for a `tools.yml`
entry, and so does `Test-Tool -PassThru`.

## Validation

Constructing an instance validates it: `Name` is required, `Method` is one of `probe`, `path` or `none`, and a found executable carries a
path while a missing one carries none.

## Version fields

`Version` is the version the executable reports, parsed by the version pattern, and null when nothing was found or the output does not
match. `VersionMs` is the milliseconds spent running the version command; it is 0 when nothing was found, or when the version came from the
session cache and no process was started.
