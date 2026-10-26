/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md"
  header: "generated"
---
*/

using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.Globs;

// SHA-256 with every CR stripped, in native code: a large tracked binary hashes in milliseconds, not minutes.
public static class DurableHash
{
    // Null for an absent file, so the caller folds the distinct missing marker.
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
