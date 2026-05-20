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

    // True when the tool is installed via a bespoke script rather than a package manager.
    public bool   script_install      { get; }

    // The install directory on Windows. Null when not applicable.
    public string windows_install_dir { get; }

    // The install directory on Unix. Null when not applicable.
    public string unix_install_dir    { get; }

    // The name of a tool that must be installed first. Null when the tool has no prerequisite.
    public string depends_on          { get; }

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
        script_install      = Flag(d, "script_install");
        windows_install_dir = OptStr(d, "windows_install_dir");
        unix_install_dir    = OptStr(d, "unix_install_dir");
        depends_on          = OptStr(d, "depends_on");
    }
}
