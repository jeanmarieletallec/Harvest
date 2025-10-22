let
    SafeRequest = (apiUrl as text, options as record, maxAttempts as number) as record =>
    let
        TryFetch = (attempt as number) as record =>
        let
            raw = try Json.Document(Web.Contents(apiUrl, options)) otherwise null
        in
            if raw <> null then raw
            else if attempt >= maxAttempts then error "SafeRequest: failed after attempts"
            else @TryFetch(attempt+1)
    in
        TryFetch(1),

    FetchAllPages = (fetchPage as function) as table =>
    let
        GetAll = (page as number, acc as list) =>
        let
            res = fetchPage(page),
            data = if Record.HasFields(res, "Data") then res[Data] else res,
            acc2 = acc & {data},
            next = if Record.HasFields(res, "NextPage") then res[NextPage] else null
        in
            if next = null then
                if List.Count(acc2) = 0 then #table({}, {}) else Table.Combine(acc2)
            else
                @GetAll(next, acc2)
    in
        GetAll(1, {} )
in
    [SafeRequest = SafeRequest, FetchAllPages = FetchAllPages]
