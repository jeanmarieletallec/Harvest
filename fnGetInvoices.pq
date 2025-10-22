let
    Source = (page as number) as record =>
let
     apiUrl = "https://api.harvestapp.com/api/v2/invoices?page=" & Number.ToText(page),
     options = [Headers =[#"User-Agent"=User_Agent,#"Harvest-Account-ID"=Harvest_Account_ID, #"Authorization"=Authorization]],
     raw = Json.Document(Web.Contents(apiUrl , options),65001),
    invoices = if Record.HasFields(raw, "invoices") then raw[invoices] else {},
    table = Table.FromList(invoices, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    expanded = Table.ExpandRecordColumn(table, "Column1", {"id", "client_key", "number", "purchase_order", "amount", "due_amount", "tax", "tax_amount", "tax2", "tax2_amount", "discount", "discount_amount", "subject", "notes", "state", "period_start", "period_end", "issue_date", "due_date", "payment_term", "sent_at", "paid_at", "closed_at", "created_at", "updated_at", "paid_date", "currency", "client", "estimate", "retainer", "creator", "line_items"}, {"id", "client_key", "number", "purchase_order", "amount", "due_amount", "tax", "tax_amount", "tax2", "tax2_amount", "discount", "discount_amount", "subject", "notes", "state", "period_start", "period_end", "issue_date", "due_date", "payment_term", "sent_at", "paid_at", "closed_at", "created_at", "updated_at", "paid_date", "currency", "client", "estimate", "retainer", "creator", "line_items"}),
    creatorExpanded = Table.ExpandRecordColumn(expanded, "creator", {"id", "name"}, {"creator.id", "creator.name"}),
    nextPage = if Record.HasFields(raw, "next_page") then raw[next_page] else null
in
    [Data = creatorExpanded, NextPage = nextPage]
in
    Source
