/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/types/HeadPolicy.cs
    folder: types
    name: head-policy
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
*/

namespace Catzc.Base.QualityGates;

public enum HeadPolicy
{
    Required,
    Optional,
    Forbidden,
}
