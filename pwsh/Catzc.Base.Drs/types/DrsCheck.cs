/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCheck.cs.md"
  header: "generated"
---
*/

using System.Collections;
using System.Collections.Generic;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

public sealed class DrsCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode" };

    public CheckMode mode { get; }

    internal DrsCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        if (raw == null) { return; }
        DrsChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = DrsChecksConfig.ParseMode(raw, where, errors);
    }
}
