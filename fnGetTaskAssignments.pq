let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/task_assignments?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    #"Converti en table" = Record.ToTable(#"Imported JSON"),
    Value = #"Converti en table"{0}[Value],
    #"Converti en table1" = Table.FromList(Value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Colonnes renommées" = Table.RenameColumns(#"Converti en table1",{{"Column1", "Task_assignments"}}),
    #"Task_assignments développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "Task_assignments", {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"}, {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"})
in
    #"Task_assignments développé"
in
    Source
