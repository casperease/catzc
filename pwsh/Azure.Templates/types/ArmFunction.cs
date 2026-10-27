// The ARM functions of ArmExpression's subset that read only their evaluated arguments: no scope, no lambda, no copy loop.
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Azure.Templates;

public static class ArmFunction
{
    // ARM function names are case-insensitive; each name of the subset maps to its documented camelCase spelling.
    private static readonly Dictionary<string, string> Known = BuildKnown();

    private static Dictionary<string, string> BuildKnown()
    {
        string[] names =
        {
            "filter", "map", "toObject", "parameters", "variables", "if", "copyIndex", "lambdaVariables", "true", "false", "createArray",
            "equals", "not", "and", "or", "createObject", "add", "sub", "mul", "concat", "objectKeys", "length", "empty", "contains",
            "null", "items", "tryGet", "coalesce", "format", "replace", "join", "tenantResourceId",
        };
        var known = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (string name in names) { known[name] = name; }
        return known;
    }

    // The canonical spelling of a parsed function name; a name outside the subset comes back as written.
    public static string Canonical(string name)
    {
        return Known.TryGetValue(name, out string canonical) ? canonical : name;
    }

    // The value of name(args); Unresolved when an argument is, or the call is outside the subset.
    public static object Call(string name, List<object> args)
    {
        name = Canonical(name);
        if (name == "coalesce") { return Coalesce(args); }
        if (args.Exists(ArmExpression.IsUnresolved)) { return ArmExpression.Unresolved; }
        object unresolved = ArmExpression.Unresolved;
        switch (name)
        {
            case "items":
                // Bicep's `for x in items(o)`: one { key, value } per entry, sorted by key, as ARM's items() returns them.
                if (args.Count != 1 || !(args[0] is IDictionary source)) { return unresolved; }
                var names = new List<string>();
                foreach (object key in source.Keys) { names.Add(key == null ? string.Empty : key.ToString()); }
                names.Sort(StringComparer.OrdinalIgnoreCase);
                var entries = new List<object>();
                foreach (string key in names)
                {
                    var entry = new System.Collections.Specialized.OrderedDictionary(StringComparer.OrdinalIgnoreCase);
                    entry["key"] = key;
                    entry["value"] = source[key];
                    entries.Add(entry);
                }
                return entries.ToArray();
            case "tryGet":
                return TryGet(args);
            case "tenantResourceId":
                // '/providers/<namespace>/<type>/<name>[/<child type>/<name>…]': it reads no deployment scope, so it resolves offline.
                if (args.Count < 2 || !args.TrueForAll(a => a is string)) { return unresolved; }
                string[] typeSegments = ((string)args[0]).Split('/');
                if (typeSegments.Length != args.Count || Array.Exists(typeSegments, string.IsNullOrEmpty)) { return unresolved; }
                var id = new System.Text.StringBuilder("/providers/").Append(typeSegments[0]);
                for (int i = 1; i < typeSegments.Length; i++) { id.Append('/').Append(typeSegments[i]).Append('/').Append((string)args[i]); }
                return id.ToString();
            case "format":
                return Format(args);
            case "replace":
                // Ordinal and case-sensitive, as ARM's.
                if (args.Count != 3 || !(args[0] is string original) || !(args[1] is string old) || !(args[2] is string replacement) || old.Length == 0) { return unresolved; }
                return original.Replace(old, replacement, StringComparison.Ordinal);
            case "join":
                if (args.Count != 2 || !(args[0] is IList parts) || args[0] is string || !(args[1] is string delimiter)) { return unresolved; }
                var texts = new List<string>();
                foreach (object part in parts)
                {
                    if (!(part is string text)) { return unresolved; }
                    texts.Add(text);
                }
                return string.Join(delimiter, texts);
            case "equals":
                return args.Count == 2 ? (object)Same(args[0], args[1]) : unresolved;
            case "not":
                return args.Count == 1 && args[0] is bool ? (object)!(bool)args[0] : unresolved;
            case "and":
            case "or":
                if (args.Count < 2 || !args.TrueForAll(a => a is bool)) { return unresolved; }
                bool and = name == "and";
                foreach (object a in args)
                {
                    if ((bool)a != and) { return !and; }
                }
                return and;
            case "createObject":
                // createObject('key', value, …): Bicep wraps a module's conditional parameter in it, createObject('value', …).
                if (args.Count % 2 != 0) { return unresolved; }
                var created = new System.Collections.Specialized.OrderedDictionary(StringComparer.OrdinalIgnoreCase);
                for (int i = 0; i < args.Count; i += 2)
                {
                    if (!(args[i] is string field)) { return unresolved; }
                    created[field] = args[i + 1];
                }
                return created;
            case "add":
            case "sub":
            case "mul":
                // Integer arithmetic, as ARM's; Bicep writes a + b, a - b and a * b as these calls.
                if (args.Count != 2 || !IsInteger(args[0]) || !IsInteger(args[1])) { return unresolved; }
                long left = Convert.ToInt64(args[0], CultureInfo.InvariantCulture);
                long right = Convert.ToInt64(args[1], CultureInfo.InvariantCulture);
                return name == "add" ? left + right : name == "sub" ? left - right : left * right;
            case "concat":
                // Arrays join into one array, strings into one string; a mix is outside the subset.
                if (args.Count == 0) { return unresolved; }
                if (args.TrueForAll(a => a is string)) { return string.Concat(args); }
                if (!args.TrueForAll(a => a is IList && !(a is string))) { return unresolved; }
                var joined = new List<object>();
                foreach (object a in args)
                {
                    foreach (object item in (IList)a) { joined.Add(item); }
                }
                return joined.ToArray();
            case "objectKeys":
                if (args.Count != 1 || !(args[0] is IDictionary)) { return unresolved; }
                var keys = new List<object>();
                foreach (object key in ((IDictionary)args[0]).Keys) { keys.Add(key == null ? string.Empty : key.ToString()); }
                return keys.ToArray();
            case "length":
                if (args.Count != 1) { return unresolved; }
                if (args[0] is string ls) { return (long)ls.Length; }
                if (args[0] is ICollection lc) { return (long)lc.Count; }
                return unresolved;
            case "empty":
                if (args.Count != 1) { return unresolved; }
                if (args[0] == null) { return true; }
                if (args[0] is string s) { return s.Length == 0; }
                if (args[0] is ICollection collection) { return collection.Count == 0; }
                return unresolved;
            case "contains":
                if (args.Count != 2) { return unresolved; }
                if (args[0] is string container) { return args[1] is string part ? (object)(container.IndexOf(part, StringComparison.OrdinalIgnoreCase) >= 0) : unresolved; }
                if (args[0] is IDictionary map) { return args[1] is string key ? (object)map.Contains(key) : unresolved; }
                if (args[0] is IEnumerable items)
                {
                    foreach (object item in items)
                    {
                        if (Same(item, args[1])) { return true; }
                    }
                    return false;
                }
                return unresolved;
            default:
                return unresolved;
        }
    }

