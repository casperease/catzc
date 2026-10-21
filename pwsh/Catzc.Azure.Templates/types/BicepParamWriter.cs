/*
---
catzc:
  immutable:
    with_body_sha: "11ddbbb75183"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/types/BicepParamWriter.Tests.ps1
    docs: "[BicepParamWriter.cs.md](../../../docs/references/pwsh/catzc-azure-templates/types/BicepParamWriter.cs.md)"
    cites:
      - ADR-AZ-DATAMOD-ONEPATHTOPARAMETERS
---
*/

using System;
using System.Collections;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

public static class BicepParamWriter
{
    private const string Indent = "  ";
    // The Bicep formatter's default line width; the repository sets no other in a bicepconfig.
    private const int LineWidth = 120;
    private static readonly Regex Identifier = new Regex(@"^[A-Za-z_][A-Za-z0-9_]*$");
    private static readonly Regex VaultId = new Regex(
        @"^/subscriptions/(?<subscription>[^/]+)/resourceGroups/(?<group>[^/]+)/providers/Microsoft\.KeyVault/vaults/(?<vault>[^/]+)$",
        RegexOptions.IgnoreCase);

    // The `.bicepparam` text for `parameters` (name -> { value } or { reference }), in their order, against the template at `usingPath`.
    public static string Write(string usingPath, IDictionary parameters)
    {
        if (string.IsNullOrWhiteSpace(usingPath)) { throw new ArgumentException("BicepParamWriter.Write requires the using path"); }
        var text = new StringBuilder();
        text.Append("using ").Append(Quote(usingPath)).Append('\n');
        if (parameters == null || parameters.Count == 0) { return text.ToString(); }
        text.Append('\n');
        foreach (DictionaryEntry entry in parameters)
        {
            string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            if (!Identifier.IsMatch(name ?? ""))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': a Bicep parameter name is an identifier", name));
            }
            string head = "param " + name + " = ";
            text.Append(head).Append(Expression(name, entry.Value, head.Length)).Append('\n');
        }
        return text.ToString();
    }

    private static string Expression(string name, object entry, int column)
    {
        IDictionary map = entry as IDictionary;
        if (map != null && map.Contains("reference") && !map.Contains("value"))
        {
            return Secret(name, map["reference"] as IDictionary, column);
        }
        if (map != null && map.Contains("value") && !map.Contains("reference"))
        {
            return Literal(name, map["value"], 0);
        }
        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "parameter '{0}': an entry holds exactly one of value or reference (an address resolves to a value before the render)", name));
    }

    private static string Secret(string name, IDictionary reference, int column)
    {
        IDictionary keyVault = reference == null ? null : reference["keyVault"] as IDictionary;
        string id = keyVault == null ? null : Convert.ToString(keyVault["id"], CultureInfo.InvariantCulture);
        Match vault = VaultId.Match(id ?? "");
        string secret = reference == null ? null : Convert.ToString(reference["secretName"], CultureInfo.InvariantCulture);
        if (!vault.Success || string.IsNullOrWhiteSpace(secret))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "parameter '{0}': a Key Vault reference needs keyVault.id as /subscriptions/<id>/resourceGroups/<name>/providers/Microsoft.KeyVault/vaults/<name> and a secretName (found id '{1}')",
                name, id));
        }
        var arguments = new System.Collections.Generic.List<string>
        {
            Quote(vault.Groups["subscription"].Value), Quote(vault.Groups["group"].Value), Quote(vault.Groups["vault"].Value), Quote(secret),
        };
        if (reference.Contains("secretVersion") && reference["secretVersion"] != null)
        {
            arguments.Add(Quote(Convert.ToString(reference["secretVersion"], CultureInfo.InvariantCulture)));
        }
        string single = "az.getSecret(" + string.Join(", ", arguments) + ")";
        if (column + single.Length <= LineWidth) { return single; }
        // bicep format breaks a call wider than its line width into one argument per line.
        return "az.getSecret(\n" + Indent + string.Join(",\n" + Indent, arguments) + "\n)";
    }

    private static string Literal(string name, object value, int depth)
    {
        switch (value)
        {
            case null:
                return "null";
            case string text:
                return Quote(text);
            case bool flag:
                return flag ? "true" : "false";
            case int or long or short or byte or sbyte or ushort or uint:
                return Convert.ToString(value, CultureInfo.InvariantCulture);
            case ulong or System.Numerics.BigInteger:
                return Convert.ToString(value, CultureInfo.InvariantCulture);
            case IDictionary map:
                return Object(name, map, depth);
            case IEnumerable items:
                return Array(name, items, depth);
            default:
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "parameter '{0}': {1} '{2}' has no Bicep literal (Bicep has no fractional number); quote it as a string",
                    name, value.GetType().Name, Convert.ToString(value, CultureInfo.InvariantCulture)));
        }
    }

    private static string Object(string name, IDictionary map, int depth)
    {
        if (map.Count == 0) { return "{}"; }
        string inner = Pad(depth + 1);
        var text = new StringBuilder("{\n");
        foreach (DictionaryEntry entry in map)
        {
            string key = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            text.Append(inner).Append(Identifier.IsMatch(key) ? key : Quote(key)).Append(": ")
                .Append(Literal(name, entry.Value, depth + 1)).Append('\n');
        }
        return text.Append(Pad(depth)).Append('}').ToString();
    }

    private static string Array(string name, IEnumerable items, int depth)
    {
        string inner = Pad(depth + 1);
        var text = new StringBuilder("[\n");
        bool any = false;
        foreach (object item in items)
        {
            any = true;
            text.Append(inner).Append(Literal(name, item, depth + 1)).Append('\n');
        }
        return any ? text.Append(Pad(depth)).Append(']').ToString() : "[]";
    }

    private static string Pad(int depth)
    {
        var pad = new StringBuilder();
        for (int i = 0; i < depth; i++) { pad.Append(Indent); }
        return pad.ToString();
    }

    // A Bicep single-quoted string: \\, \', \${, and the control characters escaped.
    private static string Quote(string text)
    {
        var quoted = new StringBuilder("'");
        for (int i = 0; i < text.Length; i++)
        {
            char c = text[i];
            switch (c)
            {
                case '\\': quoted.Append("\\\\"); break;
                case '\'': quoted.Append("\\'"); break;
                case '\n': quoted.Append("\\n"); break;
                case '\r': quoted.Append("\\r"); break;
                case '\t': quoted.Append("\\t"); break;
                case '$':
                    quoted.Append(i + 1 < text.Length && text[i + 1] == '{' ? "\\$" : "$");
                    break;
                default: quoted.Append(c); break;
            }
        }
        return quoted.Append('\'').ToString();
    }
}
