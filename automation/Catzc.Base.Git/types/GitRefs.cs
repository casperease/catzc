// A reftable ref store or a loose annotated tag is rejected loudly rather than read wrong.
// [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)
// [comment:1](/docs/references/automation/catzc-base-git/types/GitRefs.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Catzc.Base.Git;

public static class GitRefs
{
    // How many symbolic refs (`ref: <target>`) a lookup follows before it calls the chain a loop.
    private const int MaxSymbolicDepth = 5;

    // A relative gitdir pointer resolves against the checkout root; this is how linked worktrees and submodules work.
    // [comment:2](/docs/references/automation/catzc-base-git/types/GitRefs.cs.md#comment2)
    public static string GitDirectory(string checkoutRoot)
    {
        var dotGit = Path.Combine(checkoutRoot, ".git");
        if (Directory.Exists(dotGit))
        {
            return Path.GetFullPath(dotGit);
        }
        if (!File.Exists(dotGit))
        {
            throw new InvalidOperationException("'" + checkoutRoot + "' is not a git checkout (no .git).");
        }
        var pointer = File.ReadAllText(dotGit).Trim();
        if (!pointer.StartsWith("gitdir:", StringComparison.Ordinal))
        {
            throw new InvalidDataException("'" + dotGit + "' is not a 'gitdir:' pointer.");
        }
        return Path.GetFullPath(pointer.Substring("gitdir:".Length).Trim(), Path.GetFullPath(checkoutRoot));
    }

    // A linked worktree's git directory holds no shared refs; they live in the directory its commondir file names.
    // [comment:3](/docs/references/automation/catzc-base-git/types/GitRefs.cs.md#comment3)
    public static string CommonDirectory(string gitDirectory)
    {
        var pointer = Path.Combine(gitDirectory, "commondir");
        if (!File.Exists(pointer))
        {
            return gitDirectory;
        }
        return Path.GetFullPath(File.ReadAllText(pointer).Trim(), gitDirectory);
    }

    // The checkout's index file (`git rev-parse --git-path index`). The file may be absent in a fresh repository.
    public static string IndexPath(string gitDirectory) => Path.Combine(gitDirectory, "index");

    // The branch HEAD is on, short (`main`), or "HEAD" when it is detached — `git rev-parse --abbrev-ref HEAD`.
    public static string CurrentBranch(string gitDirectory)
    {
        AssertReadable(gitDirectory);
        var head = File.ReadAllText(Path.Combine(gitDirectory, "HEAD")).Trim();
        if (!head.StartsWith("ref: ", StringComparison.Ordinal))
        {
            return "HEAD";
        }
        var target = head.Substring(5).Trim();
        return target.StartsWith("refs/heads/", StringComparison.Ordinal) ? target.Substring("refs/heads/".Length) : target;
    }

