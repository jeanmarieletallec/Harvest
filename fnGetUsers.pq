let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/users?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
   Users = #"Imported JSON"[users],
    #"Converted to Table" = Table.FromList(Users, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Expanded Column1" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "first_name", "last_name", "email", "telephone", "timezone", "weekly_capacity", "has_access_to_all_future_projects", "is_contractor", "is_admin", "is_project_manager", "can_see_rates", "can_create_projects", "can_create_invoices", "is_active", "created_at", "updated_at", "default_hourly_rate", "cost_rate", "roles", "avatar_url"}, {"id", "first_name", "last_name", "email", "telephone", "timezone", "weekly_capacity", "has_access_to_all_future_projects", "is_contractor", "is_admin", "is_project_manager", "can_see_rates", "can_create_projects", "can_create_invoices", "is_active", "created_at", "updated_at", "default_hourly_rate", "cost_rate", "roles", "avatar_url"})

in
    #"Expanded Column1"
in
    Source
