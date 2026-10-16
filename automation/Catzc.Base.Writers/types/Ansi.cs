/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Writers/types/Ansi.cs
    folder: types
    name: ansi
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-writers/types/Ansi.cs.md
    test: automation/Catzc.Base.Writers/tests/types/Ansi.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#7
---
*/

using System;

namespace Catzc.Base.Writers;

public static class Ansi
{
    private const char Esc = (char)27;

    public static readonly string Reset = Esc + "[0m";

    private static readonly int[] Codes =
    {
        30, // 0  Black
        34, // 1  DarkBlue
        32, // 2  DarkGreen
        36, // 3  DarkCyan
        31, // 4  DarkRed
        35, // 5  DarkMagenta
        33, // 6  DarkYellow
        37, // 7  Gray
        90, // 8  DarkGray
        94, // 9  Blue
        92, // 10 Green
        96, // 11 Cyan
        91, // 12 Red
        95, // 13 Magenta
        93, // 14 Yellow
        97, // 15 White
    };

    public static string Code(ConsoleColor color)
    {
        int i = (int)color;
        if (i < 0 || i >= Codes.Length) { return string.Empty; }
        return Esc + "[" + Codes[i].ToString() + "m";
    }

    public static string Wrap(string text, ConsoleColor color)
    {
        string code = Code(color);
        return code.Length == 0 ? text : code + text + Reset;
    }
}
