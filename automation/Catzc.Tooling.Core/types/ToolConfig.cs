// One tool's locked definition from configs/tools.yml — its required version, how to detect it, and the
// per-manager install metadata for each platform. Mirrors a tools.yml entry (snake_case keys); each tool
// carries only the install metadata its supported platforms need, so most fields are optional. ToolsConfig
// builds one per entry and prefixes every violation with the tool's name.
//
// Constructing an instance validates the entry, collecting every violation into one ArgumentException:
//   - only the known keys below (an unknown key would be silently invisible to every caller);
//   - version, command, version_command and version_pattern are required
//     ([ADR-AUTO-DEPS#1](/docs/adr/automation/controlling-systemwide-deps.md#rule-adr-auto-deps1));
//   - version_pattern captures the version as the named group (?<ver>...);
//   - every session_host_probes entry ends with the {version} segment.
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's OptStr/StrArr/Flag extraction helpers.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.Core;

public sealed class ToolConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys =
    {
        "version", "devbox_version", "command", "version_command", "version_pattern", "winget_id", "winget_scope",
        "brew_formula", "apt_package", "pip_package", "npm_package", "uv_tool", "uv_allow_prerelease", "uv_venv",
        "max_python", "uv_python", "script_install", "system_provided", "windows_only", "admin_only",
        "linux_admin_only", "windows_install_dir", "unix_install_dir", "depends_on", "session_path_hints",
        "session_host_probes", "windows_probes", "windows_pipeline_probes", "unix_probes", "unix_pipeline_probes",
        "probe_excludes",
    };

    // The locked version the tool must satisfy. Required.
    public string version             { get; }

    // Devbox lever: outside a CI pipeline, an installed version starting with this prefix is also accepted
    // (Assert-ToolVersion, Test-Tool). A pipeline ignores it and enforces `version` alone. Null when the tool has
    // no lever.
    public string devbox_version      { get; }

    // The command/executable name used to invoke the tool. Required.
    public string command             { get; }

    // The command that prints the installed version. Required.
    public string version_command     { get; }

    // The regex that extracts the version from version_command's output, as the named group (?<ver>...). Required.
    public string version_pattern     { get; }

    // winget package id. Null when winget is not an install path for this tool.
    public string winget_id           { get; }

    // winget install scope (e.g. user/machine). Null when not applicable.
    public string winget_scope        { get; }

    // Homebrew formula name. Null when brew is not an install path.
    public string brew_formula        { get; }

    // apt package name. Null when apt is not an install path.
    public string apt_package         { get; }

    // pip package name. Null when pip is not an install path.
    public string pip_package         { get; }

    // npm package name. Null when npm is not an install path.
    public string npm_package         { get; }

    // uv tool/package name — installed with `uv tool install <uv_tool>` into an isolated env (e.g. az_cli,
    // poetry). Null when uv-tool is not an install path.
    public string uv_tool             { get; }

    // True to pass `--prerelease=allow` to the uv install — needed when the package's dependency tree pins a
    // pre-release (e.g. azure-cli depends on an azure-batch beta), which uv otherwise refuses.
    public bool   uv_allow_prerelease { get; }

    // pip package installed into a DEDICATED uv venv (not the shared managed Python, not an isolated uv tool).
    // For CLIs whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which a uv-tool shim
    // in ~/.local/bin breaks. Null when venv install is not the path.
    public string uv_venv             { get; }

    // Highest Python version this tool supports (runs under). ToolsConfig rejects a toolchain whose python pin
    // exceeds it — keeping Python off a bleeding-edge release a dependent cannot use.
    public string max_python          { get; }

    // True when this tool is Python itself, provisioned by `uv python install --default`. Null/false otherwise.
    public bool   uv_python           { get; }

    // True when the tool is installed via a bespoke script rather than a package manager.
    public bool   script_install      { get; }

    // True when the tool is provided by the operating system (e.g. winget/App Installer on Windows). The
    // toolchain asserts it and keeps it on PATH via session_path_hints, but never installs it.
    public bool   system_provided     { get; }

    // True when the tool exists only on Windows — skipped on macOS/Linux by the provisioning and status loops.
    public bool   windows_only        { get; }

    // True when the tool has only a machine-scope installer, so installing it requires Administrator. Install
    // asserts elevation; the provisioning loops skip and report it when not elevated.
    public bool   admin_only          { get; }

    // True when only the Linux install needs root (apt-get), while the Windows and macOS installs are user-space.
    // Test-ToolRequiresElevation honours it only on Linux.
    public bool   linux_admin_only    { get; }

    // The install directory on Windows. Null when not applicable.
    public string windows_install_dir { get; }

    // The install directory on Unix. Null when not applicable.
    public string unix_install_dir    { get; }

    // The name of a tool that must be installed first. Null when the tool has no prerequisite. ToolsConfig checks
    // it names a declared tool.
    public string depends_on          { get; }

    // Extra directories the session janitor (Sync-SessionTools) prepends to PATH to point THIS session at
    // a tool installed outside the installer layer (e.g. nvm-managed node under %ProgramFiles%\nodejs) when
    // it is otherwise unresolvable. Environment variables are expanded. Empty when the tool has no hints.
    public string[] session_path_hints { get; }

    // Ordered probes the session janitor (Sync-SessionTools) uses to pick WHICH install home of the command this
    // session runs, when several exist (the managed home, then every PATH directory holding the command). Each
    // probe is a path relative to a home whose last segment carries `{version}` (replaced by the locked version):
    // a home satisfies it when that folder holds a directory named the version or starting with "<version>."
    // (dotnet: `sdk/{version}` matches sdk/10.0.201). The first probe ANY home satisfies wins — so for dotnet an
    // SDK at the locked version beats a runtime-only host. Empty when the tool has a single obvious install.
    public string[] session_host_probes { get; }

    // The candidate executable paths, in order, that locate the tool without starting a process (Test-Tool
    // -PassThru): each is a full path to the executable, with %VAR% environment variables expanded. The first
    // candidate that exists wins; when none does, PATH is searched. A devbox session (actor Person or Agent)
    // reads the plain list, a pipeline session (actor Pipeline) reads the pipeline list, and Windows and Unix
    // each have their own pair. A tool with no candidates on the running platform is located on PATH alone.
    public string[] windows_probes          { get; }
    public string[] windows_pipeline_probes { get; }
    public string[] unix_probes             { get; }
    public string[] unix_pipeline_probes    { get; }

    // Executable paths (%VAR% expanded) that never count as the tool, as a candidate or on PATH: for bash, the WSL
    // launcher %SystemRoot%\System32\bash.exe, which is not Git Bash. Empty when nothing is excluded.
    public string[] probe_excludes          { get; }

    // True when the entry declares candidate paths or exclusions, so the tool is located by the probe (Test-Tool,
    // Assert-Tool) rather than by the bare command name on PATH.
    public bool HasProbes()
    {
        return windows_probes.Length > 0 || windows_pipeline_probes.Length > 0 || unix_probes.Length > 0
            || unix_pipeline_probes.Length > 0 || probe_excludes.Length > 0;
    }

    // True when the entry declares how the toolchain gets it: a package-manager id, script_install, a uv shape,
    // or system_provided (asserted, never installed). ToolsConfig requires it of every shipped entry.
    public bool HasInstallMechanism()
    {
        return winget_id != null || brew_formula != null || apt_package != null || pip_package != null
            || npm_package != null || uv_tool != null || uv_venv != null || uv_python || script_install || system_provided;
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

        version             = Required(d, "version", errors);
        devbox_version      = OptStr(d, "devbox_version");
        command             = Required(d, "command", errors);
        version_command     = Required(d, "version_command", errors);
        version_pattern     = Required(d, "version_pattern", errors);
        winget_id           = OptStr(d, "winget_id");
        winget_scope        = OptStr(d, "winget_scope");
        brew_formula        = OptStr(d, "brew_formula");
        apt_package         = OptStr(d, "apt_package");
        pip_package         = OptStr(d, "pip_package");
        npm_package         = OptStr(d, "npm_package");
        uv_tool             = OptStr(d, "uv_tool");
        uv_allow_prerelease = Flag(d, "uv_allow_prerelease");
        uv_venv             = OptStr(d, "uv_venv");
        max_python          = OptStr(d, "max_python");
        uv_python           = Flag(d, "uv_python");
        script_install      = Flag(d, "script_install");
        system_provided     = Flag(d, "system_provided");
        windows_only        = Flag(d, "windows_only");
        admin_only          = Flag(d, "admin_only");
        linux_admin_only    = Flag(d, "linux_admin_only");
        windows_install_dir = OptStr(d, "windows_install_dir");
        unix_install_dir    = OptStr(d, "unix_install_dir");
        depends_on          = OptStr(d, "depends_on");
        session_path_hints  = StrArr(d, "session_path_hints");
        session_host_probes = StrArr(d, "session_host_probes");
        windows_probes          = StrArr(d, "windows_probes");
        windows_pipeline_probes = StrArr(d, "windows_pipeline_probes");
        unix_probes             = StrArr(d, "unix_probes");
        unix_pipeline_probes    = StrArr(d, "unix_pipeline_probes");
        probe_excludes          = StrArr(d, "probe_excludes");

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
