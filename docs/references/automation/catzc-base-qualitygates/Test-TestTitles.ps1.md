# docs/references/automation/catzc-base-qualitygates/Test-TestTitles.ps1.md

`automation/Catzc.Base.QualityGates/Test-TestTitles.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the titles of
every It, Describe, and Context in the test files (except the vendored ones). Pester treats an angle-bracket word
in a title as its name template and expands it as a variable in the test's scope. With -ForEach or -TestCases data
that is the intended feature; without data the token is almost always prose (a placeholder path), which expands
to empty in a non-strict scope and THROWS in a strict one — and the tests run strict
([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)), so such a title fails its file at
name expansion, far from the cause. Each such title is an issue: rephrase it, or add -ForEach data.

The title is a block's first string argument (single- or double-quoted). A file that does not parse is another
gate's problem and is skipped. It parses the repository's test files, which exist only in the source tree
(Assert-SourceTree).
```
