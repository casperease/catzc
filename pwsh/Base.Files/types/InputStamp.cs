/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-files/types/InputStamp.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Catzc.Base.Files;

public enum InputStampIdentity
{
    Content,
    Metadata,
}

// Content identity stamps the same on every checkout; write-time identity is cheaper, and a touch only ever makes it differ.
public static class InputStamp
{
    public const InputStampIdentity DefaultIdentity = InputStampIdentity.Content;

    // Carriage returns are dropped before hashing, so a CRLF checkout, a clone and a snapshot all stamp the same.
    public static string Compute(string[] paths, string filter, string[] excludes, string root, string salt, InputStampIdentity identity)
    {
        return ComputeMany(new[] { paths }, filter, excludes, root, new[] { salt }, identity)[0];
    }

    // One stamp per path set, each the stamp Compute gives that set alone; a file named in several sets is read once for all of them.
    public static string[] ComputeMany(string[][] pathSets, string filter, string[] excludes, string root, string[] salts, InputStampIdentity identity)
    {
        if (pathSets == null)
        {
            throw new ArgumentNullException("pathSets");
        }
        if (salts == null || salts.Length != pathSets.Length)
        {
            throw new ArgumentException("salts must hold one salt per path set", "salts");
        }

        string rootFull = Path.GetFullPath(root).TrimEnd('\\', '/') + Path.DirectorySeparatorChar;
        List<Regex> skip = new List<Regex>();
        foreach (string pattern in excludes ?? new string[0])
        {
            skip.Add(ToRegex(pattern.Replace('\\', '/')));
        }

        // Every named path is stat'ed once, in parallel; a metadata line reuses the FileInfo that check read.
        string[][] fulls = new string[pathSets.Length][];
        HashSet<string> named = new HashSet<string>(StringComparer.Ordinal);
        for (int set = 0; set < pathSets.Length; set++)
        {
            string[] entries = pathSets[set] ?? new string[0];
            fulls[set] = new string[entries.Length];
            for (int i = 0; i < entries.Length; i++)
            {
                fulls[set][i] = Path.GetFullPath(entries[i]);
                named.Add(fulls[set][i]);
            }
        }
        string[] namedPaths = new string[named.Count];
        named.CopyTo(namedPaths);
        FileInfo[] namedInfo = new FileInfo[namedPaths.Length];
        Parallel.For(0, namedPaths.Length, i =>
        {
            FileInfo info = new FileInfo(namedPaths[i]);
            info.Refresh();
            namedInfo[i] = info;
        });
        Dictionary<string, FileInfo> known = new Dictionary<string, FileInfo>(namedPaths.Length, StringComparer.Ordinal);
        for (int i = 0; i < namedPaths.Length; i++)
        {
            known[namedPaths[i]] = namedInfo[i];
        }

        EnumerationOptions options = new EnumerationOptions { RecurseSubdirectories = true };
        List<string>[] kept = new List<string>[pathSets.Length];
        List<string>[] missing = new List<string>[pathSets.Length];
        HashSet<string> unique = new HashSet<string>(StringComparer.Ordinal);
        for (int set = 0; set < pathSets.Length; set++)
        {
            List<string> files = new List<string>();
            missing[set] = new List<string>();
            foreach (string full in fulls[set])
            {
                if (known[full].Exists)
                {
                    files.Add(full);
                }
                else if (Directory.Exists(full))
                {
                    files.AddRange(Directory.EnumerateFiles(full, filter ?? "*", options));
                }
                else
                {
                    missing[set].Add(Name(full, rootFull) + "|missing");
                }
            }
            kept[set] = new List<string>();
            foreach (string file in files)
            {
                string slashed = file.Replace('\\', '/');
                bool skipped = false;
                foreach (Regex pattern in skip)
                {
                    if (pattern.IsMatch(slashed)) { skipped = true; break; }
                }
                if (!skipped)
                {
                    kept[set].Add(file);
                    unique.Add(file);
                }
            }
        }

        string[] uniquePaths = new string[unique.Count];
        unique.CopyTo(uniquePaths);
        string[] uniqueLines = new string[uniquePaths.Length];
        Parallel.For(0, uniquePaths.Length, i =>
        {
            string path = uniquePaths[i];
            if (identity == InputStampIdentity.Metadata)
            {
                FileInfo info = known.TryGetValue(path, out FileInfo seen) ? seen : new FileInfo(path);
                uniqueLines[i] = Name(path, rootFull) + "|" + info.LastWriteTimeUtc.Ticks.ToString(System.Globalization.CultureInfo.InvariantCulture) + "|" +
                    info.Length.ToString(System.Globalization.CultureInfo.InvariantCulture);
                return;
            }
            string content = File.ReadAllText(path).Replace("\r", "");
            byte[] hash = SHA256.HashData(Encoding.UTF8.GetBytes(content));
            uniqueLines[i] = Name(path, rootFull) + "|" + Convert.ToHexString(hash);
        });
        Dictionary<string, string> lineOf = new Dictionary<string, string>(uniquePaths.Length, StringComparer.Ordinal);
        for (int i = 0; i < uniquePaths.Length; i++)
        {
            lineOf[uniquePaths[i]] = uniqueLines[i];
        }

        string[] stamps = new string[pathSets.Length];
        for (int set = 0; set < pathSets.Length; set++)
        {
            List<string> lines = new List<string>(missing[set]);
            foreach (string file in kept[set])
            {
                lines.Add(lineOf[file]);
            }
            string[] sorted = lines.ToArray();
            Array.Sort(sorted, StringComparer.Ordinal);
            string text = string.Join("\n", sorted) + "\n#salt:" + salts[set];
            stamps[set] = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text))).ToLowerInvariant();
        }
        return stamps;
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
