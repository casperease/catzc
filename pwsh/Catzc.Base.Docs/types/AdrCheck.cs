/*
---
catzc:
  immutable:
    with_body_sha: "873cac59303b"
  edges:
    docs: "[AdrCheck.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrCheck.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode" };

    public CheckMode mode { get; }

    internal AdrCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        if (raw == null) { return; }
        AdrChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = AdrChecksConfig.ParseMode(raw, where, errors);
    }
}
