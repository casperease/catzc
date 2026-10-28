// The keys of the generated-file head, in the order they are written, and the regenerate template a writer row fills; a key a file has no value for is left out.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class GeneratedHeadConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The one string every generated head carries, so a reader of any tracked generated file is told not to edit it.
    public const string DefaultWarning = "Do Not Edit, this file is generated";

    // The command that renders a file again: {writer} is the writer row's name, {path} the file's repository path.
    public const string DefaultRegenerate = "{writer} -Path {path}";

    private const string Failed = "generated-head configuration validation failed:\n";

    // The head keys in the one order ADR-REPO-FILEMETA-COMPOSEDFILES fixes, the body hash closing the head.
    private static readonly string[] Known = ["warning", "regenerate", "with_body_sha"];
    private static readonly string[] TopLevel = ["keys", "warning", "regenerate"];
    private static readonly string[] Placeholders = ["{writer}", "{path}"];
    private static readonly Regex Placeholder = new Regex(@"\{[^{}]*\}");

    // The head keys in writing order.
    public string[] order { get; }

    // The value of the head's `warning` key.
    public string warning { get; }

    // The template of the head's `regenerate` command, which a writer row's own `regenerate` replaces.
    public string regenerate { get; }

    public GeneratedHeadConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (Array.IndexOf(TopLevel, name) < 0) { errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", k, string.Join(", ", TopLevel))); }
        }
        warning = OptStr(raw, "warning") ?? DefaultWarning;
        regenerate = Template(raw, "regenerate", DefaultRegenerate, errors);
        string[] listed = raw.Contains("keys") ? StrArr(raw, "keys") : (string[])Known.Clone();
        foreach (string key in listed)
        {
            if (Array.IndexOf(Known, key) < 0) { errors.Add(string.Format("unknown head key '{0}' (allowed: {1})", key, string.Join(", ", Known))); }
        }
        if (listed.Distinct().Count() != listed.Length) { errors.Add("a head key is listed once"); }
        foreach (string required in Known)
        {
            if (Array.IndexOf(listed, required) < 0) { errors.Add(string.Format("the head key '{0}' is required", required)); }
        }
        if (errors.Count == 0 && !listed.SequenceEqual(Known)) { errors.Add(string.Format("the head keys are written in this order: {0}", string.Join(", ", Known))); }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        order = listed;
    }

    // The regenerate template names the file by {path} and uses no placeholder but {writer} and {path}.
    private static string Template(IDictionary raw, string key, string fallback, List<string> errors)
    {
        string template = OptStr(raw, key) ?? fallback;
        if (template.IndexOf("{path}", StringComparison.Ordinal) < 0)
        {
            errors.Add(string.Format("the {0} template '{1}' names no {{path}}", key, template));
        }
        foreach (Match token in Placeholder.Matches(template))
        {
            if (Array.IndexOf(Placeholders, token.Value) < 0)
            {
                errors.Add(string.Format("the {0} template '{1}' has the unknown placeholder '{2}' (allowed: {3})", key, template, token.Value, string.Join(", ", Placeholders)));
            }
        }
        return template;
    }
}
