/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.VSCode/types/VscodePipelineSchemaConfig.cs
    folder: types
    name: vscode-pipeline-schema-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-vscode/types/VscodePipelineSchemaConfig.cs.md
    test: automation/Catzc.Base.VSCode/tests/types/VscodePipelineSchemaConfig.Tests.ps1
    cites:
      - ADR-REPO-ROOTCFG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.VSCode;

public sealed class VscodePipelineSchemaConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-pipeline-schema config validation failed:\n";
    private const string DefinitionRef = "#/definitions/";
    private static readonly string[] AllowedKeys = { "$schema", "title", "type", "properties", "definitions" };

    // The whole authored JSON-Schema document, keyword -> value, in authored order — what the .json receives; read-only.
    public OrderedDictionary document { get; }

    public VscodePipelineSchemaConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        string metaSchema = raw.Contains("$schema") ? raw["$schema"] as string : null;
        if (string.IsNullOrWhiteSpace(metaSchema)) { errors.Add("'$schema' must be a non-empty meta-schema URI"); }

        string rootType = raw.Contains("type") ? raw["type"] as string : null;
        if (rootType != "object") { errors.Add("'type' must be 'object' (a full pipeline or any template fragment)"); }

        IDictionary definitions = raw.Contains("definitions") ? raw["definitions"] as IDictionary : null;
        foreach (string key in new[] { "properties", "definitions" })
        {
            if (raw.Contains(key) && !(raw[key] is IDictionary)) { errors.Add(string.Format("'{0}' must be a map", key)); }
        }

        Walk(raw, "", definitions, errors);

        object step = definitions != null && definitions.Contains("step") ? definitions["step"] : null;
        if (step != null) { CheckNoBranching(step, "definitions.step", errors); }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }

        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        foreach (object k in raw.Keys) { map[k.ToString()] = raw[k]; }
        document = map.AsReadOnly();
    }

    // Every node: no closed object (additionalProperties: false), and every local $ref names a definition.
    private static void Walk(object node, string path, IDictionary definitions, List<string> errors)
    {
        IDictionary map = node as IDictionary;
        if (map != null)
        {
            foreach (object k in map.Keys)
            {
                string key = k == null ? "" : k.ToString();
                string at = path.Length == 0 ? key : path + "." + key;
                object value = map[k];
                if (key == "additionalProperties" && value is bool && !(bool)value)
                {
                    errors.Add(string.Format("'{0}' is false — the schema stays open (additionalProperties defaults to true)", at));
                }
                if (key == "$ref") { CheckRef(value, at, definitions, errors); }
                Walk(value, at, definitions, errors);
            }
            return;
        }

        IList list = node as IList;
        if (list != null)
        {
            for (int i = 0; i < list.Count; i++) { Walk(list[i], path + "[" + i + "]", definitions, errors); }
        }
    }

    private static void CheckRef(object value, string at, IDictionary definitions, List<string> errors)
    {
        string target = value as string;
        if (target == null || !target.StartsWith(DefinitionRef, StringComparison.Ordinal)) { return; }
        string name = target.Substring(DefinitionRef.Length);
        if (definitions == null || !definitions.Contains(name))
        {
            errors.Add(string.Format("'{0}' points at '{1}', which is not a definition", at, target));
        }
    }

    private static void CheckNoBranching(object node, string path, List<string> errors)
    {
        IDictionary map = node as IDictionary;
        if (map != null)
        {
            foreach (object k in map.Keys)
            {
                string key = k == null ? "" : k.ToString();
                string at = path + "." + key;
                if (key == "anyOf" || key == "oneOf")
                {
                    errors.Add(string.Format("'{0}' branches the step shape — the step stays one loose object (no anyOf/oneOf)", at));
                }
                CheckNoBranching(map[k], at, errors);
            }
            return;
        }

        IList list = node as IList;
        if (list != null)
        {
            for (int i = 0; i < list.Count; i++) { CheckNoBranching(list[i], path + "[" + i + "]", errors); }
        }
    }
}
