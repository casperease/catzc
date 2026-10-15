---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/private/ConvertFrom-GoTestJson.ps1.md
    kind: reference
    body_sha: "8fa6ab143e47"
    adrs: []
---

# automation/Catzc.Base.Languages/private/ConvertFrom-GoTestJson.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the stream line by line; each line is one JSON event with an Action:

  run, pause, cont, start, bench   progress only;
  output                           a printed line, joined to its test (or to its package when it has no Test);
  pass, fail, skip                 a test's outcome and Elapsed seconds (or the package's, when it has no Test);
  build-output, build-fail         the compiler's output and verdict for a package that did not build.

A subtest (Test 'TestWidget/case') folds into its top-level test: its output joins the parent's in event
order, and go itself fails the parent when a subtest fails. A test that started but never reached an outcome
(the test binary crashed) is a failure. Results come in the order the tests first ran.

Throws, with the collected output, when a package failed to build (a build-fail event, or a package result
naming FailedBuild) or failed outside any test (a failing package with no failing test: TestMain, an init, or
a setup failure), and on a line that is not a JSON event.
```
