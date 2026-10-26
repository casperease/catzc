# pwsh/Base.RootConfig/private/Get-RootConfigCopyContent.ps1

The composer of a `source` target: it returns the template's content under the generated-file head.

## help

### synopsis

Composes a managed root file from its template: the template's content under the generated-file head.

### description

The one composition of a `source` entry of rootconfig.yml
([ADR-REPO-ROOTCFG-HEADEDCOPY](../../../../drs/repository/generated-root-configs.md#rule-adr-repo-rootcfg-headedcopy)): it reads the
template as LF and writes the generated-file head that carries the one warning, in the carrier the entry names. Build-RootConfig writes what
it returns, and Test-RootConfigFiles compares the root file with it, so the writer and the gate can never disagree on what a copy is.

### parameter `Entry`

The root-config entry: its `target`, `source` and `carrier`.

### parameter `SourcePath`

The full path of the template, resolved by the caller against the repository root it works in.

### outputs

`[string]` The root file's content, head and template, with LF line endings.

### example 1

```powershell
Get-RootConfigCopyContent -Entry $entry -SourcePath (Resolve-RepoPath $entry.source)
```
