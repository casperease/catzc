// The tool lock file (configs/tools.yml): a map of snake_case tool identity -> ToolConfig, in file order. The
// YAML root IS the tool map, so the type is the read-only dictionary itself — `$tools.Keys`, `$tools['python']`,
// `$tools.python` and `$tools.ContainsKey('python')` read it as they read the parsed YAML. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Tooling.Core.ToolsConfig), so Get-Config -Config tools
// returns this typed model.
//
// Constructing an instance validates the whole file, collecting every violation into one ArgumentException:
//   - a non-empty map; every tool identity is snake_case (Get-ToolCommandSuffix maps it to the PascalCase
//     command suffix, az_cli -> Install-AzCli);
//   - every entry is a well-formed ToolConfig (violations prefixed with the tool's name) with at least one install
//     mechanism (a package-manager id, script_install, a uv shape, or system_provided);
//   - every depends_on names a declared tool
//     ([ADR-AUTO-DEPS#4](/docs/adr/automation/controlling-systemwide-deps.md#rule-adr-auto-deps4));
//   - the `python` tool's version never exceeds a tool's max_python — a poka-yoke against bumping Python to a
//     bleeding-edge release a dependent (az_cli's venv runs on it) cannot use.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Core;

public sealed class ToolsConfig : ReadOnlyDictionary<string, ToolConfig>
{
    // A dictionary renders as its entries, { tool = … }, not as its dictionary members.
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleValue(this);

    private static readonly Regex SnakeCase = new Regex("^[a-z][a-z0-9_]*$");

    // The tool identities in file order.
    public new IReadOnlyList<string> Keys { get; }

    public ToolsConfig(IDictionary raw) : base(new Dictionary<string, ToolConfig>(StringComparer.Ordinal))
    {
        List<string> errors = new List<string>();
        List<string> keys = new List<string>();

        if (raw == null || raw.Count == 0)
        {
            throw new ArgumentException("tools.yml validation failed:\ntools.yml must be a non-empty map of tool identity -> entry");
        }

        foreach (object k in raw.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (name == null || !SnakeCase.IsMatch(name))
            {
                errors.Add(string.Format("tool '{0}': the identity is not snake_case (must match ^[a-z][a-z0-9_]*$)", name));
                continue;
            }
            IDictionary entry = raw[k] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format("tool '{0}': the entry must be a mapping", name));
                continue;
            }
            try
            {
                Dictionary.Add(name, new ToolConfig(entry));
                keys.Add(name);
            }
            catch (ArgumentException ex) { errors.Add(string.Format("tool '{0}': {1}", name, ex.Message)); }
        }
        Keys = keys;

        foreach (string name in keys)
        {
            if (!Dictionary[name].HasInstallMechanism())
            {
                errors.Add(string.Format("tool '{0}': needs an install mechanism (winget_id, brew_formula, apt_package, pip_package, npm_package, uv_tool, uv_venv, uv_python, script_install, or system_provided)", name));
            }
            string dependency = Dictionary[name].depends_on;
            if (dependency != null && !Dictionary.ContainsKey(dependency))
            {
                errors.Add(string.Format("tool '{0}': depends_on '{1}' is not a declared tool", name, dependency));
            }
        }

        CheckPythonPin(errors);

        if (errors.Count > 0) { throw new ArgumentException("tools.yml validation failed:\n" + string.Join("\n", errors)); }
    }

    // Read-only lookup that yields null for an unknown tool (the parsed-YAML idiom), rather than throwing.
    public new ToolConfig this[string name]
    {
        get { ToolConfig tool; return name != null && Dictionary.TryGetValue(name, out tool) ? tool : null; }
    }

    // True when the file declares the tool.
    public bool Contains(string name) => name != null && Dictionary.ContainsKey(name);

    private void CheckPythonPin(List<string> errors)
    {
        ToolConfig python;
        if (!Dictionary.TryGetValue("python", out python)) { return; }
        Version pin;
        if (!Version.TryParse(python.version, out pin))
        {
            errors.Add(string.Format("tool 'python': version '{0}' is not a dotted version", python.version));
            return;
        }
        foreach (string name in Keys)
        {
            string max = Dictionary[name].max_python;
            if (max == null) { continue; }
            Version limit;
            if (!Version.TryParse(max, out limit))
            {
                errors.Add(string.Format("tool '{0}': max_python '{1}' is not a dotted version", name, max));
            }
            else if (pin > limit)
            {
                errors.Add(string.Format(
                    "Python is pinned to {0}, but '{1}' supports Python <= {2}. Lower python's version, or raise '{1}''s max_python — the toolchain does not run bleeding-edge Python past a dependent's support.",
                    python.version, name, max));
            }
        }
    }
}
