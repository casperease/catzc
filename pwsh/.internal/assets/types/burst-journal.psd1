# The one declaration of how a staged burst journals the files its import writes: Invoke-StagedBurst sets the variable
# to its journal folder for the import it runs, and Save-BurstJournalWrite records each write there before it happens.
@{
    Variable  = 'CATZC_BURST_JOURNAL'
    WrittenLog = 'written.json'
    WrittenFolder = 'written'
}
