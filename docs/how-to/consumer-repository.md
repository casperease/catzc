# Set up your repository on a catzc bundle

A **consumer repository** is a working root with a bundle installed ([ADR-AUTO-CONSUMER](../drs/automation/consumer-repository.md)): the
team's own folder, with its own tracks, modules, configs, types and decision records, running catzc's commands and quality gates over them.
This guide builds one from an empty folder, using a widget team's repository as the example. Its names (`Widget`, `Gadget`, `widget/`) are
the team's own; the `Catzc` namespace is never the consumer's
([ADR-AUTO-CONSUMER-OWNTRACKS](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntracks)).

The shape below is the one `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1` proves.

## Install a bundle into the repository root

The bundle is a build of the toolset ([ADR-AUTO-BUNDLE-ISBUILD](../drs/automation/platform-bundle.md#rule-adr-auto-bundle-isbuild)). Build
it once from a catzc session, then install it into the repository's root:

```powershell
Build-Modules -Bundle full
Install-Catzc -Root C:\projects\widget-repo -Bundle full
```

`-Source` names another built bundle folder when it is not under that session's `out/`. `-DryRun` shows what would land. The install puts
these in the root:

- `.vendor/Catzc/<version>/` — the bundle, read-only.
- `importer.ps1` — the root importer, generated; it loads the installed bundle with the root as the working root.
- The root files the installed build renders through `Build-RootConfig`: `cspell.yml`, `.markdownlint.yml`, `nuget.config`,
  `PSScriptAnalyzerSettings.psd1` and every other target `pwsh/Base.RootConfig/configs/rootconfig.yml` marks `consumer`.

The two roots stay apart: the working root is the repository, the bundle under `.vendor/` is catzc's code
([ADR-AUTO-BUNDLE-TWOROOTS](../drs/automation/platform-bundle.md#rule-adr-auto-bundle-tworoots)). Dot-source the importer and check the
mode:

```powershell
. ./importer.ps1
Get-CatzcRunMode
```

The answer is `build`; a consumer's own modules never change it
([DDR-RUNMODE-MODEISDERIVED](../drs/design/run-modes.md#rule-ddr-runmode-modeisderived)).

The install also writes `importer.sh` beside `importer.ps1`: a short generated stub for a bash or zsh session
([ADR-AUTO-ENGINE](../drs/automation/execution-engines.md)). It points `CATZC_IMPORTER` at the root's `importer.ps1` and
`CATZC_COMMAND_LOOKUP` at the bundle's command lookup, then sources the bundle's shipped shell entry. Source it and run any command through
`cats`:

```bash
. ./importer.sh
cats Get-CatzcRunMode
```

## Declare the repository's tracks

Write `.catzc/configs/variants.yml`. It is a working-root config: it is read whole from the working root, never merged onto the bundle's
([ADR-CONF-LOADING-WORKINGROOTREADWHOLE](../drs/configuration/module-config-loading.md#rule-adr-conf-loading-workingrootreadwhole)), so it
lists exactly the tracks the repository has. The engine adds the bundle's own `pwsh` track.

```yaml
tracks:
  widget:
    members: [widget]
    type: modules
    namespace: Widget
  docs:
    members: [docs]
    type: documentation
```

The `widget` track holds the code, and its `namespace` joins each module folder's name: `widget/Local/` is the module `Widget.Local`. The
`docs` track, of type `documentation`, holds the docs. A repository that declares no tracks still imports; it has only the `pwsh` track.
After an import, `Get-Track` lists them.

## Override a catzc config or function

The overlay is the `.catzc/` folder at the working root, the only place a consumer changes what the bundle does
([ADR-AUTO-OVERLAY-OVERLAYFOLDER](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-overlayfolder)). A file sits at the same
relative path as the thing it changes
([ADR-AUTO-OVERLAY-SAMERELATIVEPATH](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-samerelativepath)).

- A **config fragment** is `.catzc/pwsh/<Module>/configs/<name>.yml`. It states only the keys that differ and merges onto the bundled config
  ([ADR-AUTO-OVERLAY-CONFIGFRAGMENT](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-configfragment)):

  ```yaml
  prune_vendor_in_searches: false
  ```

  Saved as `.catzc/pwsh/Base.Folders/configs/folder-walk.yml`, it makes `Get-Config -Config folder-walk` read `false`.

- A **function override** is `.catzc/pwsh/<Module>/<Verb-Noun>.ps1`, one function named for its file. It replaces the bundled function
  inside its module and keeps the original's parameters and output type
  ([ADR-AUTO-OVERLAY-FUNCTIONOVERRIDE](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-functionoverride)).

The folder after `.catzc/` is the bundle's modules folder, `pwsh`. `Get-Overlay` lists every fragment and override as a kind, a module and a
target. `Assert-Overlay` checks the overlay as a whole and reports every violation in one failure, among them a folder that names no bundled
module: new code belongs in a module of the consumer's own track
([ADR-AUTO-OVERLAY-MODULEOVERRIDEENTRIES](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-moduleoverrideentries)). A fragment
reaches a module config only; the engine configs are sealed
([ADR-AUTO-OVERLAY-SEALEDENGINECONFIGS](../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-sealedengineconfigs)).

## Add a module in your own track

A module is a folder in the consumer's track. Add `widget/Local/` with the usual layout:

```text
widget/Local/
  Get-LocalWidget.ps1
  tests/
    Get-LocalWidget.Tests.ps1
  configs/
    configs.yml
    gadget.yml
  types/
    Gadget.cs
```

The public function is a file at the module root, `Get-LocalWidget.ps1`, with its Pester tests in `tests/`. The loader that reads catzc's
modules from source reads this one too: nothing is built, and an edited file is live after the next import
([ADR-AUTO-CONSUMER-SOURCEMODULES](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-sourcemodules)). Its dependencies on
catzc's modules are declared in the consumer's own `dependencies.yml`.

The module's config is `configs/gadget.yml`, and its registry `configs/configs.yml` names the record type, in snake case like the YAML:

```yaml
configs:
  gadget:
    type: Widget.Local.Gadget
```

`types/Gadget.cs` declares `Widget.Local.Gadget`, a class whose constructor takes the raw dictionary and validates it. The types compile
in-process into one `Widget.Types.<hash>.dll` under the working root's `out/`, and are reused while the hash holds
([ADR-AUTO-CONSUMER-OWNTYPES](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owntypes)); a `Catzc.` namespace is refused.

A config's identity is its namespace and its name, so a bare name from the console resolves in catzc's namespace and finds nothing. Name the
consumer's namespace:

```powershell
Get-Config gadget -Namespace Widget
```

Inside the module's own functions the bare name reads the module's own namespace
([ADR-AUTO-CONSUMER-OWNCONFIGS](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-ownconfigs)).

## Start a decision record system

The tooling that registers, indexes and checks records is catzc's; the records are the consumer's own
([ADR-AUTO-CONSUMER-OWNDRS](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-owndrs)). Write `.catzc/configs/drs.yml`, read
whole like `variants.yml`, with one kind and one domain:

```yaml
kinds:
  ADR: { name: Architecture Decision Record }

domains:
  widget:
    kind: ADR
    role: naming # how the team names its widgets
    description: How the team names its widgets.
    stack: AUTO
    concern: [automation]
    rulesets:
      widget-naming: { external: ADR-WIDGET }
```

Then add the record `docs/drs/widget/widget-naming.md`, which starts with its rule registry:

```markdown
# Widget naming

## Rules: ADR-WIDGET

### Rule ADR-WIDGET-NAMING

A widget is named for what it does, in one lower-case word.

- [Context](#context)

## Context

A name that says what a widget does needs no lookup.
```

The domain keeps a `docs/drs/widget/dora-explains.md` with one entry per record, and `docs/drs/index.md` lists the record under its domain
with its code. Run `Test-DrsRegistry`; it reads the registry and the records and reports the issues. The index lists only the consumer's
codes, never catzc's.

## Point the package managers at your feed

A consumer behind a proxy, or on a private feed, resolves every language's packages from one `package_source` per language config
([ADR-AUTO-PKGSRC-SOURCEPERLANGUAGE](../drs/automation/package-sources.md#rule-adr-auto-pkgsrc-sourceperlanguage)). Write it in the working
root's `.catzc/configs/<language>.yml`, for example `.catzc/configs/javascript.yml`:

```yaml
package_source:
  name: widget-feed
  url: https://feeds.example/api/widget/npm
  credential_env: WIDGET_FEED_TOKEN
```

Run `Build-RootConfig`, and the root's `.npmrc`, `nuget.config` and python `pyproject.toml` carry the source. The tooling commands then
fetch from it. [Point cats at your feed](pwsh/point-cats-at-your-feed.md) has the override, the fetching command and the check for each
language, and the credential variable.

## Run the gates and the tests as CI

A consumer's pipeline is two calls, in this order
([ADR-AUTO-CONSUMER-CATZCGATES](../drs/automation/consumer-repository.md#rule-adr-auto-consumer-catzcgates)):

1. `Test-QualityGates` runs the union of the checks of the languages the repository's tracked files hold. A gate reads the repository's
   files only, never the bundle; a language with no tracked file in the repository, and a folder it lacks, add no gate. Each issue names its
   gate. A gate whose tool is not installed names the install command to run.
2. `Test-Automation` runs the tests of the consumer's modules, from the `tests/` folder of each.

As a GitHub workflow, the repository's `.github/workflows/ci.yml` holds the two as steps of one job:

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Quality gates
        shell: pwsh
        run: |
          . ./importer.ps1
          Test-QualityGates

      - name: Tests
        shell: pwsh
        run: |
          . ./importer.ps1
          Test-Automation -Level 2
```

An Azure DevOps pipeline under `.ado/pipelines/` runs the same two commands as two `pwsh` steps, each dot-sourcing `./importer.ps1` first.
The gates that list tracked files read the git index, so the repository is a git checkout in CI and on the devbox alike.
