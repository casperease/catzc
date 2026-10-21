/*
---
catzc:
  immutable:
    with_body_sha: "6bed67d2a3af"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/types/AccostedFile.Tests.ps1
    docs: "[AccostedFile.cs.md](../../../docs/references/pwsh/catzc-base-contracts/types/AccostedFile.cs.md)"
    cites:
      - ADR-AUTO-ACCOSTED-FILEFORM
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Contracts;

public sealed class AccostedFile
{
    public IReadOnlyList<AccostedRun> runs { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Reads the parsed document; the structure only, since the one reader checks each command against its contract.
    public AccostedFile(IDictionary raw)
    {
        if (raw == null || raw.Count != 1 || !raw.Contains("runs"))
        {
            throw new ArgumentException("accosted file: the document has one key, runs");
        }
        IEnumerable list = raw["runs"] as IEnumerable;
        if (list == null || raw["runs"] is string || raw["runs"] is IDictionary)
        {
            throw new ArgumentException("accosted file: runs is a list of runs");
        }
        List<AccostedRun> read = new List<AccostedRun>();
        foreach (object item in list)
        {
            read.Add(new AccostedRun(item, string.Format(CultureInfo.InvariantCulture, "run {0}", read.Count + 1)));
        }
        if (read.Count == 0)
        {
            throw new ArgumentException("accosted file: runs holds at least one run");
        }
        runs = read;
    }
}
