/*
---
catzc:
  immutable:
    with_body_sha: "875dd56e64fb"
  edges:
    test: pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Folders;

public sealed class FolderWalkConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const int DefaultDepth = 2;
    public const bool DefaultPruneVendorInSearches = true;
    public const string VendorFolder = ".vendor";

    private static readonly string[] DefaultExclude = { ".git", "node_modules", "out" };
    private static readonly string[] AllowedKeys = { "depth", "exclude", "prune_vendor_in_searches" };

    public int depth { get; }
    public IReadOnlyList<string> exclude { get; }
    public bool prune_vendor_in_searches { get; }

    public FolderWalkConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        int depthValue = DefaultDepth;
        List<string> excludeValue = new List<string>(DefaultExclude);
        bool pruneValue = DefaultPruneVendorInSearches;

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

            if (raw.Contains("depth") && raw["depth"] != null)
            {
                object value = raw["depth"];
                bool whole = value is int || value is long || value is short || value is byte;
                long parsed = whole ? Convert.ToInt64(value, CultureInfo.InvariantCulture) : 0;
                if (!whole || parsed < 1 || parsed > 64)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "depth '{0}' must be a whole number from 1 to 64", value));
                }
                else
                {
                    depthValue = (int)parsed;
                }
            }

            if (raw.Contains("exclude") && raw["exclude"] != null)
            {
                IList list = raw["exclude"] as IList;
                if (list == null || raw["exclude"] is string)
                {
                    errors.Add("exclude must be a list of folder names");
                }
                else
                {
                    excludeValue.Clear();
                    foreach (object item in list)
                    {
                        string folder = item as string;
                        if (string.IsNullOrWhiteSpace(folder) || folder.IndexOfAny(new[] { '/', '\\' }) >= 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "exclude entry '{0}' must be a folder name, not blank and without a path separator", item));
                        }
                        else
                        {
                            excludeValue.Add(folder);
                        }
                    }
                }
            }

            if (raw.Contains("prune_vendor_in_searches") && raw["prune_vendor_in_searches"] != null)
            {
                if (raw["prune_vendor_in_searches"] is bool flag)
                {
                    pruneValue = flag;
                }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "prune_vendor_in_searches '{0}' must be true or false", raw["prune_vendor_in_searches"]));
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("folder-walk configuration validation failed:\n" + string.Join("\n", errors));
        }

        depth = depthValue;
        exclude = excludeValue.AsReadOnly();
        prune_vendor_in_searches = pruneValue;
    }
}
