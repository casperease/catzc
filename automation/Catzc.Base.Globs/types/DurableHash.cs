/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/types/DurableHash.cs
    kind: type
    module: Catzc.Base.Globs
---
*/

// Native code because a per-byte PowerShell pipeline over a tracked binary takes minutes; CR stripping keeps CRLF and LF equal.
// [ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5),
// [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)
// [comment:1](/docs/references/automation/catzc-base-globs/types/DurableHash.cs.md#comment1)

using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.Globs;

public static class DurableHash
{
    // Null for an absent file, not an exception: the caller folds a distinct missing marker for a tracked-but-deleted member.
    // [comment:2](/docs/references/automation/catzc-base-globs/types/DurableHash.cs.md#comment2)
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
