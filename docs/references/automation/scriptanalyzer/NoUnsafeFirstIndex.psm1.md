---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoUnsafeFirstIndex.psm1.md
    kind: comment-page
    body_sha: ab63c54bd69b
    adrs:
      - ADR-PWSH-ERROR#8
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoUnsafeFirstIndex.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
`@(<pipeline or call>)[0]` and `(<a | b>)[0]` read the first element of a result that may be empty. Under strict
mode an index past the end throws ("Index was outside the bounds of the array"), so an empty result never
reaches the `$null` check or assert written right after it — the caller gets an engine error instead of the
intended message. `<result> | Select-Object -First 1` is `$null` on an empty result and the same element
otherwise. See [ADR-PWSH-ERROR#8](/docs/adr/pwsh/error-handling.md#rule-adr-pwsh-error8).

Flagged: index `[0]` whose target is an array subexpression `@(…)`, or a parenthesised pipeline of two or
more elements. Not flagged: an index on a variable or member (`$list[0]`, `$Matches[0]`), whose length the
surrounding code owns, and `(… -split …)[0]`, which always yields at least one element.
```

## comment:2

Above `$isFirstIndex = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
