using System;

namespace Catzc.Base.FileLimits;

public sealed class FileLimit
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public int? length { get; }
    public int? width { get; }

    public FileLimit(int? length, int? width)
    {
        this.length = length;
        this.width = width;
    }
}
