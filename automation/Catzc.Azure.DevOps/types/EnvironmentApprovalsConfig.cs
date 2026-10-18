using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps;

public sealed class EnvironmentApprovalsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "environment-approvals configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "approver_group", "timeout_hours", "environments" };

    // The ADO group that approves, named inside the project; the file may override it.
    public const string DefaultApproverGroup = "Prod Approvers";

    // How long a pending approval waits before the run times out; the file may override it.
    public const int DefaultTimeoutHours = 24;

    // ADO's own ceiling for an approval check: 30 days.
    public const int MaxTimeoutHours = 720;

    // The approver group's name inside the project, e.g. 'Prod Approvers' for '[<project>]\Prod Approvers'.
    public string approver_group { get; }

    // How long a pending approval waits, in hours.
    public int timeout_hours { get; }

    // The ADO environments that need an approval before a run deploys to them, in file order.
    public string[] environments { get; }

    public EnvironmentApprovalsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d == null)
        {
            throw new ArgumentException(Failed + "the file must be a mapping with an 'environments' key");
        }

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("Unknown top-level key: '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        approver_group = d.Contains("approver_group") ? OptStr(d, "approver_group") : DefaultApproverGroup;
        if (approver_group == null) { errors.Add("approver_group is empty"); }

        timeout_hours = DefaultTimeoutHours;
        if (d.Contains("timeout_hours"))
        {
            int hours;
            object raw = d["timeout_hours"];
            if (raw == null || !int.TryParse(raw.ToString(), out hours) || hours < 1 || hours > MaxTimeoutHours)
            {
                errors.Add(string.Format("timeout_hours '{0}' must be a whole number from 1 to {1}", raw, MaxTimeoutHours));
            }
            else
            {
                timeout_hours = hours;
            }
        }

        environments = StrArr(d, "environments");
        if (environments.Length == 0)
        {
            errors.Add("environments must be a non-empty list of ADO environment names");
        }
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (string name in environments)
        {
            if (string.IsNullOrWhiteSpace(name)) { errors.Add("environments holds an empty name"); continue; }
            if (!seen.Add(name)) { errors.Add(string.Format("environments lists '{0}' twice", name)); }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException(Failed + string.Join("\n", errors));
        }
    }
}
