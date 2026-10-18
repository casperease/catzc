using System;
using System.Collections.Generic;

namespace Catzc.Base.Languages;

// One row of a module's layout: a folder inside the module and what it holds ([ADR-AUTO-MODULE#2](/docs/adr/automation/module-model.md#rule-adr-auto-module2); rests on [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6) and [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
public sealed class LayoutRow
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The folder's name inside the module, or "." for the module root itself.
    public const string Root = ".";

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
