using System;
using System.IO;

namespace Catzc.Base.Slides;

// The draw.io kit's files, the one place their names are joined onto the kit folder (slides.yml drawio_kit, or a command's -Kit).
public sealed class DrawioKit
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string RendererFile = "drawio_forward.py";
    public const string DeclarationFile = "declaration.py";
    public const string ConfigFile = "configs/drawio.yml";

    // The kit folder, full path.
    public string Folder { get; }

    // The renderer every diagram build runs.
    public string Renderer { get; }

    // The declaration tool: put, get, sync, check and the carrier commands.
    public string Declaration { get; }

    // The kit's drawio.yml: the defaults, the carriers and the roles by stem.
    public string Config { get; }

    public DrawioKit(string repositoryRoot, string kit)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentException("repositoryRoot must not be empty", "repositoryRoot"); }
        if (string.IsNullOrEmpty(kit)) { throw new ArgumentException("kit must not be empty", "kit"); }
        Folder = Path.GetFullPath(Path.Combine(repositoryRoot, kit));
        Renderer = Path.GetFullPath(Path.Combine(Folder, RendererFile));
        Declaration = Path.GetFullPath(Path.Combine(Folder, DeclarationFile));
        Config = Path.GetFullPath(Path.Combine(Folder, ConfigFile));
    }
}
