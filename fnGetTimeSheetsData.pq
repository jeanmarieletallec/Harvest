let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/time_entries?from=20180101&page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    entries = if Record.HasFields(raw, "time_entries") then raw[time_entries] else {},
    table = Table.FromList(entries, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "spent_date", "hours", "notes", "is_locked", "locked_reason", "is_closed", "is_billed", "timer_started_at", "started_time", "ended_time", "is_running", "billable", "budgeted", "billable_rate", "cost_rate", "created_at", "updated_at", "user", "client", "project", "task", "user_assignment", "task_assignment", "invoice", "external_reference"}, {"id", "spent_date", "hours", "notes", "is_locked", "locked_reason", "is_closed", "is_billed", "timer_started_at", "started_time", "ended_time", "is_running", "billable", "budgeted", "billable_rate", "cost_rate", "created_at", "updated_at", "user", "client", "project", "task", "user_assignment", "task_assignment", "invoice", "external_reference"}),
    expandedUser = Table.ExpandRecordColumn(expanded, "user", {"id", "name"}, {"user.id", "user.name"}),
    expandedClient = Table.ExpandRecordColumn(expandedUser, "client", {"id", "name", "currency"}, {"client.id", "client.name", "client.currency"}),
    expandedProject = Table.ExpandRecordColumn(expandedClient, "project", {"id", "name", "code"}, {"project.id", "project.name", "project.code"}),
    expandedTask = Table.ExpandRecordColumn(expandedProject, "task", {"id", "name"}, {"task.id", "task.name"}),
    expandedUserAssignment = Table.ExpandRecordColumn(expandedTask, "user_assignment", {"id", "is_project_manager", "is_active", "budget", "created_at", "updated_at", "hourly_rate"}, {"user_assignment.id", "user_assignment.is_project_manager", "user_assignment.is_active", "user_assignment.budget", "user_assignment.created_at", "user_assignment.updated_at", "user_assignment.hourly_rate"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = expandedUserAssignment, NextPage = nextPage]
in
    Source
