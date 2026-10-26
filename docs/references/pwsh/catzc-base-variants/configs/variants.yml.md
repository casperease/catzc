# pwsh/Base.Variants/configs/variants.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ado_naming: standard`, written with `#`.

```text
Repo-wide variants — settings fixed for the importer session (see [ADR-REPO-VARIANT](/docs/drs/repository/repo-variants.md)).
A growing dictionary of repo-wide switches: edit a value and re-run the importer to apply it. Read only
through the module's Test-/Assert-/Get- primitives; loaded by Get-Config -Config variants and validated
by the VariantsConfig type.
```

## comment:2

Above `ado_naming: standard`, written with `#`.

```text
Azure resource-name component order — the segment order every generated resource name uses.
standard | classic (the keys of Get-AzureNameOrderSet). See [ADR-AZ-NAMING](/docs/drs/azure/azure-naming-standard.md).
Changing this re-spells every resource name, so every typed name in each template's configuration must
be re-edited to match — deliberately not a casual flip.
```

## comment:3

Above `git_workspace: main-direct`, written with `#`.

```text
Git workspace mode — how changes reach main:
  main-direct   — direct commits to main are allowed (the default; a solo-author trunk)
  main-via-pr   — everything reaches main through a PR; local work always happens on a branch, so the
                  only forbidden direct commit is one made while standing on main locally
Automation that commits (e.g. Sync-GeneratedFile syncing .compiled) enforces exactly that
stop condition: main-via-pr AND currently on main. Going 1 -> 1+ authors is when to flip this.
```

## comment:4

Above `have_customers: all`, written with `#`.

```text
Enabled-customer set for the repo:
  false            — no customer deployments; only non-customer templates allowed (the default for a
                     customer-free repo)
  all              — every customer defined in customer.yml is enabled
  [acme, globex]   — only these named customers are enabled
See [ADR-AZ-CUSTOMER](/docs/drs/azure/azure-customer-model.md). customer.yml is the catalogue of who the customers are; this
variant is which of them this repo actually deploys for. This repo ships customer templates (e.g. the
per-customer foundation), so it enables all of them; a repo with no customer templates leaves this false.
```

## comment:5

Above `aspects:`, written with `#`.

```text
Aspects ([DDR-ASPECT](/docs/drs/design/module-aspects.md)) — per-track/per-container conventions. Each is an ordered, first-match
(fallthrough)
list; the LAST aspect is the '**' catch-all remainder. The catch-all's liveness is the container's call:
automation is CODE, so 'live' is closed (a stray file falls to the 'tests' catch-all and never ships);
infrastructure is a DEPLOYMENT, so everything under a template ships and 'live' is the catch-all — only an
explicit tests/ folder is non-live. Patterns are relative to the unit root. Disjoint + exhaustive by
construction of the ordering.
```

## comment:6

Above `tracks:`, written with `#`.

```text
Tracks ([DDR-TRACK](/docs/drs/design/tracks.md)) — the repository's root concerns, the one declaration of what a
track is. Each entry names its root folder (one segment; every root folder git tracks a file under is a track, except
out/), its class (core | adapter | external-port | verification | unordered,
[DDR-TRACK-ONETRACKTYPE](/docs/drs/design/tracks.md#rule-ddr-track-onetracktype)) and the file languages its
tech-stack is declared as (names from Catzc.Base.Languages' languages.yml,
[DDR-TRACK-FILELANGUAGE](/docs/drs/design/tracks.md#rule-ddr-track-filelanguage); default: none). Read
through Get-Track; validated by the VariantsConfig type.
```

## comment:7

Above `ado-pipelines:`, written with `#`.

```text
The repository's own pipeline definitions are live as the Bicep tree is: a pipeline or workflow is what runs, a test asset under tests/
is the tests aspect.
```

## comment:8

Above `pwsh:`, written with `#`.

```text
The gitignored build outputs are members too, so a clean finds them in the model; each one's generated fact comes from its
generator's target.
```

## comment:9

Above `namespace_exempt:`, written with `#`.

```text
The files that name the product, not a module folder, so they keep the namespace on disk: the loaders PowerShell names its
modules after, and the types assembly's identity.
```
