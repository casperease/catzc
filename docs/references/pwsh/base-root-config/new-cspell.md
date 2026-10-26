# pwsh/Base.RootConfig/New-Cspell.ps1

The generator of the repository-root `cspell.yml`: a pure renderer that fills a template with the `third-party` glob set and writes nothing.

## help

### synopsis

Renders the repository-root cspell.yml content from its template and the `third-party` glob set — the generator behind the managed
cspell.yml target.

### description

Reads the template (assets/root/cspell-template.yml, not named cspell.yml, since cspell would take a file of that name beside it for a
config) and replaces its one `- "{{third-party}}"` placeholder line with a comment and one quoted ignore path per include of the
`third-party` glob set (configs/globs/globs.yml of Catzc.Base.Globs, via Get-GlobSet): the files vendored or downloaded and never authored
here, so the spelling quality gate skips exactly what that one declaration names. A template that holds the placeholder line zero or several
times throws, and so does a glob set that carries an exclude or a compose entry, since ignorePaths has no way to say it.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config registry names for the cspell.yml
target, and Build-RootConfig owns the write (through the same idempotent Write-FileIfChanged path as every managed file; see
[ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md)).

### parameter `TemplatePath`

The template to fill. Default: assets/root/cspell-template.yml of this module.

### outputs

`[string]` The rendered cspell.yml content (LF-joined; the writer canonicalises).
