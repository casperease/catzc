/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Files/types/InputStamp.cs
    folder: types
    name: input-stamp
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[InputStamp.cs.md](docs/references/pwsh/catzc-base-files/types/InputStamp.cs.md)"
---
*/

// The fingerprint of a set of input files: one SHA-256 over the sorted (path, content hash) of every file, the same on every checkout.

using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Catzc.Base.Files;

public static class InputStamp
{
    public static string Compute(string[] paths, string filter, string[] excludes, string root, string salt)
    {
        string rootFull = Path.GetFullPath(root).TrimEnd('\\', '/') + Path.DirectorySeparatorChar;
        List<Regex> skip = new List<Regex>();
        foreach (string pattern in excludes ?? new string[0])
        {
            skip.Add(ToRegex(pattern.Replace('\\', '/')));
        }

        List<string> files = new List<string>();
        List<string> lines = new List<string>();
        EnumerationOptions options = new EnumerationOptions { RecurseSubdirectories = true };
        foreach (string entry in paths)
        {
            string full = Path.GetFullPath(entry);
            if (File.Exists(full))
            {
                files.Add(full);
            }
            else if (Directory.Exists(full))
            {
                files.AddRange(Directory.EnumerateFiles(full, filter ?? "*", options));
            }
            else
            {
                lines.Add(Name(full, rootFull) + "|missing");
            }
        }

        List<string> kept = new List<string>();
        foreach (string file in files)
        {
            string slashed = file.Replace('\\', '/');
            bool skipped = false;
            foreach (Regex pattern in skip)
            {
                if (pattern.IsMatch(slashed)) { skipped = true; break; }
            }
            if (!skipped) { kept.Add(file); }
        }

        string[] hashed = new string[kept.Count];
        Parallel.For(0, kept.Count, i =>
        {
            string content = File.ReadAllText(kept[i]).Replace("\r", "");
            byte[] hash = SHA256.HashData(Encoding.UTF8.GetBytes(content));
            hashed[i] = Name(kept[i], rootFull) + "|" + Convert.ToHexString(hash);
        });
        lines.AddRange(hashed);

        string[] sorted = lines.ToArray();
        Array.Sort(sorted, StringComparer.Ordinal);
        string text = string.Join("\n", sorted) + "\n#salt:" + salt;
        return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text))).ToLowerInvariant();
    }

    private static string Name(string full, string rootFull)
    {
        string slashed = full.Replace('\\', '/');
        return full.StartsWith(rootFull, StringComparison.OrdinalIgnoreCase) ? slashed.Substring(rootFull.Length) : slashed;
    }

    private static Regex ToRegex(string wildcard)
    {
        StringBuilder expression = new StringBuilder("^");
        for (int i = 0; i < wildcard.Length; i++)
        {
            char c = wildcard[i];
            if (c == '`' && i + 1 < wildcard.Length) { expression.Append(Regex.Escape(wildcard[++i].ToString())); }
            else if (c == '*') { expression.Append(".*"); }
            else if (c == '?') { expression.Append('.'); }
            else { expression.Append(Regex.Escape(c.ToString())); }
        }
        expression.Append('$');
        return new Regex(expression.ToString(), RegexOptions.IgnoreCase | RegexOptions.CultureInvariant);
    }
}
