# docs/references/automation/catzc-base-qualitygates/private/Select-RuleTaggedFiles.ps1.md

`automation/Catzc.Base.QualityGates/private/Select-RuleTaggedFiles.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Test-Automation's `-Rule` provenance filter narrows the run to the files that actually enforce a rule.
Given the discovery pass (all tests, any tier) and the wanted citations, this returns the files in
which at least one test resolves one of those citations (Get-TestRuleTags, the same union used for
coverage). The worker additionally filters within a file by include tag, so a file mixing matched and
other tests runs only the matched ones; this just keeps whole non-matching files off the work-list.
```
