/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Languages/types/ImprintStep.cs
    folder: types
    name: imprint-step
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ImprintStep.cs.md](docs/references/pwsh/catzc-base-languages/types/ImprintStep.cs.md)"
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class ImprintStep
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The step's name, as languages.yml spells it (e.g. file-meta).
    public string name { get; }

    // Repository-relative files that decide what the step writes, so the result cache re-checks every file when one changes.
    public IReadOnlyList<string> settings { get; }

    public ImprintStep(string name, string[] settings)
    {
        this.name = name;
        this.settings = settings == null ? Array.Empty<string>() : (string[])settings.Clone();
    }
}
