/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
    folder: types
    name: identity-token-rule
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/IdentityTokenRule.cs.md
    cites:
      - ADR-AUTO-TEST#3
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class IdentityTokenRule
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string config { get; }
    public IReadOnlyList<string> path { get; }
    public string take { get; }
    public string kind { get; }
    public string suggest { get; }
    public string match { get; }
    public string skip_when { get; }

    private static readonly string[] AllowedKeys = { "config", "path", "take", "kind", "suggest", "match", "skip_when" };
    private static readonly Regex Segment = new Regex("^([A-Za-z0-9_-]+|\\*)$");

    public IdentityTokenRule(int position, IDictionary raw)
    {
        string label = string.Format("tokens[{0}]", position);
        if (raw == null) { throw new ArgumentException(label + ": must be a mapping"); }

        List<string> errors = new List<string>();
        foreach (object key in raw.Keys)
        {
            string name = key == null ? string.Empty : key.ToString();
            if (Array.IndexOf(AllowedKeys, name) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", label, name, string.Join(", ", AllowedKeys)));
            }
        }

        config = Required(raw, "config", label, errors);
        kind = Required(raw, "kind", label, errors);
        suggest = Required(raw, "suggest", label, errors);
        string pathText = Required(raw, "path", label, errors);

        List<string> segments = new List<string>();
        if (pathText != null)
        {
            foreach (string segment in pathText.Split('.'))
            {
                if (!Segment.IsMatch(segment))
                {
                    errors.Add(string.Format("{0}: path '{1}' has segment '{2}'; a segment is a key or '*'", label, pathText, segment));
                }
                segments.Add(segment);
            }
        }
        path = segments;

        take = Optional(raw, "take") ?? "value";
        if (take != "value" && take != "keys")
        {
            errors.Add(string.Format("{0}: take '{1}' is not 'value' or 'keys'", label, take));
        }
        match = Optional(raw, "match") ?? "exact";
        if (match != "exact" && match != "position")
        {
            errors.Add(string.Format("{0}: match '{1}' is not 'exact' or 'position'", label, match));
        }
        skip_when = Optional(raw, "skip_when");

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private static string Optional(IDictionary raw, string key)
    {
        if (!raw.Contains(key) || raw[key] == null) { return null; }
        string value = raw[key].ToString();
        return string.IsNullOrWhiteSpace(value) ? null : value;
    }

    private static string Required(IDictionary raw, string key, string label, List<string> errors)
    {
        string value = Optional(raw, key);
        if (value == null) { errors.Add(string.Format("{0}: '{1}' is required", label, key)); }
        return value;
    }
}
