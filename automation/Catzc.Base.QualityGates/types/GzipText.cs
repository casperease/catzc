namespace Catzc.Base.QualityGates;

using System.IO;
using System.IO.Compression;

/// <summary>
/// Gzip compress/decompress for UTF-8 text payloads, using only the BCL (ADR-TYPES:5). Shared by
/// Build-EnglishDictionary (writes the committed english.txt.gz) and SpellingOracle (reads it). Kept in one
/// place so the container handling cannot drift between the writer and the reader.
/// </summary>
public static class GzipText
{
    public static byte[] Compress(byte[] data)
    {
        using var output = new MemoryStream();
        using (var gzip = new GZipStream(output, CompressionLevel.Optimal, leaveOpen: true))
        {
            gzip.Write(data, 0, data.Length);
        }
        return output.ToArray();
    }

    public static byte[] Decompress(byte[] data)
    {
        using var input = new MemoryStream(data);
        using var gzip = new GZipStream(input, CompressionMode.Decompress);
        using var output = new MemoryStream();
        gzip.CopyTo(output);
        return output.ToArray();
    }
}
