let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/clients?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    clients = if Record.HasFields(raw, "clients") then raw[clients] else {},
    table = Table.FromList(clients, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"}, {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = expanded, NextPage = nextPage]
in
    Source
