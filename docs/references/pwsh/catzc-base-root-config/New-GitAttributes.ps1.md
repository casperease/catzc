# pwsh/Base.RootConfig/New-GitAttributes.ps1

The generator of the repository-root `.gitattributes`: it renders the content from the file-kinds registry and writes nothing.

## help

### synopsis

Renders the repository-root .gitattributes content from the file-kinds registry — the generator behind the managed .gitattributes target.

### description

Reads the template (assets/root/.gitattributes-template, not named .gitattributes, since git would apply a file of that name to the
templates beside it) and replaces its one `{{file-kind-attributes}}` line with a block per file-kinds entry that declares `gitAttributes`
(configs/file-kinds.yml of Catzc.Base.Globs, via Get-Config -Config file-kinds; each kind's subkinds first, then the kind): a `# catzc:`
comment wrapping the entry's `gitWhy` to the line width, then one `<glob> <attributes>` line per file glob of the entry. After the kinds,
one block per track whose track type declares `gitAttributes` (configs/track-types.yml of Catzc.Base.Variants): the type's `gitWhy`, then
one `<place>/** <attributes>` line per place of the track. A template that holds the placeholder line zero or several times throws.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config registry names for the
.gitattributes target, and Build-RootConfig owns the write (through the same idempotent Write-FileIfChanged path as every managed file; see
[ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md)).

### outputs

`[string]` The rendered .gitattributes content (LF-joined; the writer canonicalises).
