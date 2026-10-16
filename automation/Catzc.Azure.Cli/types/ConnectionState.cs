/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/types/ConnectionState.cs
    folder: types
    name: connection-state
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure-cli/types/ConnectionState.cs.md
---
*/

using System;

namespace Catzc.Azure.Cli;

public sealed class ConnectionState
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // True when there is any active az login at all.
    public bool logged_in { get; }

    // The verdict: true only when every supplied expected_* component matches the active session.
    public bool connected { get; }

    // The tenant that was asked for. Null when no tenant constraint was supplied.
    public string expected_tenant { get; }

    // The subscription that was asked for. Null when no subscription constraint was supplied.
    public string expected_subscription { get; }

    // The tenant the active session is actually on. Null when not applicable (e.g. before login).
    public string actual_tenant { get; }

    // The subscription the active session is actually on. Null when not applicable (e.g. before login).
    public string actual_subscription { get; }

    public ConnectionState(bool logged_in, bool connected, string expected_tenant, string expected_subscription, string actual_tenant, string actual_subscription)
    {
        this.logged_in = logged_in;
        this.connected = connected;
        this.expected_tenant = Norm(expected_tenant);
        this.expected_subscription = Norm(expected_subscription);
        this.actual_tenant = Norm(actual_tenant);
        this.actual_subscription = Norm(actual_subscription);
    }

    // Blank components collapse to null so an absent constraint reads as null, not "".
    private static string Norm(string s) { return string.IsNullOrWhiteSpace(s) ? null : s; }
}
