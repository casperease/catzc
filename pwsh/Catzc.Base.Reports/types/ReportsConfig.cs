/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Reports/types/ReportsConfig.cs
    folder: types
    name: reports-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Reports
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
    docs: "[ReportsConfig.cs.md](docs/references/pwsh/catzc-base-reports/types/ReportsConfig.cs.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Reports;

public sealed class ReportsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "folder", "report_file", "latest_file", "stamp_format" };

    // The report base folder under the output root. Default: 'test-{subject}'.
    public string folder { get; }

    // The report file inside a run's stamped folder. Default: '{subject}.md'.
    public string report_file { get; }

    // The file beside the stamped folders that names the latest one. Default: 'latest.txt'.
    public string latest_file { get; }

    // The .NET date format of a run's stamped folder name. Default: 'yyyyMMdd-HHmmss'.
    public string stamp_format { get; }

    public ReportsConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        folder = Value(d, "folder", "test-{subject}");
        report_file = Value(d, "report_file", "{subject}.md");
        latest_file = Value(d, "latest_file", "latest.txt");
        stamp_format = Value(d, "stamp_format", "yyyyMMdd-HHmmss");

        if (!folder.Contains("{subject}")) { errors.Add("folder must contain '{subject}', so every gate writes its own folder"); }
        CheckSegment("folder", folder, errors);
        CheckSegment("report_file", report_file, errors);
        CheckSegment("latest_file", latest_file, errors);
        CheckSegment("stamp_format", stamp_format, errors);

        if (errors.Count > 0) { throw new ArgumentException("reports.yml: " + string.Join("; ", errors)); }
    }

    // The report base folder name for a gate's subject.
    public string FolderFor(string subject) => folder.Replace("{subject}", subject);

    // The report file name for a gate's subject.
    public string ReportFileFor(string subject) => report_file.Replace("{subject}", subject);

    private static string Value(IDictionary d, string key, string fallback)
    {
        if (d == null || !d.Contains(key) || d[key] == null) { return fallback; }
        string value = d[key].ToString().Trim();
        return value.Length == 0 ? fallback : value;
    }

    // One path segment: no separator, no '..', not rooted — the report always lands under the output root.
    private static void CheckSegment(string key, string value, List<string> errors)
    {
        if (value.Contains("/") || value.Contains("\\") || value.Contains("..") || value.Contains(":"))
        {
            errors.Add(string.Format("{0} '{1}' must be one path segment (no '/', '\\', '..', or ':')", key, value));
        }
    }
}
