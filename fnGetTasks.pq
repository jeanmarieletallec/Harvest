let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/tasks?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    tasks = if Record.HasFields(raw, "tasks") then raw[tasks] else {},
    table = Table.FromList(tasks, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "name", "billable_by_default", "default_hourly_rate", "is_default", "is_active", "created_at", "updated_at"}, {"id", "name", "billable_by_default", "default_hourly_rate", "is_default", "is_active", "created_at", "updated_at"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = expanded, NextPage = nextPage]
in
    Source
