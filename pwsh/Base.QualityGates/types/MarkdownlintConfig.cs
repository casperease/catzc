using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class MarkdownlintConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const int DefaultBatchSize = 50;
    private const int MaxBatchSize = 500;

    public int batch_size { get; } = DefaultBatchSize;

    public MarkdownlintConfig(IDictionary raw)
    {
        var errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "batch_size")
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: batch_size)", name));
                }
            }
            if (raw.Contains("batch_size") && raw["batch_size"] != null)
            {
                int size;
                if (int.TryParse(Convert.ToString(raw["batch_size"], CultureInfo.InvariantCulture), NumberStyles.Integer, CultureInfo.InvariantCulture, out size) && size > 0 && size <= MaxBatchSize)
                {
                    batch_size = size;
                }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "batch_size must be a whole number from 1 to {0}", MaxBatchSize));
                }
            }
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("markdownlint config validation failed:\n  - " + string.Join("\n  - ", errors));
        }
    }
}
