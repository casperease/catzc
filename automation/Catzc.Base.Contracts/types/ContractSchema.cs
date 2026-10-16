/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/types/ContractSchema.cs
    folder: types
    name: contract-schema
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/types/ContractSchema.cs.md
    test: automation/Catzc.Base.Contracts/tests/types/ContractSchema.Tests.ps1
    cites:
      - ADR-PWSH-TYPES#1
      - ADR-REPO-CONTRACT#6
---
*/

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
