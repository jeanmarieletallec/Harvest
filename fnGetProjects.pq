let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/projects?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    projects = if Record.HasFields(raw, "projects") then raw[projects] else {},
    table = Table.FromList(projects, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "name", "code", "is_active", "is_billable", "is_fixed_fee", "bill_by", "budget", "budget_by", "notify_when_over_budget", "over_budget_notification_percentage", "show_budget_to_all", "created_at", "updated_at", "starts_on", "ends_on", "over_budget_notification_date", "notes", "cost_budget", "cost_budget_include_expenses", "hourly_rate", "fee", "client"}, {"id", "name", "code", "is_active", "is_billable", "is_fixed_fee", "bill_by", "budget", "budget_by", "notify_when_over_budget", "over_budget_notification_percentage", "show_budget_to_all", "created_at", "updated_at", "starts_on", "ends_on", "over_budget_notification_date", "notes", "cost_budget", "cost_budget_include_expenses", "hourly_rate", "fee", "client"}),
    clientExpanded = Table.ExpandRecordColumn(expanded, "client", {"id", "name", "currency"}, {"Client_id", "Client_name", "currency"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = clientExpanded, NextPage = nextPage]
in
    Source
