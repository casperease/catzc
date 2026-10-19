# .ado/pipelines/ci-automation.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
Fires exactly, and only, when the module system changes: the track is its own root folder, with no committed marker to go stale.
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md),
[ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](/docs/adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster) [comment:1](/docs/references/ado/pipelines/ci-automation.yaml.md#comment1)
```

## comment:2

Above `jobs:`, written with `#`.

```text
---------------------------------------------------------------------------
Job 1: Unit tests (Pester)
---------------------------------------------------------------------------
```

## comment:3

Above `- task: UseNode@1`, written with `#`.

```text
cspell + markdownlint-cli2 are installed here so the L2 'Repository spelling/markdown integrity'
tests run as part of Test-Automation -Level 2 (they self-skip when the tool is absent). These L2
integrity tests are the single spell/markdown gate.
```

## comment:4

Above `- job: FrameworkTests`, written with `#`.

```text
---------------------------------------------------------------------------
Job 2: Framework integration tests (no Azure auth)
Each step exercises a different edge of the framework through the template.
---------------------------------------------------------------------------
```

## comment:5

Above `- job: AzureAuthTests`, written with `#`.

```text
---------------------------------------------------------------------------
Job 3: Azure auth mode tests (needs sc-azure-test service connection)
---------------------------------------------------------------------------
```

## comment:6

Above `- job: ToolInstallation`, written with `#`.

```text
---------------------------------------------------------------------------
Job 4: Tool installation — install all locked-version tools on Linux
One step per tool, in dependency order.
---------------------------------------------------------------------------
```

## comment:7

Above `- task: UsePythonVersion@0`, written with `#`.

```text
Activate pre-cached tool versions on the hosted agent.
These put the correct version on PATH so Install-* sees it and skips.
```

## comment:8

Above `- template: /.ado/pipelines/steps/invoke-automation.yaml` (occurrence 18), written with `#`.

```text
Install remaining tools via our functions.
Python, Dotnet, NodeJs use native ADO tasks above.
pip-based tools depend on Python being on PATH (activated above).
apt-based tools use sudo (available on hosted agents).
```

## comment:9

Above `- job: BuildArtifact`, written with `#`.

```text
--- BVT: the post-merge run on main checks the built artifact
([ADR-AUTO-TEST-BUILDVERIFICATIONTEST](/docs/adr/automation/test-automation.md#rule-adr-auto-test-buildverificationtest)); PR runs skip it -------------------
```
