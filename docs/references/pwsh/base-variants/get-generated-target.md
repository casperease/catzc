# pwsh/Base.Variants/Get-GeneratedTarget.ps1

The registry of generated files: it gathers, from the configs that declare them, every file a generator of this repository writes and the
command that writes it, so a check can tell a generated file from an authored one without a list of its own.

## help

### synopsis

Lists every file a generator of this repository writes, with the command that writes it.

### description

The targets come from the one writer registry, the rows of every module's generated.yml
([ADR-REPO-ROOTCFG-ONECLASSPERWRITER](../../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-oneclassperwriter)). A row
answers its own outputs, unless it expands its instances from a config, which then answers them: the opted-in root configs of
rootconfig.yml, the READMEs readme.yml names. Each target carries the class of the row it answers from.

### outputs

`[Catzc.Base.Variants.GeneratedTarget]` one per target: its path or glob, its generator and its writer's class.

## Sources

- **A writer row** — the outputs it declares, in its class.
- **rootconfig** — each opted-in `rootconfig.yml` target, by its generator. A target copied from its source asset names no generator of its
  own; `Build-RootConfig` is what writes it. A generator with a row of its own (`New-GitAttributes`) gives its target that row's class, and
  the config still answers its path, once.
- **readme** — the files `readme.yml` names, by the row that expands it.
- **comment-pages** — no target, since a comment page is authored.
- Any other `expands` value throws, naming the writer.

## comment:1

Above `$rows = @(foreach ($owner in @(Get-Config -Config generated -ListOwners)) {`, written with `#`.

```text
Every writer row, each declared once in its module's generated.yml.
```
