# pwsh/Base.Docs/private/Get-RuleEnforcers.ps1

The private enforcer index of `Show-Catzc` and the glossary enforcement check: for each rule citation it lists the analyzer rules and the
tests that enforce it.

## Test enforcers

The test enforcers are the `-Tag` citations of Describe, Context and It, read by AST so a citation-shaped string in a fixture is never
mistaken for a real tag. The cache entry is read with the strict-clean probe
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## help

### synopsis

Maps each rule code to what mechanically enforces it — analyzer rules and tagged tests — for Show-Catzc.

### description

Returns a hashtable keyed by rule citation in the '#' form (e.g. 'ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS'), each value an object with two
sorted sets: Analyzers (the PSScriptAnalyzer rules mapped to it in analyzer-drs-map.yml) and Tests (the repo-relative test files that cite
it). Both sources run inside Test-Automation, so together they are what the rule-coverage report counts — this is the interactive, offline
view of the same fact.

The test citations are read by PARSING each test file's AST and taking only the `-Tag` arguments of Describe/Context/It — never a text scan,
which would false-match a citation-shaped string in a fixture or an assertion. The analyzer map is read through Get-Config (a global config
read; owned by the QualityGates module but reachable from anywhere —
[ADR-CONF-LOADING-READINGISGLOBAL](../../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-readingisglobal) — so no
module dependency on it is taken). A pure function of the files on disk, memoized for the session (re-run the importer to refresh). It reads
the source tree's tests, so it runs in source mode only (Assert-SourceTree).

Private helper for Show-Catzc; not exported.

### outputs

`[hashtable]` citation ('#' form) -> `[pscustomobject]{` Analyzers; Tests } (both sorted sets, possibly empty).
