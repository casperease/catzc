using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

// One derived name of a template: the slot parameter it fills, and what the namer renders it from. A slot never writes it.
public sealed class BicepNameEntry
{
    // The owner slots an entry may name instead of its own: the hub serving the slot's subscription.
    public static readonly string[] OwnerSlots = { "hub" };

    private static readonly string[] AllowedKeys = { "type", "role", "template", "owner_slot", "roles", "keys_from", "each", "names" };

    // What an each entry's items are keyed by: the subscription of the slot of the same template that owns the item.
    public static readonly string[] EachKeys = { "subscription" };

    // An array (or one object) of items, each naming another slot of this template by `each`; null for any other entry.
    public string each { get; }

    // The derived names of each item, keyed by the item's field; empty unless each is set.
    public IReadOnlyDictionary<string, BicepItemName> item_names { get; } = new Dictionary<string, BicepItemName>(StringComparer.Ordinal);

    // Where a roles entry takes its keys instead of every key of its roles map: the slot's subnets that carry an NSG.
    public static readonly string[] KeySources = { "nsg_subnets" };

    // An object parameter, one derived name per key, each key with its own role; empty for a plain name.
    public IReadOnlyDictionary<string, string> roles { get; } = new Dictionary<string, string>(StringComparer.Ordinal);

    // The key source of a roles entry (nsg_subnets); null when the keys are every key of roles.
    public string keys_from { get; }

    // The slot parameter the name fills.
    public string parameter { get; }

    // The namer's resource type key (rg, st, pep, ...).
    public string type { get; }

    // The 2-3 character role segment; null when the name has none.
    public string role { get; }

    // The template that owns the named resource; null when it is the declaring template.
    public string template { get; }

    // The owner slot by kind (hub); null for the owner's slot on the same subscription.
    public string owner_slot { get; }

    public BicepNameEntry(string parameterName, object raw, string templateName)
    {
        string at = string.Format("template '{0}' names.{1}", templateName, parameterName);
        if (string.IsNullOrWhiteSpace(parameterName) || !Regex.IsMatch(parameterName, "^[a-z][A-Za-z0-9]*$"))
        {
            throw new ArgumentException(string.Format("template '{0}': names key '{1}' is not a parameter name", templateName, parameterName));
        }
        IDictionary d = raw as IDictionary;
        if (d == null) { throw new ArgumentException(at + " must be a mapping of type, and optionally role, template and owner_slot"); }
        foreach (object k in d.Keys)
        {
            if (Array.IndexOf(AllowedKeys, k == null ? null : k.ToString()) < 0)
            {
                throw new ArgumentException(string.Format("{0}: unknown key '{1}' (allowed: {2})", at, k, string.Join(", ", AllowedKeys)));
            }
        }
        parameter = parameterName;
        if (d.Contains("each"))
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (key != "each" && key != "names") { throw new ArgumentException(string.Format("{0}: an each entry holds only each and names, not '{1}'", at, key)); }
            }
            each = Opt(d, "each");
            if (each == null || Array.IndexOf(EachKeys, each) < 0)
            {
                throw new ArgumentException(string.Format("{0}: unknown each '{1}' (allowed: {2})", at, each, string.Join(", ", EachKeys)));
            }
            IDictionary names = d.Contains("names") ? d["names"] as IDictionary : null;
            if (names == null || names.Count == 0) { throw new ArgumentException(at + ": an each entry needs names, a mapping of item field to its name"); }
            var items = new Dictionary<string, BicepItemName>(StringComparer.Ordinal);
            foreach (object k in names.Keys)
            {
                string field = k == null ? string.Empty : k.ToString();
                items[field] = new BicepItemName(at + ".names." + field, names[k]);
            }
            item_names = items;
            return;
        }
        if (d.Contains("names")) { throw new ArgumentException(at + ": names belongs to an each entry"); }
        type = d.Contains("type") && d["type"] != null ? d["type"].ToString() : null;
        if (type == null || !Regex.IsMatch(type, "^[a-z]{2,5}$")) { throw new ArgumentException(at + ": type must be the namer's resource type key"); }
        role = Opt(d, "role");
        if (role != null && !Regex.IsMatch(role, "^[a-z][a-z0-9]{1,2}$")) { throw new ArgumentException(string.Format("{0}: role '{1}' must be 2-3 alphanumeric, leading letter, lowercase", at, role)); }
        template = Opt(d, "template");
        owner_slot = Opt(d, "owner_slot");
        if (owner_slot != null && Array.IndexOf(OwnerSlots, owner_slot) < 0)
        {
            throw new ArgumentException(string.Format("{0}: unknown owner_slot '{1}' (allowed: {2})", at, owner_slot, string.Join(", ", OwnerSlots)));
        }
        if (owner_slot != null && template == null) { throw new ArgumentException(at + ": owner_slot names a slot of another template, so it needs template"); }
        if (d.Contains("roles") && d["roles"] != null)
        {
            IDictionary map = d["roles"] as IDictionary;
            if (map == null || map.Count == 0) { throw new ArgumentException(at + ": roles must be a non-empty mapping of key to its 2-3 character role"); }
            if (role != null) { throw new ArgumentException(at + ": role and roles exclude each other; a roles entry names one role per key"); }
            var keyed = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (object k in map.Keys)
            {
                string key = k == null ? string.Empty : k.ToString();
                string keyRole = map[k] == null ? string.Empty : map[k].ToString();
                if (!Regex.IsMatch(keyRole, "^[a-z][a-z0-9]{1,2}$")) { throw new ArgumentException(string.Format("{0}: roles['{1}'] '{2}' must be 2-3 alphanumeric, leading letter, lowercase", at, key, keyRole)); }
                keyed[key] = keyRole;
            }
            roles = keyed;
        }
        keys_from = Opt(d, "keys_from");
        if (keys_from != null && Array.IndexOf(KeySources, keys_from) < 0)
        {
            throw new ArgumentException(string.Format("{0}: unknown keys_from '{1}' (allowed: {2})", at, keys_from, string.Join(", ", KeySources)));
        }
        if (keys_from != null && roles.Count == 0) { throw new ArgumentException(at + ": keys_from picks the keys of a roles entry, so it needs roles"); }
    }

    private static string Opt(IDictionary d, string key)
    {
        return d.Contains(key) && d[key] != null && d[key].ToString().Length > 0 ? d[key].ToString() : null;
    }

    // The entries of an options.yml names section, keyed by parameter; an absent section is empty.
    public static IReadOnlyDictionary<string, BicepNameEntry> ReadAll(object raw, string templateName)
    {
        var entries = new Dictionary<string, BicepNameEntry>(StringComparer.Ordinal);
        if (raw == null) { return entries; }
        IDictionary d = raw as IDictionary;
        if (d == null) { throw new ArgumentException(string.Format("template '{0}': names must be a mapping of parameter to its name entry", templateName)); }
        foreach (object k in d.Keys)
        {
            string key = k == null ? string.Empty : k.ToString();
            entries[key] = new BicepNameEntry(key, d[k], templateName);
        }
        return entries;
    }
}
