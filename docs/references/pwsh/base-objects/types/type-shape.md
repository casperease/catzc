# pwsh/Base.Objects/types/TypeShape.cs

The reflected properties of a type, read once.

## Cache

The table is keyed by `Type` and filled on first use. A loaded type cannot change in a process (ADR-PWSH-TYPES-RESTARTTORELOAD), so an entry
cannot go stale, and it is not a session cache of the file set (ADR-AUTO-CACHE).

## Data properties

A data property is one the derived record declares, not `DictionaryRecord`'s own view members (`Keys`, the indexer). Excluding them is also
what stops `Keys` and `ToHashtable` from recursing into `get_Keys()` forever.

## Hidden

PowerShell's `[Hidden]` is matched by name so this file stays BCL only: the Bash time-safeguard hook compiles it, through
`DictionaryRecord`, into a program that does not reference `System.Management.Automation`.
