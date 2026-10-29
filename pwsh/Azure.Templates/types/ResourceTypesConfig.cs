// The resource types the Azure namer knows and the render patterns they tie to; every default is declared once here ([PDR-CONFIG-DEFAULTDECLAREDONCE](/docs/drs/principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

public sealed class ResourceTypesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "resource-types configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "patterns", "types", "not_names" };
    private static readonly string[] PatternKeys = { "separator", "limit" };
    private static readonly string[] TypeKeys = { "pattern", "charset", "limit", "omit" };
    private static readonly string[] OmittableComponents = { "env", "slot", "region", "org", "short_name", "customer", "role" };
    private static readonly Regex PatternName = new Regex("^[a-z]+$", RegexOptions.CultureInvariant);
    private static readonly Regex Ident = new Regex("^[a-z]{2,5}$", RegexOptions.CultureInvariant);
    private static readonly Regex CharacterClass = new Regex(@"^\[[^\[\]]+\]$", RegexOptions.CultureInvariant);
    private static readonly Regex NameSuffix = new Regex("^[A-Z][A-Za-z0-9]*Names?$", RegexOptions.CultureInvariant);

    // The render pattern a type takes when its line names none: hyphenated, generous, the type carrying its own limit.
    public const string DefaultPattern = "long";

    // The characters a name of the type may hold when its line names none: lowercase letters, digits and hyphens.
    public const string DefaultCharset = "[a-z0-9-]";

    // Pattern name -> { separator, limit when the pattern binds one }, in file order.
    public OrderedDictionary patterns { get; }

    // Type ident -> { pattern, charset, limit when the type declares one, omit when it drops components }, in file order.
    public OrderedDictionary types { get; }

    // The slot-parameter key suffixes that end in Name or Names yet hold no resource name: a SKU, a pinned subnet.
    public static readonly IReadOnlyList<string> DefaultNotNames = new[] { "SkuName", "SubnetName" };

    // The key suffixes the name gate skips; DefaultNotNames when the file names none.
    public IReadOnlyList<string> not_names { get; }

    public ResourceTypesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        patterns = Patterns(raw.Contains("patterns") ? raw["patterns"] : null, errors);
        types = Types(raw.Contains("types") ? raw["types"] : null, patterns, errors);
        not_names = raw.Contains("not_names") ? NotNames(raw["not_names"], errors) : DefaultNotNames;
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static OrderedDictionary Patterns(object value, List<string> errors)
    {
        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        IDictionary source = value as IDictionary;
        if (source == null || source.Count == 0)
        {
            errors.Add("'patterns' is required: a non-empty map of <name>: { separator [, limit] }");
            return map;
        }
        foreach (object k in source.Keys)
        {
            string name = k == null ? string.Empty : k.ToString();
            string at = "patterns." + name;
            IDictionary entry = source[k] as IDictionary;
            if (!PatternName.IsMatch(name)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: a pattern name is lowercase letters", at)); continue; }
            if (entry == null) { errors.Add(at + " must be a mapping of separator [, limit]"); continue; }
            UnknownKeys(at, entry, PatternKeys, errors);
            if (!entry.Contains("separator") || !(entry["separator"] is string separator) || separator.Length > 1)
            {
                errors.Add(at + ": separator is required, one character or '' for a joined render");
                continue;
            }
            Hashtable pattern = new Hashtable(StringComparer.Ordinal) { { "separator", separator } };
            if (entry.Contains("limit"))
            {
                int? limit = Limit(at, entry["limit"], errors);
                if (limit == null) { continue; }
                pattern["limit"] = limit.Value;
            }
            map[name] = pattern;
        }
        return map;
    }

    private static OrderedDictionary Types(object value, OrderedDictionary patterns, List<string> errors)
    {
        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        IDictionary source = value as IDictionary;
        if (source == null || source.Count == 0)
        {
            errors.Add("'types' is required: a non-empty map of <ident>: { [pattern] [, charset] [, limit] [, omit] }");
            return map;
        }
        foreach (object k in source.Keys)
        {
            string ident = k == null ? string.Empty : k.ToString();
            string at = "types." + ident;
            if (!Ident.IsMatch(ident)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: an ident is 2-5 lowercase letters", at)); continue; }
            IDictionary entry = source[k] as IDictionary;
            if (entry == null) { errors.Add(at + " must be a mapping of what differs from the defaults (pattern, charset, limit, omit)"); continue; }
            UnknownKeys(at, entry, TypeKeys, errors);
            string patternName = entry.Contains("pattern") && entry["pattern"] != null ? entry["pattern"].ToString() : DefaultPattern;
            if (!patterns.Contains(patternName))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: pattern '{1}' is not declared under patterns", at, patternName));
                continue;
            }
            string charset = entry.Contains("charset") && entry["charset"] != null ? entry["charset"].ToString() : DefaultCharset;
            if (!CharacterClass.IsMatch(charset)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: charset '{1}' must be one character class, such as [a-z0-9]", at, charset)); continue; }
            Hashtable type = new Hashtable(StringComparer.Ordinal) { { "pattern", patternName }, { "charset", charset } };
            bool patternBinds = ((Hashtable)patterns[patternName]).ContainsKey("limit");
            if (entry.Contains("limit"))
            {
                if (patternBinds) { errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the '{1}' pattern binds the limit, so the type declares none", at, patternName)); continue; }
                int? limit = Limit(at, entry["limit"], errors);
                if (limit == null) { continue; }
                type["limit"] = limit.Value;
            }
            else if (!patternBinds)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the '{1}' pattern has no limit, so the type declares its own", at, patternName));
                continue;
            }
            if (entry.Contains("omit"))
            {
                string[] omit = Omit(at, entry["omit"], errors);
                if (omit == null) { continue; }
                type["omit"] = omit;
            }
            map[ident] = type;
        }
        return map;
    }

    private static void UnknownKeys(string at, IDictionary entry, string[] allowed, List<string> errors)
    {
        foreach (object k in entry.Keys)
        {
            if (Array.IndexOf(allowed, k == null ? null : k.ToString()) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", at, k, string.Join(", ", allowed)));
            }
        }
    }

    private static int? Limit(string at, object value, List<string> errors)
    {
        if ((value is int || value is long) && Convert.ToInt64(value, CultureInfo.InvariantCulture) is long limit && limit > 0 && limit <= int.MaxValue)
        {
            return (int)limit;
        }
        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: limit must be a positive whole number", at));
        return null;
    }

    private static string[] Omit(string at, object value, List<string> errors)
    {
        if (!(value is IEnumerable list) || value is string || value is IDictionary)
        {
            errors.Add(at + ": omit must be a list of name components");
            return null;
        }
        List<string> omit = new List<string>();
        foreach (object item in list)
        {
            string component = item == null ? string.Empty : item.ToString();
            if (Array.IndexOf(OmittableComponents, component) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: omit names '{1}', not an omittable component (allowed: {2}; type is never omitted)", at, component, string.Join(", ", OmittableComponents)));
                return null;
            }
            omit.Add(component);
        }
        if (omit.Count == 0) { errors.Add(at + ": omit must name at least one component"); return null; }
        return omit.ToArray();
    }

    private static IReadOnlyList<string> NotNames(object value, List<string> errors)
    {
        if (!(value is IEnumerable list) || value is string || value is IDictionary)
        {
            errors.Add("not_names must be a list of key suffixes, such as SkuName");
            return DefaultNotNames;
        }
        List<string> suffixes = new List<string>();
        bool invalid = false;
        foreach (object item in list)
        {
            string suffix = item == null ? string.Empty : item.ToString();
            if (!NameSuffix.IsMatch(suffix))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "not_names: '{0}' is not a key suffix ending in Name or Names, such as SkuName", suffix));
                invalid = true;
                continue;
            }
            suffixes.Add(suffix);
        }
        if (suffixes.Count == 0 && !invalid) { errors.Add("not_names must name at least one key suffix"); }
        return suffixes.ToArray();
    }
}
