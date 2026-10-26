# pwsh/Tooling.Provisioning/types/ToolStatus.cs

The typed row of one tool's installation status: the locked requirement against what is actually on the box, the verdict, and where and how
it was found. It is the per-tool row that drives the dev box's assert and install flow (`Get-ToolsStatus` produces it).

## Properties

- **`Tool`** — the tool's name, its `tools.yml` key; always present.
- **`Locked`** — the version the lock requires; null when not applicable.
- **`Installed`** — the version actually installed; null when the tool is not installed.
- **`Status`** — the verdict, a `ToolStatusKind`. The constructor takes it as a string and parses it, so the producer's string logic binds
  directly.
- **`Location`** — where the installed tool was found on disk; null when not installed.
- **`Manager`** — the package manager the tool was installed with; null when not applicable.
- **`Scope`** — the install scope, such as user or machine; null when not applicable.
- **`Action`** — the remediation the status implies, such as install or upgrade, for the install flow to act on.
