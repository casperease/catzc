using System;
using System.Collections;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

// One derived name of an each entry's item: which slot renders it (the item's own, or the slot holding the list) and its role.
public sealed class BicepItemName
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "type", "role", "role_from", "from" };

    // The slots that may render an item name: the item's own slot, or the slot whose parameter holds the item.
    public static readonly string[] FromSlots = { "item", "self" };

    // The role sources: the customer shortcode of the item's slot.
    public static readonly string[] RoleSources = { "customer_shortcode" };

    public string type { get; }

    public string role { get; }

    public string role_from { get; }

    // item by default.
    public string from { get; } = "item";

    public BicepItemName(string at, object raw)
    {
        IDictionary d = raw as IDictionary;
        if (d == null) { throw new ArgumentException(at + " must be a mapping of type, and optionally role or role_from, and from"); }
        foreach (object k in d.Keys)
        {
            if (Array.IndexOf(AllowedKeys, k == null ? null : k.ToString()) < 0)
            {
                throw new ArgumentException(string.Format("{0}: unknown key '{1}' (allowed: {2})", at, k, string.Join(", ", AllowedKeys)));
            }
        }
        type = d.Contains("type") && d["type"] != null ? d["type"].ToString() : null;
        if (type == null || !Regex.IsMatch(type, "^[a-z]{2,5}$")) { throw new ArgumentException(at + ": type must be the namer's resource type key"); }
        role = d.Contains("role") && d["role"] != null ? d["role"].ToString() : null;
        if (role != null && !Regex.IsMatch(role, "^[a-z][a-z0-9]{1,2}$")) { throw new ArgumentException(string.Format("{0}: role '{1}' must be 2-3 alphanumeric, leading letter, lowercase", at, role)); }
        role_from = d.Contains("role_from") && d["role_from"] != null ? d["role_from"].ToString() : null;
        if (role_from != null && Array.IndexOf(RoleSources, role_from) < 0)
        {
            throw new ArgumentException(string.Format("{0}: unknown role_from '{1}' (allowed: {2})", at, role_from, string.Join(", ", RoleSources)));
        }
        if (role != null && role_from != null) { throw new ArgumentException(at + ": role and role_from exclude each other"); }
        if (d.Contains("from") && d["from"] != null)
        {
            from = d["from"].ToString();
            if (Array.IndexOf(FromSlots, from) < 0) { throw new ArgumentException(string.Format("{0}: unknown from '{1}' (allowed: {2})", at, from, string.Join(", ", FromSlots))); }
        }
    }
}
