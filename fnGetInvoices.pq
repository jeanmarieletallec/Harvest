let
    Source = (page as number) as table =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/invoices?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     result = Web.Contents(apiUrl , options),
    #"Imported JSON" = Json.Document(result,65001),
    Invoices = #"Imported JSON"[invoices],
    #"Converted to Table" = Table.FromList(Invoices, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandRecordColumn(#"Converted to Table", "Column1", {"id", "client_key", "number", "purchase_order", "amount", "due_amount", "tax", "tax_amount", "tax2", "tax2_amount", "discount", "discount_amount", "subject", "notes", "state", "period_start", "period_end", "issue_date", "due_date", "payment_term", "sent_at", "paid_at", "closed_at", "created_at", "updated_at", "paid_date", "currency", "client", "estimate", "retainer", "creator", "line_items"}, {"id", "client_key", "number", "purchase_order", "amount", "due_amount", "tax", "tax_amount", "tax2", "tax2_amount", "discount", "discount_amount", "subject", "notes", "state", "period_start", "period_end", "issue_date", "due_date", "payment_term", "sent_at", "paid_at", "closed_at", "created_at", "updated_at", "paid_date", "currency", "client", "estimate", "retainer", "creator", "line_items"}),
    #"creator développé" = Table.ExpandRecordColumn(#"Column1 développé", "creator", {"id", "name"}, {"id.1", "name"})
in
    #"creator développé"
in
    Source
