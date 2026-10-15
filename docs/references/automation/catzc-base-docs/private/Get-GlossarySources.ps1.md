# docs/references/automation/catzc-base-docs/private/Get-GlossarySources.ps1.md

`automation/Catzc.Base.Docs/private/Get-GlossarySources.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A module opts into the controlled vocabulary by shipping configs/glossary.yml
([ADR-REPO-VOCAB#2](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab2)), so the
sources are discovered, not declared: Get-Config -Config glossary -ListOwners lists every owner, and each
source is read through Get-Config -Config glossary -Module <owner>, so the GlossaryConfig type validates its
shape on load ([ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1)/2). One
git query then records whether each source file is tracked: a
source lives in the repository
([ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)), and
Get-GlossarySourceViolations reports one that is not.

Reads the source tree's configs and git, so it runs in source mode only (Assert-SourceTree). Private helper
for Get-Glossary and the glossary checks; not exported.
```
