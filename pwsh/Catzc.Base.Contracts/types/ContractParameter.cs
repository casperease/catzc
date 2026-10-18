using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// Rests on [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Name), nameof(Spec))]
public sealed class ContractParameter
{
    // The default a command computes at run time: the contract promises the parameter, not that value.
    public const string ComputedDefault = "<computed>";

    public static readonly string[] BaseTypes = { "string", "int", "bool", "switch" };

    private static readonly Regex SpecRe = new Regex(
        "^(?<type>[A-Za-z][A-Za-z0-9_.]*)(?<list>\\[\\])?(?<mandatory>!)?(?:\\s*=\\s*(?<default>'[^']*'|\\S+))?(?:\\s+(?<pipeline>pipeline))?" +
        "(?:\\s+in\\s+(?<sets>[A-Za-z][A-Za-z0-9_]*(?:,[A-Za-z][A-Za-z0-9_]*)*))?\\s*$");
    private static readonly Regex NameRe = new Regex("^[A-Za-z][A-Za-z0-9_]*$");
    private static readonly Regex CatzcType = new Regex("^Catzc\\.[A-Za-z][A-Za-z0-9_]*(\\.[A-Za-z][A-Za-z0-9_]*)+$");

    private static readonly Dictionary<string, string> KnownTypes = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
    {
        { "string", "string" }, { "System.String", "string" },
        { "int", "int" }, { "Int32", "int" }, { "System.Int32", "int" }, { "long", "int" }, { "Int64", "int" }, { "System.Int64", "int" },
        { "bool", "bool" }, { "Boolean", "bool" }, { "System.Boolean", "bool" },
        { "switch", "switch" }, { "SwitchParameter", "switch" }, { "System.Management.Automation.SwitchParameter", "switch" },
    };

    public string Name { get; }
    public string Type { get; }
    public bool IsList { get; }
    public bool Mandatory { get; }
    public string Default { get; }
    public bool Pipeline { get; }

    // The parameter sets the parameter belongs to, sorted; empty when it belongs to every set, the default.
    public IReadOnlyList<string> Sets { get; }

    // The spec text the parameter reads back as, in the contract language.
    public string Spec
    {
        get
        {
            var text = new StringBuilder(Type);
            if (IsList)
            {
                text.Append("[]");
            }
            if (Mandatory)
            {
                text.Append('!');
            }
            if (Default != null)
            {
                text.Append(" = ").Append(Default.Length == 0 || Default.Contains(' ') ? "'" + Default + "'" : Default);
            }
            if (Pipeline)
            {
                text.Append(" pipeline");
            }
            if (Sets.Count > 0)
            {
                text.Append(" in ").Append(string.Join(",", Sets));
            }
            return text.ToString();
        }
    }

    public ContractParameter(string name, string type, bool isList = false, bool mandatory = false, string defaultValue = null, bool pipeline = false,
        IEnumerable<string> sets = null)
    {
        if (name == null || !NameRe.IsMatch(name))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the name is not an identifier", name));
        }
        if (string.IsNullOrEmpty(type))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the type is required", name));
        }
        Name = name;
        Type = type;
        IsList = isList;
        Mandatory = mandatory;
        // PowerShell binds $null to a string parameter as "", so an empty default is no default, on both sides.
        Default = string.IsNullOrEmpty(defaultValue) ? null : defaultValue;
        Pipeline = pipeline;
        var setList = new List<string>();
        foreach (string set in sets ?? Array.Empty<string>())
        {
            if (set == null || !NameRe.IsMatch(set))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the set '{1}' is not an identifier", name, set));
            }
            if (!setList.Contains(set))
            {
                setList.Add(set);
            }
        }
        setList.Sort(StringComparer.Ordinal);
        Sets = setList;
    }

    // Whether the parameter takes part in a call shaped by the set: it names that set, or it names none and so belongs to every set.
    public bool IsInSet(string set) => Sets.Count == 0 || (set != null && ((List<string>)Sets).Contains(set));

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Parses one parameter's spec string; a spec outside the grammar or the closed type set throws, naming the parameter.
    public static ContractParameter Parse(string name, string spec)
    {
        if (name == null || !NameRe.IsMatch(name))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': the name is not an identifier", name));
        }
        Match match = spec == null ? Match.Empty : SpecRe.Match(spec);
        if (!match.Success)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "parameter '{0}': '{1}' is not a spec of the form type[[]][!][= literal][ pipeline][ in Set[,Set]]", name, spec));
        }
        string type = match.Groups["type"].Value;
        if (!IsContractType(type))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "parameter '{0}': type '{1}' is not one of {2} or a Catzc.* type name", name, type, string.Join(", ", BaseTypes)));
        }
        string defaultValue = match.Groups["default"].Success ? Unquote(match.Groups["default"].Value) : null;
        if (defaultValue != null && type == "switch")
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "parameter '{0}': a switch has no default", name));
        }
        string[] sets = match.Groups["sets"].Success ? match.Groups["sets"].Value.Split(',') : null;
        return new ContractParameter(name, type, match.Groups["list"].Success, match.Groups["mandatory"].Success, defaultValue,
            match.Groups["pipeline"].Success, sets);
    }

    // Whether a type name is in the closed set: a base type or a Catzc.* type name.
    public static bool IsContractType(string type) => Array.IndexOf(BaseTypes, type) >= 0 || (type != null && CatzcType.IsMatch(type));

    // Maps a type name as a PowerShell parameter block spells it to the contract's type, with isList for a trailing '[]'; null when it maps to none.
    public static string NormalizeType(string typeName, out bool isList)
    {
        isList = false;
        if (string.IsNullOrEmpty(typeName))
        {
            return null;
        }
        string bare = typeName;
        if (bare.EndsWith("[]", StringComparison.Ordinal))
        {
            isList = true;
            bare = bare.Substring(0, bare.Length - 2);
        }
        if (KnownTypes.TryGetValue(bare, out string known))
        {
            return known;
        }
        return CatzcType.IsMatch(bare) ? bare : null;
    }

    private static string Unquote(string literal) =>
        literal.Length >= 2 && literal[0] == '\'' && literal[literal.Length - 1] == '\'' ? literal.Substring(1, literal.Length - 2) : literal;
}
