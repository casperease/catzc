/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/types/LinksConfig.cs
    folder: types
    name: links-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1
    docs: "[LinksConfig.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/LinksConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
      - ADR-PWSH-PARAM-RESOLUTIONORDER
      - ADR-REPO-LINK-ONECITATIONSPELLING
      - ADR-REPO-LINK-ALIGNEDBYTOOL
---
*/

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
