---
catzc:
  derived:
    path: docs/references/pipelines/ci-automation.yaml.md
    kind: reference
    body_sha: cbbe35e4da48
    adrs:
      - ADR-DSGN-TRACK#1
---

# pipelines/ci-automation.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CI pipeline — unit tests, framework integration tests, and Azure auth tests.

Trigger = the 'automation' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)):
the track is its own root folder (automation/**,
[ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)), so this fires exactly — and only starts at
all — when the module system changes. No committed marker to go stale across a squash or concurrent merge.
```

## comment:2

Above `jobs:`.

```text
---------------------------------------------------------------------------
Job 1: Unit tests (Pester)
---------------------------------------------------------------------------
```

## comment:3

Above `- task: UseNode@1`.

```text
cspell + markdownlint-cli2 are installed here so the L2 'Repository spelling/markdown integrity'
tests run as part of Test-Automation -Level 2 (they self-skip when the tool is absent). These L2
integrity tests are the single spell/markdown gate.
```

## comment:4

Above `- job: FrameworkTests`.

```text
---------------------------------------------------------------------------
Job 2: Framework integration tests (no Azure auth)
Each step exercises a different edge of the framework through the template.
---------------------------------------------------------------------------
```

## comment:5

Above `- job: AzureAuthTests`.

```text
---------------------------------------------------------------------------
Job 3: Azure auth mode tests (needs sc-azure-test service connection)
---------------------------------------------------------------------------
```

## comment:6

Above `- job: ToolInstallation`.

```text
---------------------------------------------------------------------------
Job 4: Tool installation — install all locked-version tools on Linux
One step per tool, in dependency order.
---------------------------------------------------------------------------
```

## comment:7

Above `- task: UsePythonVersion@0`.

```text
Activate pre-cached tool versions on the hosted agent.
These put the correct version on PATH so Install-* sees it and skips.
```

## comment:8

Above `- template: /pipelines/steps/invoke-automation.yaml`.

```text
Install remaining tools via our functions.
Python, Dotnet, NodeJs use native ADO tasks above.
pip-based tools depend on Python being on PATH (activated above).
apt-based tools use sudo (available on hosted agents).
```
