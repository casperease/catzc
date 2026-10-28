# pwsh/Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1

<!-- cspell:ignore toolong gmweufxosmplst alweufxosmplst -->

The L0 tests of the command that writes a template's per-slot config.

## L0, but slow without care

These are L0 logic tests: the config and discovery are mocked, and nothing launches an external tool, so they are not L2 and should not be.
They were merely slow for an L0 tier, because the original `BeforeEach` gave every test a fresh root directory. Discovery keys its session
cache on the root, so a new root per test was a guaranteed cache miss: a full eight-template re-discovery on every test, triggered at
parameter binding (`[ValidateScript]` on `-Template` runs `Get-BicepTemplateNames`) before the body ran. That cold discovery costs about 1 s
here, because Pester's mock interception of `Get-BicepTemplatesRoot` inflates it about six times (165 ms unmocked).

Both contexts therefore share one copy and one discovery in `BeforeAll`, which keeps the cache warm:

- the validation and read-only tests never mutate the tree;
- the write tests each target a distinct config path (`sample/gamma`, `sample/delta`, `sample/alpha`, `sample-customer/acme/alpha`), so the
  shared tree never causes interference and the order of the tests does not matter.

## Root and mocks

The tool and config boundary is mocked once for the whole block. `Get-BicepTemplatesRoot` reads the current `$script:templatesRoot` at call
time, so each context just repoints that variable.

The root is a fresh, unique directory under `$TestDrive`, which Pester cleans. A unique directory is never re-deleted mid-run, so it cannot
race a file scanner, on-access antivirus or the search indexer, that holds a just-copied file open and intermittently throws "used by
another process". Scratch lives in temp, not `out/`
([ADR-REPO-OUTDIR-TEMPFORSCRATCH](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-tempforscratch)).
`Copy-Directory`, raw `[System.IO]`, is about 15 times faster per tree than `Copy-Item -Recurse` here.

## Caches

The caches are cleared once, so discovery re-derives against the fresh copy, and then warmed in `BeforeAll` and not on the first test. An
unwarmed cache makes the first `It` pay a full cold discovery at parameter binding, about six times inflated under mock interception, and
warming in setup keeps that off the L0 tier. The write tests target distinct config paths and never invalidate the templates cache, which is
session-scoped ([ADR-AUTO-CACHE-IMPORTERINVALIDATES](../../../../drs/automation/caching.md#rule-adr-auto-cache-importerinvalidates)), so one
warm-up serves every test ([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
