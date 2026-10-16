/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/FileCarrierResolver.cs
    folder: types
    name: file-carrier-resolver
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/FileCarrierResolver.cs.md
    test: automation/Catzc.Base.QualityGates/tests/types/FileCarrierResolver.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#5
---
*/

using System;
using System.Collections.Generic;
using System.Linq;
using Catzc.Base.Globs;
using Catzc.Base.Languages;

namespace Catzc.Base.QualityGates;

public sealed class FileCarrierResolver
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly FileCarriersConfig carriers;
    readonly LanguagesConfig languages;
    readonly List<(FileCarrier Carrier, List<GlobPattern> Globs)> classes;
    readonly Dictionary<string, List<GlobPattern>> excludes;

    public FileCarrierResolver(FileCarriersConfig carriers, LanguagesConfig languages)
    {
        this.carriers = carriers ?? throw new ArgumentNullException(nameof(carriers));
        this.languages = languages ?? throw new ArgumentNullException(nameof(languages));
        classes = carriers.carriers
            .Where(c => c.files.Count > 0)
            .Select(c => (c, c.files.Select(glob => new GlobPattern(glob)).ToList()))
            .ToList();
        excludes = carriers.carriers.ToDictionary(c => c.id, c => c.exclude.Keys.Select(glob => new GlobPattern(glob)).ToList(), StringComparer.Ordinal);
    }

    // The first class whose globs match the path wins; otherwise the carrier of the path's file language. Null when neither names one.
    public FileCarrier For(string path)
    {
        string normalized = Normalize(path);
        foreach ((FileCarrier carrier, List<GlobPattern> globs) in classes)
        {
            if (globs.Any(glob => glob.Matches(normalized))) { return carrier; }
        }
        FileLanguage language = languages.ForPath(normalized);
        return language == null ? null : carriers.Find(language.name);
    }

    // True when the entry leaves this path out: a glob of its exclude map matches.
    public bool IsExcluded(FileCarrier carrier, string path)
    {
        if (carrier == null) { throw new ArgumentNullException(nameof(carrier)); }
        string normalized = Normalize(path);
        return excludes.TryGetValue(carrier.id, out List<GlobPattern> globs) && globs.Any(glob => glob.Matches(normalized));
    }

    static string Normalize(string path) => (path ?? string.Empty).Replace('\\', '/');
}
