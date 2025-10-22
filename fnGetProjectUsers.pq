let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/user_assignments?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    #"Converti en table" = Record.ToTable(#"Imported JSON"),
    Value = #"Converti en table"{0}[Value],
    #"Converti en table1" = Table.FromList(Value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converti en table1", "Column1", {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project", "user"}, {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project", "user"}),
    #"project développé" = Table.ExpandRecordColumn(#"Column1 développé", "project", {"id", "name", "code"}, {"project_id", "project_name", "project_code"}),
    #"user développé" = Table.ExpandRecordColumn(#"project développé", "user", {"id", "name"}, {"user_id", "user_name"})
in
    #"user développé"
in
    Source
