/*
---
catzc:
  immutable:
    with_body_sha: "8afe91509280"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Listen;

public sealed class ListenTier
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "name", "kinds" };
    private static readonly Regex Kebab = new Regex("^[a-z0-9]+(-[a-z0-9]+)*$");

    // The tier's name, unique in the file (e.g. 'rule').
    public string name { get; }

    // The file kinds (file-kinds.yml roles) that sit in this tier.
    public IReadOnlyList<string> kinds { get; }

    public ListenTier(string name, IReadOnlyList<string> kinds)
    {
        this.name = name;
        this.kinds = kinds;
    }

    public static ListenTier FromRaw(int index, object raw, List<string> errors)
    {
        IDictionary entry = raw as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} is not a mapping with name and kinds", index));
            return null;
        }

        foreach (object key in entry.Keys)
        {
            string keyName = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (Array.IndexOf(AllowedKeys, keyName) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} has unknown key '{1}' (allowed: {2})", index, keyName, string.Join(", ", AllowedKeys)));
            }
        }

        string tierName = entry.Contains("name") ? entry["name"] as string : null;
        if (string.IsNullOrWhiteSpace(tierName) || !Kebab.IsMatch(tierName))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} name '{1}' must be kebab-case", index, tierName));
        }

        List<string> kindList = new List<string>();
        object rawKinds = entry.Contains("kinds") ? entry["kinds"] : null;
        IList list = rawKinds as IList;
        if (list == null || rawKinds is string || list.Count == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} kinds must be a non-empty list of file kinds", index));
        }
        else
        {
            foreach (object item in list)
            {
                string kind = item as string;
                if (string.IsNullOrWhiteSpace(kind) || !Kebab.IsMatch(kind))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "tier {0} kind '{1}' must be a kebab-case file kind", index, item));
                }
                else
                {
                    kindList.Add(kind);
                }
            }
        }

        return new ListenTier(tierName, kindList.AsReadOnly());
    }
}
