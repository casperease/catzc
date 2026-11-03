namespace Catzc.Base.Languages;

// How a language's modules are packaged into a bundle: the exporter command and the shipped form it produces.
public sealed class LanguagePackage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The shipped forms a language's module can take in a bundle; declared once here.
    public static readonly string[] Forms = { "binary", "source", "wheels", "vsix" };

    // The command that exports one module of the language into the bundle (e.g. Export-GoModule); validated by form only.
    public string command { get; }

    // The shipped form of the module: one of binary, source, wheels or vsix.
    public string form { get; }

    public LanguagePackage(string command, string form)
    {
        this.command = command;
        this.form = form;
    }
}
