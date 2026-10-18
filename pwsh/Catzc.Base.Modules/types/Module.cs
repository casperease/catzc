using System;
using System.Collections.Generic;

namespace Catzc.Base.Modules;

// Rests on [ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](/docs/adr/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule) and [ADR-AUTO-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-nativetypedmodel).
public sealed class Module
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The module's name: its folder (with the module type's prefix), or its file's stem.
    public string name { get; }

    // The name of the track that holds the module.
    public string track { get; }

    // The id of the module type that places the module.
    public string type { get; }

    // The place of the module type that holds the module: a repository-relative path with '/' separators.
    public string place { get; }

    // The module's root: a repository-relative path with '/' separators, a folder or the one file of a file module.
    public string root { get; }

    // What the root is: folder, file or root (the place itself).
    public string shape { get; }

    // The module's files, relative to its root with '/' separators, in ordinal order. A file module lists its one file by name.
    public IReadOnlyList<string> files { get; }

    // The names of the file languages of the module's files, in ordinal order.
    public IReadOnlyList<string> languages { get; }

    // The execution engines the module runs under: its own override, else the track's; empty when the choice is left open as auto.
    public IReadOnlyList<string> engines { get; }

    // The files inside the module's folder that the layout places in no row: findings, never silently part of the module.
    public IReadOnlyList<string> unplaced { get; }

    public Module(string name, string track, string type, string place, string root, string shape, string[] files, string[] languages,
        string[] engines, string[] unplaced)
    {
        this.name = name;
        this.track = track;
        this.type = type;
        this.place = place;
        this.root = root;
        this.shape = shape;
        this.files = Copy(files);
        this.languages = Copy(languages);
        this.engines = Copy(engines);
        this.unplaced = Copy(unplaced);
    }

    private static string[] Copy(string[] items) => items == null ? Array.Empty<string>() : (string[])items.Clone();
}
