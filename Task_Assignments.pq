let
    AddFunctionCall=List.Generate(()=>[Page Number=0,Func=null], each (try _[Func])[HasError]=false, each [Page Number=_[Page Number]+1, Func=fnGetTaskAssignments([Page Number]+1)], each _[Func]),
    #"Converted to Table" = Table.FromList(AddFunctionCall, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Column1 développé" = Table.ExpandTableColumn(#"Converted to Table", "Column1", {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"}, {"id", "billable", "is_active", "created_at", "updated_at", "hourly_rate", "budget", "project", "task"}),
    #"Lignes filtrées" = Table.SelectRows(#"Column1 développé", each [id] <> null and [id] <> ""),
    #"project développé" = Table.ExpandRecordColumn(#"Lignes filtrées", "project", {"id", "name", "code"}, {"project.id", "project.name", "project.code"}),
    #"Colonnes renommées" = Table.RenameColumns(#"project développé",{{"project.id", "project_id"}, {"project.name", "project_name"}, {"project.code", "project_code"}}),
    #"task développé" = Table.ExpandRecordColumn(#"Colonnes renommées", "task", {"id", "name"}, {"task.id", "task.name"}),
    #"Colonnes renommées1" = Table.RenameColumns(#"task développé",{{"task.id", "task_id"}, {"task.name", "task_name"}}),
    #"Type modifié" = Table.TransformColumnTypes(#"Colonnes renommées1",{{"task_name", type text}, {"task_id", Int64.Type}, {"project_code", type text}, {"project_name", type text}, {"project_id", type text}, {"budget", type number}, {"hourly_rate", type number}, {"updated_at", type datetime}, {"created_at", type datetime}, {"is_active", type logical}, {"billable", type logical}, {"id", Int64.Type}})
in
    #"Type modifié"
