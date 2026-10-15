/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Git/types/GitIndex.cs
    kind: type
    module: Catzc.Base.Git
    adrs:
      - ADR-AUTO-TRACKED
---
*/

// A split or sparse index is rejected loudly rather than read wrong; equal index bytes never yield a stale listing.
// [comment:1](/docs/references/automation/catzc-base-git/types/GitIndex.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.Git;

public sealed class GitIndex
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The SHA-1 object id length every entry carries.
    private const int HashLength = 20;

    // ctime, mtime (8 bytes each), dev, ino, mode, uid, gid, size (4 bytes each) — the fixed head of an entry.
    private const int StatLength = 40;

    // The SHA-256 of the index file's bytes (uppercase hex) — the cache key.
    public string ContentHash { get; }

    // An unmerged path is held once per conflict stage in the index but listed once here, as git ls-files lists it.
    // [comment:2](/docs/references/automation/catzc-base-git/types/GitIndex.cs.md#comment2)
    public string[] Paths { get; }

    // Same order and form as Paths, so this is an ordered subsequence of Paths: only the mode 100755 entries.
    // [comment:3](/docs/references/automation/catzc-base-git/types/GitIndex.cs.md#comment3)
    public string[] ExecutablePaths { get; }

    // git's mode for an executable regular file (octal 100755).
    private const uint ExecutableMode = 0x81ED;

    private GitIndex(string contentHash, string[] paths, string[] executablePaths)
    {
        ContentHash = contentHash;
        Paths = paths;
        ExecutablePaths = executablePaths;
    }

    // The cache key of an index file's bytes — cheap enough to compute on every lookup.
    public static string HashContent(byte[] content)
    {
        return Convert.ToHexString(SHA256.HashData(content));
    }

    public static GitIndex Parse(byte[] content)
    {
        try
        {
            return ParseCore(content);
        }
        catch (Exception ex) when (ex is IndexOutOfRangeException or ArgumentOutOfRangeException or ArgumentException)
        {
            throw new InvalidDataException("The git index is truncated or malformed.", ex);
        }
    }

    // Pathspecs are literal prefixes, not globs; '.' means the whole repository, and each path comes back once.
    // [comment:4](/docs/references/automation/catzc-base-git/types/GitIndex.cs.md#comment4)
    public string[] Under(IEnumerable<string> pathspecs) => Select(Paths, pathspecs);

    // The executable tracked paths at or under the given paths, in the same form as Under.
    public string[] ExecutableUnder(IEnumerable<string> pathspecs) => Select(ExecutablePaths, pathspecs);

    private static string[] Select(string[] candidates, IEnumerable<string> pathspecs)
    {
        var prefixes = new List<string>();
        foreach (var pathspec in pathspecs)
        {
            var normalized = NormalizePathspec(pathspec);
            if (normalized.Length == 0)
            {
                return (string[])candidates.Clone();
            }
            prefixes.Add(normalized);
        }

        var matches = new List<string>();
        foreach (var path in candidates)
        {
            foreach (var prefix in prefixes)
            {
                if (path.Length == prefix.Length
                    ? string.Equals(path, prefix, StringComparison.Ordinal)
                    : path.Length > prefix.Length && path[prefix.Length] == '/' && path.StartsWith(prefix, StringComparison.Ordinal))
                {
                    matches.Add(path);
                    break;
                }
            }
        }
        return matches.ToArray();
    }

    private static GitIndex ParseCore(byte[] content)
    {
        if (content.Length < 12 + HashLength || Encoding.ASCII.GetString(content, 0, 4) != "DIRC")
        {
            throw new InvalidDataException("Not a git index: the 'DIRC' signature is missing.");
        }
        var version = ReadUInt32(content, 4);
        if (version < 2 || version > 4)
        {
            throw new InvalidDataException($"Unsupported git index version {version} (versions 2-4 are read).");
        }

        // A mismatch means a corrupt file or a SHA-256 repository, whose 32-byte object ids this reader does not parse.
        // [comment:5](/docs/references/automation/catzc-base-git/types/GitIndex.cs.md#comment5)
        var bodyLength = content.Length - HashLength;
        var trailer = content.AsSpan(bodyLength);
        if (trailer.IndexOfAnyExcept((byte)0) >= 0 && !trailer.SequenceEqual(SHA1.HashData(content.AsSpan(0, bodyLength))))
        {
            throw new InvalidDataException("The git index checksum does not match — the file is corrupt, or the repository uses the SHA-256 object format, which is not supported.");
        }

        var count = ReadUInt32(content, 8);
        var paths = new List<string>((int)count);
        var executablePaths = new List<string>();
        var position = 12;
        var previous = Array.Empty<byte>();
        for (var i = 0; i < count; i++)
        {
            var entryStart = position;
            var mode = ReadUInt32(content, entryStart + 24);
            position += StatLength + HashLength;
            var flags = (content[position] << 8) | content[position + 1];
            position += 2;
            if ((flags & 0x4000) != 0)
            {
                // The extended flag: two more flag bytes (skip-worktree, intent-to-add) — both still listed.
                position += 2;
            }

            byte[] pathBytes;
            if (version == 4)
            {
                // Prefix compression: drop N bytes from the end of the previous path, append the NUL-terminated rest.
                var strip = ReadVarint(content, ref position);
                var end = Array.IndexOf(content, (byte)0, position);
                var keep = previous.Length - strip;
                pathBytes = new byte[keep + end - position];
                Buffer.BlockCopy(previous, 0, pathBytes, 0, keep);
                Buffer.BlockCopy(content, position, pathBytes, keep, end - position);
                position = end + 1;
            }
            else
            {
                // NUL-terminated, then NUL-padded so the entry's length is a multiple of 8.
                var end = Array.IndexOf(content, (byte)0, position);
                pathBytes = content.AsSpan(position, end - position).ToArray();
                position = entryStart + ((end - entryStart + 8) & ~7);
            }
            previous = pathBytes;

            if ((mode & 0xF000) == 0x4000)
            {
                throw new InvalidDataException("The git index is sparse (it holds directory entries); run 'git sparse-checkout disable' or 'git config index.sparse false'.");
            }

            var path = Encoding.UTF8.GetString(pathBytes);
            if (paths.Count == 0 || !string.Equals(paths[^1], path, StringComparison.Ordinal))
            {
                paths.Add(path);
                if (mode == ExecutableMode)
                {
                    executablePaths.Add(path);
                }
            }
        }

        // Extensions: a 4-byte signature and a 4-byte length each, up to the trailer.
        while (position < bodyLength)
        {
            var signature = Encoding.ASCII.GetString(content, position, 4);
            if (signature == "link")
            {
                throw new InvalidDataException("The git index is split (core.splitIndex); run 'git update-index --no-split-index'.");
            }
            position += 8 + (int)ReadUInt32(content, position + 4);
        }
        if (position != bodyLength)
        {
            throw new InvalidDataException("The git index is truncated or malformed: its extensions overrun the checksum.");
        }

        return new GitIndex(HashContent(content), paths.ToArray(), executablePaths.ToArray());
    }

    private static string NormalizePathspec(string pathspec)
    {
        var normalized = (pathspec ?? string.Empty).Trim().Replace('\\', '/');
        if (Path.IsPathRooted(normalized))
        {
            throw new ArgumentException($"'{pathspec}' is not a repository-relative path.", nameof(pathspec));
        }
        while (normalized.StartsWith("./", StringComparison.Ordinal))
        {
            normalized = normalized.Substring(2);
        }
        normalized = normalized.TrimEnd('/');
        if (normalized == ".")
        {
            normalized = string.Empty;
        }
        if (normalized == ".." || normalized.StartsWith("../", StringComparison.Ordinal) || normalized.Contains("/../", StringComparison.Ordinal))
        {
            throw new ArgumentException($"'{pathspec}' lies outside the repository.", nameof(pathspec));
        }
        return normalized;
    }

    private static uint ReadUInt32(byte[] content, int offset)
    {
        return ((uint)content[offset] << 24) | ((uint)content[offset + 1] << 16) | ((uint)content[offset + 2] << 8) | content[offset + 3];
    }

    // git's offset varint (varint.c): each continuation byte adds one before shifting.
    private static int ReadVarint(byte[] content, ref int position)
    {
        int b = content[position++];
        var value = b & 0x7F;
        while ((b & 0x80) != 0)
        {
            b = content[position++];
            value = ((value + 1) << 7) | (b & 0x7F);
        }
        return value;
    }
}
