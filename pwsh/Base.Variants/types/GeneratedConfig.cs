using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Variants;

// One module's writers of generated files, each a row keyed by its name; Get-GeneratedTarget reads every owner.
public sealed class GeneratedConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "writers" };

    // The module's writer rows, in declaration order. Default: none.
    public IReadOnlyList<GeneratedWriterRow> writers { get; }

    public GeneratedConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<GeneratedWriterRow> list = new List<GeneratedWriterRow>();
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
            object value = raw.Contains("writers") ? raw["writers"] : null;
            IDictionary rows = value as IDictionary;
            if (value != null && rows == null)
            {
                errors.Add("writers must be a mapping of writer name to its row");
            }
            else if (rows != null)
            {
                foreach (object key in rows.Keys)
                {
                    try { list.Add(new GeneratedWriterRow(Convert.ToString(key, CultureInfo.InvariantCulture), rows[key])); }
                    catch (ArgumentException ex) { errors.Add(ex.Message); }
                }
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        writers = list.AsReadOnly();
    }
}
