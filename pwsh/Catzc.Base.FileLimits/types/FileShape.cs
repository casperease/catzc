using System.IO;
using System.Text;

namespace Catzc.Base.FileLimits;

public sealed class FileShape
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string path { get; }
    public int lines { get; }
    public int width { get; }
    public int widest_line { get; }

    public FileShape(string path, int lines, int width, int widestLine)
    {
        this.path = path;
        this.lines = lines;
        this.width = width;
        widest_line = widestLine;
    }

    // One streaming pass: the line count and the widest line together, never the whole file in memory.
    public static FileShape Measure(string path)
    {
        int lines = 0, width = 0, widest = 0;
        using (StreamReader reader = new StreamReader(path, Encoding.UTF8, true))
        {
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                lines++;
                if (line.Length > width)
                {
                    width = line.Length;
                    widest = lines;
                }
            }
        }

        return new FileShape(path, lines, width, widest);
    }
}
