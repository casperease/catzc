using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Tooling.Listen;

public sealed class ListenConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultWatch = "docs";
    public const string DefaultOutput = "out/listen";
    public const int DefaultPollMilliseconds = 1000;
    public const int DefaultQuietSeconds = 20;
    public const int DefaultChangeWaitSeconds = 3600;
    public const int DefaultNoteWaitSeconds = 300;
    public const string DefaultRestTier = "code";

    // The sensible default: the rules first, then the rest of the documentation; every other file is the rest tier.
    public static IReadOnlyList<ListenTier> DefaultTiers { get; } = Array.AsReadOnly(new[]
    {
        new ListenTier("rule", Array.AsReadOnly(new[] { "adr", "glossary", "index" })),
        new ListenTier("docs", Array.AsReadOnly(new[] { "explanation", "reference", "how-to", "diagram", "slide", "comment-page" })),
    });

    private static readonly string[] AllowedKeys =
    {
        "watch", "output", "poll_milliseconds", "quiet_seconds", "change_wait_seconds", "note_wait_seconds", "tiers", "rest_tier",
    };

    // The repository-relative folder the listener watches.
    public string watch { get; }

    // The repository-relative folder each listen session's folder is created in.
    public string output { get; }

    // How long the listener sleeps between two looks at the watched folder.
    public int poll_milliseconds { get; }

    // How long the watched folder must stay unchanged before a change counts as settled.
    public int quiet_seconds { get; }

    // The bound of one wait for a settled change; the listener waits again after it.
    public int change_wait_seconds { get; }

    // The bound of one wait for an unprocessed note; under the background roof of the time safeguard.
    public int note_wait_seconds { get; }

    // The tiers, highest first, each a set of file kinds.
    public IReadOnlyList<ListenTier> tiers { get; }

    // The tier of a file whose kind no tier lists.
    public string rest_tier { get; }

    public ListenConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string watchValue = DefaultWatch;
        string outputValue = DefaultOutput;
        int pollValue = DefaultPollMilliseconds;
        int quietValue = DefaultQuietSeconds;
        int changeWaitValue = DefaultChangeWaitSeconds;
        int noteWaitValue = DefaultNoteWaitSeconds;
        IReadOnlyList<ListenTier> tiersValue = DefaultTiers;
        string restValue = DefaultRestTier;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            watchValue = RelativeFolder(raw, "watch", DefaultWatch, errors);
            outputValue = RelativeFolder(raw, "output", DefaultOutput, errors);
            pollValue = WholeNumber(raw, "poll_milliseconds", DefaultPollMilliseconds, 100, 60000, errors);
            quietValue = WholeNumber(raw, "quiet_seconds", DefaultQuietSeconds, 0, 600, errors);
            changeWaitValue = WholeNumber(raw, "change_wait_seconds", DefaultChangeWaitSeconds, 1, 86400, errors);
            noteWaitValue = WholeNumber(raw, "note_wait_seconds", DefaultNoteWaitSeconds, 1, 3600, errors);

            if (raw.Contains("rest_tier") && raw["rest_tier"] != null)
            {
                restValue = raw["rest_tier"] as string;
                if (string.IsNullOrWhiteSpace(restValue))
                {
                    errors.Add("rest_tier must be a tier name");
                }
            }

            if (raw.Contains("tiers") && raw["tiers"] != null)
            {
                IList list = raw["tiers"] as IList;
                if (list == null || raw["tiers"] is string)
                {
                    errors.Add("tiers must be a list of { name, kinds } entries");
                }
                else
                {
                    List<ListenTier> parsed = new List<ListenTier>();
                    HashSet<string> names = new HashSet<string>(StringComparer.Ordinal);
                    HashSet<string> kinds = new HashSet<string>(StringComparer.Ordinal);
                    int index = 0;
                    foreach (object item in list)
                    {
                        ListenTier tier = ListenTier.FromRaw(index, item, errors);
                        if (tier != null)
                        {
                            if (tier.name != null && !names.Add(tier.name))
                            {
                                errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} repeats the name '{1}'", index, tier.name));
                            }
                            foreach (string kind in tier.kinds)
                            {
                                if (!kinds.Add(kind))
                                {
                                    errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} lists the kind '{1}', which an earlier tier holds", index, kind));
                                }
                            }
                            parsed.Add(tier);
                        }
                        index++;
                    }
                    tiersValue = parsed.AsReadOnly();
                }
            }
        }

        foreach (ListenTier tier in tiersValue)
        {
            if (tier.name != null && tier.name == restValue)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rest_tier '{0}' is also the name of a listed tier", restValue));
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("listen configuration validation failed:\n" + string.Join("\n", errors));
        }

        watch = watchValue;
        output = outputValue;
        poll_milliseconds = pollValue;
        quiet_seconds = quietValue;
        change_wait_seconds = changeWaitValue;
        note_wait_seconds = noteWaitValue;
        tiers = tiersValue;
        rest_tier = restValue;
    }

    // The tier of a file kind: the first tier that lists it, or the rest tier.
    public string TierOf(string kind)
    {
        foreach (ListenTier tier in tiers)
        {
            foreach (string listed in tier.kinds)
            {
                if (string.Equals(listed, kind, StringComparison.Ordinal)) { return tier.name; }
            }
        }
        return rest_tier;
    }

    private static string RelativeFolder(IDictionary raw, string key, string fallback, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        string value = raw[key] as string;
        bool rooted = value != null && (value.StartsWith("/", StringComparison.Ordinal) || value.Contains(":"));
        bool climbs = value != null && Array.IndexOf(value.Split('/', '\\'), "..") >= 0;
        if (string.IsNullOrWhiteSpace(value) || rooted || climbs || value.Contains("\\"))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} '{1}' must be a repository-relative folder with forward slashes and no '..'", key, raw[key]));
            return fallback;
        }
        return value.TrimEnd('/');
    }

    private static int WholeNumber(IDictionary raw, string key, int fallback, int min, int max, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        object value = raw[key];
        bool whole = value is int || value is long || value is short || value is byte;
        long parsed = whole ? Convert.ToInt64(value, CultureInfo.InvariantCulture) : 0;
        if (!whole || parsed < min || parsed > max)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} '{1}' must be a whole number from {2} to {3}", key, value, min, max));
            return fallback;
        }
        return (int)parsed;
    }
}
