// The link-alignment settings (configs/links.yml,
// [ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)), and the single declaration of their sensible
// defaults: every key is optional, and an omitted key — or a fresh checkout with no file — behaves exactly like
// the default, so no function restates a value
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). A Format-Links parameter overrides the
// resolved value per call ([ADR-PWSH-PARAM#4](/docs/adr/pwsh/parameter-design.md#rule-adr-pwsh-param4)).
//   wrap               — how an aligned comment line that outgrows its limit is wrapped (break | off; default break)
//   line_limit         — per-extension limit overrides ({ .ps1: 120 }); default none, so .editorconfig decides
//   default_line_limit — the limit for an extension .editorconfig gives no max_line_length (default 140, the
//                        repository's prose target)
//   string_citations   — the check that a rule citation in a code string literal is spelled ADR-<CODE>#<n>, never with
//                        a ':' outside a '### Rule' heading
//                        ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)): its mode
//                        and exempt globs (a SourceCheck; default gate, nothing exempt)
// Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

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
