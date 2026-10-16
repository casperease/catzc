/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Execution/types/ToolsConfig.cs
    folder: types
    name: tools-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-execution/types/ToolsConfig.cs.md
    test: automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
    cites:
      - ADR-AUTO-DEPS#4
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;

namespace Catzc.Base.Execution;

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
                errors.Add(string.Format("tool '{0}': needs an install mechanism (winget_id, brew_formula, apt_package, pip_package, npm_package, uv_tool, uv_venv, uv_python, script_install, msys2_url, or system_provided)", name));
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
