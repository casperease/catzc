# .ado/pipelines/ci-pwsh.yaml

The CI pipeline of the module system: it runs the unit tests, exercises the framework through the pipeline template, checks the Azure
authentication modes, installs every locked-version tool on Linux, renders the console output helpers, and on `main` builds the artifact for
the build verification test. Every job runs on `ubuntu-latest`, and all but the artifact job start by restoring the C# types build with
`steps/cache-types.yaml`.

## Triggers

It fires exactly, and only, when the module system changes: the track is its own root folder, with no committed marker to go stale. The
include list is `pwsh/**`; the exclude list drops the files that are not module code (`*.psd1`, module `README.md` files, compiled output
and the types project's build folders, the importer command list and the track-sets glob config)
([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md),
[DDR-TRACK-ISPLACEDCLUSTER](../../../drs/design/tracks.md#rule-ddr-track-isplacedcluster)). Pull requests and `main` use the same filter.

## Jobs

- **UnitTests** — activates Node.js 22 and installs `cspell` and `markdownlint-cli2` with `Install-Cspell` and `Install-Markdownlint`, then
  runs `Test-Automation -Level 2 -EnforceTimings`. The tools are installed here so the L2 repository spelling and markdown integrity tests
  run as part of that run (they skip themselves when the tool is absent). These L2 integrity tests are the only check of spelling and
  markdown.
- **FrameworkTests** — framework integration tests with no Azure authentication. Each step exercises a different edge of the framework
  through the step template: a multiline command through the YAML pipe operator, `Invoke-Executable` output capture, stderr separation and
  exit-code assertion, pipeline detection and the output root, `Set-AdoPipelineVariable`, `-DryRun` on the tool wrappers, the header and
  footer rendering, module loading and function discovery, and the output of `Write-Exception`.
- **AzureAuthTests** — needs the `sc-azure-test` service connection. It proves mode `azcli` (the az CLI is pre-authenticated), mode `azps`
  (the Az PowerShell context is authenticated) and `ExposeAccessToken` (`SYSTEM_ACCESSTOKEN` is mapped).
- **ToolInstallation** — installs every locked-version tool on Linux, one step per tool in dependency order, with a tools status snapshot
  before and after. The hosted agent's pre-cached Python 3.13, .NET 10 and Node.js 22 are activated first, which puts the right version on
  `PATH`, so the `Install-*` functions see it and skip. The remaining tools install through catzc's own functions: the pip-based tools
  (`Install-AzCli`, `Install-Poetry`, `Install-PySpark`) depend on Python being on `PATH`, `Install-PySpark` also on Java, and the npm-based
  tools (`Install-Cspell`, `Install-Markdownlint`, `Install-Prettier`) on Node.js.
- **VisualTests** — renders `Write-Object` on simple types, arrays, nested hashtables, `PSCustomObject` trees, arrays of objects, ordered
  dictionaries, a splat, the real Azure configuration, a mixed-type array and flattened settings from `ConvertTo-FlatSettingSet`. The log is
  the check, so a person reads it.
- **BuildArtifact** — the BVT: the post-merge run on `main` checks the built artifact with `Test-BuildArtifact`
  ([ADR-AUTO-TEST-BUILDVERIFICATIONTEST](../../../drs/automation/test-automation.md#rule-adr-auto-test-buildverificationtest)). Pull request
  runs skip it.
