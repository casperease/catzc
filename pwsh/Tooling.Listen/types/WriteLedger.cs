using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Tooling.Listen;

// One line of a write ledger: when, what happened, and whichever of path, hash, session and tool-call id the event has.
public sealed class WriteLedgerEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public DateTimeOffset at { get; }
    public string kind { get; }
    public string path { get; }
    public string hash { get; }
    public string session { get; }
    public string id { get; }

    public WriteLedgerEntry(DateTimeOffset at, string kind, string path, string hash, string session, string id)
    {
        this.at = at;
        this.kind = kind;
        this.path = path;
        this.hash = hash;
        this.session = session;
        this.id = id;
    }
}

// Who made a file's bytes: agent (with its session), editor, or unknown.
public sealed class WriteSource
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string source { get; }
    public string agent { get; }

    public WriteSource(string source, string agent)
    {
        this.source = source;
        this.agent = agent;
    }
}

// The two ledgers that say who wrote a file: one line of JSON per event, appended by its writer and read by the listener.
public static class WriteLedger
{
    // Every Claude Code session's tool writes and Bash windows, appended by the Record-AgentWrite hook.
    public const string AgentLedger = "out/agent-writes.jsonl";

    // Every editor save, appended by the catzc-save-ledger extension, which spells the same path.
    public const string EditorLedger = "out/editor-saves.jsonl";

    // A Bash call's window stays open this long after its end, for the last writes of a formatter it ran.
    public const int WindowGraceSeconds = 2;

    private static readonly Regex FieldRe = new Regex("\"([a-z]+)\":\"((?:[^\"\\\\]|\\\\.)*)\"", RegexOptions.Compiled | RegexOptions.CultureInvariant);

    // One ledger line: the time, the event (write, save, bash-start, bash-end), and whichever of the rest the event has.
    public static string Line(string at, string kind, string path, string hash, string session, string id)
    {
        StringBuilder line = new StringBuilder("{");
        Field(line, "at", at, true);
        Field(line, "event", kind, false);
        Field(line, "path", path, false);
        Field(line, "hash", hash, false);
        Field(line, "session", session, false);
        Field(line, "id", id, false);
        return line.Append('}').ToString();
    }

    // The entries of a ledger file, in file order; a missing file has none, and a torn or foreign line is skipped.
    public static IReadOnlyList<WriteLedgerEntry> Read(string file)
    {
        List<WriteLedgerEntry> entries = new List<WriteLedgerEntry>();
        string[] lines;
        try
        {
            if (!File.Exists(file)) { return entries; }
            using (FileStream stream = new FileStream(file, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                lines = reader.ReadToEnd().Split('\n');
            }
        }
        catch (IOException) { return entries; }

        foreach (string raw in lines)
        {
            Dictionary<string, string> fields = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (Match match in FieldRe.Matches(raw)) { fields[match.Groups[1].Value] = Regex.Unescape(match.Groups[2].Value); }
            string atText;
            string kind;
            DateTimeOffset at;
            if (!fields.TryGetValue("at", out atText) || !fields.TryGetValue("event", out kind)) { continue; }
            if (!DateTimeOffset.TryParse(atText, CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind, out at)) { continue; }
            entries.Add(new WriteLedgerEntry(at, kind, Get(fields, "path"), Get(fields, "hash"), Get(fields, "session"), Get(fields, "id")));
        }
        return entries;
    }

    // Rank decides: an exact agent write, then an exact editor save, then a write inside an open Bash window, else unknown.
    public static WriteSource SourceOf(IReadOnlyList<WriteLedgerEntry> agent, IReadOnlyList<WriteLedgerEntry> editor, string path, string hash,
        DateTimeOffset? writtenAt, int openWindowSeconds, DateTimeOffset now)
    {
        if (!string.IsNullOrEmpty(hash))
        {
            foreach (WriteLedgerEntry entry in agent)
            {
                if (entry.kind == "write" && entry.path == path && entry.hash == hash) { return new WriteSource("agent", entry.session); }
            }
            foreach (WriteLedgerEntry entry in editor)
            {
                if (entry.kind == "save" && entry.path == path && entry.hash == hash) { return new WriteSource("editor", null); }
            }
        }

        if (writtenAt.HasValue)
        {
            for (int i = 0; i < agent.Count; i++)
            {
                WriteLedgerEntry start = agent[i];
                if (start.kind != "bash-start") { continue; }
                DateTimeOffset to = start.at.AddSeconds(openWindowSeconds);
                for (int j = i + 1; j < agent.Count; j++)
                {
                    WriteLedgerEntry end = agent[j];
                    if (end.kind == "bash-end" && start.id != null && end.id == start.id) { to = end.at.AddSeconds(WindowGraceSeconds); break; }
                }
                if (to > now) { to = now; }
                if (writtenAt.Value >= start.at && writtenAt.Value <= to) { return new WriteSource("agent", start.session); }
            }
        }

        return new WriteSource("unknown", null);
    }

    private static string Get(Dictionary<string, string> fields, string name)
    {
        string value;
        return fields.TryGetValue(name, out value) ? value : null;
    }

    // An empty value is no value: PowerShell passes $null to a string parameter as "".
    private static void Field(StringBuilder line, string name, string value, bool first)
    {
        if (string.IsNullOrEmpty(value)) { return; }
        if (!first) { line.Append(','); }
        line.Append('"').Append(name).Append("\":\"");
        foreach (char c in value)
        {
            if (c == '"' || c == '\\') { line.Append('\\').Append(c); }
            else if (c < ' ') { line.Append("\\u").Append(((int)c).ToString("x4", CultureInfo.InvariantCulture)); }
            else { line.Append(c); }
        }
        line.Append('"');
    }
}
