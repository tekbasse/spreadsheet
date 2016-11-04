ad_library {

    API for the qss_TIPS api
    @creation-date 12 Oct 2016
    @cs-id $Id:
}

ad_proc -private qss_tips_user_id_set {
} {
    Sets user_id in calling environment, 
    @return user_id, or 0 if not a logged in user, or -1 if not called via connected session.
} {
    upvar 1 user_id user_id
    if { [ns_conn isconnected] } {
        set user_id [ad_conn user_id]
    } else {
        set user_id -1
    }
    return 1
}    

ad_proc -public qss_tips_field_id_name_list {
    table_id
} {
    Returns a name value list of field names and field ids.
} {
    upvar 1 instance_id instance_id
    set id_name_list [list ]
    if {[qf_is_natural_number $table_id ]} {
        set fields_lists [db_list_of_lists qss_tips_field_defs_id_name_r {select id,name from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}]
        foreach row $fields_lsits {
            foreach {id name} {
                lappend id_name_list $id $name
            }
        }
    }
    return $id_name_list
}

ad_proc -public qss_tips_field_label_name_list {
    table_id
} {
    Returns a name value list of field names and field labels.
} {
    upvar 1 instance_id instance_id
    set label_name_list [list ]
    if {[qf_is_natural_number $table_id ]} {
        set fields_lists [db_list_of_lists qss_tips_field_defs_label_name_r {select label,name from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}]
        foreach row $fields_lsits {
            foreach {label name} {
                lappend label_name_list $label $name
            }
        }
    }
    return label_name_list
}


ad_proc -private qss_tips_field_defs_maps_set {
    table_id
    {field_type_of_label_array_name ""}
    {field_id_of_label_array_name ""}
    {field_type_of_id_array_name ""}
    {field_label_of_id_array_name ""}
    {field_ids_list_name ""}
    {field_labels_list_name ""}
    {filter_by_label_list ""}
} {
    Returns count of fields returned.
    If filter_by_label_list is nonempty, scopes to return info on only field definitions in filter_by_label_list.

    If field_type_of_label_array_name is nonempty, returns an array in calling environment
    of that name in the form field_type_of(label) for example.

    If field_id_of_label_array_name is nonempty, returns an array in calling environment
    of that name in the form field_id_of(label) for example.

    If field_type_of_id_array_name is nonempty, returns an array in calling environment
    of that name in the form field_type_of(id) for example.

    If field_label_of_id_array_name is nonempty, returns an array in calling environment
    of that name in the form field_label_of(id) for example.

    If field_labels_list_name is nonempty, returns a list of field labels in calling environment.

    If field_ids_list_name is nonempty, returns a list of field ids in calling environment.
} {
    set fields_lists [qss_tips_field_def_read $table_id $field_labels]
    set field_labels_list [list ]
    set field_ids_list [list ]
    set set_field_type_label_arr_p 0
    if { [regsub -all -nocase -- {[^a-z0-9\_]+} $field_type_of_label_array_name {} field_type_label_arr_nam ] } {
        upvar $field_type_label_arr_nam field_type_label_arr
        set set_field_type_label_arr_p 1
    }         
    set set_field_id_label_arr_p 0
    if { [regsub -all -nocase -- {[^a-z0-9\_]+} $field_id_of_label_array_name {} field_id_label_arr_nam ] } {
        upvar $field_id_label_arr_nam field_id_label_arr
        set set_field_id_label_arr_p 1
    }
    set set_field_type_id_arr_p 0
    if { [regsub -all -nocase -- {[^a-z0-9\_]+} $field_type_of_id_array_name {} field_type_id_arr_nam ] } {
        upvar $field_type_id_arr_nam field_type_id_arr
        set set_field_type_id_arr_p 1
    }         
    set set_field_label_id_arr_p 0
    if { [regsub -all -nocase -- {[^a-z0-9\_]+} $field_label_of_id_array_name {} field_label_id_arr_nam ] } {
        upvar $field_label_id_arr_nam field_label_id_arr
        set set_field_label_id_arr_p 1
    }
    if { [llength $fields_lists ] > 0 } {
        foreach field_list $field_lists {
            foreach {field_id label name def_val tdt_type field_type} $fields_list {
                lappend field_labels_list $label
                lappend field_ids_list $field_id
                lappend field_label_type_list $label $field_type
                lappend field_label_id_list $label $field_id
                lappend field_id_label_list $field_id $label
                lappend field_id_type_list $field_id $field_type
            }
        }
        if { $set_field_type_label_arr_p } {
            array set $field_type_label_arr_nam $field_label_type_list
        }
        if { $set_field_id_label_arr_p } {
            array set $field_id_label_arr_nam $field_label_id_list
        }
        if { $set_field_type_id_arr_p } {
            array set $field_type_id_arr_nam $field_id_type_list
        }
        if { $set_field_label_id_arr_p } {
            array set $field_label_id_arr_nam $field_id_label_list
        }
    }
    set count [llength $field_labels_list]
    return $count
}

