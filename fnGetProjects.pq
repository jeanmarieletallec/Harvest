let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/projects?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Projects = #"Imported JSON"[projects],
    #"Converted to Table" = Table.FromList(Projects, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "name", "code", "is_active", "is_billable", "is_fixed_fee", "bill_by", "budget", "budget_by", "notify_when_over_budget", "over_budget_notification_percentage", "show_budget_to_all", "created_at", "updated_at", "starts_on", "ends_on", "over_budget_notification_date", "notes", "cost_budget", "cost_budget_include_expenses", "hourly_rate", "fee", "client"}, {"id", "name", "code", "is_active", "is_billable", "is_fixed_fee", "bill_by", "budget", "budget_by", "notify_when_over_budget", "over_budget_notification_percentage", "show_budget_to_all", "created_at", "updated_at", "starts_on", "ends_on", "over_budget_notification_date", "notes", "cost_budget", "cost_budget_include_expenses", "hourly_rate", "fee", "client"}),
    #"client développé" = Table.ExpandRecordColumn(#"Column1 développé", "client", {"id", "name", "currency"}, {"id.1", "name.1", "currency"})
in
    #"client développé"
in
    Source
