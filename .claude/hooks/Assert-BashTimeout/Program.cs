/*
---
catzc:
  immutable:
    path: ".claude/hooks/Assert-BashTimeout/Program.cs"
    folder: hooks/Assert-BashTimeout
    name: program
    filetype: cs
    kind: hook
    language: csharp
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    page: docs/references/automation/claude-hooks/Assert-BashTimeout/Program.cs.md
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;
using Catzc.Base.Timeouts;
using YamlDotNet.RepresentationModel;

namespace Catzc.Hooks;

public static class AssertBashTimeout
{
    private static readonly Regex PlainInteger = new Regex(@"^[-+]?\d+$", RegexOptions.CultureInvariant);
    private static readonly Regex PlainFloat = new Regex(@"^[-+]?(\d+\.\d*|\.\d+)([eE][-+]?\d+)?$", RegexOptions.CultureInvariant);

    public static int Main()
    {
        try
        {
            string repositoryRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", ".."));
            TimeoutsConfig config = new TimeoutsConfig(LoadYaml(Path.Combine(repositoryRoot, BashSafeguard.ConfigRelativePath)));
            string environment = BashSafeguard.EnvironmentOf(
                Environment.GetEnvironmentVariable("TF_BUILD"), Environment.GetEnvironmentVariable("GITHUB_ACTIONS"));

            string logLine;
            string reason = BashSafeguard.Decide(Console.In.ReadToEnd(), config, environment, out logLine);
            if (reason != null)
            {
                Console.Out.Write(BashSafeguard.DenyOutput(reason));
                AppendLog(Path.Combine(repositoryRoot, "out", "time-safeguard.log"), logLine);
            }
            return 0;
        }
        catch (Exception e)
        {
            // A non-blocking hook error: the call goes ahead and the person sees why the safeguard did not run.
            Console.Error.WriteLine("Bash time safeguard hook failed: " + e.Message);
            return 1;
        }
    }

    private static void AppendLog(string path, string line)
    {
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            File.AppendAllText(path, line + Environment.NewLine);
        }
        catch (IOException)
        {
            // The log is a tuning aid; a locked or missing out/ never turns a denial into a hook error.
        }
    }

    private static IDictionary LoadYaml(string path)
    {
        YamlStream stream = new YamlStream();
        using (StreamReader reader = new StreamReader(path))
        {
            stream.Load(reader);
        }
        if (stream.Documents.Count == 0)
        {
            return null;
        }
        object root = Convert(stream.Documents[0].RootNode);
        return root as IDictionary;
    }

    private static object Convert(YamlNode node)
    {
        YamlMappingNode mapping = node as YamlMappingNode;
        if (mapping != null)
        {
            Hashtable table = new Hashtable(StringComparer.Ordinal);
            foreach (KeyValuePair<YamlNode, YamlNode> entry in mapping.Children)
            {
                table[((YamlScalarNode)entry.Key).Value] = Convert(entry.Value);
            }
            return table;
        }
        YamlSequenceNode sequence = node as YamlSequenceNode;
        if (sequence != null)
        {
            ArrayList list = new ArrayList();
            foreach (YamlNode item in sequence.Children)
            {
                list.Add(Convert(item));
            }
            return list;
        }
        YamlScalarNode scalar = (YamlScalarNode)node;
        string value = scalar.Value;
        if (scalar.Style != YamlDotNet.Core.ScalarStyle.Plain || value == null)
        {
            return value;
        }
        if (value.Length == 0 || value == "~" || value == "null")
        {
            return null;
        }
        long integer;
        if (PlainInteger.IsMatch(value) && long.TryParse(value, NumberStyles.AllowLeadingSign, CultureInfo.InvariantCulture, out integer))
        {
            return integer;
        }
        if (PlainFloat.IsMatch(value))
        {
            return double.Parse(value, CultureInfo.InvariantCulture);
        }
        return value;
    }
}