    // The first argument that is not null, which Bicep's `a ?? b` compiles to; an unresolved argument before it leaves the value unknown.
    private static object Coalesce(List<object> args)
    {
        foreach (object a in args)
        {
            if (ArmExpression.IsUnresolved(a)) { return ArmExpression.Unresolved; }
            if (a != null) { return a; }
        }
        return null;
    }

    // tryGet(o, key, …): each key reads an object's property or an array's index, and a missing one is null, which Bicep's `o.?key` compiles to.
    private static object TryGet(List<object> args)
    {
        if (args.Count < 2) { return ArmExpression.Unresolved; }
        object current = args[0];
        for (int i = 1; i < args.Count; i++)
        {
            if (current == null) { return null; }
            if (current is IDictionary map && args[i] is string name)
            {
                object found = null;
                foreach (object k in map.Keys)
                {
                    if (string.Equals(k == null ? null : k.ToString(), name, StringComparison.OrdinalIgnoreCase)) { found = map[k]; break; }
                }
                current = found;
                continue;
            }
            if (current is IList list && !(current is string) && IsInteger(args[i]))
            {
                long index = Convert.ToInt64(args[i], CultureInfo.InvariantCulture);
                current = index >= 0 && index < list.Count ? list[(int)index] : null;
                continue;
            }
            return ArmExpression.Unresolved;
        }
        return current;
    }

    // format('…{0}…', a, …), which Bicep string interpolation compiles to: plain {n} holes and {{ }} escapes over string and integer
    // arguments; a format specifier or another argument kind is outside the subset, since its text depends on ARM's formatter.
    private static object Format(List<object> args)
    {
        if (args.Count < 1 || !(args[0] is string pattern)) { return ArmExpression.Unresolved; }
        var builder = new System.Text.StringBuilder();
        int i = 0;
        while (i < pattern.Length)
        {
            char c = pattern[i];
            if (c == '{' && i + 1 < pattern.Length && pattern[i + 1] == '{') { builder.Append('{'); i += 2; continue; }
            if (c == '}' && i + 1 < pattern.Length && pattern[i + 1] == '}') { builder.Append('}'); i += 2; continue; }
            if (c == '}') { return ArmExpression.Unresolved; }
            if (c != '{') { builder.Append(c); i++; continue; }
            int close = pattern.IndexOf('}', i);
            if (close < 0 || !int.TryParse(pattern.Substring(i + 1, close - i - 1), NumberStyles.None, CultureInfo.InvariantCulture, out int hole)) { return ArmExpression.Unresolved; }
            if (hole + 1 >= args.Count) { return ArmExpression.Unresolved; }
            object value = args[hole + 1];
            if (value is string text) { builder.Append(text); }
            else if (IsInteger(value)) { builder.Append(Convert.ToInt64(value, CultureInfo.InvariantCulture).ToString(CultureInfo.InvariantCulture)); }
            else { return ArmExpression.Unresolved; }
            i = close + 1;
        }
        return builder.ToString();
    }

    // ARM compares strings without regard to case; numbers by value.
    private static bool Same(object a, object b)
    {
        if (a is string sa && b is string sb) { return string.Equals(sa, sb, StringComparison.OrdinalIgnoreCase); }
        if (a is bool ba && b is bool bb) { return ba == bb; }
        if (IsNumber(a) && IsNumber(b)) { return Convert.ToDecimal(a, CultureInfo.InvariantCulture) == Convert.ToDecimal(b, CultureInfo.InvariantCulture); }
        return Equals(a, b);
    }

    // A JSON number as the template reader holds it.
    public static bool IsNumber(object value)
    {
        return value is int || value is long || value is double || value is decimal;
    }

    private static bool IsInteger(object value)
    {
        return value is int || value is long;
    }
}
