---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Export-SpellingTriage.Tests.ps1.md
    kind: test-asset
    body_sha: "4b1427de892f"
---

# automation/Catzc.Base.QualityGates/tests/Export-SpellingTriage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above ``$script:cspellOut = @('mango', 'banana', 'Apple', 'kiwi') -join "`n"``.

```text
Build the newline-delimited output by joining real words, so the test's own source carries no
coined tokens for Test-Spelling to flag. Apple/mango are 'known' via the mocked registry below.
```

## comment:2

Above `$raw | Should -Match "meaning: ''"`.

```text
The stub carries a blank meaning and no category, so a copy-paste into terminology.yml fails to load
(category is required) until a human classifies it.
```
