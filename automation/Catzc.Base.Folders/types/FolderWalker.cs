/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Folders/types/FolderWalker.cs
    kind: type
    module: Catzc.Base.Folders
    adrs: []
---
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Enumeration;

namespace Catzc.Base.Folders;

public static class FolderWalker
{
    private static readonly bool IgnoreCase = OperatingSystem.IsWindows() || OperatingSystem.IsMacOS();
    private static readonly StringComparer NameComparer = IgnoreCase ? StringComparer.OrdinalIgnoreCase : StringComparer.Ordinal;
    private static readonly string[] AllNames = { "*" };

    public static string[] Walk(string root, int depth, IEnumerable<string> patterns, bool files, bool directories, IEnumerable<string> exclude)
    {
        if (string.IsNullOrEmpty(root))
        {
            throw new ArgumentException("root must not be empty", "root");
        }
        if (depth < 1)
        {
            throw new ArgumentOutOfRangeException("depth", depth, "depth must be at least 1 (1 lists the direct children only)");
        }
        if (!Directory.Exists(root))
        {
            throw new DirectoryNotFoundException("folder does not exist: " + root);
        }

        List<string> filters = new List<string>(patterns ?? AllNames);
        if (filters.Count == 0)
        {
            filters.AddRange(AllNames);
        }
        HashSet<string> pruned = new HashSet<string>(exclude ?? new string[0], NameComparer);
        EnumerationOptions options = new EnumerationOptions { IgnoreInaccessible = true, RecurseSubdirectories = false, AttributesToSkip = 0 };

        List<string> results = new List<string>();
        Stack<KeyValuePair<string, int>> pending = new Stack<KeyValuePair<string, int>>();
        pending.Push(new KeyValuePair<string, int>(root, 1));
        while (pending.Count > 0)
        {
            KeyValuePair<string, int> top = pending.Pop();
            string current = top.Key;
            int level = top.Value;

            foreach (string directory in Directory.EnumerateDirectories(current, "*", options))
            {
                string name = Path.GetFileName(directory);
                if (pruned.Contains(name))
                {
                    continue;
                }
                if (directories && Matches(filters, name))
                {
                    results.Add(directory);
                }
                if (level < depth && !IsLink(directory))
                {
                    pending.Push(new KeyValuePair<string, int>(directory, level + 1));
                }
            }

            if (files)
            {
                foreach (string file in Directory.EnumerateFiles(current, "*", options))
                {
                    if (Matches(filters, Path.GetFileName(file)))
                    {
                        results.Add(file);
                    }
                }
            }
        }

        results.Sort(StringComparer.Ordinal);
        return results.ToArray();
    }

    private static bool Matches(List<string> filters, string name)
    {
        foreach (string filter in filters)
        {
            if (FileSystemName.MatchesSimpleExpression(filter, name, IgnoreCase))
            {
                return true;
            }
        }
        return false;
    }

    private static bool IsLink(string directory)
    {
        try
        {
            return (File.GetAttributes(directory) & FileAttributes.ReparsePoint) != 0;
        }
        catch (IOException)
        {
            return true;
        }
        catch (UnauthorizedAccessException)
        {
            return true;
        }
    }
}
