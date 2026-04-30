// A reference to one exported firewall-rules CSV on disk: which rule kind it holds, where the local file
// is, and the provenance of the blob it came from. The handle passed down the export → convert chain.

using System;

namespace Catzc.Azure.Firewall;

public sealed class CsvExportRef
{
    // Which rule collection kind this CSV holds (application or network).
    public RuleType Type      { get; }

    // Absolute path of the downloaded CSV on the local disk. Always present.
    public string   Path      { get; }

    // When the export was generated (UTC), parsed from the source blob's file name.
    public DateTime Generated { get; }

    // The source blob's name in storage — the provenance of this CSV.
    public string   Blob      { get; }

    // The source blob's last-modified time.
    public DateTime Modified  { get; }

    // Type is taken as the tooling's lowercase string ('application'/'network') and parsed to the enum.
    public CsvExportRef(string type, string path, DateTime generated, string blob, DateTime modified)
    {
        Type = (RuleType)Enum.Parse(typeof(RuleType), type, true);
        if (string.IsNullOrWhiteSpace(path)) { throw new ArgumentException("CsvExportRef.Path is required"); }
        Path      = path;
        Generated = generated;
        Blob      = blob;
        Modified  = modified;
    }
}
