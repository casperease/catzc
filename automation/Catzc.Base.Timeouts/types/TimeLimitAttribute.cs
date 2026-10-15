/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Timeouts/types/TimeLimitAttribute.cs
    kind: csharp-type
    module: Catzc.Base.Timeouts
    adrs:
      - ADR-PWSH-ASSERT#1
---
*/

// The values are checked on creation: whole seconds above zero, and the pipeline limit no lower than the devbox one.
// [comment:1](/docs/references/automation/catzc-base-timeouts/types/TimeLimitAttribute.cs.md#comment1)

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

    // An exempt budget makes the exemption ceiling win over the declared limit; empty when the function has no budget.
    // [comment:2](/docs/references/automation/catzc-base-timeouts/types/TimeLimitAttribute.cs.md#comment2)
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
