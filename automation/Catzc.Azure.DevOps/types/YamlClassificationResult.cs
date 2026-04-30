// The outcome of classifying one ADO YAML file: the coarse kind plus, for templates, the body sub-kind.

using System;

namespace Catzc.Azure.DevOps;

public sealed class YamlClassificationResult
{
    // The coarse classification — Pipeline, Template, or Unknown.
    public YamlClassification         Classification { get; }

    // The template sub-kind. Null for non-Template files (Pipeline/Unknown).
    public Nullable<YamlTemplateType> TemplateType   { get; }

    // The constructor takes the two values as strings and parses them to the enums, so a caller that
    // computed string literals binds directly without first converting to enum values.
    public YamlClassificationResult(string classification, string templateType)
    {
        Classification = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
    }
}
