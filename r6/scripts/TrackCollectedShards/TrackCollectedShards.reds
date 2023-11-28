@addMethod(gameLootContainerBase)
private final func GetShardData(itemTDBID: TweakDBID) -> wref<JournalOnscreen> {
  let itemRecord: ref<Item_Record> = TweakDBInterface.GetItemRecord(itemTDBID);

  if !IsDefined(itemRecord) {
    return null;
  };

  if itemRecord.TagsContains(n"Shard") {
    let journalPath = TweakDBInterface.GetString(itemRecord.ItemSecondaryAction().GetID() + t".journalEntry", "");
    return GameInstance.GetJournalManager(this.GetGame()).GetEntryByString(journalPath, "gameJournalOnscreen") as JournalOnscreen;
  };
  
  return null;
}
