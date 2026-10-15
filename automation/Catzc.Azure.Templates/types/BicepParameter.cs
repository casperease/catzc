/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/types/BicepParameter.cs
    kind: csharp-type
    module: Catzc.Azure.Templates
    relatives:
      page: docs/references/automation/catzc-azure-templates/types/BicepParameter.cs.md
    adrs:
      - ADR-AUTO-TYPES#{8,9}
---
*/

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text.Json;

namespace Catzc.Azure.Templates;

public sealed class BicepParameter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public static readonly IReadOnlyList<string> Types = Array.AsReadOnly(new[]
    {
        "string", "int", "bool", "object", "array", "secureString", "secureObject",
    });

    // The parameter name, as main.json declares it. Always present.
    public string Name { get; }

    // One of Types. Always present.
    public string Type { get; }

    // True when main.json gives the parameter a defaultValue, so a parameters file may omit it.
    public bool HasDefault { get; }

    // True when the parameter is declared nullable (a Bicep `type?`), so a parameters file may omit it or set null.
    public bool Nullable { get; }

    // The @allowed values, each normalized by ToComparable. Empty when the parameter has no @allowed list.
    public IReadOnlyList<object> AllowedValues { get; }

    // The @minValue / @maxValue bounds of an int parameter. Null when not declared.
    public long? MinValue { get; }
    public long? MaxValue { get; }

    // The @minLength / @maxLength bounds of a string or array parameter. Null when not declared.
    public long? MinLength { get; }
    public long? MaxLength { get; }

    // True for secureString and secureObject: a parameters file may carry such a value only as a Key Vault reference.
    public bool IsSecure => Type == "secureString" || Type == "secureObject";

    // True when a parameters file must supply the parameter: it has no default and is not nullable.
    public bool IsRequired => !HasDefault && !Nullable;

    public BicepParameter(string name, string type, bool hasDefault, bool nullable, IEnumerable<object> allowedValues,
        long? minValue, long? maxValue, long? minLength, long? maxLength)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BicepParameter.Name is required"); }
        Name = name;
        Type = CanonicalType(name, type);
        HasDefault = hasDefault;
        Nullable = nullable;
        AllowedValues = new ReadOnlyCollection<object>(new List<object>(allowedValues ?? Array.Empty<object>()));
        MinValue = minValue;
        MaxValue = maxValue;
        MinLength = minLength;
        MaxLength = maxLength;
    }

    public static BicepParameter FromArmDeclaration(string name, JsonElement declaration, JsonElement definitions)
    {
        if (declaration.ValueKind != JsonValueKind.Object)
        {
            throw new ArgumentException($"main.json parameter '{name}' is not a JSON object");
        }

        // The declaration first, then each definition it names: the nearest declaration of a property wins.
        var chain = new List<JsonElement> { declaration };
        var current = declaration;
        while (current.TryGetProperty("$ref", out var reference))
        {
            if (chain.Count > 32) { throw new ArgumentException($"main.json parameter '{name}' has a $ref chain that does not end"); }
            current = ResolveDefinition(name, reference.GetString(), definitions);
            chain.Add(current);
        }

        string type = null;
        bool hasDefault = false;
        bool nullable = false;
        JsonElement? allowed = null;
        long? minValue = null, maxValue = null, minLength = null, maxLength = null;
        foreach (var element in chain)
        {
            if (type == null && element.TryGetProperty("type", out var typeElement)) { type = typeElement.GetString(); }
            if (element.TryGetProperty("defaultValue", out _)) { hasDefault = true; }
            if (element.TryGetProperty("nullable", out var nullableElement) && nullableElement.ValueKind == JsonValueKind.True) { nullable = true; }
            if (allowed == null && element.TryGetProperty("allowedValues", out var allowedElement)) { allowed = allowedElement; }
            minValue ??= ReadLong(name, element, "minValue");
            maxValue ??= ReadLong(name, element, "maxValue");
            minLength ??= ReadLong(name, element, "minLength");
            maxLength ??= ReadLong(name, element, "maxLength");
        }

        var allowedValues = new List<object>();
        if (allowed.HasValue)
        {
            if (allowed.Value.ValueKind != JsonValueKind.Array)
            {
                throw new ArgumentException($"main.json parameter '{name}' has an allowedValues that is not an array");
            }
            foreach (var value in allowed.Value.EnumerateArray()) { allowedValues.Add(ToComparable(value)); }
        }

        return new BicepParameter(name, type, hasDefault, nullable, allowedValues, minValue, maxValue, minLength, maxLength);
    }

    public static object ToComparable(JsonElement value)
    {
        switch (value.ValueKind)
        {
            case JsonValueKind.String: return value.GetString();
            case JsonValueKind.Number: return value.TryGetInt64(out var integer) ? integer : (object)value.GetRawText();
            case JsonValueKind.True: return true;
            case JsonValueKind.False: return false;
            case JsonValueKind.Null: return null;
            default: return JsonSerializer.Serialize(value);
        }
    }

    private static string CanonicalType(string name, string type)
    {
        foreach (var known in Types)
        {
            if (string.Equals(known, type, StringComparison.OrdinalIgnoreCase)) { return known; }
        }
        throw new ArgumentException($"main.json parameter '{name}' has type '{type}'; expected one of: {string.Join(", ", Types)}");
    }

    private static JsonElement ResolveDefinition(string name, string reference, JsonElement definitions)
    {
        const string prefix = "#/definitions/";
        if (reference == null || !reference.StartsWith(prefix, StringComparison.Ordinal))
        {
            throw new ArgumentException($"main.json parameter '{name}' has $ref '{reference}'; only '{prefix}<name>' is supported");
        }
        var definitionName = reference.Substring(prefix.Length);
        if (definitions.ValueKind != JsonValueKind.Object || !definitions.TryGetProperty(definitionName, out var definition))
        {
            throw new ArgumentException($"main.json parameter '{name}' refers to definition '{definitionName}', which main.json does not declare");
        }
        return definition;
    }

    private static long? ReadLong(string name, JsonElement element, string property)
    {
        if (!element.TryGetProperty(property, out var value)) { return null; }
        if (value.ValueKind != JsonValueKind.Number || !value.TryGetInt64(out var result))
        {
            throw new ArgumentException($"main.json parameter '{name}' has a {property} that is not an integer");
        }
        return result;
    }
}
