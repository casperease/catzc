---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Show-Cats.ps1.md
    kind: reference
    body_sha: "2c1742c3a519"
    adrs: []
---

# automation/Catzc.Base.Docs/Show-Cats.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
"Ask cats": surfaces what the catzc system can do from what the repository already knows, offline and
deterministically (no network, no LLM). With no argument it prints the overview of what you can ask; an
area narrows it:

  Show-Cats adr [query]     the ADR codes and titles; with a query, the matching ADRs and their rules
  Show-Cats module [name]   the modules; with a name substring, the public functions they export
  Show-Cats verbs           the approved verbs in use across the tree

Output is presentation only (the information stream,
[ADR-AUTO-CONSOLE](/docs/adr/automation/console-output-matters.md));
the function returns nothing. Live bicep templates are out of scope here — use Get-BicepTemplates. The ADR
reads are memoized for the session by the private getters
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md)); the module and
verb areas read the loaded modules' exports, so they answer the same in source mode and build mode.
```

## comment:2

Section `.PARAMETER Query` of the comment-based help.

```text
Narrows the area: an ADR code/title substring for 'adr', a module-name substring for 'module'. Ignored by
'verbs' and the overview.
```

## comment:3

Above `$entries = Get-CatsAdrIndex`.

```text
Plain assignment (not @(...)): the getter returns a comma-wrapped array
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md) exemplar),
which assignment receives intact — wrapping it again in @() would nest it one level too deep.
```

## comment:4

Above `$entryEnforcers = $enforcers[($rule.Id -replace ':', '#')]`.

```text
Show what mechanically enforces this rule (tests + analyzer rules), if anything —
the citation is the '#' form of the registry id ([index](/docs/adr/index.md)).
```
