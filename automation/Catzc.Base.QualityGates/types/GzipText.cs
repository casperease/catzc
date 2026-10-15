/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/GzipText.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-PWSH-TYPES#1
---
*/

namespace Catzc.Base.QualityGates;

using System.IO;
using System.IO.Compression;

/// <summary> Kept in one place so the container handling cannot drift between the writer and the reader.
/// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/GzipText.cs.md#comment1)
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
