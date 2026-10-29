using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

public static class AzureNameMatcher
{
    public const string RolePattern = "^[a-z][a-z0-9]{1,2}$";

    private const string Hole = "\u0000";

    private static readonly string[] Parts = { "env", "slot", "region", "org", "short_name", "customer", "type" };

    // Returns the components of the one match; throws with a per-part diagnosis on none and with every match on more than one.
    public static OrderedDictionary Match(string name, string ident, IDictionary candidateSets, IEnumerable order)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("A name to match is required", nameof(name)); }
        if (candidateSets == null) { throw new ArgumentNullException(nameof(candidateSets)); }
        if (order == null) { throw new ArgumentNullException(nameof(order)); }
        IDictionary types = Required(candidateSets, "types");
        IDictionary patterns = Required(candidateSets, "patterns");
        List<string> typeKeys = TypeKeys(types, ident);
        Dictionary<string, OrderedDictionary> matches = new Dictionary<string, OrderedDictionary>();
        Dictionary<string, SortedSet<string>> tokens = Parts.ToDictionary(part => part, part => new SortedSet<string>(StringComparer.Ordinal));
        SortedSet<string> leftovers = new SortedSet<string>(StringComparer.Ordinal);
        foreach (string candidate in typeKeys)
        {
            IDictionary typeSpec = types[candidate] as IDictionary
                ?? throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "Type '{0}' has no specification", candidate));
            string patternName = typeSpec.Contains("pattern") && typeSpec["pattern"] != null ? typeSpec["pattern"].ToString() : "long";
            IDictionary pattern = patterns.Contains(patternName) ? patterns[patternName] as IDictionary : null;
            if (pattern == null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "Type '{0}' references unknown name pattern '{1}'",
                    candidate, patternName));
            }
            List<List<KeyValuePair<string, string>>> sets = Sets(candidateSets, candidate, typeSpec, patternName);
            for (int index = 0; index < Parts.Length; index++)
            {
                foreach (KeyValuePair<string, string> option in sets[index]) { if (option.Value.Length > 0) { tokens[Parts[index]].Add(option.Value); } }
            }
            bool roleOmitted = AzureNameRenderer.Omit(typeSpec).Contains("role");
            Walk(sets, 0, new Hashtable(), new Hashtable(), combination =>
                Try(name, combination.Item1, combination.Item2, order, typeSpec, pattern, roleOmitted, matches, leftovers));
        }
        if (matches.Count == 1) { return matches.Values.First(); }
        if (matches.Count == 0) { throw new ArgumentException(Diagnose(name, tokens, leftovers)); }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "Name '{0}' is ambiguous: it matches {1} canonical forms: {2}",
            name, matches.Count, string.Join("; ", matches.Keys.OrderBy(key => key, StringComparer.Ordinal))));
    }

    private static void Try(string name, Hashtable rendered, Hashtable values, IEnumerable order, IDictionary typeSpec, IDictionary pattern,
        bool roleOmitted, Dictionary<string, OrderedDictionary> matches, SortedSet<string> leftovers)
    {
        rendered["role"] = string.Empty;
        if (AzureNameRenderer.Join(rendered, order, typeSpec, pattern) == name) { Add(matches, values, string.Empty); }
        if (roleOmitted) { return; }
        rendered["role"] = Hole;
        string framed = AzureNameRenderer.Join(rendered, order, typeSpec, pattern);
        int at = framed.IndexOf(Hole, StringComparison.Ordinal);
        if (at < 0) { return; }
        string prefix = framed.Substring(0, at);
        string suffix = framed.Substring(at + 1);
        if (name.Length <= prefix.Length + suffix.Length) { return; }
        if (!name.StartsWith(prefix, StringComparison.Ordinal) || !name.EndsWith(suffix, StringComparison.Ordinal)) { return; }
        string role = name.Substring(prefix.Length, name.Length - prefix.Length - suffix.Length);
        if (Regex.IsMatch(role, RolePattern)) { Add(matches, values, role); } else { leftovers.Add(role); }
    }

    private static void Add(Dictionary<string, OrderedDictionary> matches, Hashtable values, string role)
    {
        OrderedDictionary components = new OrderedDictionary();
        foreach (string part in new[] { "env", "slot", "region", "org", "short_name", "customer", "role", "type" })
        {
            components[part] = part == "role" ? role : (string)values[part];
        }
        string key = string.Join(" ", components.Keys.Cast<string>()
            .Where(part => ((string)components[part]).Length > 0)
            .Select(part => part + "=" + components[part]));
        matches[key] = components;
    }

    private static List<List<KeyValuePair<string, string>>> Sets(IDictionary candidateSets, string ident, IDictionary typeSpec, string patternName)
    {
        List<string> omit = AzureNameRenderer.Omit(typeSpec);
        List<List<KeyValuePair<string, string>>> sets = new List<List<KeyValuePair<string, string>>>();
        foreach (string part in Parts)
        {
            List<KeyValuePair<string, string>> set = new List<KeyValuePair<string, string>>();
            if (part == "slot" || part == "customer" || omit.Contains(part)) { set.Add(new KeyValuePair<string, string>(string.Empty, string.Empty)); }
            if (part == "type") { set.Add(new KeyValuePair<string, string>(ident, ident)); }
            else if (!omit.Contains(part) && candidateSets.Contains(part) && candidateSets[part] != null)
            {
                object source = candidateSets[part];
                if (source is IDictionary forms)
                {
                    foreach (DictionaryEntry entry in forms)
                    {
                        string value = entry.Key.ToString();
                        string shortcode = entry.Value == null ? value : entry.Value.ToString();
                        set.Add(new KeyValuePair<string, string>(value, AzureNameRenderer.ComponentForm(patternName, value, shortcode)));
                    }
                }
                else if (source is IEnumerable list && !(source is string))
                {
                    foreach (object item in list) { if (item != null && item.ToString().Length > 0) { set.Add(Pair(item.ToString())); } }
                }
                else { set.Add(Pair(source.ToString())); }
            }
            sets.Add(set);
        }
        return sets;
    }

    private static KeyValuePair<string, string> Pair(string value) => new KeyValuePair<string, string>(value, value);

    private static void Walk(List<List<KeyValuePair<string, string>>> sets, int index, Hashtable rendered, Hashtable values,
        Action<Tuple<Hashtable, Hashtable>> visit)
    {
        if (index == Parts.Length) { visit(Tuple.Create(rendered, values)); return; }
        foreach (KeyValuePair<string, string> option in sets[index])
        {
            values[Parts[index]] = option.Key;
            rendered[Parts[index]] = option.Value;
            Walk(sets, index + 1, rendered, values, visit);
        }
    }

    private static string Diagnose(string name, Dictionary<string, SortedSet<string>> tokens, SortedSet<string> leftovers)
    {
        List<string> lines = new List<string>
        {
            string.Format(CultureInfo.InvariantCulture, "Name '{0}' matches no canonical form under the given order:", name)
        };
        foreach (string part in Parts)
        {
            List<string> found = tokens[part].Where(token => name.Contains(token)).ToList();
            if (found.Count > 0) { lines.Add(string.Format(CultureInfo.InvariantCulture, "  {0}: found '{1}'", part, string.Join("', '", found))); }
            else if (part == "slot" || part == "customer") { lines.Add(string.Format(CultureInfo.InvariantCulture, "  {0}: absent", part)); }
            else
            {
                lines.Add(string.Format(CultureInfo.InvariantCulture, "  {0}: none of ({1}) in the name", part, string.Join(", ", tokens[part])));
            }
        }
        lines.Add(leftovers.Count > 0
            ? string.Format(CultureInfo.InvariantCulture, "  role: leftover '{0}' is not {1}", string.Join("', '", leftovers), RolePattern)
            : "  role: no render of the other parts frames the name");
        return string.Join(Environment.NewLine, lines);
    }

    private static List<string> TypeKeys(IDictionary types, string ident)
    {
        if (string.IsNullOrEmpty(ident)) { return types.Keys.Cast<object>().Select(key => key.ToString()).ToList(); }
        if (!types.Contains(ident))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "Unknown resource type '{0}' (known: {1})", ident,
                string.Join(", ", types.Keys.Cast<object>())));
        }
        return new List<string> { ident };
    }

    private static IDictionary Required(IDictionary candidateSets, string key)
    {
        return candidateSets.Contains(key) && candidateSets[key] is IDictionary set
            ? set
            : throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "The candidate sets hold no '{0}' map", key));
    }
}
