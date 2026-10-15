/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrCheck.cs
    kind: type
    module: Catzc.Base.Docs
---
*/

// Only a mode is configurable here; an omitted mode takes the default CheckMode declares, which is gate.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrCheck.cs.md#comment1)

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
