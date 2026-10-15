// One imprint step of the file-language registry: its name, and the files whose bytes change what it writes.
// [ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)

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
