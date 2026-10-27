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
        if (args.Exists(ArmExpression.IsUnresolved)) { return ArmExpression.Unresolved; }
        object unresolved = ArmExpression.Unresolved;
        name = Canonical(name);
        switch (name)
        {
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
