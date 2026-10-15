# docs/references/automation/catzc-base-repository/Assert-SourceTree.ps1.md

`automation/Catzc.Base.Repository/Assert-SourceTree.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A guard for tools that operate on the catzc source repository by definition — lint and format quality gates,
dependency analysis over the per-function files, test discovery, and authoring steps that write back into
automation/. In build mode
([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)) those files are not where the loaded code lives, so the tool
stops with a named error instead of silently reading or writing the wrong tree. Silent in source mode.
```
