using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace Catzc.Base.Git;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Clean))]
public sealed class GitHistoryScan
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The bytes `git grep -I` reads to decide a blob is binary.
    private const int BinaryProbeLength = 8000;

    // True when no surface contains the token.
    public bool Clean => Blobs.Length == 0 && Paths.Length == 0 && Messages.Length == 0;

    // The token searched for.
    public string Token { get; }

    public string[] Blobs { get; }

    // Distinct repo-relative paths containing the token, ordinal order.
    public string[] Paths { get; }

    // Commit-message lines containing the token, one per commit that holds the line.
    public string[] Messages { get; }

    // The number of distinct blobs searched (binary and excluded blobs not counted).
    public int BlobsSearched { get; }

    private GitHistoryScan(string token, string[] blobs, string[] paths, string[] messages, int blobsSearched)
    {
        Token = token;
        Blobs = blobs;
        Paths = paths;
        Messages = messages;
        BlobsSearched = blobsSearched;
    }

    private readonly struct Entry
    {
        public readonly string Type;
        public readonly int Offset;
        public readonly int Length;

        public Entry(string type, int offset, int length)
        {
            Type = type;
            Offset = offset;
            Length = length;
        }
    }

    // Scans everything the roots reach. roots: object ids (commits or annotated tags), e.g. `git rev-parse --all`.
    public static GitHistoryScan Scan(byte[] batch, string[] roots, string token, string[] excludePrefixes)
    {
        if (batch == null) { throw new ArgumentNullException(nameof(batch)); }
        if (string.IsNullOrEmpty(token)) { throw new ArgumentException("the token to scan for must not be empty", nameof(token)); }

        var excluded = (excludePrefixes ?? Array.Empty<string>()).Where(p => !string.IsNullOrEmpty(p)).ToArray();
        var needle = Encoding.UTF8.GetBytes(token);
        var objects = Index(batch);

        var messages = new List<string>();
        var blobPaths = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        var allPaths = new HashSet<string>(StringComparer.Ordinal);
        var seenCommits = new HashSet<string>(StringComparer.Ordinal);
        var seenTrees = new HashSet<string>(StringComparer.Ordinal);
        var pending = new Stack<string>((roots ?? Array.Empty<string>()).Where(r => !string.IsNullOrWhiteSpace(r)).Select(r => r.Trim()));

        while (pending.Count > 0)
        {
            var id = pending.Pop();
            if (!seenCommits.Add(id)) { continue; }
            var entry = Lookup(objects, id);
            var text = Encoding.UTF8.GetString(batch, entry.Offset, entry.Length);
            if (entry.Type == "tag")
            {
                pending.Push(HeaderValue(text, "object", id));
                continue;
            }
            if (entry.Type != "commit")
            {
                continue;
            }

            var bodyStart = text.IndexOf("\n\n", StringComparison.Ordinal);
            var header = bodyStart < 0 ? text : text.Substring(0, bodyStart);
            foreach (var line in header.Split('\n'))
            {
                if (line.StartsWith("parent ", StringComparison.Ordinal)) { pending.Push(line.Substring(7)); }
            }
            WalkTree(batch, objects, HeaderValue(header, "tree", id), "", seenTrees, blobPaths, allPaths);

            if (bodyStart >= 0)
            {
                foreach (var line in text.Substring(bodyStart + 2).Split('\n'))
                {
                    if (line.Contains(token, StringComparison.OrdinalIgnoreCase)) { messages.Add(line.TrimEnd('\r')); }
                }
            }
        }

        var paths = allPaths
            .Where(p => p.Contains(token, StringComparison.OrdinalIgnoreCase) && !IsExcluded(p, excluded))
            .OrderBy(p => p, StringComparer.Ordinal)
            .ToArray();

        var blobs = new List<string>();
        var searched = 0;
        foreach (var pair in blobPaths.OrderBy(p => p.Key, StringComparer.Ordinal))
        {
            var path = pair.Value.FirstOrDefault(p => !IsExcluded(p, excluded));
            if (path == null) { continue; }
            var entry = Lookup(objects, pair.Key);
            var content = new ReadOnlySpan<byte>(batch, entry.Offset, entry.Length);
            if (content.Slice(0, Math.Min(content.Length, BinaryProbeLength)).IndexOf((byte)0) >= 0) { continue; }
            searched++;
            foreach (var line in MatchingLines(content, needle))
            {
                blobs.Add(pair.Key + ":" + path + ":" + line);
            }
        }

        return new GitHistoryScan(token, blobs.ToArray(), paths, messages.ToArray(), searched);
    }

    // Indexes the `<oid> <type> <size>\n<content>\n` records of a cat-file --batch stream.
    private static Dictionary<string, Entry> Index(byte[] batch)
    {
        var objects = new Dictionary<string, Entry>(StringComparer.Ordinal);
        var position = 0;
        while (position < batch.Length)
        {
            var newline = Array.IndexOf(batch, (byte)'\n', position);
            if (newline < 0) { throw new InvalidDataException("The git object stream ends inside a header."); }
            var parts = Encoding.ASCII.GetString(batch, position, newline - position).Split(' ');
            if (parts.Length != 3 || !int.TryParse(parts[2], out var size) || size < 0)
            {
                throw new InvalidDataException("Unexpected git object header '" + string.Join(" ", parts) + "'.");
            }
            var offset = newline + 1;
            // The content is followed by one LF of its own.
            if ((long)offset + size + 1 > batch.Length)
            {
                throw new InvalidDataException("The git object stream is truncated inside object " + parts[0] + ".");
            }
            objects[parts[0]] = new Entry(parts[1], offset, size);
            position = offset + size + 1;
        }
        return objects;
    }

    private static Entry Lookup(Dictionary<string, Entry> objects, string id)
    {
        if (!objects.TryGetValue(id, out var entry))
        {
            throw new InvalidDataException("Object " + id + " is reachable but missing from the object stream.");
        }
        return entry;
    }

    private static string HeaderValue(string header, string key, string id)
    {
        foreach (var line in header.Split('\n'))
        {
            if (line.StartsWith(key + " ", StringComparison.Ordinal)) { return line.Substring(key.Length + 1); }
        }
        throw new InvalidDataException("Object " + id + " has no '" + key + "' header.");
    }

    // Records every path under a tree; a tree already walked at the same prefix is skipped.
    private static void WalkTree(byte[] batch, Dictionary<string, Entry> objects, string treeId, string prefix,
        HashSet<string> seenTrees, Dictionary<string, SortedSet<string>> blobPaths, HashSet<string> allPaths)
    {
        if (!seenTrees.Add(treeId + "\0" + prefix)) { return; }
        var entry = Lookup(objects, treeId);
        var hashLength = treeId.Length / 2;
        var position = entry.Offset;
        var end = entry.Offset + entry.Length;
        while (position < end)
        {
            var space = Array.IndexOf(batch, (byte)' ', position, end - position);
            var nul = Array.IndexOf(batch, (byte)0, space + 1, end - space - 1);
            if (space < 0 || nul < 0 || nul + 1 + hashLength > end)
            {
                throw new InvalidDataException("Tree " + treeId + " is malformed.");
            }
            var mode = Encoding.ASCII.GetString(batch, position, space - position);
            var path = prefix + Encoding.UTF8.GetString(batch, space + 1, nul - space - 1);
            var id = Convert.ToHexString(batch, nul + 1, hashLength).ToLowerInvariant();
            position = nul + 1 + hashLength;

            if (mode == "40000")
            {
                WalkTree(batch, objects, id, path + "/", seenTrees, blobPaths, allPaths);
                continue;
            }
            if (mode == "160000")
            {
                continue; // a submodule's commit lives in another repository
            }
            allPaths.Add(path);
            if (!blobPaths.TryGetValue(id, out var set))
            {
                set = new SortedSet<string>(StringComparer.Ordinal);
                blobPaths[id] = set;
            }
            set.Add(path);
        }
    }

    private static bool IsExcluded(string path, string[] excluded)
    {
        foreach (var prefix in excluded)
        {
            if (path.StartsWith(prefix, StringComparison.OrdinalIgnoreCase)) { return true; }
        }
        return false;
    }

    // Each line of the content that contains the needle, ignoring ASCII case, once per line.
    private static IEnumerable<string> MatchingLines(ReadOnlySpan<byte> content, byte[] needle)
    {
        var lines = new List<string>();
        var start = 0;
        while (start <= content.Length - needle.Length)
        {
            var hit = IndexOfIgnoreAsciiCase(content.Slice(start), needle);
            if (hit < 0) { break; }
            hit += start;
            var lineStart = content.Slice(0, hit).LastIndexOf((byte)'\n') + 1;
            var lineEnd = content.Slice(hit).IndexOf((byte)'\n');
            lineEnd = lineEnd < 0 ? content.Length : hit + lineEnd;
            lines.Add(Encoding.UTF8.GetString(content.Slice(lineStart, lineEnd - lineStart)).TrimEnd('\r'));
            start = lineEnd + 1;
        }
        return lines;
    }

    private static int IndexOfIgnoreAsciiCase(ReadOnlySpan<byte> haystack, byte[] needle)
    {
        var first = needle[0];
        var lower = ToLowerAscii(first);
        var upper = (byte)(lower >= 'a' && lower <= 'z' ? lower - 32 : lower);
        var position = 0;
        while (position <= haystack.Length - needle.Length)
        {
            var candidate = haystack.Slice(position).IndexOfAny(lower, upper);
            if (candidate < 0) { return -1; }
            candidate += position;
            if (candidate > haystack.Length - needle.Length) { return -1; }
            var match = true;
            for (var i = 1; i < needle.Length; i++)
            {
                if (ToLowerAscii(haystack[candidate + i]) != ToLowerAscii(needle[i])) { match = false; break; }
            }
            if (match) { return candidate; }
            position = candidate + 1;
        }
        return -1;
    }

    private static byte ToLowerAscii(byte b) => b >= 'A' && b <= 'Z' ? (byte)(b + 32) : b;
}
