/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlClassificationResult.cs
    kind: type
    module: Catzc.Azure.DevOps
    adrs: []
---
*/

// The outcome of classifying one ADO YAML file: the coarse kind plus, for templates, the body sub-kind.

using System;

namespace Catzc.Azure.DevOps;

public sealed class YamlClassificationResult
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The coarse classification — Pipeline, Template, or Unknown.
    public YamlClassification Classification { get; }

    // The template sub-kind. Null for non-Template files (Pipeline/Unknown).
    public Nullable<YamlTemplateType> TemplateType { get; }

    // Strings are parsed to the enums here, so a caller holding string literals binds without converting first.
    // [comment:1](/docs/references/automation/catzc-azure-devops/types/YamlClassificationResult.cs.md#comment1)
    public YamlClassificationResult(string classification, string templateType)
    {
        Classification = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
    }
}
