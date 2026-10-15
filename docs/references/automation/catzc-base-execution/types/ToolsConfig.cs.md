---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/types/ToolsConfig.cs.md
    kind: comment-page
    body_sha: a60b8892aaf5
    adrs:
      - ADR-AUTO-DEPS#4
    links: []
---

# automation/Catzc.Base.Execution/types/ToolsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The tool lock file (configs/tools.yml): a map of snake_case tool identity -> ToolConfig, in file order. The
YAML root IS the tool map, so the type is the read-only dictionary itself — `$tools.Keys`, `$tools['python']`,
`$tools.python` and `$tools.ContainsKey('python')` read it as they read the parsed YAML. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Execution.ToolsConfig), so Get-Config -Config tools
returns this typed model.

Constructing an instance validates the whole file, collecting every violation into one ArgumentException:
  - a non-empty map; every tool identity is snake_case (Get-ToolCommandSuffix maps it to the PascalCase
    command suffix, az_cli -> Install-AzCli);
  - every entry is a well-formed ToolConfig (violations prefixed with the tool's name) with at least one install
    mechanism (a package-manager id, script_install, a uv shape, an MSYS2 package, or system_provided);
  - every depends_on names a declared tool
    ([ADR-AUTO-DEPS#4](/docs/adr/automation/controlling-systemwide-deps.md#rule-adr-auto-deps4));
  - the `python` tool's version never exceeds a tool's max_python — a poka-yoke against bumping Python to a
    bleeding-edge release a dependent (az_cli's venv runs on it) cannot use.
```
