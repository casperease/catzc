// One pipeline (build definition) registered in Azure DevOps. The registration-side view of a pipeline:
// its identity and folder placement, and — for YAML pipelines — which file in which repo backs it.

using System;

namespace Catzc.Azure.DevOps;

public sealed class PipelineDefinition
{
    // The ADO build-definition id.
    public int    Id             { get; }

    // The pipeline's display name.
    public string Name           { get; }

    // The ADO folder the definition lives in (the pipeline tree path).
    public string Folder         { get; }

    // Path of the backing YAML file within its repo. Null for a classic (designer, non-YAML) pipeline.
    public string YamlPath       { get; }

    // The backing YAML file's bare file name. Null for a classic pipeline.
    public string FileName       { get; }

    // Name of the repository the pipeline's YAML lives in.
    public string RepositoryName { get; }

    // The definition's revision number.
    public int    Revision       { get; }

    // The web URL of the definition.
    public string Url            { get; }

    public PipelineDefinition(int id, string name, string folder, string yamlPath, string fileName, string repositoryName, int revision, string url)
    {
        Id             = id;
        Name           = name;
        Folder         = folder;
        YamlPath       = string.IsNullOrWhiteSpace(yamlPath) ? null : yamlPath;
        FileName       = string.IsNullOrWhiteSpace(fileName) ? null : fileName;
        RepositoryName = repositoryName;
        Revision       = revision;
        Url            = url;
    }
}
