---
catzc:
  immutable:
    with_body_sha: "611dcf22acee"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Export-SpellingTriage.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: export-spelling-triage-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Export-SpellingTriage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``$script:cspellOut = @('mango', 'banana', 'Apple', 'kiwi') -join "`n"``, written with `#`.

```text
Build the newline-delimited output by joining real words, so the test's own source carries no
coined tokens for Test-Spelling to flag. Apple/mango are 'known' via the mocked registry below.
```

## comment:2

Above `$raw | Should -Match "meaning: ''"`, written with `#`.

```text
The stub carries a blank meaning and no category, so a copy-paste into terminology.yml fails to load
(category is required) until a human classifies it.
```
