# pwsh/Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1

<!-- cspell:ignore toolong gmweutstsmplst alweutstsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Set-BicepTemplateConfiguration'`, written with `#`.

```text
These are L0 'logic' tests (mocked config/discovery, no real az/cspell) — they are NOT L2 and should not
be: nothing here launches an external tool. They were merely SLOW for an L0 tier, because the original
BeforeEach gave EVERY test a fresh root ([Guid] dir). Discovery keys its session cache on the root, so a
new root per test was a guaranteed cache miss — a full 8-template re-discovery every test, triggered at
parameter binding ([ValidateScript] on -Template runs Get-BicepTemplateNames) before the body ever runs.
That cold discovery costs ~1s here because Pester's Mock interception of Get-BicepTemplatesRoot inflates it
~6x (165ms unmocked -> ~1s mocked). Both contexts now share ONE copy + ONE discovery (BeforeAll), keeping
the cache warm:
  - 'validation and read-only' tests never mutate the tree.
  - 'writes' tests each target a DISTINCT config path, so the shared tree never causes interference.
```

## comment:2

Above `Mock Get-BicepTemplatesRoot { $script:templatesRoot } -ModuleName...`, written with `#`.

```text
The tool/config boundary is mocked once for the whole block — Get-BicepTemplatesRoot reads the
current $script:templatesRoot at call time, so each context just repoints that variable.
```

## comment:3

Above `$script:templatesRoot = Join-Path $TestDrive ([Guid]::NewGuid())`, written with `#`.

```text
FRESH, UNIQUE root under $TestDrive (Pester auto-cleans it): a unique dir is never re-deleted
mid-run, so it can't race a concurrent file scanner (on-access AV / the search indexer) holding
a just-copied file open and intermittently throwing "used by another process". Scratch lives in
temp, not out/
([ADR-REPO-OUTDIR-TEMPFORSCRATCH](/docs/drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-tempforscratch)).
Copy-Directory (raw [System.IO]) instead of Copy-Item -Recurse: ~15x faster per tree here.
```

## comment:4

Above `InModuleScope Catzc.Base.Config { $script:configCache = $null }`, written with `#`.

```text
Clear the caches ONCE so discovery re-derives against the fresh copy, then WARM them here in
BeforeAll — not on the first test. The -Template [ValidateScript] runs Get-BicepTemplateNames
(-> Get-BicepTemplates) at parameter binding, so an unwarmed cache makes the first It pay a
full cold discovery (~6x inflated under Mock interception); warming here keeps that off the L0
gate. These tests never mutate the tree, so the cache stays valid for all of them
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
```

## comment:5

Above `BeforeAll {` (occurrence 3), written with `#`.

```text
Each test writes to a DISTINCT path (sample/gamma, sample/delta, sample/alpha,
sample-customer/acme/alpha), so a single shared writable copy never causes interference and the
order of the tests does not matter. One copy + ONE discovery (BeforeAll) keeps the discovery
cache warm — a fresh per-test root would defeat the cache and pay a full cold re-discovery every
test (discovery is filesystem-bound — see Get-BicepTemplates). See the read-only BeforeAll for
the unique-dir / AV-race rationale.
```

## comment:6

Above `InModuleScope Catzc.Base.Config { $script:configCache = $null }` (occurrence 2), written with `#`.

```text
Clear the caches ONCE so discovery re-derives against the fresh copy, then WARM them here so the
first It in this context does not pay the cold parameter-binding discovery (see the read-only
context's BeforeAll). Writes target distinct config paths and never invalidate the templates
cache (session-scoped, [ADR-AUTO-CACHE-IMPORTERINVALIDATES](/docs/drs/automation/caching.md#rule-adr-auto-cache-importerinvalidates)), so one
warm-up serves every test.
```
