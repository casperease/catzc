/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/FormatterEngine.cs
    kind: csharp-type
    module: Catzc.Base.Languages
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-FORMAT#8
---
*/

// The settings files are listed so Format-Code's result cache is invalidated when one of them changes the engine's output.
// [comment:1](/docs/references/automation/catzc-base-languages/types/FormatterEngine.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FormatterEngine
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The engine's name, as a language's `formatter:` spells it (e.g. prettier).
    public string name { get; }

    // Null when the editor has no extension that runs the engine, so the engine has no editor formatter.
    // [comment:2](/docs/references/automation/catzc-base-languages/types/FormatterEngine.cs.md#comment2)
    public string vscode_extension { get; }

    // The repository-relative files whose content decides the engine's output (e.g. .prettierrc.yml). Empty when none.
    public IReadOnlyList<string> settings { get; }

    public FormatterEngine(string name, string vscodeExtension, string[] settings)
    {
        this.name = name;
        vscode_extension = vscodeExtension;
        this.settings = settings == null ? Array.Empty<string>() : (string[])settings.Clone();
    }
}
