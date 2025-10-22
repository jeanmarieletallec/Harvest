let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/tasks?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Tasks = #"Imported JSON"[tasks],
    #"Converted to Table" = Table.FromList(Tasks, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "billable_by_default", "default_hourly_rate", "is_default", "is_active", "created_at", "updated_at"}, {"id", "name", "billable_by_default", "default_hourly_rate", "is_default", "is_active", "created_at", "updated_at"})
in
    #"Column1 développé"
in
    Source