    // Short names are tried in git's own order: refs/name, tags, heads, remotes; a name that matches nothing throws.
    // [comment:4](/docs/references/automation/catzc-base-git/types/GitRefs.cs.md#comment4)
    public static string ResolveCommit(string gitDirectory, string name)
    {
        AssertReadable(gitDirectory);
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("a ref name must not be empty", nameof(name));
        }
        if (IsFullId(name))
        {
            return name.ToLowerInvariant();
        }
        var packed = ReadPackedRefs(CommonDirectory(gitDirectory));
        foreach (var candidate in Candidates(name))
        {
            var id = Lookup(gitDirectory, packed, candidate, 0);
            if (id != null)
            {
                return id;
            }
        }
        throw new InvalidOperationException("'" + name + "' does not name a ref in '" + gitDirectory + "'.");
    }

    private static IEnumerable<string> Candidates(string name)
    {
        if (name == "HEAD" || name.StartsWith("refs/", StringComparison.Ordinal))
        {
            return new[] { name };
        }
        return new[] { "refs/" + name, "refs/tags/" + name, "refs/heads/" + name, "refs/remotes/" + name, "refs/remotes/" + name + "/HEAD" };
    }

    // A ref's commit, following symbolic refs; null when the ref does not exist.
    private static string Lookup(string gitDirectory, Dictionary<string, PackedRef> packed, string reference, int depth)
    {
        if (depth > MaxSymbolicDepth)
        {
            throw new InvalidDataException("The symbolic ref chain at '" + reference + "' is too deep (a loop?).");
        }
        // HEAD and the other per-worktree refs live in the git directory; shared refs in the common directory.
        var loose = File.Exists(Path.Combine(gitDirectory, reference))
            ? Path.Combine(gitDirectory, reference)
            : Path.Combine(CommonDirectory(gitDirectory), reference);
        if (File.Exists(loose))
        {
            var content = File.ReadAllText(loose).Trim();
            if (content.StartsWith("ref: ", StringComparison.Ordinal))
            {
                return Lookup(gitDirectory, packed, content.Substring(5).Trim(), depth + 1);
            }
            if (!IsFullId(content))
            {
                throw new InvalidDataException("The ref file '" + loose + "' holds no object id.");
            }
            if (reference.StartsWith("refs/tags/", StringComparison.Ordinal) && packed.TryGetValue(reference, out var same) && same.Id == content && same.Peeled != null)
            {
                return same.Peeled;
            }
            if (reference.StartsWith("refs/tags/", StringComparison.Ordinal) && IsAnnotatedTagObject(gitDirectory, content))
            {
                throw new NotSupportedException(
                    "'" + reference + "' is a loose annotated tag; its commit sits inside a tag object, which this reader does not open. Use git rev-parse.");
            }
            return content.ToLowerInvariant();
        }
        if (packed.TryGetValue(reference, out var entry))
        {
            return entry.Peeled ?? entry.Id;
        }
        return null;
    }

    // A packed object counts as annotated since it cannot be told apart without unpacking: loud, never wrong.
    // [comment:5](/docs/references/automation/catzc-base-git/types/GitRefs.cs.md#comment5)
    private static bool IsAnnotatedTagObject(string gitDirectory, string id)
    {
        var path = Path.Combine(CommonDirectory(gitDirectory), "objects", id.Substring(0, 2), id.Substring(2));
        if (!File.Exists(path))
        {
            return true;
        }
        using var file = File.OpenRead(path);
        using var inflate = new System.IO.Compression.ZLibStream(file, System.IO.Compression.CompressionMode.Decompress);
        var head = new byte[4];
        var read = inflate.ReadAtLeast(head, head.Length, throwOnEndOfStream: false);
        return read == 4 && head[0] == (byte)'t' && head[1] == (byte)'a' && head[2] == (byte)'g' && head[3] == (byte)' ';
    }

    private sealed class PackedRef
    {
        public string Id;
        public string Peeled;
    }

    // `packed-refs`: one `<id> <ref>` line per ref, and a `^<id>` line after an annotated tag naming its commit.
    private static Dictionary<string, PackedRef> ReadPackedRefs(string commonDirectory)
    {
        var refs = new Dictionary<string, PackedRef>(StringComparer.Ordinal);
        var path = Path.Combine(commonDirectory, "packed-refs");
        if (!File.Exists(path))
        {
            return refs;
        }
        PackedRef last = null;
        foreach (var line in File.ReadAllLines(path))
        {
            if (line.Length == 0 || line[0] == '#')
            {
                continue;
            }
            if (line[0] == '^')
            {
                if (last != null) { last.Peeled = line.Substring(1).Trim().ToLowerInvariant(); }
                continue;
            }
            var space = line.IndexOf(' ');
            if (space < 0)
            {
                throw new InvalidDataException("Unexpected packed-refs line '" + line + "'.");
            }
            last = new PackedRef { Id = line.Substring(0, space).ToLowerInvariant() };
            refs[line.Substring(space + 1).Trim()] = last;
        }
        return refs;
    }

    private static void AssertReadable(string gitDirectory)
    {
        if (!File.Exists(Path.Combine(gitDirectory, "HEAD")))
        {
            throw new InvalidOperationException("'" + gitDirectory + "' is not a git directory (no HEAD).");
        }
        if (Directory.Exists(Path.Combine(CommonDirectory(gitDirectory), "reftable")))
        {
            throw new NotSupportedException("'" + gitDirectory + "' keeps its refs in a reftable, which this reader does not read. Use git rev-parse.");
        }
    }

    private static bool IsFullId(string value) =>
        (value.Length == 40 || value.Length == 64) && value.All(Uri.IsHexDigit);
}
