# pwsh/Base.CodeMeta/tests/types/CodeMetaHead.Tests.ps1

The logic tests of `CodeMetaHead` over short widget and gadget texts: a head is rendered, imprinted, replaced and removed on strings, and
the proofs are the byte-identical second run and the lossless removal.

## Agreement with the types hash

The types hash strips the head before the types load, so it cannot call `CodeMetaHead`. The last block therefore proves that the two read
every real C# type the same way.
