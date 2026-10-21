/*
---
catzc:
  immutable:
    with_body_sha: "4e2a6f8a93ff"
  edges:
    docs: "[AccostedRun.cs.md](../../../docs/references/pwsh/catzc-base-contracts/types/AccostedRun.cs.md)"
    cites:
      - ADR-AUTO-ACCOSTED-FILEFORM
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Contracts;

public sealed class AccostedRun
{
    public IReadOnlyList<AccostedCommand> commands { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Reads one run, a non-empty list of commands; where says which run it is, for messages.
    public AccostedRun(object raw, string where)
    {
        IEnumerable list = raw as IEnumerable;
        if (list == null || raw is string || raw is IDictionary)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: a run is a list of commands", where));
        }
        List<AccostedCommand> read = new List<AccostedCommand>();
        foreach (object item in list)
        {
            read.Add(new AccostedCommand(item, string.Format(CultureInfo.InvariantCulture, "{0}, command {1}", where, read.Count + 1)));
        }
        if (read.Count == 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: a run holds at least one command", where));
        }
        commands = read;
    }
}
