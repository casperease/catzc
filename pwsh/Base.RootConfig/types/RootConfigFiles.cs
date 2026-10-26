using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.RootConfig;

// The rootconfig registry: unique targets, every malformed entry collected into one error.
public sealed class RootConfigFiles
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Managed root-file entries, in registry order.
    public IReadOnlyList<RootConfigFile> files { get; }

    private static readonly string[] AllowedKeys = { "files" };

    public RootConfigFiles(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string topKey = key == null ? string.Empty : key.ToString();
                if (Array.IndexOf(AllowedKeys, topKey) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", topKey, string.Join(", ", AllowedKeys)));
                }
            }
        }
        List<RootConfigFile> list = new List<RootConfigFile>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        object obj = (raw != null && raw.Contains("files")) ? raw["files"] : null;
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            errors.Add("'files' must be a list with at least one entry");
        }
        else
        {
            foreach (object item in seq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add("each 'files' entry must be a mapping"); continue; }

                RootConfigFile f;
                try { f = new RootConfigFile(entry); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(f.target)) { errors.Add(string.Format("duplicate target '{0}'", f.target)); continue; }
                list.Add(f);
            }
            if (errors.Count == 0 && list.Count == 0)
            {
                errors.Add("'files' must be a list with at least one entry");
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("rootconfig config validation failed:\n" + string.Join("\n", errors));
        }
        files = list;
    }

    // The spell checker's and linter's settings files, named once for every gate that runs them.
    public static string SpellingConfigPath(string repositoryRoot) => RootFile(repositoryRoot, "cspell.yml");

    public static string MarkdownlintConfigPath(string repositoryRoot) => RootFile(repositoryRoot, ".markdownlint.yml");

    private static string RootFile(string repositoryRoot, string name)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentException("repositoryRoot must not be empty", "repositoryRoot"); }
        return new Catzc.Base.Folders.PathSet().AddFile(repositoryRoot, name).ToArray()[0];
    }
}
