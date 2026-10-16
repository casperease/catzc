/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs
    folder: types
    name: comment-block-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    adrs:
      - ADR-PRIN-ONELIVE#1
---
*/

// A run of line comments, or one delimited block; both move to the page the same way.

namespace Catzc.Base.QualityGates;

public enum CommentBlockKind
{
    LineRun,
    Block,
}
