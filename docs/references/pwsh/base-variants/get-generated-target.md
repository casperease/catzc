# pwsh/Base.Variants/Get-GeneratedTarget.ps1

The registry of generated files: it gathers, from the configs that declare them, every file a generator of this repository writes and the
command that writes it, so a check can tell a generated file from an authored one without a list of its own.

## help

### synopsis

Lists every file a generator of this repository writes, with the command that writes it.

### description

The targets come from the registries that declare them: the opted-in root configs of rootconfig.yml, the READMEs readme.yml names, and every
other generator's targets as its module's generated.yml declares them.

### outputs

`[Catzc.Base.Variants.GeneratedTarget]` one per target: its path or glob and its generator.

## Sources

- **Root configs** — each opted-in `rootconfig.yml` target, by its generator. A target copied from its source asset names no generator of
  its own; `Build-RootConfig` is what writes it.
- **READMEs** — the files `readme.yml` names.
- **Every other generator** — the targets its module's `generated.yml` declares.
