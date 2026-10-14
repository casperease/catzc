// One formatter engine's settings in the file-language registry (configs/languages.yml `engines:`): the VS Code
// extension that runs the same engine in the editor, so Format Document and Format-Code agree
// ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)). The fields mirror the YAML
// keys, so the properties are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's key.

namespace Catzc.Base.Languages;

public sealed class FormatterEngine
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The engine's name, as a language's `formatter:` spells it (e.g. prettier).
    public string name { get; }

    // The publisher.name id of the VS Code extension that runs the engine (e.g. esbenp.prettier-vscode). Null when the
    // editor has none.
    public string vscode_extension { get; }

    public FormatterEngine(string name, string vscodeExtension)
    {
        this.name = name;
        vscode_extension = vscodeExtension;
    }
}
