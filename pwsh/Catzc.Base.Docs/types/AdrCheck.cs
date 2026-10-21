/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrCheck.cs
    folder: types
    name: adr-check
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
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
