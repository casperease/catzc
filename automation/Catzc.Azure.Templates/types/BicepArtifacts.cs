/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/types/BicepArtifacts.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Azure.Templates
    relatives:
      page: docs/references/automation/catzc-azure-templates/types/BicepArtifacts.cs.md
---
*/

using System;

namespace Catzc.Azure.Templates;

public sealed class BicepArtifacts
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // True when the template was compiled locally for this deploy (rather than reusing a prior build).
    public bool did_local_build { get; }

    // The template's build folder (repo-relative). Always present.
    public string folder { get; }

    // The ARM/Bicep template file to deploy (repo-relative). Always present.
    public string template_file { get; }

    // The parameters file for the deploy (repo-relative). Always present.
    public string parameters_file { get; }

    // The template's PrePost.psm1 hook module (repo-relative). Null when the template ships no PrePost.psm1.
    public string prepost_module { get; }

    public BicepArtifacts(bool did_local_build, string folder, string template_file, string parameters_file, string prepost_module)
    {
        if (string.IsNullOrWhiteSpace(folder)) { throw new ArgumentException("BicepArtifacts.folder is required"); }
        if (string.IsNullOrWhiteSpace(template_file)) { throw new ArgumentException("BicepArtifacts.template_file is required"); }
        if (string.IsNullOrWhiteSpace(parameters_file)) { throw new ArgumentException("BicepArtifacts.parameters_file is required"); }
        this.did_local_build = did_local_build;
        this.folder = folder;
        this.template_file = template_file;
        this.parameters_file = parameters_file;
        this.prepost_module = string.IsNullOrWhiteSpace(prepost_module) ? null : prepost_module;
    }
}
