let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/time_entries?from=20180101&page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    #"Converted to Table" = Record.ToTable(#"Imported JSON"),
    Value = #"Converted to Table"{0}[Value],
    #"Converted to Table1" = Table.FromList(Value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table1", "Column1", {"id", "spent_date", "hours", "notes", "is_locked", "locked_reason", "is_closed", "is_billed", "timer_started_at", "started_time", "ended_time", "is_running", "billable", "budgeted", "billable_rate", "cost_rate", "created_at", "updated_at", "user", "client", "project", "task", "user_assignment", "task_assignment", "invoice", "external_reference"}, {"id", "spent_date", "hours", "notes", "is_locked", "locked_reason", "is_closed", "is_billed", "timer_started_at", "started_time", "ended_time", "is_running", "billable", "budgeted", "billable_rate", "cost_rate", "created_at", "updated_at", "user", "client", "project", "task", "user_assignment", "task_assignment", "invoice", "external_reference"}),
    #"Expanded user" = Table.ExpandRecordColumn(#"Expanded Column1", "user", {"id", "name"}, {"user.id", "user.name"}),
    #"Expanded client" = Table.ExpandRecordColumn(#"Expanded user", "client", {"id", "name", "currency"}, {"client.id", "client.name", "client.currency"}),
    #"Expanded project" = Table.ExpandRecordColumn(#"Expanded client", "project", {"id", "name", "code"}, {"project.id", "project.name", "project.code"}),
    #"Expanded task" = Table.ExpandRecordColumn(#"Expanded project", "task", {"id", "name"}, {"task.id", "task.name"}),
    #"Expanded user_assignment" = Table.ExpandRecordColumn(#"Expanded task", "user_assignment", {"id", "is_project_manager", "is_active", "budget", "created_at", "updated_at", "hourly_rate"}, {"user_assignment.id", "user_assignment.is_project_manager", "user_assignment.is_active", "user_assignment.budget", "user_assignment.created_at", "user_assignment.updated_at", "user_assignment.hourly_rate"})
in
    #"Expanded user_assignment"
in
    Source
