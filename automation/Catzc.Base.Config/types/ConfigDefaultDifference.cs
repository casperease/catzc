using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using System.Text;

namespace Catzc.Base.Config;

// One top-level key whose value in a shipped config file differs from the default its config type declares for it ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
public sealed class ConfigDefaultDifference
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string key { get; }
    public string shipped { get; }
    public string declared { get; }

    public ConfigDefaultDifference(string key, string shipped, string declared)
    {
        this.key = key;
        this.shipped = shipped;
        this.declared = declared;
    }

    // The keys of a shipped file whose scalar value differs from the type's Default<Key> constant (the key in Pascal case); a key with no such
    // constant, or one whose default is no scalar (a list or a map), compares nothing.
    public static IReadOnlyList<ConfigDefaultDifference> Compare(Type configType, IDictionary shipped)
    {
        var differences = new List<ConfigDefaultDifference>();
        if (configType == null || shipped == null) { return differences; }
        foreach (DictionaryEntry pair in shipped)
        {
            string key = Convert.ToString(pair.Key, CultureInfo.InvariantCulture);
            FieldInfo field = configType.GetField("Default" + Pascal(key), BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
            if (field == null || !IsScalar(field.FieldType)) { continue; }
            string declared = Text(field.GetValue(null));
            if (pair.Value != null && !IsScalar(pair.Value.GetType())) { continue; }
            string value = Text(pair.Value);
            if (!string.Equals(declared, value, StringComparison.Ordinal))
            {
                differences.Add(new ConfigDefaultDifference(key, value, declared));
            }
        }
        return differences;
    }

    // snake_case or kebab-case to PascalCase: ado_naming -> AdoNaming.
    public static string Pascal(string key)
    {
        var text = new StringBuilder();
        foreach (string part in (key ?? string.Empty).Split(new[] { '_', '-' }, StringSplitOptions.RemoveEmptyEntries))
        {
            text.Append(char.ToUpperInvariant(part[0])).Append(part.Substring(1));
        }
        return text.ToString();
    }

    private static bool IsScalar(Type type) => type == typeof(string) || type == typeof(bool) || type.IsPrimitive || type == typeof(decimal);

    // A bool reads lower case, the way YAML writes it; every other scalar in the invariant culture.
    private static string Text(object value)
    {
        if (value == null) { return null; }
        if (value is bool flag) { return flag ? "true" : "false"; }
        return Convert.ToString(value, CultureInfo.InvariantCulture);
    }
}
