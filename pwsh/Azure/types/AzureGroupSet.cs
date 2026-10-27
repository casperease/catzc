using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure;

// The Entra groups of one owner (a customer or shared) in one environment class: the object id each standard role assignment goes to.
public sealed class AzureGroupSet : Catzc.Base.Objects.DictionaryRecord
{
    // The group roles the templates assign to, declared once; a key outside them is a violation.
    public static readonly string[] GroupRoles = { "readers", "operators", "data_readers", "data_writers" };

    // Read the subscription's resources. Null when absent: the templates assign nothing to it.
    public string readers { get; }

    // Manage the subscription's resources and grant the data roles. Null when absent.
    public string operators { get; }

    // Read the workload's blob data. Null when absent.
    public string data_readers { get; }

    // Read and write the workload's blob data and read its vault's secrets. Null when absent.
    public string data_writers { get; }

    public AzureGroupSet(string where, IDictionary d, List<string> errors)
    {
        if (d == null)
        {
            errors.Add(string.Format("{0} must be a map of group role ({1}) to an Entra group object id", where, string.Join(", ", GroupRoles)));
            return;
        }
        AzureConfig.UnknownKeys(d, GroupRoles, where, errors);
        readers = GroupId(d, "readers", where, errors);
        operators = GroupId(d, "operators", where, errors);
        data_readers = GroupId(d, "data_readers", where, errors);
        data_writers = GroupId(d, "data_writers", where, errors);
    }

    private static string GroupId(IDictionary d, string role, string where, List<string> errors)
    {
        if (!d.Contains(role)) { return null; }
        string id = AzureConfig.Text(d[role]);
        if (AzureConfig.IsGuid(id)) { return id; }
        errors.Add(string.Format("{0}.{1}: '{2}' is not an Entra group object id (a GUID)", where, role, id));
        return null;
    }
}
