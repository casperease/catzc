using System;
using System.IO;

namespace Catzc.Base.Git;

// The paths a git work tree is known by: its .git folder and the marker that makes it a repository snapshot, joined in one place.
public static class GitWorkTree
{
    public const string GitFolderName = ".git";
    public const string SnapshotMarkerFile = ".git/catzc-snapshot.json";

    // The work tree's .git folder, full path.
    public static string GitFolder(string root) => Join(root, GitFolderName);

    // The snapshot marker New-RepositorySnapshot writes into a snapshot's .git folder, full path.
    public static string SnapshotMarker(string root) => Join(root, SnapshotMarkerFile);

    // True when the work tree is a repository snapshot: its marker exists.
    public static bool IsSnapshot(string root) => File.Exists(SnapshotMarker(root));

    private static string Join(string root, string relative)
    {
        if (string.IsNullOrEmpty(root)) { throw new ArgumentException("root must not be empty", "root"); }
        return Path.GetFullPath(Path.Combine(root, relative));
    }
}
