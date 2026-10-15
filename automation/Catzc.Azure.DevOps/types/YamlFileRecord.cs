/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlFileRecord.cs
    kind: csharp-type
    module: Catzc.Azure.DevOps
---
*/

// The filesystem-side view of a file, before any cross-reference to ADO registration.
// [comment:1](/docs/references/automation/catzc-azure-devops/types/YamlFileRecord.cs.md#comment1)

using System;

namespace Catzc.Azure.DevOps;

public sealed class YamlFileRecord
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The scan root the file was found under (absolute). Always present.
    public string Root { get; }

    // The file's absolute path. Always present.
    public string Path { get; }

    // The file's path relative to Root.
    public string RelativePath { get; }

    // The directory of the file, relative to Root.
    public string RelativeDirectory { get; }

    // The coarse classification derived from the file's top-level keys.
    public YamlClassification Classification { get; }

    // The template sub-kind. Null for non-Template files.
    public Nullable<YamlTemplateType> TemplateType { get; }

    // Never null: a file with no top-level keys gives an empty array, so callers can enumerate without a guard.
    // [comment:2](/docs/references/automation/catzc-azure-devops/types/YamlFileRecord.cs.md#comment2)
    public string[] TopLevelKeys { get; }

    // The YAML parse error, if the file failed to parse. Null when it parsed cleanly.
    public string ParseError { get; }

    // Strings are parsed to enums here, so a producer or test mock supplying literals binds without converting first.
    // [comment:3](/docs/references/automation/catzc-azure-devops/types/YamlFileRecord.cs.md#comment3)
    public YamlFileRecord(string root, string path, string relativePath, string relativeDirectory, string classification, string templateType, string[] topLevelKeys, string parseError)
    {
        if (string.IsNullOrWhiteSpace(root)) { throw new ArgumentException("YamlFileRecord.Root is required"); }
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("YamlFileRecord.Path is required"); }
        Root = root;
        Path = path;
        RelativePath = relativePath;
        RelativeDirectory = relativeDirectory;
        Classification = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
        TopLevelKeys = topLevelKeys ?? new string[0];
        ParseError = string.IsNullOrWhiteSpace(parseError) ? null : parseError;
    }
}
