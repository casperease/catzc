namespace Catzc.Base.FileLimits;

public sealed class ResolvedFileLimit
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string language { get; }
    public string file_class { get; }
    public int? length { get; }
    public string length_source { get; }
    public int? width { get; }
    public string width_source { get; }

    public ResolvedFileLimit(string language, string fileClass, int? length, string lengthSource, int? width, string widthSource)
    {
        this.language = language;
        file_class = fileClass;
        this.length = length;
        length_source = lengthSource;
        this.width = width;
        width_source = widthSource;
    }
}
