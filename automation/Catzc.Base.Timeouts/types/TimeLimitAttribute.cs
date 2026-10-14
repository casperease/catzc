// A function's own time limit, declared beside its code on the param block:
//
//     function Test-Widget {
//         [CmdletBinding()]
//         [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 1800)]
//         param([int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Test-Widget'))
//
// Get-TimeoutSeconds -Command reads it when no config entry overrides it, so a long-running function carries its
// limit with its code and config only states what was tuned
// ([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). The values are
// checked when the attribute is created: whole seconds above zero, the pipeline limit at least the devbox one.

using System;

namespace Catzc.Base.Timeouts;

[AttributeUsage(AttributeTargets.All, AllowMultiple = false)]
public sealed class TimeLimitAttribute : Attribute
{
    private int pipeline;
    private string budget = string.Empty;

    // devbox: the limit in seconds on a devbox. Pipeline defaults to the same value.
    public TimeLimitAttribute(int devbox)
    {
        if (devbox <= 0)
        {
            throw new ArgumentException(string.Format("invalid TimeLimit devbox seconds {0} (must be a positive whole number)", devbox));
        }
        Devbox = devbox;
        pipeline = devbox;
    }

    // The limit in seconds on a devbox.
    public int Devbox { get; }

    // The limit in seconds in a pipeline; at least the devbox limit. Defaults to the devbox limit.
    public int Pipeline
    {
        get { return pipeline; }
        set
        {
            if (value < Devbox)
            {
                throw new ArgumentException(string.Format("invalid TimeLimit Pipeline seconds {0} (must be at least the devbox limit {1})", value, Devbox));
            }
            pipeline = value;
        }
    }

    // The work's immutable budget GUID (managed in guids.yml); while timeout-exemptions.yml exempts it, the
    // exemption's ceiling wins. Empty when the function has no budget.
    public string Budget
    {
        get { return budget; }
        set
        {
            Guid parsed;
            if (!string.IsNullOrEmpty(value) && !Guid.TryParse(value, out parsed))
            {
                throw new ArgumentException(string.Format("invalid TimeLimit Budget '{0}' (must be a GUID)", value));
            }
            budget = value ?? string.Empty;
        }
    }

    // The limit for an environment: devbox | pipeline (case-insensitive).
    public int SecondsFor(string environment)
    {
        string normalized = environment == null ? string.Empty : environment.Trim().ToLowerInvariant();
        if (normalized == "devbox")
        {
            return Devbox;
        }
        if (normalized == "pipeline")
        {
            return Pipeline;
        }
        throw new ArgumentException(string.Format("unknown environment '{0}' (allowed: devbox, pipeline)", environment));
    }
}
