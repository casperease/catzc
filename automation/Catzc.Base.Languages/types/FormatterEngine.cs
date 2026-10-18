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
