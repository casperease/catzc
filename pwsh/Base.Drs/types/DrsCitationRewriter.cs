using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

using Catzc.Base.MarkdownMeta;
using static Catzc.Base.Drs.DrsCitationText;

namespace Catzc.Base.Drs;

// Rewrites one file's record references through a code map and a rule map: codes, rule anchors, link destinations and path mentions.
public sealed class DrsCitationRewriter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly string drsRoot;
    // The root every decision record moves to: drsRoot itself unless a code map row of kind root moves it.
    string newRoot;
    const string Segment = @"[\w<>*-]+(?:\.[\w<>*-]+)*";

    static readonly Regex InlineDestination = new Regex(@"\]\((?<dest><[^>\r\n]*>|[^)\s]+)", RegexOptions.Compiled);
    static readonly Regex ReferenceDestination = new Regex(@"^ {0,3}\[[^\]\r\n]+\]:[ \t]*(?<dest><[^>\r\n]*>|\S+)", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);
    static readonly string[] CodeMapColumns = { "old_code", "new_code", "old_path", "new_path", "kind" };
    static readonly string[] RuleMapColumns = { "old_rule", "new_rule", "kind" };
    static readonly HashSet<string> CodeMapKinds = new HashSet<string>(StringComparer.Ordinal) { "move", "path", "new", "folder", "root" };
    static readonly HashSet<string> RuleMapKinds = new HashSet<string>(StringComparer.Ordinal) { "move", "collapse" };

    readonly Dictionary<string, string> codeMap = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, string> ruleMap = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, string> pathMap = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly List<(string Old, string New)> folderMap = new List<(string, string)>();
    readonly List<string> bareFolders = new List<string>();
    readonly HashSet<string> recordFiles = new HashSet<string>(StringComparer.Ordinal);
    readonly HashSet<string> recordFolders = new HashSet<string>(StringComparer.Ordinal);
    readonly Dictionary<string, string> newPathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly Dictionary<string, string> oldPathByCode = new Dictionary<string, string>(StringComparer.Ordinal);
    readonly DrsCitationMap citations;
    readonly Regex reference;
    // The code grammar over the registered record kinds, the markers of a code.
    readonly string anchorPattern;
    readonly string codePattern;
    readonly Regex ruleAnchor;
    readonly Regex codeShape;
    // The width a markdown line may reach before its citations take the reference form; 0 never changes a citation's form.
    readonly int markdownWidth;

    // root: the repository-relative folder of the decision records (DrsConfig.Root).
    public DrsCitationRewriter(IEnumerable codeRows, IEnumerable ruleRows, DrsCitationMap citations, IEnumerable<string> treeFiles, IEnumerable<string> kinds,
        string root, int markdownWidth)
    {
        if (string.IsNullOrEmpty(root)) { throw new ArgumentNullException(nameof(root)); }
        if (markdownWidth < 0) { throw new ArgumentOutOfRangeException(nameof(markdownWidth), "the markdown width is 0 (off) or a positive column count"); }
        this.markdownWidth = markdownWidth;
        drsRoot = root.TrimEnd('/') + "/";
        newRoot = drsRoot;
        if (codeRows == null) { throw new ArgumentNullException(nameof(codeRows)); }
        if (ruleRows == null) { throw new ArgumentNullException(nameof(ruleRows)); }
        if (treeFiles == null) { throw new ArgumentNullException(nameof(treeFiles)); }
        if (kinds == null) { throw new ArgumentNullException(nameof(kinds)); }
        var kindList = new List<string>(kinds);
        if (kindList.Count == 0 || kindList.Exists(k => k == null || !Regex.IsMatch(k, "^[A-Z]+$")))
        {
            throw new ArgumentException("kinds must be one or more upper-case record kinds", nameof(kinds));
        }
        string upper = "(?:" + string.Join("|", kindList) + ")";
        string lower = upper.ToLowerInvariant();
        anchorPattern = "rule-" + lower + @"(?:-[a-z][a-z0-9]*)+(?![\w-])";
        codePattern = upper + @"(?>(?:-[A-Z][A-Z0-9]*)+)";
        ruleAnchor = new Regex(@"^rule-(?<code>" + lower + @"(?:-[a-z][a-z0-9]*)+)$", RegexOptions.Compiled);
        // A new code may be a bare kind: a framing domain's code becomes its kind.
        codeShape = new Regex("^" + upper + @"(?:-[A-Z][A-Z0-9]*)*$", RegexOptions.Compiled);
        this.citations = citations;
        foreach (string file in treeFiles)
        {
            string recordPath = Normalize(file);
            if (!recordPath.StartsWith(drsRoot, StringComparison.Ordinal)) { continue; }
            recordPath = recordPath.Substring(drsRoot.Length);
            recordFiles.Add(recordPath);
            for (int slash = recordPath.LastIndexOf('/'); slash > 0; slash = recordPath.LastIndexOf('/', slash - 1))
            {
                recordFolders.Add(recordPath.Substring(0, slash));
            }
        }

        foreach (object row in codeRows) { AddCodeRow(Cells(row, CodeMapColumns, "code map")); }
        foreach (object row in ruleRows) { AddRuleRow(Cells(row, RuleMapColumns, "rule map")); }
        folderMap.Sort((left, right) => right.Old.Length.CompareTo(left.Old.Length));

        var literals = new List<string>(pathMap.Keys);
        // A moved folder of one segment is matched only as a path, its name followed by '/': its bare name is a word of prose.
        var folders = bareFolders;
        foreach ((string old, string _) in folderMap)
        {
            if (old.Contains('/')) { literals.Add(old); } else { folders.Add(old); }
        }
        literals.Sort((left, right) => right.Length.CompareTo(left.Length));
        folders.Sort((left, right) => right.Length.CompareTo(left.Length));
        string path = Segment + "(?:/" + Segment + ")*/?";
        var alternatives = new List<string>
        {
            @"(?<![\w./-])(?<repo>/?" + Regex.Escape(drsRoot) + path + ")(?:#(?<repoAnchor>" + anchorPattern + "))?",
            @"(?<![\w./-])(?<relative>(?:\.\.?/)+" + path + ")(?:#(?<relativeAnchor>" + anchorPattern + "))?",
        };
        // A moved root is also named bare, as a folder or a setting's value; a path under it is the repo form above.
        if (newRoot != drsRoot)
        {
            alternatives.Add(@"(?<![\w./-])(?<rootBare>/?" + Regex.Escape(drsRoot.TrimEnd('/')) + @")(?![\w-]|\.\w|/[\w<>*.-])");
        }
        var bare = new List<string>();
        if (literals.Count > 0) { bare.Add("(?:" + string.Join("|", literals.ConvertAll(Regex.Escape)) + ")(?:/" + Segment + ")*/?"); }
        if (folders.Count > 0) { bare.Add("(?:" + string.Join("|", folders.ConvertAll(Regex.Escape)) + ")/(?:" + path + ")?"); }
        if (bare.Count > 0)
        {
            alternatives.Add(@"(?<![\w./-])(?<bare>" + string.Join("|", bare) + @")(?![\w-])(?:#(?<bareAnchor>" + anchorPattern + "))?");
        }
        // A numbered citation or a group names rules by a number no rule carries: it is reported, never rewritten.
        alternatives.Add(@"(?<![\w-])(?<numbered>" + codePattern + @"(?:[#:][0-9]+|#\{[^}\r\n]*\}))");
        alternatives.Add(@"(?<![\w-])(?<code>" + codePattern + @")(?![\w-])");
        alternatives.Add(@"(?<![\w-])(?<anchor>" + anchorPattern + ")");
        reference = new Regex(string.Join("|", alternatives), RegexOptions.Compiled);
    }

    // The text with every mapped reference rewritten, as seen from the file at repoPath (repository-relative).
    public DrsCitationRewrite Rewrite(string text, string repoPath)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        string self = Normalize(repoPath);
        if (self.Length == 0) { throw new ArgumentException("the file's repository-relative path is required", nameof(repoPath)); }

        var edits = new List<(int Start, int Length, DrsCitationChangeKind Kind, string Replacement)>();
        var unhandled = new List<(int Start, string Old)>();

        var destinations = new List<Group>();
        foreach (Match link in InlineDestination.Matches(text)) { destinations.Add(link.Groups["dest"]); }
        if (self.EndsWith(".md", StringComparison.OrdinalIgnoreCase))
        {
            foreach (Match definition in ReferenceDestination.Matches(text)) { destinations.Add(definition.Groups["dest"]); }
        }
        destinations.Sort((left, right) => left.Index.CompareTo(right.Index));

        int scanned = 0;
        foreach (Group destination in destinations)
        {
            if (destination.Index < scanned) { continue; }
            Scan(text, scanned, destination.Index - scanned, self, edits, unhandled);
            string replacement = RewriteDestination(destination.Value, self);
            if (replacement != null) { edits.Add((destination.Index, destination.Length, DrsCitationChangeKind.Link, replacement)); }
            scanned = destination.Index + destination.Length;
        }
        Scan(text, scanned, text.Length - scanned, self, edits, unhandled);

        List<int> lineStarts = LineStarts(text);
        var found = new List<(int Start, DrsCitationChange Change)>();
        var output = new StringBuilder(text.Length);
        int copied = 0;
        edits.Sort((left, right) => left.Start.CompareTo(right.Start));
        foreach ((int start, int length, DrsCitationChangeKind kind, string replacement) in edits)
        {
            output.Append(text, copied, start - copied).Append(replacement);
            copied = start + length;
            found.Add((start, new DrsCitationChange(self, LineOf(lineStarts, start), kind, text.Substring(start, length), replacement)));
        }
        output.Append(text, copied, text.Length - copied);
        foreach ((int start, string old) in unhandled)
        {
            found.Add((start, new DrsCitationChange(self, LineOf(lineStarts, start), DrsCitationChangeKind.Unhandled, old, null)));
        }
        found.Sort((left, right) => left.Start.CompareTo(right.Start));
        var changes = new List<DrsCitationChange>(found.Count);
        foreach ((int _, DrsCitationChange change) in found) { changes.Add(change); }

        if (edits.Count == 0) { return new DrsCitationRewrite(text, false, changes); }
        string rewritten = output.ToString();
        if (markdownWidth > 0 && self.EndsWith(".md", StringComparison.OrdinalIgnoreCase))
        {
            var edited = new HashSet<int>();
            foreach ((int start, int _, DrsCitationChangeKind _, string _) in edits) { edited.Add(LineOf(lineStarts, start)); }
            rewritten = DrsCitationForm.ToReference(rewritten, self, edited, markdownWidth, codePattern, changes);
        }
        return new DrsCitationRewrite(rewritten, true, changes);
    }

    void Scan(string text, int start, int length, string self, List<(int, int, DrsCitationChangeKind, string)> edits, List<(int, string)> unhandled)
    {
        if (length <= 0) { return; }
        for (Match match = reference.Match(text, start, length); match.Success; match = match.NextMatch())
        {
            DrsCitationChangeKind kind;
            string replacement;
            if (match.Groups["repo"].Success)
            {
                string written = match.Groups["repo"].Value;
                Form form = written.StartsWith("/", StringComparison.Ordinal) ? Form.Rooted : Form.Repository;
                kind = DrsCitationChangeKind.Path;
                replacement = RewriteReference(written, Fragment(match.Groups["repoAnchor"]), form, self);
            }
            else if (match.Groups["rootBare"].Success)
            {
                kind = DrsCitationChangeKind.Path;
                replacement = (match.Value.StartsWith("/", StringComparison.Ordinal) ? "/" : string.Empty) + newRoot.TrimEnd('/');
            }
            else if (match.Groups["relative"].Success)
            {
                kind = DrsCitationChangeKind.Path;
                replacement = RewriteReference(match.Groups["relative"].Value, Fragment(match.Groups["relativeAnchor"]), Form.Relative, self);
            }
            else if (match.Groups["bare"].Success)
            {
                kind = DrsCitationChangeKind.Path;
                string written = match.Groups["bare"].Value;
                // A moved one-segment folder's path is a record path only when it resolves under docs/drs from the citing file; elsewhere it names another folder of that name, such as the modules folder.
                bool folderPath = IsBareFolderPath(written);
                string resolved = folderPath ? Join(Resolve(Segments(ParentOf(self)), written)) : drsRoot;
                // It must also name the moved folder itself or a file or folder of it in the tree, so a module path such as pwsh/Catzc.X/... stays as written.
                bool named = !folderPath || NamesMovedContent(written);
                replacement = named && resolved != null && resolved.StartsWith(drsRoot, StringComparison.Ordinal)
                    ? RewriteReference(written, Fragment(match.Groups["bareAnchor"]), Form.DrsRelative, self)
                    : null;
            }
            else if (match.Groups["numbered"].Success)
            {
                unhandled.Add((match.Index, match.Value));
                continue;
            }
            else if (match.Groups["code"].Success)
            {
                kind = ruleMap.ContainsKey(match.Value) ? DrsCitationChangeKind.Citation : DrsCitationChangeKind.Code;
                replacement = MapCode(match.Value);
            }
            else
            {
                kind = DrsCitationChangeKind.Anchor;
                replacement = RewriteAnchor(match.Value);
            }
            if (replacement != null && replacement != match.Value) { edits.Add((match.Index, match.Length, kind, replacement)); }
        }
    }

    string RewriteAnchor(string anchor)
    {
        Match match = ruleAnchor.Match(anchor);
        if (!match.Success) { return null; }
        string oldCode = match.Groups["code"].Value.ToUpperInvariant();
        string code = MapCode(oldCode);
        return code == oldCode ? null : DrsCitationMap.Anchor(code);
    }

    // A link destination as written, (<target>) or (target): its path resolved by the link's form and mapped.
    string RewriteDestination(string written, string self)
    {
        bool angle = written.StartsWith("<", StringComparison.Ordinal) && written.EndsWith(">", StringComparison.Ordinal);
        string destination = angle ? written.Substring(1, written.Length - 2) : written;
        if (destination.Length == 0 || Scheme.IsMatch(destination)) { return null; }

        int hash = destination.IndexOf('#');
        string fragment = hash >= 0 ? destination.Substring(hash + 1) : null;
        string beforeFragment = hash >= 0 ? destination.Substring(0, hash) : destination;
        int question = beforeFragment.IndexOf('?');
        string query = question >= 0 ? beforeFragment.Substring(question) : string.Empty;
        string pathPart = question >= 0 ? beforeFragment.Substring(0, question) : beforeFragment;

        Form form = pathPart.Length == 0 ? Form.InFile : pathPart.StartsWith("/", StringComparison.Ordinal) ? Form.Rooted : Form.Relative;
        string rewritten = RewriteReference(pathPart, fragment, form, self);
        if (rewritten == null) { return null; }
        int rewrittenHash = rewritten.IndexOf('#');
        string result = rewrittenHash >= 0
            ? rewritten.Substring(0, rewrittenHash) + query + rewritten.Substring(rewrittenHash)
            : rewritten + query;
        return angle ? "<" + result + ">" : result;
    }

    // A path reference mapped and written back in its own form; null when it does not point into docs/drs/ or nothing changes.
    string RewriteReference(string pathPart, string fragment, Form form, string self)
    {
        string target;
        switch (form)
        {
            case Form.InFile: target = self; break;
            case Form.Rooted: target = Join(Resolve(new List<string>(), pathPart)); break;
            case Form.Repository: target = Join(Resolve(new List<string>(), pathPart)); break;
            case Form.DrsRelative: target = Join(Resolve(new List<string>(), drsRoot + pathPart)); break;
            default: target = Join(Resolve(Segments(ParentOf(self)), pathPart)); break;
        }
        if (target == null || !target.StartsWith(drsRoot, StringComparison.Ordinal)) { return null; }

        string recordPath = target.Substring(drsRoot.Length);
        bool trailing = pathPart.EndsWith("/", StringComparison.Ordinal);
        (string newRecordPath, string newFragment) = MapTarget(recordPath, fragment, form == Form.InFile);
        // A moved root moves every path under it; an in-file anchor and a path relative to the root keep their form.
        bool rootMoves = newRoot != drsRoot && form != Form.InFile && form != Form.DrsRelative;
        if (newRecordPath == recordPath && newFragment == fragment && !rootMoves) { return null; }

        string slash = trailing ? "/" : string.Empty;
        string newPathPart;
        if (newRecordPath == recordPath && !rootMoves)
        {
            newPathPart = pathPart;
        }
        else
        {
            switch (form)
            {
                case Form.Rooted: newPathPart = "/" + newRoot + newRecordPath + slash; break;
                case Form.Repository: newPathPart = newRoot + newRecordPath + slash; break;
                case Form.DrsRelative: newPathPart = newRecordPath + slash; break;
                default: newPathPart = MarkdownLinkRebaser.RelativeLink(ParentOf(Moved(self)), newRoot + newRecordPath) + slash; break;
            }
        }
        return newFragment == null ? newPathPart : newPathPart + "#" + newFragment;
    }

    // Where a reference points after the maps: a rule anchor follows its rule, a path follows the file and folder map.
    (string Path, string Fragment) MapTarget(string recordPath, string fragment, bool inFile)
    {
        string newPath = MapPath(recordPath);
        if (fragment == null) { return (newPath, null); }
        Match anchor = ruleAnchor.Match(fragment);
        if (!anchor.Success) { return (newPath, fragment); }

        string oldCode = anchor.Groups["code"].Value.ToUpperInvariant();
        string code = MapCode(oldCode);
        if (code == oldCode) { return (newPath, fragment); }
        string oldRecord = RecordOf(oldCode, false);
        string newRecord = RecordOf(code, true);
        if (newRecord != null && newRecord != MapCode(oldRecord ?? string.Empty) && !(inFile && oldRecord != null && !IsFileOf(oldRecord, recordPath)))
        {
            newPath = PathOfCode(newRecord);
        }
        return (newPath, DrsCitationMap.Anchor(code));
    }

    string MapPath(string recordPath)
    {
        string bare = recordPath.TrimEnd('/');
        if (pathMap.TryGetValue(bare, out string mapped)) { return mapped; }
        foreach ((string old, string replacement) in folderMap)
        {
            if (bare == old) { return replacement; }
            if (bare.StartsWith(old + "/", StringComparison.Ordinal)) { return replacement + bare.Substring(old.Length); }
        }
        return bare;
    }

    // A code's new spelling: a rule row first, then the longest moved record code it extends, with the rest of its segments kept.
    string MapCode(string code)
    {
        if (ruleMap.TryGetValue(code, out string moved)) { return moved; }
        string prefix = code;
        while (true)
        {
            if (codeMap.TryGetValue(prefix, out string renamed)) { return renamed + code.Substring(prefix.Length); }
            int dash = prefix.LastIndexOf('-');
            if (dash <= 0) { return code; }
            prefix = prefix.Substring(0, dash);
        }
    }

    // The record a code names or extends: the longest prefix the maps or the index know as a record; null when none does.
    string RecordOf(string code, bool renamed)
    {
        string prefix = code;
        while (true)
        {
            bool known = renamed
                ? newPathByCode.ContainsKey(prefix) || (citations != null && citations.HasCode(prefix) && !citations.IsRule(prefix))
                : oldPathByCode.ContainsKey(prefix) || codeMap.ContainsKey(prefix) || (citations != null && citations.HasCode(prefix) && !citations.IsRule(prefix));
            if (known) { return prefix; }
            int dash = prefix.LastIndexOf('-');
            if (dash <= 0) { return null; }
            prefix = prefix.Substring(0, dash);
        }
    }

    bool IsFileOf(string code, string recordPath)
    {
        if (oldPathByCode.TryGetValue(code, out string oldPath) && oldPath == recordPath) { return true; }
        if (citations != null && citations.PathOf(code) == drsRoot + recordPath) { return true; }
        return codeMap.TryGetValue(code, out string renamed) && newPathByCode.TryGetValue(renamed, out string newPath) && newPath == recordPath;
    }

    string PathOfCode(string code)
    {
        if (newPathByCode.TryGetValue(code, out string path)) { return path; }
        string indexed = citations?.PathOf(code);
        if (indexed != null && indexed.StartsWith(drsRoot, StringComparison.Ordinal)) { return indexed.Substring(drsRoot.Length); }
        throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
            "no record path for '{0}': neither the code map nor the DRS index names it", code));
    }

    void AddCodeRow(Dictionary<string, string> cells)
    {
        string oldCode = cells["old_code"], newCode = cells["new_code"], oldPath = cells["old_path"], newPath = cells["new_path"], kind = cells["kind"];
        if (!CodeMapKinds.Contains(kind)) { throw Invalid("code map", "kind '" + kind + "' is not one of move, path, new, folder, root"); }
        if (kind == "root")
        {
            // A root row's paths are repository-relative: the root itself and where it goes, at the same depth, so a link out of it stays.
            string from = Normalize(oldPath), to = Normalize(newPath);
            if (from + "/" != drsRoot) { throw Invalid("code map", "a root row moves the root '" + drsRoot.TrimEnd('/') + "', not '" + oldPath + "'"); }
            if (newRoot != drsRoot) { throw Invalid("code map", "the root is moved twice"); }
            if (to.Length == 0 || Segments(to).Count != Segments(from).Count)
            {
                throw Invalid("code map", "the root moves to '" + newPath + "', not a folder of its own depth");
            }
            newRoot = to + "/";
            return;
        }
        foreach (string code in new[] { oldCode, newCode })
        {
            if (code != "-" && !codeShape.IsMatch(code)) { throw Invalid("code map", "'" + code + "' is not a code of a registered kind"); }
        }
        if (oldCode != "-")
        {
            if (newCode == "-") { throw Invalid("code map", "'" + oldCode + "' has no new code"); }
            if (codeMap.ContainsKey(oldCode) || oldPathByCode.ContainsKey(oldCode)) { throw Invalid("code map", "'" + oldCode + "' appears twice"); }
            if (oldCode != newCode) { codeMap[oldCode] = newCode; }
            if (oldPath != "-") { oldPathByCode[oldCode] = Normalize(oldPath); }
        }
        if (newCode != "-" && newPath != "-") { newPathByCode[newCode] = Normalize(newPath); }
        if (oldPath != "-" && newPath != "-" && oldPath != newPath)
        {
            pathMap[Normalize(oldPath)] = Normalize(newPath);
            if (kind == "folder") { folderMap.Add((ParentOf(Normalize(oldPath)), ParentOf(Normalize(newPath)))); }
        }
    }

    void AddRuleRow(Dictionary<string, string> cells)
    {
        if (!RuleMapKinds.Contains(cells["kind"])) { throw Invalid("rule map", "kind '" + cells["kind"] + "' is not one of move, collapse"); }
        string old = cells["old_rule"], moved = cells["new_rule"];
        if (!codeShape.IsMatch(old) || !codeShape.IsMatch(moved)) { throw Invalid("rule map", "'" + old + "' -> '" + moved + "' is not a rule code -> a rule code"); }
        if (ruleMap.ContainsKey(old)) { throw Invalid("rule map", "'" + old + "' appears twice"); }
        ruleMap[old] = moved;
    }

    // Where a citing file lands when the root moves: under the new root when it sits under the old one.
    string Moved(string repoPath) =>
        repoPath.StartsWith(drsRoot, StringComparison.Ordinal) ? newRoot + repoPath.Substring(drsRoot.Length) : repoPath;

    // True when the path names a moved folder itself, or a file or folder of it that the tree holds at its old or its new place.
    bool NamesMovedContent(string written)
    {
        string path = written.TrimEnd('/');
        foreach ((string old, string replacement) in folderMap)
        {
            if (path == old) { return true; }
            if (!path.StartsWith(old + "/", StringComparison.Ordinal)) { continue; }
            string moved = replacement + path.Substring(old.Length);
            return recordFiles.Contains(path) || recordFolders.Contains(path) || recordFiles.Contains(moved) || recordFolders.Contains(moved);
        }
        return false;
    }

    bool IsBareFolderPath(string written)
    {
        foreach (string folder in bareFolders)
        {
            if (written.StartsWith(folder + "/", StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    enum Form
    {
        InFile,
        Rooted,
        Repository,
        Relative,
        DrsRelative
    }
}
