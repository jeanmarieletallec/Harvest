let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/clients?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Clients = #"Imported JSON"[clients],
    #"Converted to Table" = Table.FromList(Clients, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"}, {"id", "name", "is_active", "address", "created_at", "updated_at", "currency"})
in
    #"Column1 développé"
in
    Source
