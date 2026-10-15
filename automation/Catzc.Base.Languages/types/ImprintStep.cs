/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/ImprintStep.cs
    kind: type
    module: Catzc.Base.Languages
    adrs:
      - ADR-REPO-FORMAT#8
---
*/

// One imprint step of the file-language registry: its name, and the files whose bytes change what it writes.
// [comment:1](/docs/references/automation/catzc-base-languages/types/ImprintStep.cs.md#comment1)

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
