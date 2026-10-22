using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;
using Catzc.Base.QualityGates;
using YamlDotNet.RepresentationModel;

namespace Catzc.Hooks;

public static class ShowEditReminder
{
    public static int Main()
    {
        try
        {
            string repositoryRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", ".."));
            string relative = EditedPath(Console.In.ReadToEnd(), repositoryRoot);
            if (relative == null) { return 0; }
            string configPath = EditRemindersConfig.FindConfig(repositoryRoot);
            if (configPath == null) { return 0; }
            string output = EditRemindersConfig.HookOutput(new EditRemindersConfig(LoadYaml(configPath)).For(relative));
            if (output != null) { Console.Out.Write(output); }
        }
        catch (Exception e)
        {
            // A reminder must never cost the edit it follows; stderr with exit 0 is shown to no one but a person debugging the hook.
            Console.Error.WriteLine("Show-EditReminder: " + e.Message);
        }
        return 0;
    }

    // The repository-relative path an Edit or Write call changed, or null when it names none inside the repository.
    private static string EditedPath(string input, string repositoryRoot)
    {
        using (JsonDocument document = JsonDocument.Parse(input))
        {
            JsonElement root = document.RootElement;
            JsonElement toolInput;
            if (!root.TryGetProperty("tool_input", out toolInput) || toolInput.ValueKind != JsonValueKind.Object) { return null; }
            JsonElement value;
            if (!toolInput.TryGetProperty("file_path", out value) || value.ValueKind != JsonValueKind.String) { return null; }
            string file = value.GetString();
            string cwd = root.TryGetProperty("cwd", out value) && value.ValueKind == JsonValueKind.String ? value.GetString() : repositoryRoot;
            string full = Path.GetFullPath(Path.IsPathRooted(file) ? file : Path.Combine(cwd, file));
            string relative = Path.GetRelativePath(repositoryRoot, full).Replace('\\', '/');
            return relative.StartsWith("..", StringComparison.Ordinal) || Path.IsPathRooted(relative) ? null : relative;
        }
    }

    private static IDictionary LoadYaml(string path)
    {
        YamlStream stream = new YamlStream();
        using (StreamReader reader = new StreamReader(path))
        {
            stream.Load(reader);
        }
        return stream.Documents.Count == 0 ? null : Convert(stream.Documents[0].RootNode) as IDictionary;
    }

    // The config holds maps, lists and strings only, so every scalar stays its text.
    private static object Convert(YamlNode node)
    {
        if (node is YamlMappingNode mapping)
        {
            Hashtable table = new Hashtable(StringComparer.Ordinal);
            foreach (KeyValuePair<YamlNode, YamlNode> entry in mapping.Children)
            {
                table[((YamlScalarNode)entry.Key).Value] = Convert(entry.Value);
            }
            return table;
        }
        if (node is YamlSequenceNode sequence)
        {
            ArrayList list = new ArrayList();
            foreach (YamlNode item in sequence.Children) { list.Add(Convert(item)); }
            return list;
        }
        return ((YamlScalarNode)node).Value;
    }
}
