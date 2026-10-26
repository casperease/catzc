/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/MapsLabels.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Maps;

public sealed class MapsLabels
{
    // The prefix of every value-chain map label key.
    public const string ValueChainPrefix = "value_chain_";

    public const string DefaultGridTitle = "World map: tracks × file languages";
    public const string DefaultTreeTitle = "World map: repository tree";
    public const string DefaultRowAxis = "Track";
    public const string DefaultColumnAxis = "File language";
    public const string DefaultRootFiles = "Root files";
    public const string DefaultUnlistedFiles = "Unlisted files";
    public const string DefaultLegendFiles = "Cell: files";
    public const string DefaultLegendViolation = "Stack violation";
    public const string DefaultLegendHighlight = "Lit cell";
    public const string DefaultValueChainTitle = "Value-chain map: value-chain stack × value-chain concerns";
    public const string DefaultValueChainRowAxis = "Value-chain stack";
    public const string DefaultValueChainColumnAxis = "Value-chain concern";
    public const string DefaultValueChainLegendAdrs = "Cell: ADRs";
    public const string DefaultValueChainLegendHighlight = "Lit cell";

    // The title of the grid view (world-map.grid.pdf). Default: DefaultGridTitle.
    public string grid_title { get; }

    // The title of the tree view (world-map.tree.pdf). Default: DefaultTreeTitle.
    public string tree_title { get; }

    // The header of the row axis (the tracks). Default: DefaultRowAxis.
    public string row_axis { get; }

    // The header of the column axis (the file languages). Default: DefaultColumnAxis.
    public string column_axis { get; }

    // The header of the row of the root files, the files no track holds. Default: DefaultRootFiles.
    public string root_files { get; }

    // The header of the column of the unlisted files, the files no file language names. Default: DefaultUnlistedFiles.
    public string unlisted_files { get; }

    // The legend entry of the file-count scale. Default: DefaultLegendFiles.
    public string legend_files { get; }

    // The legend entry of the stack-violation mark. Default: DefaultLegendViolation.
    public string legend_violation { get; }

    // The legend entry of a lit cell's outline. Default: DefaultLegendHighlight.
    public string legend_highlight { get; }

    // The title of the value-chain map. Default: DefaultValueChainTitle.
    public string value_chain_title { get; }

    // The header of the value-chain map's row axis (the rows of the value-chain stack). Default: DefaultValueChainRowAxis.
    public string value_chain_row_axis { get; }

    // The header of the value-chain map's column axis (the value-chain concerns). Default: DefaultValueChainColumnAxis.
    public string value_chain_column_axis { get; }

    // The legend entry of the value-chain map's ADR-count scale. Default: DefaultValueChainLegendAdrs.
    public string value_chain_legend_adrs { get; }

    // The legend entry of a lit value-chain map cell. Default: DefaultValueChainLegendHighlight.
    public string value_chain_legend_highlight { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsLabels(string gridTitle, string treeTitle, string rowAxis, string columnAxis, string rootFiles, string unlistedFiles,
        string legendFiles, string legendViolation, string legendHighlight, string valueChainTitle, string valueChainRowAxis,
        string valueChainColumnAxis, string valueChainLegendAdrs, string valueChainLegendHighlight)
    {
        grid_title = gridTitle;
        tree_title = treeTitle;
        row_axis = rowAxis;
        column_axis = columnAxis;
        root_files = rootFiles;
        unlisted_files = unlistedFiles;
        legend_files = legendFiles;
        legend_violation = legendViolation;
        legend_highlight = legendHighlight;
        value_chain_title = valueChainTitle;
        value_chain_row_axis = valueChainRowAxis;
        value_chain_column_axis = valueChainColumnAxis;
        value_chain_legend_adrs = valueChainLegendAdrs;
        value_chain_legend_highlight = valueChainLegendHighlight;
    }
}
