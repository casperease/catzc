// One YAML file discovered by scanning a repository, with the classification derived from its content.
// The filesystem-side view of a pipeline/template (before any cross-reference to ADO registration).

using System;

namespace Catzc.Azure.DevOps;

public sealed class YamlFileRecord
{
    // The scan root the file was found under (absolute). Always present.
    public string                     Root              { get; }

    // The file's absolute path. Always present.
    public string                     Path              { get; }

    // The file's path relative to Root.
    public string                     RelativePath      { get; }

    // The directory of the file, relative to Root.
    public string                     RelativeDirectory { get; }

    // The coarse classification derived from the file's top-level keys.
    public YamlClassification         Classification    { get; }

    // The template sub-kind. Null for non-Template files.
    public Nullable<YamlTemplateType> TemplateType      { get; }

    // The file's top-level YAML keys — the evidence the classification was derived from. Never null (an
    // empty array when there were none).
    public string[]                   TopLevelKeys      { get; }

    // The YAML parse error, if the file failed to parse. Null when it parsed cleanly.
    public string                     ParseError        { get; }

    // Classification/templateType are taken as strings and parsed to enums, so a producer (or a test mock)
    // that supplies string literals binds without first converting to enum values.
    public YamlFileRecord(string root, string path, string relativePath, string relativeDirectory, string classification, string templateType, string[] topLevelKeys, string parseError)
    {
        if (string.IsNullOrWhiteSpace(root)) { throw new ArgumentException("YamlFileRecord.Root is required"); }
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("YamlFileRecord.Path is required"); }
        Root              = root;
        Path              = path;
        RelativePath      = relativePath;
        RelativeDirectory = relativeDirectory;
        Classification    = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType      = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
        TopLevelKeys      = topLevelKeys ?? new string[0];
        ParseError        = string.IsNullOrWhiteSpace(parseError) ? null : parseError;
    }
}
