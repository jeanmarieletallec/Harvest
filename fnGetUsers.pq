let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/users?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    users = if Record.HasFields(raw, "users") then raw[users] else {},
    table = Table.FromList(users, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "first_name", "last_name", "email", "telephone", "timezone", "weekly_capacity", "has_access_to_all_future_projects", "is_contractor", "is_admin", "is_project_manager", "can_see_rates", "can_create_projects", "can_create_invoices", "is_active", "created_at", "updated_at", "default_hourly_rate", "cost_rate", "roles", "avatar_url"}, {"id", "first_name", "last_name", "email", "telephone", "timezone", "weekly_capacity", "has_access_to_all_future_projects", "is_contractor", "is_admin", "is_project_manager", "can_see_rates", "can_create_projects", "can_create_invoices", "is_active", "created_at", "updated_at", "default_hourly_rate", "cost_rate", "roles", "avatar_url"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = expanded, NextPage = nextPage]
in
    Source
