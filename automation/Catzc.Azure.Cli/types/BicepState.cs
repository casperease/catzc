// The Bicep CLI's installation state measured against the configured minimum version. A point-in-time
// probe of the local toolchain, not a config record.

using System;

namespace Catzc.Azure.Cli;

public sealed class BicepState
{
    // True when a Bicep CLI is present (a version was obtained).
    public bool    installed     { get; }

    // The parsed installed version. Null when Bicep is absent or its version output was unparseable.
    public Version version       { get; }

    // The required floor — the configured minimum Bicep version. Always present.
    public Version min_version   { get; }

    // True only when an installed, parseable version is at or above min_version.
    public bool    meets_minimum { get; }

    public BicepState(bool installed, Version version, Version min_version, bool meets_minimum)
    {
        if (min_version == null) { throw new ArgumentException("BicepState.min_version is required"); }
        this.installed     = installed;
        this.version       = version;
        this.min_version   = min_version;
        this.meets_minimum = meets_minimum;
    }
}
