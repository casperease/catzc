// The schema check of a contract asset ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
// a value — a real file or a sample payload, parsed (ContractValue is the value model) — validates against a JSON Schema.
// The BCL carries no JSON Schema validator and no package may be added
// ([ADR-AUTO-TYPES#5](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types5)), so this is a bounded subset,
// and it says so: a schema is an object or a boolean (true admits every value, false none), and its keywords are
//   type                  a JSON type name, or an array of them: null, boolean, object, array, number, string, integer
//                         (an integer is a number too)
//   required              an array of property names the object must hold
//   properties            an object of property name to schema; each property the object holds validates against its own
//   additionalProperties  true or false only; false admits no property that properties does not name
//   enum                  an array; the value equals one of its elements (ContractValue.Equal)
//   items                 one schema every array element validates against (the array form is not supported)
//   const                 the value equals it
// The annotation keywords $schema, $id, $comment, title, description and examples are explicit no-ops: each is read
// and ignored by name, in any form, and never constrains a value. Every other keyword is a finding "unsupported
// keyword", never ignored, and so is a keyword of the subset in a form it does not support. The schema is read whole
// first, every nested schema under properties and items included, whatever the value holds; a value is validated only
// against a schema with no such finding, since a schema the subset cannot read whole cannot say what it admits.
//
// Inspect returns the schema's own findings alone (for a schema whose instance another check validates); Validate
// returns those, or else the value's findings, one precise message per violation, and an empty list when the value
// validates. A schema location is a JSON Pointer from # (#/properties/name); a value location is JSONPath ($.name).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.Contracts;

public static class ContractSchema
{
    // Declared before Keywords: static fields initialise in text order.
    public static readonly string[] Annotations = { "$schema", "$id", "$comment", "title", "description", "examples" };

    public static readonly string[] Keywords =
        new[] { "type", "required", "properties", "additionalProperties", "enum", "items", "const" }.Concat(Annotations).ToArray();

    public static readonly string[] Types = { "null", "boolean", "object", "array", "number", "string", "integer" };

    public static IReadOnlyList<string> Inspect(object schema)
    {
        var findings = new List<string>();
        Read(schema, "#", findings);
        return findings;
    }

    public static IReadOnlyList<string> Validate(object schema, object value)
    {
        var findings = new List<string>();
        Read(schema, "#", findings);
        if (findings.Count == 0)
        {
            Check(schema, value, "#", "$", findings);
        }
        return findings;
    }

    // The schema's own findings: what the subset cannot read.
    private static void Read(object schema, string at, List<string> findings)
    {
        schema = ContractValue.Unwrap(schema);
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
            object argument = ContractValue.Unwrap(entry.Value);
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
                            Read(property.Value, here + "/" + Pointer(ContractValue.Text(property.Key)), findings);
                        }
                    }
                    else
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture, "schema {0}: properties is an object of property name to schema", here));
                    }
                    break;
                case "additionalProperties":
                    if (!(argument is bool))
                    {
                        findings.Add(string.Format(CultureInfo.InvariantCulture,
                            "schema {0}: unsupported form of additionalProperties: only true or false is supported, not a schema", here));
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
                        Read(argument, here, findings);
                    }
                    break;
                case "const":
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

    private static void Check(object schema, object value, string at, string path, List<string> findings)
    {
        schema = ContractValue.Unwrap(schema);
        value = ContractValue.Unwrap(value);
        if (schema is bool admits)
        {
            if (!admits)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the schema {1} is false, which admits no value", path, at));
            }
            return;
        }

        var map = (IDictionary)schema;
        string kind = ContractValue.Kind(value);
        if (ContractValue.TryGetMember(map, "type", out object type))
        {
            type = ContractValue.Unwrap(type);
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
            var options = ((IList)ContractValue.Unwrap(choices)).Cast<object>().ToArray();
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
        if (value is IDictionary instance)
        {
            CheckObject(map, instance, at, path, findings);
        }
        if (value is IList elements && ContractValue.TryGetMember(map, "items", out object items))
        {
            for (int i = 0; i < elements.Count; i++)
            {
                Check(items, elements[i], at + "/items", path + "[" + i.ToString(CultureInfo.InvariantCulture) + "]", findings);
            }
        }
    }

    private static void CheckObject(IDictionary map, IDictionary instance, string at, string path, List<string> findings)
    {
        if (ContractValue.TryGetMember(map, "required", out object required))
        {
            foreach (object name in (IList)ContractValue.Unwrap(required))
            {
                if (!ContractValue.TryGetMember(instance, ContractValue.Text(name), out _))
                {
                    findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the required property '{1}' is missing",
                        path, ContractValue.Text(name)));
                }
            }
        }

        IDictionary properties = ContractValue.TryGetMember(map, "properties", out object declared)
            ? (IDictionary)ContractValue.Unwrap(declared)
            : null;
        bool closed = ContractValue.TryGetMember(map, "additionalProperties", out object additional) && !(bool)ContractValue.Unwrap(additional);
        foreach (DictionaryEntry entry in instance)
        {
            string key = ContractValue.Text(entry.Key);
            string member = ContractValue.MemberPath(path, key);
            if (properties != null && ContractValue.TryGetMember(properties, key, out object nested))
            {
                Check(nested, entry.Value, at + "/properties/" + Pointer(key), member, findings);
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
