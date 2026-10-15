---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/private/ConvertFrom-BatsJunit.ps1.md
    kind: reference
    body_sha: "0944a4368f15"
    adrs: []
---

# automation/Catzc.Base.Languages/private/ConvertFrom-BatsJunit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads every <testcase> of the report bats writes with --report-formatter junit. Its classname is the .bats file's
path inside the test folder bats ran ('/'-separated: repository.bats, or nested/widget.bats) and its name the
@test name:

  outcome   fail when the case has a <failure> or <error>; skip when it has <skipped>; pass otherwise;
  duration  the case's time;
  output    the failure, error or skip text (bats folds the test's output into it), and any system-out or
            system-err.

Results come in report order. A case outside any .bats file (a classname that is no .bats path) is not a test
result: the call throws with its text, as Invoke-GoTest throws when a package fails outside any test.
```
