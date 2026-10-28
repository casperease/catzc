using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Variants;

// One output of a writer row: the path or glob it writes, and the inputs this output reads, which default to the writer's inputs.
public sealed class GeneratedOutput : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "path", "inputs" };

    // The repository-relative path or glob the writer writes, '/'-separated.
    public string path { get; }

    // The repository-relative globs this output reads. Default: every input of its writer.
    public string[] inputs { get; }

    // An output is a bare path, or a mapping of its path and the inputs it reads.
    public GeneratedOutput(string writer, object raw, string[] writerInputs)
    {
        List<string> errors = new List<string>();
        IDictionary entry = raw as IDictionary;
        string value;
        if (entry == null)
        {
            value = raw as string;
            inputs = writerInputs ?? new string[0];
        }
        else
        {
            foreach (object k in entry.Keys)
            {
                string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}': output carries unknown key '{1}' (allowed: {2})", writer, key, string.Join(", ", AllowedKeys)));
                }
            }
            value = OptStr(entry, "path");
            inputs = entry.Contains("inputs") ? StrArr(entry, "inputs") : (writerInputs ?? new string[0]);
        }
        if (string.IsNullOrWhiteSpace(value) || value.IndexOf('\\') >= 0 || value.StartsWith("/", StringComparison.Ordinal))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}': output path '{1}' must be a repository-relative path or glob, '/'-separated", writer, value));
        }
        foreach (string input in inputs)
        {
            if (string.IsNullOrWhiteSpace(input) || input.IndexOf('\\') >= 0 || input.StartsWith("/", StringComparison.Ordinal))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "writer '{0}': output '{1}' input '{2}' must be a repository-relative path or glob, '/'-separated", writer, value, input));
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        path = value;
    }
}
