/*
---
catzc:
  immutable:
    with_body_sha: "107b68e71d81"
  edges:
    docs: "[CsvExportRef.cs.md](../../../docs/references/pwsh/catzc-azure-firewall/types/CsvExportRef.cs.md)"
---
*/

using System;

namespace Catzc.Azure.Firewall;

public sealed class CsvExportRef
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Which rule collection kind this CSV holds (application or network).
    public RuleType Type { get; }

    // Absolute path of the downloaded CSV on the local disk. Always present.
    public string Path { get; }

    // When the export was generated (UTC), parsed from the source blob's file name.
    public DateTime Generated { get; }

    // The source blob's name in storage — the provenance of this CSV.
    public string Blob { get; }

    // The source blob's last-modified time.
    public DateTime Modified { get; }

    // Type is taken as the tooling's lowercase string ('application'/'network') and parsed to the enum.
    public CsvExportRef(string type, string path, DateTime generated, string blob, DateTime modified)
    {
        Type = (RuleType)Enum.Parse(typeof(RuleType), type, true);
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("CsvExportRef.Path is required"); }
        Path = path;
        Generated = generated;
        Blob = blob;
        Modified = modified;
    }
}
