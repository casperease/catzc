/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-cli/types/SubscriptionAccessState.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Azure.Cli;

// Established by a real read-only ARM call, since local session state can claim access the login no longer has.
public sealed class SubscriptionAccessState
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // On a failed probe this tells "not logged in" from "logged in without access", which need different fixes.
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
