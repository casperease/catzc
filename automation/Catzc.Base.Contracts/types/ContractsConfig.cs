/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/types/ContractsConfig.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Contracts
    relatives:
      page: docs/references/automation/catzc-base-contracts/types/ContractsConfig.cs.md
      test: automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-PWSH-PARAM#4
      - ADR-REPO-CONTRACT#{2,8,10}
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

public sealed class ContractsConfig
{
    public const string DefaultAddressing = "full-path";

    // The target root of a module that target_roots does not name: the repository root, as the empty path.
    public const string DefaultTargetRoot = "";

    public static readonly string[] AddressingModes = { "full-path", "manifest-glob", "per-folder" };

    public static readonly string[] BuiltAddressingModes = { "full-path" };

    private static readonly string[] AllowedKeys = { "addressing", "target_roots" };
    private static readonly Regex Root = new Regex("^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex ModuleName = new Regex("^[A-Za-z0-9_-][A-Za-z0-9._-]*$");

    public string addressing { get; }

    // Module name -> target root, in ordinal module order. Empty when the file declares none.
    public IReadOnlyDictionary<string, string> target_roots { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractsConfig(IDictionary raw)
    {
        addressing = DefaultAddressing;
        SortedDictionary<string, string> roots = new SortedDictionary<string, string>(StringComparer.Ordinal);
        target_roots = roots;
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
                    "contracts config: unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
            }
        }

        if (raw.Contains("addressing") && raw["addressing"] != null)
        {
            string value = Convert.ToString(raw["addressing"], CultureInfo.InvariantCulture);
            if (Array.IndexOf(AddressingModes, value) < 0)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "contracts config: addressing '{0}' is not one of: {1}", value, string.Join(", ", AddressingModes)));
            }
            addressing = value;
        }

        if (raw.Contains("target_roots") && raw["target_roots"] != null)
        {
            IDictionary map = raw["target_roots"] as IDictionary;
            if (map == null)
            {
                throw new ArgumentException("contracts config: target_roots must be a map of module name to target root, e.g. { Catzc.Widget: .widget }");
            }
            foreach (DictionaryEntry entry in map)
            {
                string module = Convert.ToString(entry.Key, CultureInfo.InvariantCulture) ?? "";
                if (!ModuleName.IsMatch(module))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "contracts config: target_roots key '{0}' is not a module name (one folder name, not dot-prefixed)", module));
                }
                roots[module] = CheckRoot(module, entry.Value);
            }
        }
    }

    public static string ResolveTargetRoot(IDictionary targetRoots, string module)
    {
        if (targetRoots == null || module == null || !targetRoots.Contains(module))
        {
            return DefaultTargetRoot;
        }
        return CheckRoot(module, targetRoots[module]);
    }

    private static string CheckRoot(string module, object value)
    {
        string root = value as string;
        bool valid = root != null && Root.IsMatch(root) && !Array.Exists(root.Split('/'), s => s == "." || s == "..");
        if (!valid)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "contracts config: target root '{0}' of '{1}' is not a repository-relative folder ('/'-separated segments, no leading or trailing slash, no '.' or '..' segment, e.g. '.widget')",
                Convert.ToString(value, CultureInfo.InvariantCulture), module));
        }
        return root;
    }
}
