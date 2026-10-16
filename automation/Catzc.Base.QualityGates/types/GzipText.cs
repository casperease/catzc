/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/GzipText.cs
    folder: types
    name: gzip-text
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/GzipText.cs.md
    test: automation/Catzc.Base.QualityGates/tests/types/GzipText.Tests.ps1
    cites:
      - ADR-PWSH-TYPES#1
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
