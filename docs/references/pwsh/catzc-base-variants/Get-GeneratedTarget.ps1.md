# pwsh/Base.Variants/Get-GeneratedTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every file a generator of this repository writes, with the command that writes it.

### description

The targets come from the registries that declare them: the opted-in root configs of rootconfig.yml, the READMEs readme.yml names, the
comment-page roots, and every other generator's targets as its module's generated.yml declares them.

### outputs

`[Catzc.Base.Variants.GeneratedTarget]` one per target: its path or glob and its generator.

## comment:1

Above `foreach ($file in (Get-Config -Config rootconfig).files.Where({ $_.optIn })) {`, written with `#`.

```text
The root configs this repository renders: each opted-in rootconfig.yml target, by its generator; a target copied from its source
asset has none of its own, and Build-RootConfig is what writes it.
```

## comment:2

Above `$pageRoots =...`, written with `#`.

```text
The comment pages Format-Code's comment imprint writes: one tree per page root comment-pages.yml declares, a `{kebab}` root one
folder per module. The pages are the tool's, so they are generated like the READMEs (the user, 2026-10-25).
```
