// The pipeline-diagnostics whitelist, configs/pipeline-env.yml: a top-level SEQUENCE of environment variable
// names that Write-AdoEnvironmentDiagnostic prints at the top of every Invoke-AdoScript run (build context,
// paths, agent info). The YAML has no top-level key, so the sequence is exposed as `variables`. Constructing an
// instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.PipelineEnvConfig), so
// Get-Config -Config pipeline-env returns this typed model.
//
// Load-time rules:
//   - the file is a non-empty sequence (a mapping or a scalar is rejected);
//   - each entry is an environment variable name (^[A-Za-z_][A-Za-z0-9_]*$) — a scalar, never a map or a list;
//   - names are unique case-insensitively (Windows environment variable names are case-insensitive).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure.DevOps;

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
