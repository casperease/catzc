# pwsh/Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1

The tests of `Format-MarkdownTitle` over a widget and gadget fixture tree, with `Get-MarkdownScope` mocked. The mock filters on the bound
parameters, not on `$Path`. An unbound `-Path` resolves `$Path` from a caller's scope (the test runner's own `$Path`), which would send the
engine's whole-scope call to the narrowed mock too.
