using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Variants;

// One module's declaration of what its generators write: each target a repository path or glob and the generator that writes it.
// Every generating module keeps its own configs/generated.yml; Get-GeneratedTarget reads every owner beside rootconfig.yml.
public sealed class GeneratedConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "targets" };
    private static readonly string[] AllowedTargetKeys = { "path", "generator" };

    public IReadOnlyList<GeneratedTarget> targets { get; }

    public GeneratedConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<GeneratedTarget> list = new List<GeneratedTarget>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }
            object value = raw.Contains("targets") ? raw["targets"] : null;
            IList items = value as IList;
            if (value != null && (items == null || value is string))
            {
                errors.Add("targets must be a list of { path, generator }");
            }
            else if (items != null)
            {
                foreach (object item in items)
                {
                    IDictionary entry = item as IDictionary;
                    if (entry == null)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "target '{0}' must be a mapping of path and generator", item));
                        continue;
                    }
                    foreach (object key in entry.Keys)
                    {
                        string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                        if (Array.IndexOf(AllowedTargetKeys, name) < 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "target: unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedTargetKeys)));
                        }
                    }
                    string path = entry.Contains("path") ? entry["path"] as string : null;
                    string generator = entry.Contains("generator") ? entry["generator"] as string : null;
                    if (string.IsNullOrWhiteSpace(path) || path.IndexOf('\\') >= 0 || path.StartsWith("/", StringComparison.Ordinal))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "target path '{0}' must be a repository-relative path or glob, '/'-separated", path));
                        continue;
                    }
                    if (string.IsNullOrWhiteSpace(generator))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "target '{0}' names no generator", path));
                        continue;
                    }
                    list.Add(new GeneratedTarget(path, generator));
                }
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        targets = list.AsReadOnly();
    }
}

// A generated target: the path or glob a generator writes, and the generator.
public sealed class GeneratedTarget
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string path { get; }

    public string generator { get; }

    public GeneratedTarget(string path, string generator)
    {
        this.path = path;
        this.generator = generator;
    }
}
