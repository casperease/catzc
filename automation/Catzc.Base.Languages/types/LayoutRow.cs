/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Languages/types/LayoutRow.cs
    folder: types
    name: layout-row
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-MODULE#2
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// One row of a module's layout: a folder inside the module and what it holds.
public sealed class LayoutRow
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The folder's name inside the module, or "." for the module root itself.
    public const string Root = ".";

    // The rows no single file language owns, so every module has them: assets ship with the module, tests never do.
    // A language's own rows (public functions at the root, `private/`, `types/`, `configs/`) are declared under it in languages.yml.
    public static IReadOnlyList<LayoutRow> Shared { get; } = new[]
    {
        new LayoutRow(null, "assets", "asset", null, true, true),
        new LayoutRow(null, "tests", "test", null, false, false),
    };

    // The file language that owns the row, or null for a shared row.
    public string language { get; }

    public string folder { get; }

    // What the folder holds (e.g. public-function, private-function, type, config, asset, test).
    public string role { get; }

    // The extensions the row places, as a language states them; empty when it places every file in the folder.
    public IReadOnlyList<string> extensions { get; }

    // True when the row's files are the module's live files (what the protection identity covers); false for tests.
    public bool live { get; }

    // True when a build ships the row's files with the module.
    public bool shipped { get; }

    public LayoutRow(string language, string folder, string role, string[] extensions, bool live, bool shipped)
    {
        this.language = language;
        this.folder = folder;
        this.role = role;
        this.extensions = extensions == null ? Array.Empty<string>() : (string[])extensions.Clone();
        this.live = live;
        this.shipped = shipped;
    }

    // The globs, relative to the module root, that place the row's files: `*.ps1` for the root and each extension, `folder/**` otherwise.
    public IReadOnlyList<string> Patterns()
    {
        List<string> patterns = new List<string>();
        if (folder == Root)
        {
            foreach (string extension in extensions) { patterns.Add("*" + extension); }
            return patterns;
        }
        patterns.Add(folder + "/**");
        return patterns;
    }
}
