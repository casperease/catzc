/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/types/SubscriptionAccessState.cs
    folder: types
    name: subscription-access-state
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[SubscriptionAccessState.cs.md](docs/references/pwsh/catzc-azure-cli/types/SubscriptionAccessState.cs.md)"
---
*/

using System;

namespace Catzc.Azure.Cli;

public sealed class SubscriptionAccessState
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

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
