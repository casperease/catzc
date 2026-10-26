# pwsh/Azure.Templates/tests/BicepParams.Fixture.ps1

The shared test fixture that supplies stand-ins for `bicep build-params` in L0 tests that mock `Invoke-AzCli`. Both stand-ins throw on any
line they do not know, naming it, and never guess. The real compile is proven at L2.

## The literal-only stand-in

`compileBicepParams` reads `param <name> = <literal>` lines, where the literal is a single-quoted string, an integer, `true`, `false` or
`null`, and writes the ARM parameters JSON.

## The strict stand-in

`readBicepParams` reads exactly the forms `BicepParamWriter` writes: a one-line literal, a multi-line `[ ]` or `{ }` block of those
literals, and `az.getSecret` on one line or with one argument per line. It writes the ARM parameters JSON.
