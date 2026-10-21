using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Docs;

// The session-learnings log: a few markdown files of bounded length, first in first out (Add-SessionLearning).
public sealed class LearningsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultFolder = ".claude/learnings";
    public const int DefaultFiles = 5;
    public const int DefaultLinesPerFile = 50;

    private static readonly string[] AllowedKeys = { "folder", "files", "lines_per_file" };

    // The repository-relative folder the learnings files live in.
    public string folder { get; }

    // How many files are kept; the oldest is dropped when a new one would exceed it.
    public int files { get; }

    // How many learnings one file holds before the next file starts.
    public int lines_per_file { get; }

    public LearningsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string folderValue = DefaultFolder;
        int filesValue = DefaultFiles;
        int linesValue = DefaultLinesPerFile;

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

            if (raw.Contains("folder") && raw["folder"] != null)
            {
                string value = raw["folder"] as string;
                bool climbs = value != null && Array.IndexOf(value.Split('/', '\\'), "..") >= 0;
                if (string.IsNullOrWhiteSpace(value) || value.StartsWith("/", StringComparison.Ordinal) || value.Contains(":") || value.Contains("\\") || climbs)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "folder '{0}' must be a repository-relative folder with forward slashes and no '..'", raw["folder"]));
                }
                else
                {
                    folderValue = value.TrimEnd('/');
                }
            }

            filesValue = WholeNumber(raw, "files", DefaultFiles, 1, 100, errors);
            linesValue = WholeNumber(raw, "lines_per_file", DefaultLinesPerFile, 1, 1000, errors);
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("learnings configuration validation failed:\n" + string.Join("\n", errors));
        }

        folder = folderValue;
        files = filesValue;
        lines_per_file = linesValue;
    }

    private static int WholeNumber(IDictionary raw, string key, int fallback, int min, int max, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        object value = raw[key];
        bool whole = value is int || value is long || value is short || value is byte;
        long parsed = whole ? Convert.ToInt64(value, CultureInfo.InvariantCulture) : 0;
        if (!whole || parsed < min || parsed > max)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} '{1}' must be a whole number from {2} to {3}", key, value, min, max));
            return fallback;
        }
        return (int)parsed;
    }
}
