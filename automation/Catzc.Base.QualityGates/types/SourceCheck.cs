using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Catzc.Base.Docs;
using Catzc.Base.Globs;

namespace Catzc.Base.QualityGates;

public class SourceCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly string[] OwnKeys = { "mode", "exempt" };

    readonly List<GlobPattern> exemptGlobs = new List<GlobPattern>();

    public CheckMode mode { get; }
    public IReadOnlyDictionary<string, string> exempt { get; }

    // True when the check prints its findings and never fails the run on them.
    public bool IsReport => mode == CheckMode.Report;

    // name: the check's config key, for messages ('engine_set'). raw: its map, or null for every default.
    public SourceCheck(string name, IDictionary raw) : this(name, raw, Array.Empty<string>())
    {
    }

    // extraKeys: the keys a derived check reads itself; any other key is rejected.
    protected SourceCheck(string name, IDictionary raw, IEnumerable<string> extraKeys)
    {
        mode = default(CheckMode);
        var exemptions = new Dictionary<string, string>(StringComparer.Ordinal);
        var errors = new List<string>();
        string[] allowed = OwnKeys.Concat(extraKeys ?? Array.Empty<string>()).ToArray();

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string keyName = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (!allowed.Contains(keyName, StringComparer.Ordinal))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", keyName, string.Join(", ", allowed)));
                }
            }

            mode = CheckModes.Parse(raw, out string modeError);
            if (modeError != null)
            {
                errors.Add(modeError);
            }

            if (raw.Contains("exempt") && raw["exempt"] != null)
            {
                if (!(raw["exempt"] is IDictionary map))
                {
                    errors.Add("exempt must be a map of glob to reason");
                }
                else
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        string glob = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                        string reason = Convert.ToString(entry.Value, CultureInfo.InvariantCulture)?.Trim() ?? string.Empty;
                        try
                        {
                            exemptGlobs.Add(new GlobPattern(glob));
                        }
                        catch (ArgumentException exception)
                        {
                            errors.Add("exempt: " + exception.Message);
                            continue;
                        }
                        if (reason.Length == 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "exempt '{0}' needs the reason its files are left out", glob));
                        }
                        exemptions[glob] = reason;
                    }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: invalid settings:\n  - {1}", name, string.Join("\n  - ", errors)));
        }
        exempt = exemptions;
    }

    // True when an exempt glob matches the repository-relative, '/'-separated path.
    public bool IsExempt(string repoRelativePath)
    {
        string path = repoRelativePath?.Replace('\\', '/');
        return exemptGlobs.Any(glob => glob.Matches(path));
    }
}
