// One tool's locked definition from configs/tools.yml — its required version, how to detect it, and the
// per-manager install metadata for each platform. Mirrors a tools.yml entry (snake_case keys); each tool
// carries only the install metadata its supported platforms need, so most fields are optional.
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's Req/OptStr/Flag extraction helpers.

using System;
using System.Collections;

namespace Catzc.Tooling.Core;

public sealed class ToolConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The locked version the tool must satisfy. Required.
    public string version             { get; }

    // The command/executable name used to invoke the tool. Required.
    public string command             { get; }

    // The command that prints the installed version. Required.
    public string version_command     { get; }

    // The regex that extracts the version from version_command's output. Required.
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

    // The install directory on Windows. Null when not applicable.
    public string windows_install_dir { get; }

    // The install directory on Unix. Null when not applicable.
    public string unix_install_dir    { get; }

    // The name of a tool that must be installed first. Null when the tool has no prerequisite.
    public string depends_on          { get; }

    // Extra directories the session janitor (Sync-SessionTools) prepends to PATH to point THIS session at
    // a tool installed outside the installer layer (e.g. nvm-managed node under %ProgramFiles%\nodejs) when
    // it is otherwise unresolvable. Environment variables are expanded. Empty when the tool has no hints.
    public string[] session_path_hints { get; }

    // Constructed from the parsed tools.yml dictionary; the constructor validates the required keys.
    public ToolConfig(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("ToolConfig requires a dictionary"); }
        version             = Req(d, "version");
        command             = Req(d, "command");
        version_command     = Req(d, "version_command");
        version_pattern     = Req(d, "version_pattern");
        winget_id           = OptStr(d, "winget_id");
        winget_scope        = OptStr(d, "winget_scope");
        brew_formula        = OptStr(d, "brew_formula");
        apt_package         = OptStr(d, "apt_package");
        pip_package         = OptStr(d, "pip_package");
        npm_package         = OptStr(d, "npm_package");
        uv_tool             = OptStr(d, "uv_tool");
        uv_python           = Flag(d, "uv_python");
        script_install      = Flag(d, "script_install");
        system_provided     = Flag(d, "system_provided");
        windows_only        = Flag(d, "windows_only");
        admin_only          = Flag(d, "admin_only");
        windows_install_dir = OptStr(d, "windows_install_dir");
        unix_install_dir    = OptStr(d, "unix_install_dir");
        depends_on          = OptStr(d, "depends_on");
        session_path_hints  = StrArr(d, "session_path_hints");
    }
}
