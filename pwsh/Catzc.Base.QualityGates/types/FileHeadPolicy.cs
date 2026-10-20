using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class FileHeadPolicy
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const HeadPolicy DefaultPolicy = HeadPolicy.Forbidden;

    // A file with a comment page carries the head that links it, whatever the default says of its class.
    public const HeadPolicy DefaultPagesPolicy = HeadPolicy.Required;

    static readonly string[] Allowed = { "default", "pages", "classes" };

    public HeadPolicy @default { get; }

    public HeadPolicy pages { get; }

    // Class patterns in registry order, each with its policy; the first pattern that matches a file's class decides.
    public IReadOnlyList<KeyValuePair<string, HeadPolicy>> classes { get; }

    public FileHeadPolicy(IDictionary raw)
    {
        @default = DefaultPolicy;
        pages = DefaultPagesPolicy;
        var list = new List<KeyValuePair<string, HeadPolicy>>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(Allowed, name) < 0)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: head_policy has unknown key '{0}' (allowed: {1})", name, string.Join(", ", Allowed)));
                }
            }
            if (raw.Contains("default") && raw["default"] != null)
            {
                @default = Parse("head_policy.default", raw["default"]);
            }
            if (raw.Contains("pages") && raw["pages"] != null)
            {
                pages = Parse("head_policy.pages", raw["pages"]);
            }
            if (raw.Contains("classes") && raw["classes"] != null)
            {
                if (!(raw["classes"] is IDictionary map))
                {
                    throw new ArgumentException("file-meta config: head_policy.classes must be a map of class to policy");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string pattern = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    list.Add(new KeyValuePair<string, HeadPolicy>(pattern, Parse("head_policy.classes." + pattern, entry.Value)));
                }
            }
        }
        classes = list;
    }

    // A class entry decides first; a file no entry names takes the pages policy when it has a comment page, else the default.
    public HeadPolicy For(string fileClass, bool hasPage = false)
    {
        foreach (KeyValuePair<string, HeadPolicy> entry in classes)
        {
            if (FileSelector.ClassMatches(entry.Key, fileClass)) { return entry.Value; }
        }
        return hasPage ? pages : @default;
    }

    static HeadPolicy Parse(string where, object value)
    {
        string text = Convert.ToString(value, CultureInfo.InvariantCulture);
        switch (text)
        {
            case "required": return HeadPolicy.Required;
            case "optional": return HeadPolicy.Optional;
            case "forbidden": return HeadPolicy.Forbidden;
            default:
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "file-meta config: {0} is '{1}' (allowed: required, optional, forbidden)", where, text));
        }
    }
}
