// Which templates Set-AnomalyAlertRecipientSecret reads; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Azure.Templates;

public sealed class AnomalyAlertConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "anomaly-alert configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "configuration_template", "vault_template" };

    // The template whose configuration references the recipients' Key Vault secret.
    public string configuration_template { get; } = "discovery";

    // The template whose Key Vault holds the recipients' secret, named by the namer.
    public string vault_template { get; } = "foundation";

    public AnomalyAlertConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("configuration_template")) { configuration_template = Template(raw, "configuration_template", errors) ?? configuration_template; }
        if (raw.Contains("vault_template")) { vault_template = Template(raw, "vault_template", errors) ?? vault_template; }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // A template name: one non-empty string.
    private static string Template(IDictionary raw, string key, List<string> errors)
    {
        if (!(raw[key] is string name) || string.IsNullOrWhiteSpace(name))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a template name", key));
            return null;
        }
        return name;
    }
}
