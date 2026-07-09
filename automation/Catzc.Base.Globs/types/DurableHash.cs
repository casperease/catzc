// The durable-SHA digest primitives (ADR-FLOW-CD-GLOBS:5), in native code: a globset may include large binaries
// (the committed type assembly is a tracked file), where a per-byte PowerShell pipeline takes minutes and
// this takes milliseconds. HashFile is SHA-256 over the file's bytes with every CR (0x0D) stripped —
// EOL-insensitive, so CRLF and LF working trees agree — and HashFold is SHA-256 over the UTF-8 fold text;
// both return 64 lowercase hex chars. BCL only.
// See docs/adr/flow/durable-sha-globs.md.

using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.Globs;

public static class DurableHash
{
    // SHA-256 (lowercase hex) of the file's bytes with every CR stripped; null when the file is absent —
    // the caller folds the distinct 'missing' marker for a tracked-but-deleted member.
    public static string HashFile(string path)
    {
        if (!File.Exists(path)) { return null; }
        byte[] bytes = File.ReadAllBytes(path);
        int length = 0;
        for (int i = 0; i < bytes.Length; i++)
        {
            if (bytes[i] != 13) { bytes[length++] = bytes[i]; }
        }
        using (SHA256 sha = SHA256.Create())
        {
            return ToHex(sha.ComputeHash(bytes, 0, length));
        }
    }

    // SHA-256 (lowercase hex) of the UTF-8 bytes of the fold text (the <path>|<digest> lines).
    public static string HashFold(string fold)
    {
        using (SHA256 sha = SHA256.Create())
        {
            return ToHex(sha.ComputeHash(Encoding.UTF8.GetBytes(fold ?? string.Empty)));
        }
    }

    private static string ToHex(byte[] digest)
    {
        StringBuilder hex = new StringBuilder(digest.Length * 2);
        foreach (byte b in digest)
        {
            hex.Append(b.ToString("x2"));
        }
        return hex.ToString();
    }
}
