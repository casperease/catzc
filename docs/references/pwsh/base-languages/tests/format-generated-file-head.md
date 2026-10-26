# pwsh/Base.Languages/tests/Format-GeneratedFileHead.Tests.ps1

The logic tests of `Format-GeneratedFileHead`.

## Tracked or not

Whether git tracks the path decides whether the head carries the body hash: a tracked path comes back from the index read, an untracked one
does not. A fixture stands for the index here.

## Quoting

The block renderer quotes a value YAML would not read back as the same string, so a hash that opens with a digit is quoted.
