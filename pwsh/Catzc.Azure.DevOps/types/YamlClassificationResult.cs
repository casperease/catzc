/*
---
catzc:
  immutable:
    with_body_sha: "7754b73f6538"
  edges:
    docs: "[YamlClassificationResult.cs.md](docs/references/pwsh/catzc-azure-devops/types/YamlClassificationResult.cs.md)"
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

    public YamlClassificationResult(string classification, string templateType)
    {
        Classification = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
    }
}
