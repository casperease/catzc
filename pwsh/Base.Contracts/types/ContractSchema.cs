/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractSchema.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// Validates a parsed value against a bounded JSON Schema subset.
public static class ContractSchema
{
    // Declared before Keywords: static fields initialise in text order.
    public static readonly string[] Annotations = { "$schema", "$id", "$comment", "title", "description", "examples" };

    public static readonly string[] Keywords =
        new[] { "type", "required", "properties", "additionalProperties", "enum", "items", "const", "pattern", "definitions", "$ref" }
            .Concat(Annotations).ToArray();

    public static readonly string[] Types = { "null", "boolean", "object", "array", "number", "string", "integer" };

    // The one reference form the subset reads: a local definition of the same schema.
    private const string DefinitionPrefix = "#/definitions/";

    public static IReadOnlyList<string> Inspect(object schema)
    {
        var findings = new List<string>();
        Read(schema, schema, "#", findings);
        return findings;
    }

    public static IReadOnlyList<string> Validate(object schema, object value)
    {
        var findings = new List<string>();
        Read(schema, schema, "#", findings);
        if (findings.Count == 0)
        {
            Check(schema, schema, value, "#", "$", findings);
        }
        return findings;
    }

    // The schema's own findings: what the subset cannot read.
    private static void Read(object root, object schema, string at, List<string> findings)
    {
        if (schema is bool)
        {
            return;
        }
        if (!(schema is IDictionary map))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: a schema is an object or a boolean, not {1}",
                at, ContractValue.Describe(schema)));
            return;
        }
        foreach (DictionaryEntry entry in map)
        {
            string keyword = ContractValue.Text(entry.Key);
            object argument = entry.Value;
            string here = at + "/" + Pointer(keyword);
            switch (keyword)
            {
                case "type":
                    ReadType(argument, here, findings);
                    break;
                case "required":
                    if (!(argument is IList names) || names.Cast<object>().Any(name => ContractValue.Kind(name) != "string"))
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: required is an array of property names", here));
                    }
                    break;
                case "properties":
                    if (argument is IDictionary properties)
                    {
                        foreach (DictionaryEntry property in properties)
                        {
                            Read(root, property.Value, here + "/" + Pointer(ContractValue.Text(property.Key)), findings);
                        }
                    }
                    else
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: properties is an object of property name to schema", here));
                    }
                    break;
                case "additionalProperties":
                    // true or false opens or closes the object; a schema checks every member properties does not name.
                    if (!(argument is bool))
                    {
                        Read(root, argument, here, findings);
                    }
                    break;
                case "enum":
                    if (!(argument is IList))
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: enum is an array of values", here));
                    }
                    break;
                case "items":
                    if (argument is IList)
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture,
                            "schema {0}: unsupported form of items: only one schema for every element is supported, not an array of them", here));
                    }
                    else
                    {
                        Read(root, argument, here, findings);
                    }
                    break;
                case "const":
                    break;
                case "pattern":
                    ReadPattern(argument, here, findings);
                    break;
                case "definitions":
                    if (!ReferenceEquals(schema, root))
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: definitions are read at the root of a schema only", here));
                    }
                    else if (argument is IDictionary definitions)
                    {
                        foreach (DictionaryEntry definition in definitions)
                        {
                            Read(root, definition.Value, here + "/" + Pointer(ContractValue.Text(definition.Key)), findings);
                        }
                    }
                    else
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: definitions is an object of name to schema", here));
                    }
                    break;
                case "$ref":
                    if (Resolve(root, argument) == null)
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture,
                            "schema {0}: unsupported form of $ref: only {1}<name> of a definition this schema declares is supported, not {2}",
                            here, DefinitionPrefix, ContractValue.Describe(argument)));
                    }
                    else if (Loops(root, argument))
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: the $ref chain from {1} returns to itself", here,
                            ContractValue.Text(argument)));
                    }
                    break;
                default:
                    if (Array.IndexOf(Annotations, keyword) >= 0)
                    {
                        break;
                    }
                    findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: unsupported keyword {1}", at, keyword));
                    break;
            }
        }
    }

    private static void ReadType(object argument, string here, List<string> findings)
    {
        IEnumerable<object> names = argument is IList list ? list.Cast<object>() : new[] { argument };
        foreach (object name in names)
        {
            string text = ContractValue.Kind(name) == "string" ? ContractValue.Text(name) : null;
            if (text == null || Array.IndexOf(Types, text) < 0)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: {1} is not a JSON type ({2})",
                    here, ContractValue.Describe(name), string.Join(", ", Types)));
            }
        }
    }

    private static void ReadPattern(object argument, string here, List<string> findings)
    {
        string text = ContractValue.Kind(argument) == "string" ? ContractValue.Text(argument) : null;
        if (text == null)
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: pattern is a regular expression string", here));
            return;
        }
        try
        {
            _ = new Regex(text, RegexOptions.CultureInvariant);
        }
        catch (ArgumentException error)
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: pattern is not a valid regular expression: {1}", here, error.Message));
        }
    }

    // The definition a $ref names, or null when it is not a local definition the root declares.
    private static object Resolve(object root, object reference)
    {
        string text = ContractValue.Kind(reference) == "string" ? ContractValue.Text(reference) : null;
        if (text == null || !text.StartsWith(DefinitionPrefix, StringComparison.Ordinal) || !(root is IDictionary rootMap))
        {
            return null;
        }
        if (!ContractValue.TryGetMember(rootMap, "definitions", out object definitions) || !(definitions is IDictionary named))
        {
            return null;
        }
        return ContractValue.TryGetMember(named, text.Substring(DefinitionPrefix.Length), out object definition) ? definition : null;
    }

    // A chain of definitions that each only refer on, without reading a value, never ends.
    private static bool Loops(object root, object reference)
    {
        var seen = new HashSet<string>(StringComparer.Ordinal);
        object current = reference;
        while (current != null && seen.Add(ContractValue.Text(current)))
        {
            object target = Resolve(root, current);
            current = target is IDictionary map && ContractValue.TryGetMember(map, "$ref", out object next) ? next : null;
        }
        return current != null;
    }

    private static void Check(object root, object schema, object value, string at, string path, List<string> findings)
    {
        if (schema is bool admits)
        {
            if (!admits)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the schema {1} is false, which admits no value", path, at));
            }
            return;
        }

        var map = (IDictionary)schema;
        if (ContractValue.TryGetMember(map, "$ref", out object reference))
        {
            Check(root, Resolve(root, reference), value, ContractValue.Text(reference), path, findings);
        }
        string kind = ContractValue.Kind(value);
        if (ContractValue.TryGetMember(map, "type", out object type))
        {
            string[] allowed = type is IList list ? list.Cast<object>().Select(ContractValue.Text).ToArray() : new[] { ContractValue.Text(type) };
            bool typed = allowed.Contains(kind) || (kind == "integer" && allowed.Contains("number"));
            if (!typed)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: expected type {1}, found {2} ({3})",
                    path, string.Join(" or ", allowed), kind, ContractValue.Describe(value)));
            }
        }
        if (ContractValue.TryGetMember(map, "enum", out object choices))
        {
            var options = ((IList)choices).Cast<object>().ToArray();
            if (!options.Any(option => ContractValue.Equal(option, value)))
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: {1} is not one of the enum values {2}",
                    path, ContractValue.Describe(value), string.Join(", ", options.Select(ContractValue.Describe))));
            }
        }
        if (ContractValue.TryGetMember(map, "const", out object constant) && !ContractValue.Equal(constant, value))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: expected the constant {1}, found {2}",
                path, ContractValue.Describe(constant), ContractValue.Describe(value)));
        }
        if (kind == "string" && ContractValue.TryGetMember(map, "pattern", out object pattern)
            && !Regex.IsMatch(ContractValue.Text(value), ContractValue.Text(pattern), RegexOptions.CultureInvariant))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: {1} does not match the pattern {2}",
                path, ContractValue.Describe(value), ContractValue.Text(pattern)));
        }
        if (value is IDictionary instance)
        {
            CheckObject(root, map, instance, at, path, findings);
        }
        if (value is IList elements && ContractValue.TryGetMember(map, "items", out object items))
        {
            for (int i = 0; i < elements.Count; i++)
            {
                Check(root, items, elements[i], at + "/items", path + "[" + i.ToString(CultureInfo.InvariantCulture) + "]", findings);
            }
        }
    }

    private static void CheckObject(object root, IDictionary map, IDictionary instance, string at, string path, List<string> findings)
    {
        if (ContractValue.TryGetMember(map, "required", out object required))
        {
            foreach (object name in (IList)required)
            {
                if (!ContractValue.TryGetMember(instance, ContractValue.Text(name), out _))
                {
                    findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the required property '{1}' is missing",
                        path, ContractValue.Text(name)));
                }
            }
        }

        IDictionary properties = ContractValue.TryGetMember(map, "properties", out object declared)
            ? (IDictionary)declared
            : null;
        bool hasAdditional = ContractValue.TryGetMember(map, "additionalProperties", out object additional);
        bool closed = hasAdditional && additional is bool open && !open;
        object additionalSchema = hasAdditional && !(additional is bool) ? additional : null;
        foreach (DictionaryEntry entry in instance)
        {
            string key = ContractValue.Text(entry.Key);
            string member = ContractValue.MemberPath(path, key);
            if (properties != null && ContractValue.TryGetMember(properties, key, out object nested))
            {
                Check(root, nested, entry.Value, at + "/properties/" + Pointer(key), member, findings);
            }
            else if (additionalSchema != null)
            {
                Check(root, additionalSchema, entry.Value, at + "/additionalProperties", member, findings);
            }
            else if (closed)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture,
                    "{0}: the property is not allowed: additionalProperties is false and properties does not name it", member));
            }
        }
    }

    // A key as a JSON Pointer segment: ~ is ~0 and / is ~1.
    private static string Pointer(string key) => key.Replace("~", "~0").Replace("/", "~1");
}
