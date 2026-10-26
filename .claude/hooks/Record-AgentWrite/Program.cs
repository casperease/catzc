using System;
using System.Globalization;
using System.IO;
using System.Text.Json;
using System.Threading;
using Catzc.Base.Globs;
using Catzc.Tooling.Listen;

namespace Catzc.Hooks;

public static class RecordAgentWrite
{
    public static int Main()
    {
        try
        {
            string repositoryRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", ".."));
            string line = LineFor(Console.In.ReadToEnd(), repositoryRoot, DateTimeOffset.Now);
            if (line != null)
            {
                Append(Path.Combine(repositoryRoot, WriteLedger.AgentLedger), line);
            }
        }
        catch (Exception)
        {
            // A hook that records must never cost the call it records.
        }
        return 0;
    }

    // The ledger line for one hook input, or null when the input names nothing to record.
    public static string LineFor(string input, string repositoryRoot, DateTimeOffset now)
    {
        using (JsonDocument document = JsonDocument.Parse(input))
        {
            JsonElement root = document.RootElement;
            string at = now.ToString("o", CultureInfo.InvariantCulture);
            string tool = Text(root, "tool_name");
            string session = Text(root, "session_id");
            string id = Text(root, "tool_use_id");

            if (tool == "Bash")
            {
                string kind = Text(root, "hook_event_name") == "PreToolUse" ? "bash-start" : "bash-end";
                return WriteLedger.Line(at, kind, null, null, session, id);
            }

            JsonElement toolInput;
            if (!root.TryGetProperty("tool_input", out toolInput) || toolInput.ValueKind != JsonValueKind.Object) { return null; }
            string file = Text(toolInput, "file_path") ?? Text(toolInput, "notebook_path");
            if (file == null) { return null; }

            string full = Path.GetFullPath(Path.IsPathRooted(file) ? file : Path.Combine(Text(root, "cwd") ?? repositoryRoot, file));
            string relative = Path.GetRelativePath(repositoryRoot, full).Replace('\\', '/');
            if (relative.StartsWith("..", StringComparison.Ordinal) || Path.IsPathRooted(relative)) { return null; }
            return WriteLedger.Line(at, "write", relative, DurableHash.HashFile(full), session, id);
        }
    }

    private static string Text(JsonElement element, string name)
    {
        JsonElement value;
        return element.TryGetProperty(name, out value) && value.ValueKind == JsonValueKind.String ? value.GetString() : null;
    }

    // Several sessions append at once; a line is written whole under a shared append, retried while another writer holds the file.
    private static void Append(string path, string line)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        byte[] bytes = System.Text.Encoding.UTF8.GetBytes(line + "\n");
        for (int attempt = 0; attempt < 20; attempt++)
        {
            try
            {
                using (FileStream stream = new FileStream(path, FileMode.Append, FileAccess.Write, FileShare.ReadWrite))
                {
                    stream.Write(bytes, 0, bytes.Length);
                }
                return;
            }
            catch (IOException)
            {
                Thread.Sleep(10);
            }
        }
    }
}
