// Whether the current az CLI login can actually reach a given subscription, established by a real,
// read-only ARM probe (not just by inspecting local session state). A point-in-time access check.

using System;

namespace Catzc.Azure.Cli;

public sealed class SubscriptionAccessState
{
    // True when there is any active az login at all. On the failure path this separates "not logged in"
    // from "logged in but no access to this subscription".
    public bool   logged_in    { get; }

    // The verdict: true only when the scoped ARM probe against the subscription succeeded.
    public bool   accessible   { get; }

    // The subscription that was probed (id or name). Always present.
    public string subscription { get; }

    // The az CLI error captured on the failure path. Null when the probe succeeded.
    public string detail       { get; }

    public SubscriptionAccessState(bool logged_in, bool accessible, string subscription, string detail)
    {
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("SubscriptionAccessState.subscription is required"); }
        this.logged_in    = logged_in;
        this.accessible   = accessible;
        this.subscription = subscription;
        this.detail       = string.IsNullOrWhiteSpace(detail) ? null : detail;
    }
}
