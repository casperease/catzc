/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/CheckMode.cs
    folder: types
    name: check-mode
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[CheckMode.cs.md](docs/references/pwsh/catzc-base-docs/types/CheckMode.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY
---
*/

namespace Catzc.Base.Docs;

public enum CheckMode
{
    Gate = 0,
    Report = 1,
}
