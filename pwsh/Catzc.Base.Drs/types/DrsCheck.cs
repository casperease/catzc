/*
---
catzc:
  immutable:
    with_body_sha: "873cac59303b"
  edges:
    docs: "[DrsCheck.cs.md](docs/references/pwsh/catzc-base-docs/types/DrsCheck.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
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
