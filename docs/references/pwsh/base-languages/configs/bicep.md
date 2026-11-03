# pwsh/Base.Languages/configs/bicep.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

At the end of the file, written with `#`.

```text
The Bicep module registry comes from package_source (the public registry, mcr.microsoft.com/bicep, when it is left out).
The linter settings come from analyzers (the core analyzer, enabled and not verbose, when it is left out).
```

## comment:2

At the end of the file, written with `#`.

```text
The Bicep module registry comes from package_source (the public registry, mcr.microsoft.com/bicep, when it is left out).
The linter settings come from analyzers (the core analyzer, enabled and not verbose, when it is left out).
```
