/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/LinksConfig.cs
    kind: type
    module: Catzc.Base.QualityGates
---
*/

// The one declaration of the defaults: every key is optional, so no function restates a value and a missing file acts the same.
// [ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6),
// [ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4),
// [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinksConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class LinksConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const LinkWrap DefaultWrap = LinkWrap.Break;
    public const int DefaultLineLimit = 140;

    public LinkWrap wrap { get; }
    public IReadOnlyDictionary<string, int> line_limit { get; }
    public int default_line_limit { get; }
    public SourceCheck string_citations { get; }

    public LinksConfig(IDictionary raw)
    {
        wrap = DefaultWrap;
        default_line_limit = DefaultLineLimit;
        var limits = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        IDictionary stringCitations = null;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "wrap" && name != "line_limit" && name != "default_line_limit" && name != "string_citations")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "links config: unknown key '{0}' (allowed: wrap, line_limit, default_line_limit, string_citations)", name));
                }
            }

            if (raw.Contains("string_citations") && raw["string_citations"] != null)
            {
                stringCitations = raw["string_citations"] as IDictionary
                    ?? throw new ArgumentException("links config: string_citations must be a map (mode, exempt)");
            }

            if (raw.Contains("wrap") && raw["wrap"] != null)
            {
                string value = Convert.ToString(raw["wrap"], CultureInfo.InvariantCulture);
                if (!Enum.TryParse(value, true, out LinkWrap parsed) || int.TryParse(value, out _))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "links config: wrap '{0}' is not one of: {1}", value, string.Join(", ", Enum.GetNames(typeof(LinkWrap))).ToLowerInvariant()));
                }
                wrap = parsed;
            }

            if (raw.Contains("default_line_limit") && raw["default_line_limit"] != null)
            {
                default_line_limit = PositiveInt("default_line_limit", raw["default_line_limit"]);
            }

            if (raw.Contains("line_limit") && raw["line_limit"] != null)
            {
                if (!(raw["line_limit"] is IDictionary overrides))
                {
                    throw new ArgumentException("links config: line_limit must be a map of extension to limit, e.g. { .ps1: 120 }");
                }
                foreach (DictionaryEntry entry in overrides)
                {
                    string extension = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    if (string.IsNullOrEmpty(extension) || extension[0] != '.')
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "links config: line_limit key '{0}' must be a file extension starting with '.'", extension));
                    }
                    limits[extension] = PositiveInt("line_limit." + extension, entry.Value);
                }
            }
        }

        line_limit = limits;
        string_citations = new SourceCheck("links config: string_citations", stringCitations);
    }

    static int PositiveInt(string key, object value)
    {
        if (!int.TryParse(Convert.ToString(value, CultureInfo.InvariantCulture), NumberStyles.Integer, CultureInfo.InvariantCulture, out int parsed) || parsed <= 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "links config: {0} must be a positive integer, got '{1}'", key, value));
        }
        return parsed;
    }
}
