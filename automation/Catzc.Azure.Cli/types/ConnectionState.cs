// The az CLI session's connection state measured against an expected tenant and/or subscription. Pairs
// what was asked for (expected_*) with what the active session actually has (actual_*) plus the verdict.
// A point-in-time probe of the CLI session, not a config record.

using System;

namespace Catzc.Azure.Cli;

public sealed class ConnectionState
{
    // True when there is any active az login at all.
    public bool   logged_in             { get; }

    // The verdict: true only when every supplied expected_* component matches the active session.
    public bool   connected             { get; }

    // The tenant that was asked for. Null when no tenant constraint was supplied.
    public string expected_tenant       { get; }

    // The subscription that was asked for. Null when no subscription constraint was supplied.
    public string expected_subscription { get; }

    // The tenant the active session is actually on. Null when not applicable (e.g. before login).
    public string actual_tenant         { get; }

    // The subscription the active session is actually on. Null when not applicable (e.g. before login).
    public string actual_subscription   { get; }

    public ConnectionState(bool logged_in, bool connected, string expected_tenant, string expected_subscription, string actual_tenant, string actual_subscription)
    {
        this.logged_in             = logged_in;
        this.connected             = connected;
        this.expected_tenant       = Norm(expected_tenant);
        this.expected_subscription = Norm(expected_subscription);
        this.actual_tenant         = Norm(actual_tenant);
        this.actual_subscription   = Norm(actual_subscription);
    }

    // Blank components collapse to null so an absent constraint reads as null, not "".
    private static string Norm(string s) { return string.IsNullOrWhiteSpace(s) ? null : s; }
}
