let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/user_assignments?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    userAssignments = if Record.HasFields(raw, "user_assignments") then raw[user_assignments] else {},
    table = Table.FromList(userAssignments, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project", "user"}, {"id", "is_project_manager", "is_active", "use_default_rates", "budget", "created_at", "updated_at", "hourly_rate", "project", "user"}),
    projectExpanded = Table.ExpandRecordColumn(expanded, "project", {"id", "name", "code"}, {"project_id", "project_name", "project_code"}),
    userExpanded = Table.ExpandRecordColumn(projectExpanded, "user", {"id", "name"}, {"user_id", "user_name"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = userExpanded, NextPage = nextPage]
in
    Source
