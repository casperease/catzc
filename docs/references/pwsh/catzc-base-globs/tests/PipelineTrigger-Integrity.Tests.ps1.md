# pwsh/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ADO pipeline trigger globs match the globset projection' -Tag 'L2',...`, written with `#`.

```text
Integrity: every pipeline-bound globset's ADO pipeline (and the GitHub CI workflow) declares the trigger
path filters its projection computes — the drift quality gates over THIS repo's real pipeline files
([FDR-CD-GLOBS-NAMEDGLOBSETS](/docs/adr/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets)).
A source-path filter hand-edited out of sync with globs.yml fails here.
```
