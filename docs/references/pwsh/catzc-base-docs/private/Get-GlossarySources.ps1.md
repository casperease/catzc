# pwsh/Base.Docs/private/Get-GlossarySources.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists every glossary source — each opting-in module's configs/glossary.yml — with its validated config.

### description

A module opts into the controlled vocabulary by shipping configs/glossary.yml
([ADR-REPO-VOCAB-GLOSSARYSOURCE](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-glossarysource)), so the sources
are discovered, not declared: Get-Config -Config glossary -ListOwners lists every owner, and each source is read through Get-Config -Config
glossary -Module `<owner>`, so the GlossaryConfig type validates its shape on load
([ADR-CONF-LOADING-ONEREADER](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-onereader)/2). One git query then
records whether each source file is tracked: a source lives in the repository
([ADR-REPO-VOCAB-SOURCESINREPOSITORY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)), and
Get-GlossarySourceViolations reports one that is not.

Reads the source tree's configs and git, so it runs in source mode only (Assert-SourceTree). Private helper for Get-Glossary and the
glossary checks; not exported.

### outputs

`[pscustomobject]` One { Owner; Path; Config; Tracked } per source, sorted by owner (ordinal): Path is repo-relative, Config the source's
Catzc.Base.Docs.GlossaryConfig, Tracked whether git tracks Path. Nothing when no module ships a glossary.

### example 1

```powershell
Get-GlossarySources | Format-Table Owner, Path, Tracked
```
