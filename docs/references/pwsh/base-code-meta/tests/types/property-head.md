# pwsh/Base.CodeMeta/tests/types/PropertyHead.Tests.ps1

The logic tests of `PropertyHead`: the meta property is imprinted, replaced and removed on short JSON and MSBuild texts, and the proofs are
the byte-identical second run and the text that comes back untouched when it is not a carrier.

## Line ends in the fixtures

A `~` in a single-quoted JSON fixture stands for a real line end, which `Get-Lines` swaps in. A JSON `\n` escape therefore stays a backslash
and an `n` instead of turning into a line break.
