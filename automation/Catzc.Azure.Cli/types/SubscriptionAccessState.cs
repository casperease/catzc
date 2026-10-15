/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/types/SubscriptionAccessState.cs
    kind: type
    module: Catzc.Azure.Cli
    adrs: []
---
*/

// A real ARM probe decides access, not local session state, so this is a point-in-time check of the login.
// [comment:1](/docs/references/automation/catzc-azure-cli/types/SubscriptionAccessState.cs.md#comment1)

using System;

namespace Catzc.Azure.Cli;

public sealed class SubscriptionAccessState
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // On a failed probe this separates not logged in from logged in without access to the subscription.
    // [comment:2](/docs/references/automation/catzc-azure-cli/types/SubscriptionAccessState.cs.md#comment2)
    public bool logged_in { get; }

    // The verdict: true only when the scoped ARM probe against the subscription succeeded.
    public bool accessible { get; }

    // The subscription that was probed (id or name). Always present.
    public string subscription { get; }

    // The az CLI error captured on the failure path. Null when the probe succeeded.
    public string detail { get; }

    public SubscriptionAccessState(bool logged_in, bool accessible, string subscription, string detail)
    {
        if (string.IsNullOrWhiteSpace(subscription)) { throw new ArgumentException("SubscriptionAccessState.subscription is required"); }
        this.logged_in = logged_in;
        this.accessible = accessible;
        this.subscription = subscription;
        this.detail = string.IsNullOrWhiteSpace(detail) ? null : detail;
    }
}
