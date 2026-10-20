/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/types/LinkWrap.cs
    folder: types
    name: link-wrap
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[LinkWrap.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/LinkWrap.cs.md)"
    cites:
      - ADR-REPO-LINK-ALIGNEDBYTOOL
---
*/

namespace Catzc.Base.QualityGates;

public enum LinkWrap
{
    Break,
    Off,
}
