using System;
using System.IO;
using Catzc.Base.Folders;

namespace Catzc.Base.Contracts;

// One level of the contracts tree through the bounded walker, in ordinal order.
public sealed class ContractLayout
{
    // Every root's current contracts live in this one version folder.
    public const string CurrentVersion = "0.1.0";

    // The one provided root; every other root is a vendor's, depended-on.
    public const string ProvidedRoot = "catzc";

    // Get-TypesContractPath spells this name for the bootstrap; a test pins the two equal.
    public const string TypesSurfaceName = "types.json";

    public const string TypesSchemaName = "types.schema.json";

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private readonly string[] pruned;

    // A layout that walks with the folder-walk defaults declared on FolderWalkConfig.
    public ContractLayout() : this(null) { }

    // A layout that walks with the folder-walk config given.
    public ContractLayout(FolderWalkConfig walk)
    {
        pruned = PathSet.Pruned(walk);
    }

    // The folders directly in a folder (root, version or group folders), as full paths.
    public string[] Folders(string folder) => FolderWalker.Walk(Required(folder), 1, null, false, true, pruned);

    // The names of the files directly in a folder.
    public string[] FileNames(string folder) => Names(FolderWalker.Walk(Required(folder), 1, null, true, false, pruned));

    // The names of every folder and file directly in a folder, none pruned: a presence check must see a target wherever it lies.
    public string[] EntryNames(string folder) => Names(FolderWalker.Walk(Required(folder), 1, null, true, true, Array.Empty<string>()));

    static string Required(string folder)
    {
        if (string.IsNullOrEmpty(folder)) { throw new ArgumentException("folder must not be empty", "folder"); }
        return folder;
    }

    static string[] Names(string[] paths)
    {
        string[] names = new string[paths.Length];
        for (int i = 0; i < paths.Length; i++) { names[i] = Path.GetFileName(paths[i]); }
        Array.Sort(names, StringComparer.Ordinal);
        return names;
    }
}