ad_proc -public qss_tips_table_id_of_label {
    table_label
} { 
    Returns table_id of table_name, or empty string if not found.
} {
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_id ""
    db_0or1_row qss_tips_table_defs_r_name {select id as table_id from qss_tips_table_defs
        where label=:table_name
        and instance_id=:instance_id}
    return $table_id
}

ad_proc -private qss_tips_table_id_exists_q {
    table_id
    {trashed_p "0"}
} {
    Returns 1 if table_id exists.
    Defaults to only check untrashed tables (trashed_p is 0). Set trashed_p to 1 to check all cases.
} {
    upvar 1 instance_id instance_id
    if { ![qf_is_true $trashed_p ] } {
        set exists_p [db_0or1row qss_tips_trashed_table_id_exists {
            select id from qss_tips_table_defs 
            where id=:table_id 
            and instance_id=:instance_id
        } ]
    } else {
        set exists_p [db_0or1row qss_tips_untrashed_table_id_exists {
            select id from qss_tips_table_defs 
            where id=:table_id
            and instance_id=:instance_id
            and trashed_p!='1'
        } ]
    }
    return $exists_p
}

ad_proc -private qss_tips_row_id_exists_q {
    row_id
    table_id
    {trashed_p "0"}
} {
    Returns 1 if row_id of table_id exists.
    Defaults to only check untrashed tables (trashed_p is 0). 
    Set trashed_p to 1 to check all cases.
} {
    upvar 1 instance_id instance_id
    if { ![qf_is_true $trashed_p ] } {
        set exists_p [db_0or1row qss_tips_trashed_row_id_exists {
            select id from qss_tips_table_field_values
            where row_id=:row_id
            and table_id=:table_id
            and instance_id=:instance_id } ]
    } else {
        set exists_p [db_0or1row qss_tips_untrashed_row_id_exists {
            select id from qss_tips_table_field_values
            where row_id=:row_id
            and table_id=:table_id
            and instance_id=:instance_id
            and trashed_p!='1' } ]
    }
    return $exists_p
}

ad_proc -public qss_tips_table_def_read {
    table_label
} { 
    Returns list of table_id, label, name, flags, trashed_p or empty list if not found.
} {
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_list [list ]
    set exists_p [db_0or1_row qss_tips_table_defs_r1 {select id,label,name,flags,trashed_p from qss_tips_table_defs
        where label=:table_label
        and instance_id=:instance_id}]
    if { $exists_p } {
        set table_list [list $id $label $name $flags $trashed_p]
    }
    return $table_list
}


ad_proc -public qss_tips_table_def_create {
    label
    name
    {flags ""}
} {
    Defines a tips table. Label is a short reference with no spaces.
    Name is usually a title for display and has spaces.
    @return id if successful, otherwise returns empty string.
} {
    upvar 1 instance_id instance_id
    
    # fields may not be defined at the same time the table is
    # new fields may be applied to existing tables, 
    # resulting in fields with no (empty) values.
    # New columns start with empty values.
    # This should also help when importing data. A new column could be temporarily added,
    # then removed after data has been integrated into other columns for example.
    # 
    # sql doesn't have to create an empty data.
    # When reading, assume column is empty, unless data exists -- consistent with simple_tables
    set id ""
    qss_table_user_id_set
    if { [hf_are_printable_characters_q $label] && [hf_are_visible_characters_q $title] } {
        set existing_id [qss_tips_table_id_of_label $label]
        if { $existing_id eq "" } {
            set id [db_nextval qss_tips_id_seq]
            set flags ""
            set trashed_p "0"
            db_dml qss_tips_table_cre {
                insert into qss_tips_table_defs 
                (instance_id,id,label,name,flags,user_id,created,trashed_p)
                values (:instance_id,:id,:label,:name,:flags,:user_id,now(),:trashed_p)                   
            }
        }
    }
    return $id
}


ad_proc -public qss_tips_table_def_update {
    table_id
    args
} {
    Updates a table definition for table_id. 
    @return 1 if successful, otherwise 0.
} {
    set exists_p [db_0or1row qss_tips_table_def_ur {
        select label,name,flags from qss_tips_table_defs 
        where instance_id=:instance_id 
        and id=:table_id
        and trashed_p!='1'}]
    if { $exists_p } {
        # Allow args to be passed as a list or separate parameters
        set args_list [list ]
        set arg1 [lindex $args 0]
        if { [llength $arg1] > 1 } {
            set args_list $arg1
        }
        set args_list [concat $args_list $args]
        
        set field_list [list label name flags]
        set changed_p 0
        foreach {arg val} $args_list {
            if { $arg in $field_list } {
                set changed_p 1
                set $arg $val
            }
        }
        if { $changed_p } {
            qss_table_user_id_set
            db_transaction {
                # trash record
                qss_tips_table_def_trash $table_id
                # create new
                set trashed_p 0
                db_dml tips_table_def_log_rev {
                    insert into qss_tips_table_defs 
                    (instance_id,id,label,name,flags,user_id,created,trashed_p)
                    values (:instance_id,:table_id,:label,:name,:flags,:ouser_id,now(),:trashed_p) 
                }
            }
        }
    }
    return $exists_p
}

