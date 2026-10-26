using System;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Slides;

// The draw.io kit's files, the one place their names are joined onto the kit folder (slides.yml drawio_kit, or a command's -Kit).
public sealed class DrawioKit
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string RendererFile = "drawio_forward.py";
    public const string DeclarationFile = "declaration.py";
    public const string ConfigFile = "configs/drawio.yml";
    public const string ManifestFile = "pyproject.toml";

    // The one package line New-PythonProject writes into a module member's manifest.
    private static readonly Regex PackageLine = new Regex(@"^packages = \[""([A-Za-z_][A-Za-z0-9_.]*)""\]\s*$", RegexOptions.Multiline);

    // The kit folder, full path.
    public string Folder { get; }

    // The renderer every diagram build runs.
    public string Renderer { get; }

    // The declaration tool: put, get, sync, check and the carrier commands.
    public string Declaration { get; }

    // The kit's drawio.yml: the defaults, the carriers and the roles by stem.
    public string Config { get; }

    // The kit's manifest, which names the package the kit imports as.
    public string Manifest { get; }

    public DrawioKit(string repositoryRoot, string kit)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentException("repositoryRoot must not be empty", "repositoryRoot"); }
        if (string.IsNullOrEmpty(kit)) { throw new ArgumentException("kit must not be empty", "kit"); }
        Folder = Path.GetFullPath(Path.Combine(repositoryRoot, kit));
        Renderer = Path.GetFullPath(Path.Combine(Folder, RendererFile));
        Declaration = Path.GetFullPath(Path.Combine(Folder, DeclarationFile));
        Config = Path.GetFullPath(Path.Combine(Folder, ConfigFile));
        Manifest = Path.GetFullPath(Path.Combine(Folder, ManifestFile));
    }

    // A method, not a property: PowerShell swallows a getter's exception, so a missing manifest entry would read as null.
    public string RendererModule() => ModuleOf(RendererFile);

    // The declaration tool as the module `python -m` runs.
    public string DeclarationModule() => ModuleOf(DeclarationFile);

    // A tool of the kit as a module: the package the manifest names, a dot, the tool's file stem.
    private string ModuleOf(string file)
    {
        if (!File.Exists(Manifest)) { throw new InvalidOperationException($"the draw.io kit has no {ManifestFile} at {Manifest}, so it names no package; run Build-RootConfig"); }
        Match match = PackageLine.Match(File.ReadAllText(Manifest));
        if (!match.Success) { throw new InvalidOperationException($"{Manifest} names no package (a packages = [\"...\"] line), so the kit runs as no module; run Build-RootConfig"); }
        return match.Groups[1].Value + "." + Path.GetFileNameWithoutExtension(file);
    }
}
