/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/DocumentLinks.cs
    folder: types
    name: document-links
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/types/DocumentLinks.Tests.ps1
---
*/

// A link inside the document stays internal and is not listed: an anchor in the same file, the file itself, and its own comment page.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public static class DocumentLinks
{
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);

    // Every link of a Markdown text in one spelling, a repository-relative path with its anchor or an absolute URL, sorted without duplicates.
    public static IReadOnlyList<string> Of(string text, string repoPath, string ownPage)
    {
        var links = new SortedSet<string>(StringComparer.Ordinal);
        string normalized = (repoPath ?? string.Empty).Replace('\\', '/');
        int slash = normalized.LastIndexOf('/');
        string directory = slash < 0 ? string.Empty : normalized.Substring(0, slash);
        foreach (string written in MarkdownLinkScanner.Destinations(text))
        {
            string link = Canonical(written, directory, normalized, ownPage);
            if (link != null) { links.Add(link); }
        }
        return new List<string>(links);
    }

    static string Canonical(string written, string directory, string repoPath, string ownPage)
    {
        if (written.Length == 0) { return null; }
        if (Scheme.IsMatch(written)) { return written; }

        int hash = written.IndexOf('#');
        string pathPart = Uri.UnescapeDataString(hash >= 0 ? written.Substring(0, hash) : written);
        string fragment = hash >= 0 ? written.Substring(hash) : string.Empty;
        if (pathPart.Length == 0) { return null; }

        string resolved = Resolve(pathPart.StartsWith("/", StringComparison.Ordinal) ? pathPart : directory + "/" + pathPart);
        if (resolved == null) { return null; }
        if (string.Equals(resolved, repoPath, StringComparison.OrdinalIgnoreCase)) { return null; }
        if (ownPage != null && string.Equals(resolved, ownPage.Replace('\\', '/'), StringComparison.OrdinalIgnoreCase)) { return null; }
        return resolved + fragment;
    }

    // The path with its dot segments folded; null when it climbs above the repository root.
    static string Resolve(string path)
    {
        var kept = new List<string>();
        foreach (string segment in path.Replace('\\', '/').Split('/'))
        {
            if (segment.Length == 0 || segment == ".") { continue; }
            if (segment != "..") { kept.Add(segment); continue; }
            if (kept.Count == 0) { return null; }
            kept.RemoveAt(kept.Count - 1);
        }
        if (kept.Count == 0) { return "."; }
        return string.Join("/", kept) + (path.EndsWith("/", StringComparison.Ordinal) ? "/" : string.Empty);
    }
}
