---
catzc:
  immutable:
    with_body_sha: c1e0f8f84b93
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/private/Get-CatsRuleEnforcers.ps1.md
    folder: docs/references/automation/catzc-base-docs/private
    name: get-cats-rule-enforcers-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/private/Get-CatsRuleEnforcers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps each ADR rule citation to what mechanically enforces it — analyzer rules and tagged tests — for
Show-Cats.

### description

Returns a hashtable keyed by rule citation in the '#' form (e.g. 'ADR-AUTO-NOPWD#1'), each value an object with
two sorted sets: Analyzers (the PSScriptAnalyzer rules mapped to it in analyzer-adr-map.yml) and Tests (the
repo-relative test files that cite it). Both sources run inside Test-Automation, so together they are what
the rule-coverage report counts — this is the interactive, offline view of the same fact.

The test citations are read by PARSING each test file's AST and taking only the `-Tag` arguments of
Describe/Context/It — never a text scan, which would false-match a citation-shaped string in a fixture or
an assertion. The analyzer map is read through Get-Config (a global config read; owned by the QualityGates
module but reachable from anywhere —
[ADR-CONF-LOADING#6](../../../../adr/configuration/module-config-loading.md#rule-adr-conf-loading6) — so no module
dependency on it is taken). A pure
function of the files on disk, memoized for the session (re-run the importer to refresh). It reads the
source tree's tests, so it runs in source mode only (Assert-SourceTree).

Private helper for Show-Cats; not exported.

### outputs

`[hashtable]` citation ('#' form) -> `[pscustomobject]{` Analyzers; Tests } (both sorted sets, possibly empty).

## comment:1

Above `$cached =...`, written with `#`.

```text
strict-clean
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$isCommand = { param($node) $node -is...`, written with `#`.

```text
Test enforcers — the `-Tag` citations of Describe/Context/It, read by AST so a citation-shaped fixture
string is never mistaken for a real tag.
```
