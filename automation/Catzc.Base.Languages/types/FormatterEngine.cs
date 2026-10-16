/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/types/FormatterEngine.cs
    folder: types
    name: formatter-engine
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/types/FormatterEngine.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-FORMAT#8
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FormatterEngine
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The engine's name, as a language's `formatter:` spells it (e.g. prettier).
    public string name { get; }

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
