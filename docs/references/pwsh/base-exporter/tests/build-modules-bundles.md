# pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$probe = {`, written with `#`.

```text
The rule for the function called per module: the module must be loaded in the fresh session (else the row is failed); then the
first of at most five exported Get- functions with all-optional parameters, in name order, that runs without throwing is
called and the row is ok. A function that throws needs a live service or the source tree (az context, VS Code, the
repository's modules folder), so it is not a load defect; a module where none of those succeeds is logged skipped with the
first error, and a module with no such function is logged skipped.
```

## comment:2

Above `$bundleRegistry = (Get-Config -Config exporter).bundles`, written with `#`.

```text
The registry is read at discovery, so a bundle added to exporter.yml is covered without an edit here.
Every bundle is built, self-checked and loaded in a fresh session for real.
```
