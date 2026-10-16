/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/GeneratedWriter.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/GeneratedWriter.cs.md
    adrs:
      - ADR-AUTO-DEFAULT#6
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class GeneratedWriter : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly Regex VerbNoun = new Regex("^[A-Z][a-z]+-[A-Z][A-Za-z0-9]*$");
    private static readonly string[] Checks = { "file", "english-dictionary", "root-config" };
    private static readonly string[] AllowedKeys = { "check", "result_path" };

    // The writer's command name.
    public string name { get; }

    public string check { get; }

    // The property of a file result that holds the stale file's path. Default: Path. Null for a check that reads no result path.
    public string result_path { get; }

    public GeneratedWriter(string name, object raw)
    {
        List<string> errors = new List<string>();
        if (name == null || !VerbNoun.IsMatch(name))
        {
            errors.Add(string.Format("writer name '{0}' is invalid (must be a Verb-Noun command name)", name));
        }
        this.name = name;

        IDictionary entry = raw == null ? new Hashtable() : raw as IDictionary;
        if (entry == null)
        {
            throw new ArgumentException(string.Format("writer '{0}' must be a map with the optional keys: {1}", name, string.Join(", ", AllowedKeys)));
        }
        foreach (object k in entry.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("writer '{0}' carries unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedKeys)));
            }
        }

        check = OptStr(entry, "check") ?? "file";
        if (Array.IndexOf(Checks, check) < 0)
        {
            errors.Add(string.Format("writer '{0}' has unknown check '{1}' (allowed: {2})", name, check, string.Join(", ", Checks)));
        }

        string resultPath = OptStr(entry, "result_path");
        if (check != "file" && resultPath != null)
        {
            errors.Add(string.Format("writer '{0}' sets result_path, which only the check 'file' reads", name));
        }
        result_path = check == "file" ? (resultPath ?? "Path") : null;

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
