/*
---
catzc:
  immutable:
    with_body_sha: "63fc75d894bf"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/types/GzipText.Tests.ps1
    docs: "[GzipText.cs.md](docs/references/pwsh/catzc-base-quality-gates/types/GzipText.cs.md)"
    cites:
      - ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES
---
*/

namespace Catzc.Base.QualityGates;

using System.IO;
using System.IO.Compression;

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
