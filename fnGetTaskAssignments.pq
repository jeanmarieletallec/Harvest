let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/task_assignments?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    taskAssignments = if Record.HasFields(raw, "task_assignments") then raw[task_assignments] else {},
    table = Table.FromList(taskAssignments, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"}, {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"}),
    projectExpanded = Table.ExpandRecordColumn(expanded, "project", {"id", "name", "code"}, {"project_id", "project_name", "project_code"}),
    taskExpanded = Table.ExpandRecordColumn(projectExpanded, "task", {"id", "name"}, {"task_id", "task_name"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = taskExpanded, NextPage = nextPage]
in
    Source
