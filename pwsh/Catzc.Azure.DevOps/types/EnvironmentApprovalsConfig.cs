using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps;

public sealed class EnvironmentApprovalsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "environment-approvals configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "approver_group", "timeout_hours", "environments" };
    private static readonly string[] GroupKeys = { "name", "description", "members" };

    // The approver group's name inside the project when the file names none.
    public const string DefaultApproverGroup = "Prod Approvers";

    // The approver group's description when the file gives none.
    public const string DefaultApproverDescription = "Approves deploys to the prod-tier environments; synced from environment-approvals.yml.";

    // How long a pending approval waits before the run times out, when the file sets no timeout_hours.
    public const int DefaultTimeoutHours = 24;

    // ADO's own ceiling for an approval check: 30 days.
    public const int MaxTimeoutHours = 720;

    // The approver group's name inside the project, e.g. 'Prod Approvers' for '[<project>]\Prod Approvers'.
    public string approver_group { get; }

    // The approver group's description, set when the apply creates or updates the group.
    public string approver_description { get; }

    // The group's members by principal name (e.g. 'person@example.com'), in file order; the apply makes the group hold exactly these.
    public string[] approver_members { get; }

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

        approver_group = DefaultApproverGroup;
        approver_description = DefaultApproverDescription;
        approver_members = new string[0];
        if (d.Contains("approver_group"))
        {
            IDictionary group = d["approver_group"] as IDictionary;
            if (group == null)
            {
                errors.Add("approver_group must be a mapping of name, description, members");
            }
            else
            {
                foreach (object k in group.Keys)
                {
                    string key = k == null ? null : k.ToString();
                    if (Array.IndexOf(GroupKeys, key) < 0)
                    {
                        errors.Add(string.Format("Unknown approver_group key: '{0}' (allowed: {1})", key, string.Join(", ", GroupKeys)));
                    }
                }
                if (group.Contains("name"))
                {
                    approver_group = OptStr(group, "name");
                    if (approver_group == null) { errors.Add("approver_group.name is empty"); }
                }
                if (group.Contains("description"))
                {
                    approver_description = OptStr(group, "description");
                    if (approver_description == null) { errors.Add("approver_group.description is empty"); }
                }
                approver_members = StrArr(group, "members");
                HashSet<string> members = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                foreach (string member in approver_members)
                {
                    if (string.IsNullOrWhiteSpace(member)) { errors.Add("approver_group.members holds an empty name"); continue; }
                    if (!members.Add(member)) { errors.Add(string.Format("approver_group.members lists '{0}' twice", member)); }
                }
            }
        }

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
