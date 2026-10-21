/*
---
catzc:
  immutable:
    with_body_sha: e978c46ab4bd
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/types/AccostedConfig.Tests.ps1
    cites:
      - ADR-AUTO-ACCOSTED
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// The accosted language's settings
// ([ADR-AUTO-ACCOSTED](/docs/drs/automation/accosted-language.md)): which verbs are harmless, and the timeouts.yml key that bounds one run.
public sealed class AccostedConfig
{
    public static readonly string[] DefaultHarmlessVerbs = { "get", "test", "find", "measure" };

    public const string DefaultRunTimeout = "run_list_seconds";

    private static readonly string[] AllowedKeys = { "harmless_verbs", "run_timeout" };
    private static readonly Regex Word = new Regex("^[a-z][a-z0-9_]*$");

    // The verbs a contracted command may start with and still be harmless, in the normal form, sorted and without duplicates.
    public IReadOnlyList<string> harmless_verbs { get; }

    // The key under tests in the timeouts config whose limit bounds one run.
    public string run_timeout { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public AccostedConfig(IDictionary raw)
    {
        harmless_verbs = DefaultHarmlessVerbs.OrderBy(v => v, StringComparer.Ordinal).ToArray();
        run_timeout = DefaultRunTimeout;
        if (raw == null)
        {
            return;
        }

        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (Array.IndexOf(AllowedKeys, name) < 0)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "accosted config: unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
            }
        }

        if (raw.Contains("harmless_verbs") && raw["harmless_verbs"] != null)
        {
            IEnumerable list = raw["harmless_verbs"] as IEnumerable;
            if (list == null || raw["harmless_verbs"] is string)
            {
                throw new ArgumentException("accosted config: harmless_verbs must be a list of verbs");
            }
            SortedSet<string> verbs = new SortedSet<string>(StringComparer.Ordinal);
            foreach (object item in list)
            {
                string verb = Convert.ToString(item, CultureInfo.InvariantCulture);
                if (verb == null || !Word.IsMatch(verb))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "accosted config: harmless verb '{0}' is not a lowercase normal-form word", verb));
                }
                verbs.Add(verb);
            }
            if (verbs.Count == 0)
            {
                throw new ArgumentException("accosted config: harmless_verbs names no verb, so no command would be harmless");
            }
            harmless_verbs = verbs.ToArray();
        }

        if (raw.Contains("run_timeout") && raw["run_timeout"] != null)
        {
            string key = Convert.ToString(raw["run_timeout"], CultureInfo.InvariantCulture);
            if (!Word.IsMatch(key))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "accosted config: run_timeout '{0}' is not a timeouts.yml key", key));
            }
            run_timeout = key;
        }
    }

    // Whether a contracted command, by its normal-form name (verb_noun), starts with a harmless verb.
    public bool IsHarmlessVerb(string command)
    {
        if (string.IsNullOrEmpty(command)) { return false; }
        int underscore = command.IndexOf('_');
        string verb = underscore < 0 ? command : command.Substring(0, underscore);
        return harmless_verbs.Contains(verb, StringComparer.Ordinal);
    }
}
