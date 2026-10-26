using System;

namespace Catzc.Azure.DevOps;

// The inventory row that answers whether a file backs a registered pipeline; registration fields are null when it does not.
public sealed class YamlInventoryRecord
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

    // The classification, reconciled with registration: an Unknown file that IS registered becomes Pipeline.
    public YamlClassification Classification { get; }

    // The template sub-kind. Null for non-Template files.
    public Nullable<YamlTemplateType> TemplateType { get; }

    // True when this file backs a registered ADO pipeline; gates the registration-side fields below.
    public bool IsRegistered { get; }

    // The registered pipeline's name. Null when the file is not registered.
    public string PipelineName { get; }

    // The registered pipeline's id. Null when the file is not registered.
    public Nullable<int> PipelineId { get; }

    // The ADO folder the registered pipeline lives in. Null when the file is not registered.
    public string PipelineDirectory { get; }

    // The file's top-level YAML keys. Never null (an empty array when there were none).
    public string[] TopLevelKeys { get; }

    // The YAML parse error, if any. Null when the file parsed cleanly.
    public string ParseError { get; }

    // Flat over primitives, not a YamlFileRecord, so a test mocking the scan with a plain pscustomobject still binds.
    public YamlInventoryRecord(string root, string path, string relativePath, string relativeDirectory, string classification, string templateType, bool isRegistered, string pipelineName, Nullable<int> pipelineId, string pipelineDirectory, string[] topLevelKeys, string parseError)
    {
        if (string.IsNullOrWhiteSpace(root)) { throw new ArgumentException("YamlInventoryRecord.Root is required"); }
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("YamlInventoryRecord.Path is required"); }
        Root = root;
        Path = path;
        RelativePath = relativePath;
        RelativeDirectory = relativeDirectory;
        Classification = (YamlClassification)Enum.Parse(typeof(YamlClassification), classification, true);
        TemplateType = string.IsNullOrWhiteSpace(templateType)
            ? (Nullable<YamlTemplateType>)null
            : (YamlTemplateType)Enum.Parse(typeof(YamlTemplateType), templateType, true);
        IsRegistered = isRegistered;
        PipelineName = string.IsNullOrWhiteSpace(pipelineName) ? null : pipelineName;
        PipelineId = pipelineId;
        PipelineDirectory = string.IsNullOrWhiteSpace(pipelineDirectory) ? null : pipelineDirectory;
        TopLevelKeys = topLevelKeys ?? new string[0];
        ParseError = string.IsNullOrWhiteSpace(parseError) ? null : parseError;
    }
}
