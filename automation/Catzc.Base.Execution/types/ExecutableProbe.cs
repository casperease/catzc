// One executable's existence check (Find-Executable): where the executable was found and how, the version it
// reports against the required one, how long each step took, and the session actor the check ran as.
// Resolve-ToolExecutable returns one for a tools.yml entry, and so does Test-Tool -PassThru.
//
// Constructing an instance validates it: Name is required, Method is one of probe | path | none, and a found
// executable carries a Path while a missing one carries none.

using System;

namespace Catzc.Base.Execution;

public sealed class ExecutableProbe
{
    private static readonly string[] Methods = { "probe", "path", "none" };

    // The name the executable was looked for by (a tools.yml key, for a tool). Always present.
    public string Name      { get; }

    // True when an executable was located.
    public bool   Found     { get; }

    // The located executable's full path. Null when not found.
    public string Path      { get; }

    // How it was located: "probe" (a candidate path exists), "path" (found on PATH), or "none".
    public string Method    { get; }

    // The version the executable reports, parsed by the version pattern. Null when not found or when the output
    // does not match.
    public string Version   { get; }

    // The required version prefix the reported one must start with.
    public string Required  { get; }

    // True when Version starts with Required, or with one of the additionally accepted prefixes.
    public bool   VersionOk { get; }

    // Milliseconds spent locating the executable (file checks and the PATH lookup; no process start).
    public long   ProbeMs   { get; }

    // Milliseconds spent running the version command. 0 when nothing was found, or when the version came from
    // the session cache (no process was started).
    public long   VersionMs { get; }

    // The session actor the check ran as: Pipeline, Agent, or Person.
    public string Actor     { get; }

    public ExecutableProbe(string name, string path, string method, string version, string required, bool versionOk,
        long probeMs, long versionMs, string actor)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("ExecutableProbe.Name is required"); }
        if (Array.IndexOf(Methods, method) < 0)
        {
            throw new ArgumentException(string.Format("ExecutableProbe.Method '{0}' must be one of: {1}", method, string.Join(", ", Methods)));
        }
        bool found = !string.IsNullOrWhiteSpace(path);
        if (found == (method == "none"))
        {
            throw new ArgumentException(string.Format("ExecutableProbe for '{0}': Method '{1}' does not agree with Path '{2}'", name, method, path));
        }
        Name      = name;
        Found     = found;
        Path      = found ? path : null;
        Method    = method;
        Version   = string.IsNullOrWhiteSpace(version) ? null : version;
        Required  = required;
        VersionOk = versionOk;
        ProbeMs   = probeMs;
        VersionMs = versionMs;
        Actor     = actor;
    }
}
