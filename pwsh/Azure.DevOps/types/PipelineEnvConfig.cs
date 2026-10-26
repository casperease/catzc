using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure.DevOps;

// A bare YAML sequence of variable names, exposed as variables; names are unique case-insensitively, as Windows variables are.
public sealed class PipelineEnvConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "pipeline-env config validation failed:\n";
    private static readonly Regex VariableName = new Regex("^[A-Za-z_][A-Za-z0-9_]*$");

    // The whitelisted environment variable names, in file order.
    public string[] variables { get; }

    // The parsed YAML: a sequence (a list) of environment variable names.
    public PipelineEnvConfig(object raw)
    {
        if (raw == null || raw is string || raw is IDictionary || !(raw is IEnumerable))
        {
            throw new ArgumentException(Failed + "the file must be a sequence of environment variable names");
        }

        List<string> errors = new List<string>();
        List<string> names = new List<string>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        int count = 0;
        foreach (object item in (IEnumerable)raw)
        {
            count++;
            string name = (item is IDictionary || item is IList || item == null) ? null : item.ToString();
            if (name == null || !VariableName.IsMatch(name))
            {
                errors.Add(string.Format("'{0}' is not an environment variable name (must match ^[A-Za-z_][A-Za-z0-9_]*$)", item));
                continue;
            }
            if (!seen.Add(name))
            {
                errors.Add(string.Format("duplicate environment variable '{0}'", name));
                continue;
            }
            names.Add(name);
        }
        if (count == 0) { errors.Add("the sequence is empty — list at least one environment variable name"); }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        variables = names.ToArray();
    }
}
