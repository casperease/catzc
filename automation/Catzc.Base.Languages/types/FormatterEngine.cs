// One formatter engine's settings in the file-language registry (configs/languages.yml `engines:`): the VS Code extension that runs the...
// [ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-languages/types/FormatterEngine.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

public sealed class FormatterEngine
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The engine's name, as a language's `formatter:` spells it (e.g. prettier).
    public string name { get; }

    // The publisher.name id of the VS Code extension that runs the engine (e.g.
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
