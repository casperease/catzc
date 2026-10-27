using System;
using System.Globalization;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Tooling.Claude;

public sealed class EditorClaim
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The Claude Code session id that holds the claim.
    public string Session { get; }

    // The claimed file's full path, in the one spelling NormalPath gives.
    public string Path { get; }

    // When the claim lapses, in UTC.
    public DateTime Expires { get; }

    public EditorClaim(string session, string path, DateTime expires)
    {
        if (string.IsNullOrWhiteSpace(session) || session.IndexOfAny(new[] { '|', '\r', '\n' }) >= 0)
        {
            throw new ArgumentException("An editor claim needs a session id without '|' or a line break.", nameof(session));
        }
        if (string.IsNullOrWhiteSpace(path))
        {
            throw new ArgumentException("An editor claim needs the path it claims.", nameof(path));
        }
        Session = session;
        Path = NormalPath(path);
        Expires = DateTime.SpecifyKind(expires.ToUniversalTime(), DateTimeKind.Utc);
    }

    // The folder of claim records, beside the run lock's queue under the machine's temporary folder.
    public static string DefaultFolder()
    {
        return System.IO.Path.Combine(System.IO.Path.GetTempPath(), "catzc-run-queue", "editor-claims");
    }

    // A full path in one spelling: forward slashes, and lower case where the file system ignores case.
    public static string NormalPath(string path)
    {
        string full = System.IO.Path.GetFullPath(path).Replace('\\', '/');
        return OperatingSystem.IsWindows() || OperatingSystem.IsMacOS() ? full.ToLowerInvariant() : full;
    }

    // The record file of a path: its normal spelling hashed, so any path makes a short, safe file name.
    public static string RecordPath(string folder, string path)
    {
        byte[] hash = SHA256.HashData(Encoding.UTF8.GetBytes(NormalPath(path)));
        return System.IO.Path.Combine(folder, Convert.ToHexString(hash, 0, 8).ToLowerInvariant() + ".claim");
    }

    // The live claim on a path, or null: no record, a record past its expiry, or one torn or written for another path.
    public static EditorClaim Read(string folder, string path, DateTime now)
    {
        string text;
        try
        {
            text = File.ReadAllText(RecordPath(folder, path));
        }
        catch (IOException)
        {
            return null;
        }
        catch (UnauthorizedAccessException)
        {
            return null;
        }
        string[] parts = text.Split('|', 3);
        long ticks;
        if (parts.Length != 3 || parts[0].Length == 0 ||
            !long.TryParse(parts[1], NumberStyles.None, CultureInfo.InvariantCulture, out ticks) || ticks > DateTime.MaxValue.Ticks)
        {
            return null;
        }
        if (!string.Equals(parts[2], NormalPath(path), StringComparison.Ordinal))
        {
            return null;
        }
        DateTime expires = new DateTime(ticks, DateTimeKind.Utc);
        return expires > now.ToUniversalTime() ? new EditorClaim(parts[0], parts[2], expires) : null;
    }

    public static EditorClaim Claim(string folder, string path, string session, DateTime expires, DateTime now)
    {
        EditorClaim claim = new EditorClaim(session, path, expires);
        EditorClaim held = Read(folder, path, now);
        if (held != null && held.Session != session)
        {
            return held;
        }
        Directory.CreateDirectory(folder);
        string record = RecordPath(folder, path);
        byte[] line = Encoding.UTF8.GetBytes(claim.Line());
        if (held == null)
        {
            // A free path is taken with a create-new write, so of two sessions claiming at once only one wins.
            try
            {
                using (FileStream stream = new FileStream(record, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                {
                    stream.Write(line, 0, line.Length);
                }
                return claim;
            }
            catch (IOException)
            {
                held = Read(folder, path, now);
                if (held != null && held.Session != session)
                {
                    return held;
                }
            }
        }
        File.WriteAllBytes(record, line);
        return claim;
    }

    public static EditorClaim Release(string folder, string path, string session, DateTime now)
    {
        EditorClaim held = Read(folder, path, now);
        if (held != null && held.Session != session)
        {
            return held;
        }
        try
        {
            File.Delete(RecordPath(folder, path));
        }
        catch (IOException)
        {
            // No folder yet, or a claimant writing at this moment: no claim of this session's is left either way.
        }
        return null;
    }

    private string Line()
    {
        return Session + "|" + Expires.Ticks.ToString(CultureInfo.InvariantCulture) + "|" + Path;
    }
}
