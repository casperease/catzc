using System;
using System.Globalization;
using System.IO;
using System.Text.Json;

namespace Catzc.Tooling.Claude;

public static class EditorClaimGuard
{
    private static readonly string[] EditTools = { "Edit", "Write", "MultiEdit", "NotebookEdit" };

    // The reason the call is denied, or null when it may go on.
    public static string Decide(string payload, string folder, DateTime now)
    {
        using (JsonDocument document = JsonDocument.Parse(payload))
        {
            JsonElement root = document.RootElement;
            if (root.ValueKind != JsonValueKind.Object || Array.IndexOf(EditTools, Text(root, "tool_name")) < 0)
            {
                return null;
            }
            JsonElement input;
            if (!root.TryGetProperty("tool_input", out input) || input.ValueKind != JsonValueKind.Object)
            {
                return null;
            }
            string file = Text(input, "file_path") ?? Text(input, "notebook_path");
            string cwd = Text(root, "cwd");
            if (file == null || (!Path.IsPathRooted(file) && cwd == null))
            {
                return null;
            }
            string full = Path.IsPathRooted(file) ? file : Path.Combine(cwd, file);
            EditorClaim claim = EditorClaim.Read(folder, full, now);
            if (claim == null || claim.Session == Text(root, "session_id"))
            {
                return null;
            }
            return string.Format(CultureInfo.InvariantCulture,
                "{0} is claimed by session {1} until {2:HH:mm:ss} UTC (Lock-SharedConfig): one session edits a shared config at a time, so wait for its Unlock-SharedConfig or the expiry, then claim it yourself.",
                file, claim.Session, claim.Expires);
        }
    }

    // The PreToolUse output that denies the call with the reason.
    public static string DenyOutput(string reason)
    {
        return JsonSerializer.Serialize(new
        {
            hookSpecificOutput = new
            {
                hookEventName = "PreToolUse",
                permissionDecision = "deny",
                permissionDecisionReason = reason
            }
        });
    }

    private static string Text(JsonElement element, string name)
    {
        JsonElement value;
        return element.TryGetProperty(name, out value) && value.ValueKind == JsonValueKind.String ? value.GetString() : null;
    }
}
