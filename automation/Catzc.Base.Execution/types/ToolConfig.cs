/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/types/ToolConfig.cs
    kind: type
    module: Catzc.Base.Execution
    adrs:
      - ADR-AUTO-DEPS#1
      - ADR-AUTO-PKGMGR#6
---
*/

// An unknown key would be invisible to every caller, so the constructor rejects it and lists all violations at once.
// [comment:1](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Execution;

public sealed class ToolConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys =
    {
        "version", "devbox_version", "command", "version_command", "version_pattern", "winget_id", "winget_scope",
        "brew_formula", "apt_package", "pip_package", "npm_package", "uv_tool", "uv_allow_prerelease", "uv_venv",
        "max_python", "uv_python", "script_install", "system_provided", "windows_only", "admin_only",
        "linux_admin_only", "windows_install_dir", "unix_install_dir", "depends_on", "session_path_hints",
        "session_host_probes", "windows_probes", "windows_pipeline_probes", "unix_probes", "unix_pipeline_probes",
        "probe_excludes", "msys2_url", "msys2_sha256",
    };

    // The locked version the tool must satisfy. Required.
    public string version { get; }

    // A pipeline ignores this lever and enforces version alone, so a devbox-only version never passes CI.
    // [comment:2](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment2)
    public string devbox_version { get; }

    // The command/executable name used to invoke the tool. Required.
    public string command { get; }

    // The command that prints the installed version. Required.
    public string version_command { get; }

    // The regex that extracts the version from version_command's output, as the named group (?<ver>...). Required.
    public string version_pattern { get; }

    // winget package id. Null when winget is not an install path for this tool.
    public string winget_id { get; }

    // winget install scope (e.g. user/machine). Null when not applicable.
    public string winget_scope { get; }

    // Homebrew formula name. Null when brew is not an install path.
    public string brew_formula { get; }

    // apt package name. Null when apt is not an install path.
    public string apt_package { get; }

    // pip package name. Null when pip is not an install path.
    public string pip_package { get; }

    // npm package name. Null when npm is not an install path.
    public string npm_package { get; }

    // Isolated env per tool, so its dependencies cannot collide with the shared managed Python.
    // [comment:3](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment3)
    public string uv_tool { get; }

    // Without it uv refuses a pre-release in the dependency tree, such as the azure-batch beta behind azure-cli.
    // [comment:4](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment4)
    public bool uv_allow_prerelease { get; }

    // A uv-tool shim in the local bin breaks CLIs that expect python.exe beside their launcher, as az.bat does.
    // [comment:5](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment5)
    public string uv_venv { get; }

    // ToolsConfig rejects a python pin above this, keeping Python off a release a dependent cannot use.
    // [comment:6](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment6)
    public string max_python { get; }

    // True when this tool is Python itself, provisioned by `uv python install --default`. Null/false otherwise.
    public bool uv_python { get; }

    // True when the tool is installed via a bespoke script rather than a package manager.
    public bool script_install { get; }

    // Asserted and kept on PATH through session_path_hints, but never installed, as winget is on Windows.
    // [comment:7](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment7)
    public bool system_provided { get; }

    // True when the tool exists only on Windows — skipped on macOS/Linux by the provisioning and status loops.
    public bool windows_only { get; }

    // Install asserts elevation, and the provisioning loops skip and report the tool when not elevated.
    // [comment:8](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment8)
    public bool admin_only { get; }

    // Test-ToolRequiresElevation honours it only on Linux, because the Windows and macOS installs stay user-space.
    // [comment:9](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment9)
    public bool linux_admin_only { get; }

    // Declared together with msys2_sha256, which the download is verified against before anything is extracted.
    // [comment:10](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment10)
    public string msys2_url { get; }
    public string msys2_sha256 { get; }

    // Relative to LOCALAPPDATA, and also the tree an msys2 tool installs into, not only a script-installed tool's home.
    // [comment:11](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment11)
    public string windows_install_dir { get; }

    // The install directory on Unix. Null when not applicable.
    public string unix_install_dir { get; }

    // ToolsConfig checks that it names a declared tool, so a typo fails validation instead of a later install.
    // [comment:12](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment12)
    public string depends_on { get; }

    // Applies only when the tool is otherwise unresolvable on PATH, such as nvm-managed node under ProgramFiles.
    // [comment:13](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment13)
    public string[] session_path_hints { get; }

    // The first probe any home satisfies wins, so a dotnet SDK at the locked version beats a runtime-only host.
    // [comment:14](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment14)
    public string[] session_host_probes { get; }

    // The first existing candidate wins, then PATH; a tool with no candidates on this platform is found on PATH alone.
    // [comment:15](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment15)
    public string[] windows_probes { get; }
    public string[] windows_pipeline_probes { get; }
    public string[] unix_probes { get; }
    public string[] unix_pipeline_probes { get; }

    // For bash this is the WSL launcher in System32, which is not Git Bash and must never count as the tool.
    // [comment:16](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment16)
    public string[] probe_excludes { get; }

    // A tool without probes is located by its bare command name on PATH instead.
    // [comment:17](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment17)
    public bool HasProbes()
    {
        return windows_probes.Length > 0 || windows_pipeline_probes.Length > 0 || unix_probes.Length > 0
            || unix_pipeline_probes.Length > 0 || probe_excludes.Length > 0;
    }

    // ToolsConfig requires it of every shipped entry, so a tool nobody can install fails validation.
    // [comment:18](/docs/references/automation/catzc-base-execution/types/ToolConfig.cs.md#comment18)
    public bool HasInstallMechanism()
    {
        return winget_id != null || brew_formula != null || apt_package != null || pip_package != null
            || npm_package != null || uv_tool != null || uv_venv != null || uv_python || script_install || system_provided
            || msys2_url != null;
    }

    // Constructed from one parsed tools.yml entry; throws one ArgumentException listing every violation.
    public ToolConfig(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("a tool entry must be a mapping"); }
        List<string> errors = new List<string>();

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        version = Required(d, "version", errors);
        devbox_version = OptStr(d, "devbox_version");
        command = Required(d, "command", errors);
        version_command = Required(d, "version_command", errors);
        version_pattern = Required(d, "version_pattern", errors);
        winget_id = OptStr(d, "winget_id");
        winget_scope = OptStr(d, "winget_scope");
        brew_formula = OptStr(d, "brew_formula");
        apt_package = OptStr(d, "apt_package");
        pip_package = OptStr(d, "pip_package");
        npm_package = OptStr(d, "npm_package");
        uv_tool = OptStr(d, "uv_tool");
        uv_allow_prerelease = Flag(d, "uv_allow_prerelease");
        uv_venv = OptStr(d, "uv_venv");
        max_python = OptStr(d, "max_python");
        uv_python = Flag(d, "uv_python");
        script_install = Flag(d, "script_install");
        system_provided = Flag(d, "system_provided");
        windows_only = Flag(d, "windows_only");
        admin_only = Flag(d, "admin_only");
        linux_admin_only = Flag(d, "linux_admin_only");
        windows_install_dir = OptStr(d, "windows_install_dir");
        unix_install_dir = OptStr(d, "unix_install_dir");
        depends_on = OptStr(d, "depends_on");
        session_path_hints = StrArr(d, "session_path_hints");
        session_host_probes = StrArr(d, "session_host_probes");
        windows_probes = StrArr(d, "windows_probes");
        windows_pipeline_probes = StrArr(d, "windows_pipeline_probes");
        unix_probes = StrArr(d, "unix_probes");
        unix_pipeline_probes = StrArr(d, "unix_pipeline_probes");
        probe_excludes = StrArr(d, "probe_excludes");
        msys2_url = OptStr(d, "msys2_url");
        msys2_sha256 = OptStr(d, "msys2_sha256");

        if ((msys2_url == null) != (msys2_sha256 == null))
        {
            errors.Add("msys2_url and msys2_sha256 are declared together: the download is verified against its SHA-256");
        }

        if (msys2_sha256 != null && !Regex.IsMatch(msys2_sha256, @"\A[0-9a-f]{64}\z"))
        {
            errors.Add(string.Format("msys2_sha256 '{0}' must be 64 lowercase hex digits", msys2_sha256));
        }

        if (version_pattern != null && !version_pattern.Contains("(?<ver>"))
        {
            errors.Add(string.Format("version_pattern '{0}' must capture the version as the named group (?<ver>...)", version_pattern));
        }

        foreach (string probe in session_host_probes)
        {
            if (!probe.EndsWith("{version}", StringComparison.Ordinal))
            {
                errors.Add(string.Format("session_host_probes entry '{0}' must end with the {{version}} segment", probe));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("; ", errors)); }
    }

    private static string Required(IDictionary d, string key, List<string> errors)
    {
        string value = OptStr(d, key);
        if (value == null) { errors.Add(key + " is required"); }
        return value;
    }
}
