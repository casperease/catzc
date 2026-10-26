# pwsh/Base.Execution/types/ToolsConfig.cs

The tool lock file (`configs/tools.yml`): a map of snake_case tool identity to `ToolConfig`, in file order. The YAML root is the tool map,
so the type is the read-only dictionary itself, and `$tools.Keys`, `$tools['python']`, `$tools.python` and `$tools.ContainsKey('python')`
read it as they read the parsed YAML. It is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config tools` returns
this typed model.

## Validation

Constructing an instance validates the whole file and collects every violation into one `ArgumentException`:

- the map is non-empty, and every tool identity is snake_case (`Get-ToolCommandSuffix` maps it to the PascalCase command suffix, `az_cli` to
  `Install-AzCli`);
- every entry is a well-formed `ToolConfig`, with violations prefixed by the tool's name, and has at least one install mechanism (a
  package-manager id, `script_install`, a uv shape, an MSYS2 package, or `system_provided`);
- every `depends_on` names a declared tool
  ([ADR-AUTO-DEPS-INSTALLORDERINCONFIG](../../../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-installorderinconfig));
- the `python` tool's version never exceeds a tool's `max_python`, a poka-yoke against bumping Python to a bleeding-edge release a dependent
  (the `az_cli` venv runs on it) cannot use.
