// The contracts settings (configs/contracts.yml), and the single declaration of their sensible defaults: every key is
// optional, and an omitted key, or a fresh checkout with no file, behaves exactly like the default, so no function
// restates a value ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). A Get-Contract
// parameter overrides the resolved value per call
// ([ADR-AUTO-PSPARAM#4](/docs/adr/automation/powershell/parameter-design.md#rule-adr-auto-psparam4)).
//   addressing  how one contract asset addresses many files
//               ([ADR-REPO-CONTRACT#8](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract8)), one of AddressingModes;
//               default full-path (an asset addresses the one real file at its own path). A mode in AddressingModes but
//               not in BuiltAddressingModes is declared and valid here, and Get-Contract throws NotImplementedException
//               when it is selected.
// Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Contracts;

public sealed class ContractsConfig
{
    public const string DefaultAddressing = "full-path";

    // Every declared addressing mode: full-path (the asset's own path), manifest-glob (a glob in a manifest names the
    // files), per-folder (one asset applies to each file of its folder).
    public static readonly string[] AddressingModes = { "full-path", "manifest-glob", "per-folder" };

    // The modes that are built. A mode joins this list only once it is proven from both pwsh and bash.
    public static readonly string[] BuiltAddressingModes = { "full-path" };

    public string addressing { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractsConfig(IDictionary raw)
    {
        addressing = DefaultAddressing;
        if (raw == null)
        {
            return;
        }

        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "addressing")
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "contracts config: unknown key '{0}' (allowed: addressing)", name));
            }
        }

        if (raw.Contains("addressing") && raw["addressing"] != null)
        {
            string value = Convert.ToString(raw["addressing"], CultureInfo.InvariantCulture);
            if (Array.IndexOf(AddressingModes, value) < 0)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "contracts config: addressing '{0}' is not one of: {1}", value, string.Join(", ", AddressingModes)));
            }
            addressing = value;
        }
    }
}