ad_proc -public qss_tips_table_def_trash {
    table_id
} {
    Trashes a tips table by table_id.
    @return 1 if success, otherwise return 0.
} {
    upvar 1 instance_id instance_id
    qss_tips_user_id_set
    set success_p [qss_tips_table_id_exists_q $table_id]
    if { $success_p } {
        [db_dml qss_tips_table_trash {
            update qss_tips_table_defs 
            set trashed_p='1'
            and trashed_by=:user_id
            and trashed_dt=now()
            where id=:table_id
            and instance_id=:instance_id
        } ]
    }
    return $success_p
}


ad_proc -public qss_tips_table_read_as_array {
    name_array
    table_label
    {vc1k_search_label_val_list ""}
    {row_id_list ""}
} {
    Returns one or more records of table_label as an array
    where field value pairs in vc1k_search_label_val_list match query.
    array indexes are name_array(row_id,field_label)
    where row_id are in a list in name_array(row_ids)
    Returns only untrashed rows and cells.
    If row_id_list contains row_ids, only returns ids that are supplied in row_id_list.
} {
    # Returns an array instead of list of lists in order to avoid sorting row_ids.
    # And because maybe not every field is defined in every row.

    # Trashed_p = 1 doesn't make sense, because row_id and field_id are same ref..
    # trashed_p only makes sense if calling up history of a single cell, row, or table.. by activity.
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_id [qss_tips_table_id_of_name $table_label]
    set success_p 0

    if { [qf_is_natural_number $table_id] } {
        set count [qss_tips_field_defs_maps_set $table_id "" field_id_arr type_arr label_arr ]
        if { $count > 0 } {
            set row_ids_sql ""
            if { $row_id_list ne "" } {
                # filter to row_id_list
                if { [hf_natural_number_list_validate $row_id_list] } {
                    set row_ids_sql "and row_id in ([template::util::tcl_to_sql_list $row_id_list])"
                } else {
                    ns_log Warning "qss_tips_read.31: One or more row_id are not a natural number '${row_id_list}'"
                    set row_ids_sql "na"
                }
            }
            set vc1k_search_sql ""
            if { $vc1k_search_label_val ne "" } {
                # search scope
                foreach {label vc1k_search_val} $vc1k_search_label_val_list {
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        set field_id $field_id_arr(${label})
                        append vk1k_search_sql " and (field_id='${field_id}' and f_vc1k='${vc1k_search_val}')"
                    } else {
                        ns_log Warning "qss_tips_read.37: no field_id for search label '${label}' table_label '${table_label}' "
                        set vc1k_search_sql "na"
                    }
                }
            }

            if { $row_ids_sql eq "na" || $vc1k_search_sql eq "na" } {
                set n_arr(row_ids) [list ]
            } else {
                set values_lists [db_list_of_lists qss_tips_field_values_r "select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
        where table_id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1' ${vc1k_search_sql} ${row_ids_sql}"]
                
                # val_i = values initial
                set row_ids_list [list ]
                foreach cell_list $values_lists {
                    foreach {row_id field_id f_vc1k f_nbr f_txt} $cell_list {
                        lappend row_ids_list $row_id
                        # since only one case of field value should be nonempty,
                        # following logic could be sped up using qal_first_nonempty_in_list
                        if { [info exists type_arr(${field_id}) ] } {
                            set v [qss_tips_value_of_field_type $field_type f_nbr f_txt f_vc1k]
                        } else {
                            ns_log Warning "qss_tips_read.54: field_id does not have a field_type. table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                        }
                        set label $label_arr(${field_id})
                        set n_arr(${label},${row_id}) $v
                    }
                }
                set n_arr(row_ids) [lsort -unqiue -integer $row_ids_list]
                if { [llength $values_lists] > 0 } {
                    set success_p 1
                }
            }
        }
    }
    return $success_p
}

ad_proc -public qss_tips_table_read {
    table_label
    {vc1k_search_label_val_list ""}
    {row_id_list ""}
} {
    Returns one or more records of table_label as a list of lists
    where field value pairs in vc1k_search_label_val_list match query.
    Returns only untrashed cells and rows.
    If row_id_list contains row_ids, only returns ids that are supplied in row_id_list.
} {
    # Returns an array instead of list of lists in order to avoid sorting row_ids.
    upvar 1 instance_id instance_id
    set table_id [qss_tips_table_id_of_name $table_label]
    set success_p 0
    set table_lists [list ]
    if { [qf_is_natural_number $table_id] } {
        set label_ids_list_len [qss_tips_field_defs_maps_set $table_id "" field_id_arr type_arr label_arr label_ids_list titles_list]
        if { $label_ids_list_len > 0 } {
            lappend table_lists $titles_list

            set row_ids_sql ""
            if { $row_id_list ne "" } {
                # filter to row_id_list
                if { [hf_natural_number_list_validate $row_id_list] } {
                    set row_ids_sql "and row_id in ([template::util::tcl_to_sql_list $row_id_list])"
                } else {
                    ns_log Warning "qss_tips_read.31: One or more row_id are not a natural number '${row_id_list}'"
                    set row_ids_sql "na"
                }
            }
            set vc1k_search_sql ""
            if { $vc1k_search_label_val ne "" } {
                # search scope
                foreach {label vc1k_search_val} $vc1k_search_label_val_list {
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        set field_id $field_id_arr(${label})
                        append vk1k_search_sql " and (field_id='${field_id}' and f_vc1k='${vc1k_search_val}')"
                    } else {
                        ns_log Warning "qss_tips_read.37: no field_id for search label '${label}' table_label '${table_label}' "
                        set vc1k_search_sql "na"
                    }
                }
            }

            if { $row_ids_sql eq "na" || $vc1k_search_sql eq "na" } {
                # do nothing
            } else {
                set values_lists [db_list_of_lists qss_tips_field_values_r_sorted "select row_id, field_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
        where table_id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1' ${vc1k_search_sql} ${row_ids_sql} order by row_id, field_id asc"]
                
                set current_cell_list [lindex $values_lists 0]
                set current_row_id [lindex $current_cell_list 0]
                set current_field_id [lindex $current_cell_list 0]
                set row_list [list ]
                set f_idx 0
                foreach cell_list $values_lists {
                    foreach {row_id field_id f_vc1k f_nbr f_txt} $cell_list {
                        if { $row_id ne $current_row_id } {
                            lappend table_lists $row_list
                            set row_list [list ]
                            set current_row_id $row_id
                            set f_idx 0
                            set current_field_id [lindex $label_ids_list $f_idx]
                        }
                        while { $field_id > $current_field_id && $f_idx < $label_ids_list_len } {
                            lappend row_list ""
                            incr f_idx
                            set current_field_id [lindex $label_ids_list $f_idx]
                        }
                        if { [info exists type_arr(${field_id}) ] } {
                            set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                        } else {
                            ns_log Warning "qss_tips_read.54: field_id does not have a field_type. table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                        }
                        # label $label_arr(${field_id})
                        # v is value
                        lappend row_list $v
                    }
                }
                if { [llength $row_list] > 0 } {
                    lappend table_lists $row_list
                }
            }
        }
    }
    return $table_lists
}



ad_proc -public qss_tips_field_def_create {
    args
} {
    Adds a field to an existing table. 
    Each field is a column in a table.
    args is passed in name value pairs. 
    Requires table_label or table_id and field: label name tdt_data_type field_type.
    default_val is empty string unless supplied.
} {
    upvar 1 instance_id instance_id
    qss_tips_user_id_set

    # Allow args to be passed as a list or separate parameters
    set args_list [list ]
    set arg1 [lindex $args 0]
    if { [llength $arg1] > 1 } {
        set args_list $arg1
    }
    set args_list [concat $args_list $args]
    # req = required
    set req_list [list label name tdt_data_type field_type]
    set opt_list [list default_val]
    set xor_list [list table_id table_label]
    set all_list [concat $req_list $opt_list $xor_list]
    set name_list [list ]

    # optional values have defaults
    set default_val ""

    foreach {nam val} $args_list {
        if { $nam in $all_list } {
            set $nam $val
            lappend name_list $nam
        }
    }
    set success_p 1
    foreach nam $req_list {
        if { $nam ni $name_list } {
            set success_p 0
        }
    }
    if { $success_p && ( $table_id ni $name_list && $table_label ni $name_list ) } {
        set success_p 0
    }
    if { $success_p } {
        # since optional values have defaults, no need to customize sql
        if { ![info exists table_id] } {
            set table_id [qss_tips_table_id_of_label $table_label]
        }
        set trashed_p 0
        if { [qf_is_natural_number $table_id] } {
            db_dml qss_tips_field_def_cr {insert into qss_tips_field_defs
                (instance_id,id,table_id,created,user_id,label,name,default_val,tdt_data_type,field_type,trashed_p)
                values (:instance_id,:id,:table_id,now(),:user_id,:label,:name,:default_val,:tdt_data_type,:field_type,:trashed_p)
            }
        } else {
            set success_p 0
        }
    }
    return $success_p
}


ad_proc -public qss_tips_field_def_trash {
    field_ids
    {table_id ""}
} {
    Trashes one or more fields. 
    Each field is a column in a table. 
    Accepts list or scalar value.
    If table_id is supplied, scopes to table_id.

    @return 1 if all cases are success,  otherwise returns 0.
} {
    upvar 1 instance_id instance_id
    qss_tips_user_id_set
    set field_ids_list [qf_listify $field_ids]
    set success_p_tot 1
    foreach field_id $field_ids_list {
        set success_p [qss_tips_field_id_exists_q $field_id $table_id]
        set success_p_tot [expr { $success_p && $success_p_tot } ]
        if { $success_p } {
            [db_dml qss_tips_field_trash_def {
                update qss_tips_field_defs 
                set trashed_p='1'
                and trashed_by=:user_id
                and trashed_dt=now()
                where id=:field_id
                and instance_id=:instance_id
            } ]
        }
    }
    return $success_p
}

ad_proc -public qss_tips_field_def_update {
    table_id
    args
} {
    Given table_id and field_id or field_label, updates label and/or name.
    args can be passed as list or list of args in name value pairs.
    Acceptable names are field_id or field_label for referencing field;
    and name_new and/or label_new for setting new values for these.
    @return 1 if successful, otherwise return 0.
} {
    upvar 1 instance_id instance_id
    set success_p 0

    # Allow args to be passed as a list or separate parameters
    set args_list [list ]
    set arg1 [lindex $args 0]
    if { [llength $arg1] > 1 } {
        set args_list $arg1
    }
    set args_list [concat $args_list $args]

    set includes_ref_p 0
    set includes_set_p 0
    set names_list [list field_id field_label name_new label_new]
    set ref_list [list field_id field_label]
    foreach {n v} $args_list {
        if { $n in $names_list } {
            set $n $v
            if { $n in $ref_list } {
                set includes_ref_p 1
            } else {
                set includes_set_p 1
            }
        }
    }
    if { $includes_ref_p && $includes_set_p } {

        if { [info exists field_id] } {
            set extra_ref_sql "and id=:field_id"
        } elseif { [info exists field_label] } {
            set extra_ref_sql "and label=:field_label"
        }

        
        set exists_p [db_0or1row qss_tips_field_def_r_u1 "select id as field_id,label,name,default_val,tdt_data_type,field_type,created as c_date,user_id as c_user_id from qss_tips_field_defs
        where instance_id=:instance_id
        and table_id=:table_id
        and trashed_p!='1' ${extra_ref_sql}" ]
        if { $exists_p } {
            qss_table_user_id_set
            if { ![info exists name_new] } {
                set name_new $name
            }
            if { ![info exists label_new] } {
                set label_new $label
            }
            set trashed_p 0
            db_transaction {
                db_dml qss_tips_field_def_u1 { update qss_tips_field_def 
                    set trashed_p='1'
                    trashed_by=:user_id
                    where id=:field_id 
                    and instance_id=:instance_id 
                    and table_id=:table_id }
                db_dml qss_tips_field_def_u1_cr {
                    {instance_id,table_id,id,label,name,flags,user_id,created,trashed_p,default_val,tdt_data_type,field_type}
                    values (:instance_id,:table_id,:field_id,:label_new,:name_new,:flags,:user_id,now(),:trashed_p,:default_val,:tdt_data_type,:field_type)
                }
            }
            set success_p 1
        }
    }
    return $success_p
}


ad_proc -private qss_tips_field_def_read {
    table_id
    {field_labels ""}
    {field_ids ""}
} { 
    Reads definitions about fields in a table.
    Returns list of lists, where colums are field_id,label,name,default_val,tdt_data_type,field_type or empty list if not found.
    If field_labels or field_ids is nonempty (list or scalar), scopes to just these.
} {
    upvar 1 instance_id instance_id
    set fields_lists [list ]
    if {[qf_is_natural_number $table_id ]} {
        set fields_lists [db_list_of_lists qss_tips_field_defs_r {select id as field_id,label,name,default_val,tdt_data_type,field_type from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}]
        # allow glob with field_labels
        set field_label_list [qf_listify $field_labels]
        set field_label_list_len [llength $field_label_list]
        if { $field_label_list_len > 0 } {
            # create a searchable list
            set label_search_list [list ]
            foreach field_list $field_lists {
                lappend label_search_list [lindex $field_list 1]
            }
            set field_label_idx_list [list ]
            foreach field_label $field_label_list {
                set indexes [lsearch -all -glob $label_search_list $field_label]
                set field_label_idx_list [concat $field_label_idx_list $indexes]
            }
            
        }        
        
        set field_id_list [qf_listify $field_ids]
        set field_id_list_len [llength $field_id_list]
        if { $field_id_list_len > 0 } {
            # create a searchable list
            set id_search_list [list ]
            foreach field_list $field_lists {
                lappend id_search_list [lindex $field_list 1]
            }
            set field_id_idx_list [list ]
            foreach id $field_id_list {
                set indexes [lsearch -exact -integer $id_search_list $id]
                set field_id_idx_list [concat $field_id_idx_list $indexes]
            }
        }
        
        if { $field_id_list_len > 0 || $field_label_list_len > 0 } {
            set field_idx_list [concat $field_id_idx_list $field_label_idx_list]
            # remove duplicates
            set field_idx_list [lsort -unique $field_idx_list]
            # scope fields_lists to just the filtered ones
            set filtered_lists [list ]
            foreach fid $field_idx_list {
                lappend filtered_lists [lindex $fields_lists $fid]
            }
            set fields_lists $filtered_lists
        }
    }
    return $fields_lists
}



ad_proc -public qss_tips_row_create {
    label_value_list
    table_id
} {
    Writes a record into table_label. Returns row_id if successful, otherwise empty string.
    Missing field labels are left blank.
} {
    upvar 1 instance_id instance_id
    set new_id ""
    if { [qf_is_natural_number $table_id] } {
        set count [qss_tips_field_defs_maps_set $table_id t_arr l_arr "" "" "" field_labels_list]
        if { $count > 0 } {
            qss_tips_user_id_set
            set new_id [db_nextval qss_tips_id_seq]
            db_transaction {
                foreach {label value} $label_value_list {
                    # if field value is blank, skip..
                    if { $label in $field_labels_list && $value ne "" } {
                        set field_id $l_arr(${label})
                        set field_type $t_arr(${label})
                        qss_tips_set_by_field_type $field_type $value f_nbr f_txt f_vc1k
                        db_dml qss_tips_field_values_row_cr_1f { insert into qss_tips_field_values
                            (instance_id,table_id,row_id,trashed_p,created,user_id,field_id,f_vc1k,f_nbr,f_txt)
                            values (:instance_id,:table_id,:new_id,:trashed_p,now(),:user_id,:field_id,:f_vc1k,:f_nbr,:f_txt)
                        }
                    }
                }
            }
        }
    }
    return $new_id
}

ad_proc -private qss_tips_value_of_field_type {
    field_type
    f_nbr
    f_txt
    f_vc1k
} {
    Returns value based on field_type
} {
    switch -exact -- $type_arr(${field_id}) {
        vc1k { set v $f_vc1k }
        nbr  { set v $f_nbr }
        txt  { set v $f_txt }
        default {
            set v [qal_first_nonempty_in_list [list $f_nbr $f_vc1k $f_txt]]
            ns_log Warning "qss_tips_value_of_field_type.843: unknown field_type '${field_type}'. choosing first nonempty value: '${v}'"
        }
    }
    return $v
}

ad_proc -private qss_tips_set_by_field_type {
    field_type
    value
    nbr_var_name
    txt_var_name
    vc1k_var_name
} {
    Sets value to appropriate variable based on field_type. Others are set to empty string.
} {
    upvar 1 $nbr_var_name f_nbr
    upvar 1 $txt_var_name f_txt
    upvar 1 $vc1k_var_name f_vc1k
    switch -exact $field_type -- {
        vc1k {
            set f_nbr ""
            set f_txt ""
            set f_vc1k $value
        }
        nbr {
            set f_nbr $value
            set f_txt ""
            set f_vc1k ""
        }
        txt {
            set f_nbr ""
            set f_txt $value
            set f_vc1k ""
        }
        default {
            ns_log Warning "qss_tips_set_by_field_type.783: field_type '${field_type}' not valid.  Defaulting to txt"
            set f_nbr ""
            set f_txt $value
            set f_vc1k ""
        }
    }
    return $v
}


ad_proc -public qss_tips_row_update {
    label_value_list
    table_label
    row_id
} {
    Updates a record into table_label. 
    @return 1 if successful, otherwise return 0.
} {
    upvar 1 instance_id instance_id
    upvar 1 __qss_tips_cell_arr 
    set success_p [qss_tips_row_id_exists_q $row_id $table_id ]
    if { $success_p } {
        set table_id [qss_tips_table_id_of_name $table_label]
        if { [qf_is_natural_number $table_id] } {
            set count [qss_tips_field_defs_maps_set $table_id t_arr l_arr "" "" "" field_labels_list ]
            if { $count > 0 } { 
                qss_tips_user_id_set
                db_transaction {
                    foreach {label value} $label_value_list {
                        if { $label in $field_labels_list } {
                            #set field_id $l_arr(${label})
                            #set field_type $t_arr(${label})
                            qss_tips_set_by_field_type $t_arr(${label}) $value f_nbr f_txt f_vc1k
                            qss_tips_cell_update $table_id $larr(${label}) $row_id $value
                        }
                    }
                }
            }
        }
    }
    return $success_p
}


ad_proc -public qss_tips_row_id_of_table_label_value {
    table_id
    {vc1k_search_label_val_list ""}
    {if_multiple "1"}
} {
    Reads a row from table_label as a name_value_list.
    If more than one row matches, returns 1 row based on value of choose1:
    -1 = return empty row
    0 = row based on earliest value of label
    1 = row based on latest value of label
    @return name_value_list
} {
    upvar 1 instance_id instance_id
    set row_list [list ]
    if { [qf_is_natural_number $table_id] } {
        set count [qss_tips_field_defs_maps_set $table_id "" "" type_arr label_arr ]
        if { $count > 0 } {
            set sort_sql ""
            switch -exact $if_multiple -- {
                -1 { set vc1k_search_sql "na" }
                1 { set sort_sql "order by created des" }
                0 -
                default  { set sort_sql "order by created asc" }
            }
            
            set vc1k_search_sql ""
            if { $vc1k_search_label_val ne "" } {
                # search scope
                foreach {label vc1k_search_val} $vc1k_search_label_val_list {
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        #set field_id $field_id_arr(${label})
                        append vk1k_search_sql " and (field_id='$field_id_arr(${label})' and f_vc1k='${vc1k_search_val}')"
                    } else {
                        ns_log Warning "qss_tips_read.37: no field_id for search label '${label}' table_label '${table_label}' "
                        set vc1k_search_sql "na"
                    }
                }
            } else {
                set vck1_search_sql "na"
            }
            
            if { $vc1k_search_sql eq "na" } {
                # do nothing
            } else {
                set exists_p [db_0or1_row qss_tips_field_values_row_id_search "select row_id from qss_tips_field_values 
                    where instance_id=:instance_id and table_id=:table_id and trashed_p!='1' ${vc1k_search_sql} ${sort_sql} limit 1"]
                # get row id, then row
                if { $exists_p } {
                    set values_lists [db_list_of_lists qss_tips_field_values_r1m "select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
        where table_id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1'
        and row_id=:row_id"]
                    
                    set values_lists [db_list_of_lists qss_tips_field_values_r {select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
                        where table_id=:table_id
                        and row_id=:row_id
                        and instance_id=:instance_id
                        and trashed_p!='1'}]
                    foreach row $values_lists {
                        foreach {field_id row_id f_vc1k f_nbr f_txt} {
                            if { [info exists type_arr(${field_id}) ] } {
                                set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                            } else {
                                ns_log Warning "qss_tips_read_from_id.848: field_id does not have a field_type. table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                            }
                            # label $label_arr(${field_id})
                            lappend row_list $label_arr(${field_id}) $v
                        }
                    }
                }
            }
        }
    }
    return $row_list
}

ad_proc -public qss_tips_rows_read {
    table_id
    row_ids_list
} {
    Reads rows from table_id as a list of lists, where first list is field labels.
    row_ids_list is a list of row_ids of table_id.
    Returns empty list if table not found.
} {
    upvar 1 instance_id instance_id
    set rows_lists [list ]
    if { [qf_is_natural_number $table_id] && [hf_natural_number_list_validate $row_ids_list] } {
        set count [qss_tips_field_defs_maps_set $table_id "" "" type_arr label_arr "" labels_list]
        if { $count > 0  } {
            lappend rows_lists $labels_list
            set values_lists [db_list_of_lists qss_tips_field_values_r_mult "select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
                where table_id=:table_id
                and instance_id=:instance_id
                and trashed_p!='1'
                and row_id in ([template::util::tcl_to_sql_list $row_id_list])"]
            set values_lists [lsort -integer -index 1 $values_lists]
            set row_id [lindex [lindex $values_lists 0] 1]
            set row_id_prev $row_id
            set row_list [list ]
            foreach row $values_lists {
                foreach {field_id row_id f_vc1k f_nbr f_txt} $row {
                    if { [info exists type_arr(${field_id}) ] } {
                        set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                    } else {
                        ns_log Warning "qss_tips_read_from_id.848: field_id does not have a field_type. table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                    }
                    if { $row_id eq $row_id_prev } {
                        # label $label_arr(${field_id})
                        lappend row_list $label_arr(${field_id}) $v
                    } else {
                        array set row_arr $row_list
                        set row2_list [list ]
                        foreach label $labels_list {
                            if { [info exists row_arr(${label}) ] } {
                                lappend row2_list $row_arr(${label})
                            } else {
                                lappend row2_list ""
                            }
                        }
                        lappend rows_lists $row2_list
                        array unset row_arr
                        set row_list [list ]
                        lappend row_list $label_arr(${field_id}) $v
                    }
                }
            }
        }
    }
    return $rows_lists
}


ad_proc -public qss_tips_row_read {
    table_id
    row_id
} {
    Reads a row from table_label as a name_value_list
} {
    upvar 1 instance_id instance_id
    set row_list [list ]
    if { [qf_is_natural_number $table_id ] } {
        set count [qss_tips_field_defs_maps_set $table_id "" "" type_arr label_arr ]
        if { $count > 0 } {
            set values_lists [db_list_of_lists qss_tips_field_values_r {select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
                where table_id=:table_id
                and row_id=:row_id
                and instance_id=:instance_id
                and trashed_p!='1'}]
            foreach row $values_lists {
                foreach {field_id row_id f_vc1k f_nbr f_txt} $row {
                    if { [info exists type_arr(${field_id}) ] } {
                        set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                    } else {
                        ns_log Warning "qss_tips_read_from_id.848: field_id does not have a field_type. table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                    }
                    # label $label_arr(${field_id})
                    lappend row_list $label_arr(${field_id}) $v

                }
            }
        }
    }
    return $row_list
}

ad_proc -public qss_tips_row_trash {
    row_id
    table_id
} {
    Trashes a record of table_id. Returns 1 if successful, otherwise 0.
} {
    upvar 1 instance_id instance_id
    set success_p [qss_tips_row_id_exists_q $row_id $table_id ]
    if { $success_p } {
        qss_tips_user_id_set
        db_dml qss_tips_field_values_row_trash {
            update qss_tips_field_values
            set trashed_p='1',trashed_by=:user_id,trashed_dt=now()
            where row_id=:row_id
            and table_id=:table_id
            and instance_id=:instance_id
        }
    }
    return $success_p
}

ad_proc -public qss_tips_cell_read {
    table_label
    {vc1k_search_label_val_list ""}
    {if_multiple "1"}
    {return_val_label_list ""}
    {which_row "0"}
} {
    Returns the values of the field labels in return_val_label_list in order in list.
    If more than one record matches search_value for search_label, value of "which_row"
    determines which one is chosen. Cases assume chronological order and
    are "0" for first, integer N for Nth, or "end" for more recent one.
    "which_row" accepts tcl ref math, such as "end-1" for example.
} {
    set table_id [qss_tips_table_id_of_name $table_label]
    set row_id [qss_tips_row_id_of_table_label_value $table_id $vc1k_search_label_val_list $which_row]
    set field_id_list [qss_tips_field_ids_of_labels $return_val_label_list]
    set values_list [qss_tips_cell_read_by_id $table_id $row_id $field_id_list]
    return $return_val
}

ad_proc -public qss_tips_cell_read_by_id {
    table_id
    row_id
    field_id_list
} {
    Returns the values of the field labels in return_val_label_list in order in list.
} {
    upvar 1 instance_id instance_id
    set exists_p [db_0or1row qss_tips_field_values_r1_by_id {select f_vc1k, f_nbr, f_txt from qss_tips_field_values
        where row_id=:row_id
        and table_id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1'} ]
    ##code
    if { $exists_p } {
        set field_value [qal_first_nonempty_in_list [list $f_vc1k $f_nbr $f_txt] ]
    }
    return $return_val
}

ad_proc -public qss_tips_cell_update {
    table_id
    field_id
    row_id
    new_value
} {
    Updates a cell value.
} {
    upvar 1 instance_id instance_id
    set field_info_list [qss_tips_field_def_read $table_id "" $field_id]
    if { [llength $field_info_list] > 0 } {
        set field_type [lindex $field_info_list 5]
        qss_tips_set_by_field_type $field_type $value f_nbr f_txt f_vc1k
        qss_tips_user_id_set
        set trashed_p 0
        db_transaction {
            qss_tips_cell_trash $table_id $row_id $field_id
            db_dml qss_tips_field_values_row_up_1f { insert into qss_tips_field_values
                (instance_id,table_id,row_id,trashed_p,created,user_id,field_id,f_vc1k,f_nbr,f_txt)
                values (:instance_id,:table_id,:row_id,:trashed_p,now(),:user_id,:field_id,:f_vc1k,:f_nbr,:f_txt)
            }
        }
    }
    return $return_val
}

ad_proc -public qss_tips_cell_trash {
    table_id
    row_id
    field_id
} {
    @return 1 if successful, otherwise 0
} {
    set exists_p [db_dml qss_tips_field_values_cell_trash { update qss_tips_field_values
        set trashed_p='1',trashed_by=:user_id,trashed_dt=now()
        where instance_id=:instance_id
        and table_id=:table_id
        and row_id=:row_id
        and field_id=:field_id }]
    return $exists_p
}
