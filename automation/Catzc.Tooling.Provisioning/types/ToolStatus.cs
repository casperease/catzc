// One tool's installation status: the locked requirement vs. what's actually on the box, the verdict, and
// where/how it was found. The per-tool row that drives the devbox tools assert/install flow.

using System;

namespace Catzc.Tooling.Provisioning;

public sealed class ToolStatus
{
    // The tool's name (its tools.yml key). Always present.
    public string         Tool      { get; }

    // The version the lock requires. Null when not applicable.
    public string         Locked    { get; }

    // The version actually installed. Null when the tool is not installed (e.g. Missing).
    public string         Installed { get; }

    // The verdict — see ToolStatusKind.
    public ToolStatusKind Status    { get; }

    // Where the installed tool was found on disk. Null when not installed.
    public string         Location  { get; }

    // The package manager the tool was installed with. Null when not applicable.
    public string         Manager   { get; }

    // The install scope (e.g. user/machine). Null when not applicable.
    public string         Scope     { get; }

    // The remediation this status implies (e.g. install/upgrade), for the install flow to act on.
    public string         Action    { get; }

    // Status is taken as a string and parsed to the enum, so the producer's string logic binds directly.
    public ToolStatus(string tool, string locked, string installed, string status, string location, string manager, string scope, string action)
    {
        if (string.IsNullOrWhiteSpace(tool)) { throw new ArgumentException("ToolStatus.Tool is required"); }
        Tool      = tool;
        Locked    = string.IsNullOrWhiteSpace(locked) ? null : locked;
        Installed = string.IsNullOrWhiteSpace(installed) ? null : installed;
        Status    = (ToolStatusKind)Enum.Parse(typeof(ToolStatusKind), status, true);
        Location  = string.IsNullOrWhiteSpace(location) ? null : location;
        Manager   = string.IsNullOrWhiteSpace(manager) ? null : manager;
        Scope     = string.IsNullOrWhiteSpace(scope) ? null : scope;
        Action    = action;
    }
}
