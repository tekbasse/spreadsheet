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
        set db_sql {
            select id,name from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}
        set fields_lists [db_list_of_lists qss_tips_field_defs_id_name_r $db_sql]
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
        set db_sql {select label,name from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}
        set fields_lists [db_list_of_lists qss_tips_field_defs_label_name_r $db_sql]
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
    <br><br>
    If field_type_of_label_array_name is nonempty, returns an array in calling environment
    of that name in the form field_type_of(label) for example.
    <br><br>
    If field_id_of_label_array_name is nonempty, returns an array in calling environment
    of that name in the form field_id_of(label) for example.
    <br><br>
    If field_type_of_id_array_name is nonempty, returns an array in calling environment
    of that name in the form field_type_of(id) for example.
    <br><br>
    If field_label_of_id_array_name is nonempty, returns an array in calling environment
    of that name in the form field_label_of(id) for example.
    <br><br>
    If field_labels_list_name is nonempty, returns a list of field labels in calling environment.
    <br><br>
    If field_ids_list_name is nonempty, returns a list of field ids in calling environment.
} {
    upvar 1 instance_id instance_id
    set fields_lists [qss_tips_field_def_read $table_id $filter_by_label_list]
    ns_log Notice "qss_tips_field_defs_maps_set.96: fields_lists '${fields_lists}'"
    if { $field_ids_list_name ne "" } {
        upvar 1 $field_ids_list_name field_ids_list
    }
    if { $field_labels_list_name ne "" } {
        upvar 1 $field_labels_list_name field_labels_list
    }
    set field_labels_list [list ]
    set field_ids_list [list ]
    set set_field_type_label_arr_p 0
    if { [regexp -all -nocase -- {^[a-z0-9\_]+$} $field_type_of_label_array_name] } {
        upvar 1 $field_type_of_label_array_name field_type_label_arr
        set set_field_type_label_arr_p 1
    }         
    set set_field_id_label_arr_p 0
    if { [regexp -all -nocase -- {^[a-z0-9\_]+$} $field_id_of_label_array_name ] } {
        upvar 1 $field_id_of_label_array_name field_id_label_arr
        set set_field_id_label_arr_p 1
    }
    set set_field_type_id_arr_p 0
    if { [regexp -all -nocase -- {^[a-z0-9\_]+$} $field_type_of_id_array_name ] } {
        upvar 1 $field_type_of_id_array_name field_type_id_arr
        set set_field_type_id_arr_p 1
    }         
    set set_field_label_id_arr_p 0
    if { [regexp -all -nocase -- {^[a-z0-9\_]+$} $field_label_of_id_array_name ] } {
        upvar 1 $field_label_of_id_array_name field_label_id_arr
        set set_field_label_id_arr_p 1
    }
    if { [llength $fields_lists ] > 0 } {
        foreach field_list $fields_lists {
            foreach {field_id label name def_val tdt_type field_type} $field_list {
                lappend field_labels_list $label
                lappend field_ids_list $field_id
                lappend field_label_type_list $label $field_type
                lappend field_label_id_list $label $field_id
                lappend field_id_label_list $field_id $label
                lappend field_id_type_list $field_id $field_type
            }
        }
        if { $set_field_type_label_arr_p } {
            array set field_type_label_arr $field_label_type_list
            ns_log Notice "qss_tips_field_defs_maps_set.137: field_label_type_list '${field_label_type_list}'"
        }
        if { $set_field_id_label_arr_p } {
            array set field_id_label_arr $field_label_id_list
            ns_log Notice "qss_tips_field_defs_maps_set.140: field_label_id_list '${field_label_id_list}'"
        }
        if { $set_field_type_id_arr_p } {
            array set field_type_id_arr $field_id_type_list
            ns_log Notice "qss_tips_field_defs_maps_set.145: field_id_type_list '${field_id_type_list}'"
        }
        if { $set_field_label_id_arr_p } {
            array set field_label_id_arr $field_id_label_list
            ns_log Notice "qss_tips_field_defs_maps_set.140: field_id_label_list '${field_id_label_list}'"
        }
    }
    set count [llength $field_labels_list]
    return $count
}

ad_proc -public qss_tips_table_id_of_label {
    table_label
} { 
    Returns table_id of table_label, or empty string if not found.
} {
    # cannot check for trashed tables, because that could give multiple results.
    upvar 1 instance_id instance_id
    set table_id ""
    set db_sql {
        select id as table_id from qss_tips_table_defs
        where label=:table_label
        and instance_id=:instance_id
        and trashed_p!='1'}
    db_0or1row qss_tips_table_defs_r_name_untrashed $db_sql
    return $table_id
}

ad_proc -private qss_tips_table_id_exists_q {
    table_id
    {trashed_p "0"}
} {
    Returns 1 if table_id exists.
    <br>
    Defaults to only check untrashed tables (trashed_p is 0). 
    <br>
    Set trashed_p to 1 to check all cases.
} {
    upvar 1 instance_id instance_id
    if { ![qf_is_true $trashed_p ] } {
        set exists_p [db_0or1row qss_tips_trashed_table_id_exists {
            select id from qss_tips_table_defs 
            where id=:table_id 
            and instance_id=:instance_id limit 1
        } ]
    } else {
        set exists_p [db_0or1row qss_tips_untrashed_table_id_exists {
            select id from qss_tips_table_defs 
            where id=:table_id
            and instance_id=:instance_id
            and trashed_p!='1' limit 1
        } ]
    }
    return $exists_p
}


ad_proc -private qss_tips_field_def_id_exists_q {
    field_id
    table_id
    {trashed_p "0"}
} {
    Returns 1 if field_id exists for table_id.
    <br>
    Defaults to only check untrashed fields (trashed_p is 0). 
    <br>
    Set trashed_p to 1 to check all cases.
} {
    upvar 1 instance_id instance_id
    if { ![qf_is_true $trashed_p ] } {
        set exists_p [db_0or1row qss_tips_trashed_field_id_exists {
            select id from qss_tips_field_defs
            where id=:field_id 
            and table_id=:table_id
            and instance_id=:instance_id limit 1
        } ]
    } else {
        set exists_p [db_0or1row qss_tips_untrashed_field_id_exists {
            select id from qss_tips_field_defs
            where id=:field_id
            and table_id=:table_id
            and instance_id=:instance_id
            and trashed_p!='1' limit 1
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
    if { [qf_is_true $trashed_p ] } {
        set exists_p [db_0or1row qss_tips_trashed_row_id_exists {
            select row_id from qss_tips_field_values
            where row_id=:row_id
            and table_id=:table_id
            and instance_id=:instance_id limit 1} ]
    } else {
        set exists_p [db_0or1row qss_tips_untrashed_row_id_exists {
            select row_id from qss_tips_field_values
            where row_id=:row_id
            and table_id=:table_id
            and instance_id=:instance_id
            and trashed_p!='1' limit 1 } ]
    }
    return $exists_p
}

ad_proc -public qss_tips_table_def_read {
    table_label
} { 
    Returns list of table_id, label, name, flags, trashed_p or empty list if not found.
} {
    upvar 1 instance_id instance_id
    set table_list [list ]
    set db_sql {select id,label,name,flags,trashed_p from qss_tips_table_defs
        where label=:table_label
        and instance_id=:instance_id
        and trashed_p!='1'}
    set exists_p [db_0or1row qss_tips_table_defs_r1_untrashed $db_sql]
    if { $exists_p } {
        set table_list [list $id $label $name $flags $trashed_p]
    }
    return $table_list
}

ad_proc -public qss_tips_table_def_read_by_id {
    table_id
} { 
    Returns list of table_id, label, name, flags, trashed_p or empty list if not found.
} {
    upvar 1 instance_id instance_id
    set table_list [list ]
    set db_sql {select id,label,name,flags,trashed_p from qss_tips_table_defs
        where id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1'}
    set exists_p [db_0or1row qss_tips_table_defs_r1_untrashed $db_sql]
    if { $exists_p } {
        lappend table_list $id $label $name $flags $trashed_p
    }
    return $table_list
}


ad_proc -public qss_tips_table_def_create {
    label
    name
    {flags ""}
} {
    Defines a tips table. Label is a short reference (up to 40 chars) with no spaces.
    Name is usually a title for display and has spaces (40 char max).
    If label exists, will rename label to "-integer".
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
    qss_tips_user_id_set
    if { [hf_are_printable_characters_q $label] && [hf_are_visible_characters_q $name] } {
        set existing_id [qss_tips_table_id_of_label $label]
        set label_len [string length $label]
        set name_len [string length $name]
        set i 1
        if { $label_len > 39 || $name_len > 39 } {
            incr i
            set chars_max [expr { 38 - [string length $i] } ]
            if { $label_len > 39 } {
                set label [qf_abbreviate $label $chars_max "" "_"]
                append label "-" $i
            }
            if { $name_len > 39 } {
                set name [qf_abbreviate $name $chars_max ".." " "]
            }
        }
        set label_orig $label
        while { $existing_id ne "" && $i < 1000 } {
            incr i
            set chars_max [expr { 38 - [string length $i] } ]
            set label [string range $label_orig 0 $chars_max]
            append label "-" $i
            set existing_id [qss_tips_table_id_of_label $label]
        }
        if { $existing_id eq "" } {
            set id [db_nextval qss_tips_id_seq]
            set trashed_p "0"
            db_dml qss_tips_table_cre {
                insert into qss_tips_table_defs 
                (instance_id,id,label,name,flags,user_id,created,trashed_p)
                values (:instance_id,:id,:label,:name,:flags,:user_id,now(),:trashed_p)                   
            }
        } else {
            ns_log Notice "qss_tips_table_def_create.273: table label '${label}' already exists."
        }
    } else {
        ns_log Notice "qss_tips_table_def_create.276: table label or name includes characters not allowed."
    }
    return $id
}


ad_proc -public qss_tips_table_def_update {
    table_id
    args
} {
    Updates a table definition for table_id. 
    <br>
    <code>args</code> can be passed as name value list or parameters.
    <br>
    Accepted names are: <code>label</code>, <code>name</code>, and <code>flags</code>.
    <br>
    @return 1 if successful, otherwise 0.
} {
    upvar 1 instance_id instance_id
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
        set field_len_limit_list [list label name]
        set changed_p 0
        foreach {arg val} $args_list {
            if { $arg in $field_list } {
                set changed_p 1
                set $arg $val
                if { $arg in $field_len_limit_list } {
                    if { [string length $val] > 39 } {
                        set i 2
                        set chars_max [expr { 38 - [string length $i] } ]
                        if { $arg eq "name" } {
                            set name [qf_abbreviate $val $chars_max ".." " "]
                        } elseif { $arg eq "label" } {
                            set label_orig [qf_abbreviate $val $chars_max "" "_"]
                            set label $label_orig
                            set existing_id [qss_tips_table_id_of_label $label]
                            while { ( $existing_id ne "" && $existing_id ne $table_id ) && $i < 1000 } {
                                incr i
                                set chars_max [expr { 38 - [string length $i] } ]
                                set label [string range $label_orig 0 $chars_max]
                                append label "-" $i
                                set existing_id [qss_tips_table_id_of_label $label]
                            }
                        }
                    }
                }
            }
        }
        if { $changed_p } {
            qss_tips_user_id_set
            db_transaction {
                # trash record
                qss_tips_table_def_trash $table_id
                # create new
                set trashed_p 0
                db_dml tips_table_def_log_rev {
                    insert into qss_tips_table_defs 
                    (instance_id,id,label,name,flags,user_id,created,trashed_p)
                    values (:instance_id,:table_id,:label,:name,:flags,:user_id,now(),:trashed_p) 
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
    <br>
    @return 1 if success, otherwise return 0.
} {
    upvar 1 instance_id instance_id
    qss_tips_user_id_set
    set success_p [qss_tips_table_id_exists_q $table_id]
    if { $success_p } {
        db_dml qss_tips_table_trash {
            update qss_tips_table_defs 
            set trashed_p='1',trashed_by=:user_id,trashed_dt=now()
            where id=:table_id
            and instance_id=:instance_id
        }
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
    <br>
    Array indexes are name_array(row_id,field_label)
    where row_id are in a list in name_array(row_ids).
    <br>
    If row_id_list contains row_ids, only returns ids that are supplied in row_id_list.
    <br>
    name_array(row_ids) contains a list of row_ids used for array indexes.
    <br>
    name_array(labels) contains a list of table labels (ie columns)
} {
    # Returns an array instead of list of lists in order to avoid sorting row_ids.

    # Querying Trashed_p = 1 doesn't make sense, because row_id and field_id are same ref..
    # trashed_p only makes sense if calling up history of a single cell, row, or table.. by activity.
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_id [qss_tips_table_id_of_label $table_label]
    set success_p 0
    
    if { [qf_is_natural_number $table_id] } {
        set count [qss_tips_field_defs_maps_set $table_id "" field_id_arr type_arr label_arr field_ids_list field_labels_list]
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
            if { $vc1k_search_label_val_list ne "" } {
                # search scope
                set vc1k_search_lv_list [qf_listify $vc1k_search_label_val_list]
                set vref 0
                foreach {label vc1k_search_val} $vc1k_search_lv_list {
                    incr vref
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        set field_id $field_id_arr(${label})
                        if { $vc1k_search_val eq "" } {
                            append vc1k_search_sql " and row_id in ("
                            append vc1k_search_sql "select row_id from qss_tips_field_values
    where table_id=:table_id 
        and trashed_p!='1' 
        and row_id not in ("
                            append vc1k_search_sql "select row_id from qss_tips_field_values 
    where table_id=:table_id 
        and f_vc1k is not null 
        and field_id='" 
                            append vc1k_search_sql $field_id "' and trashed_p!='1') group by row_id)" 
                        } else {
                            #set field_id $field_id_arr(${label})
                            set vc1k_val_${vref} $vc1k_search_val
                            append vc1k_search_sql " and (field_id='" $field_id "' and f_vc1k=:vc1k_val_${vref})" 
                        }
                    } else {
                        ns_log Warning "qss_tips_read.492: no field_id for search label '${label}' \
    table_label '${table_label}' "
                        set vc1k_search_sql "na"
                    }
                }
            }

            if { $row_ids_sql eq "na" || $vc1k_search_sql eq "na" } {
                set n_arr(row_ids) [list ]
                set n_arr(labels) [list ]
            } else {
                set db_sql "select row_id, field_id, f_vc1k, f_nbr, f_txt \
                            from qss_tips_field_values \
                            where table_id=:table_id \
                            and instance_id=:instance_id \
                            and trashed_p!='1' \
                            and field_id in ([template::util::tcl_to_sql_list $field_ids_list]) \
                            ${vc1k_search_sql} ${row_ids_sql}"
                set values_lists [db_list_of_lists qss_tips_field_values_r $db_sql]
                # How to set all values for a row_id without sorting?
                # Answer: set all cases to empty string.. 
                # And yet that may double the cases of setting vars.
                # By sorting by row_id, loops can be combined, and scalar and list vars used.
                set values_by_row_lists [lsort -integer -index 0 $values_lists]
                # For missing cases that need to be set to empty string.
                set es ""
                
                # val_i = values initial
                set row_ids_list [list ]
                set field_ids_used_list [list ]
                set row_id_prev ""
                foreach cell_list $values_by_row_lists {
                    foreach {row_id field_id f_vc1k f_nbr f_txt} $cell_list {
                        if { $row_id ne $row_id_prev } {
                            # new row_id. 
                            # Add any missing cells for previous row
                            if { $row_id_prev ne "" } {
                                set field_ids_blank_list [set_difference $field_ids_list $field_ids_used_list]
                                if { [llength $field_ids_blank_list] > 0 } {
                                    set v ""
                                    set row_id_comma $row_id_prev
                                    append row_id_comma ","
                                    foreach f_id $field_ids_blank_list {
                                        set row_id_label $row_id_comma
                                        append row_id_label $label_arr(${f_id})
                                        set n_arr(${row_id_label}) $v
                                    }
                                }
                             
                            }
                            # Start new row processing
                            lappend row_ids_list $row_id
                            set field_ids_used_list [list ]
                        }

                        if { [info exists type_arr(${field_id}) ] } {
                            # set field_type $type_arr(${field_id})
                            set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                        } else {
                            ns_log Warning "qss_tips_read.54: field_id does not have a field_type. \
    table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                            set v [qal_first_nonempty_in_list [list $f_nbr $f_vc1k $f_txt]]
                        }
                        lappend field_ids_used_list $field_id
                        set row_id_label $row_id
                        append row_id_label ","  $label_arr(${field_id})
                        set n_arr(${row_id_label}) $v
                        set row_id_prev $row_id
                    }
                }
                # process last row blanks, if any
                if { $row_id_prev ne "" } {
                    set field_ids_blank_list [set_difference $field_ids_list $field_ids_used_list]
                    if { [llength $field_ids_blank_list] > 0 } {
                        set v ""
                        set row_id_comma $row_id_prev
                        append row_id_comma ","
                        foreach f_id $field_ids_blank_list {
                            set row_id_label $row_id_comma
                            append row_id_label $label_arr(${f_id})
                            set n_arr(${row_id_label}) $v
                        }
                    }
                    
                }



                set n_arr(row_ids) $row_ids_list
                set n_arr(labels) $field_labels_list
                if { [llength $row_ids_list] > 0 } {
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
    {row_id_column_name ""}
} {
    Returns one or more records of table_label as a list of lists
    where field value pairs in vc1k_search_label_val_list match query.
    <br>
    First row contains table labels cooresponding to values in subsequent rows.
    <br>
    If row_id_list contains row_ids, only returns ids that are supplied in row_id_list.
    <br>
    If row_id_column_name is supplied, 
    a column containing row_id for each row will be appended to the table.
    The label name will be the one supplied to row_id_column_name
} {
    upvar 1 instance_id instance_id
    set table_id [qss_tips_table_id_of_label $table_label]
    set success_p 0
    set table_lists [list ]
    if { [qf_is_natural_number $table_id] } {
        set label_ids_list_len [qss_tips_field_defs_maps_set $table_id "" field_id_arr type_arr label_arr label_ids_list labels_list]
        if { $label_ids_list_len > 0 } {

            set label_ids_sorted_list [lsort -integer $label_ids_list]
            set titles_list [list ]

            foreach id $label_ids_sorted_list { 
                set label $label_arr(${id})
                lappend titles_list $label
            }
            if { [hf_are_safe_and_printable_characters_q $row_id_column_name ] } {
                set row_id_column_name_exists_p 1
                lappend titles_list $row_id_column_name
            } else {
                set row_id_column_name_exists_p 0
            }
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
            if { $vc1k_search_label_val_list ne "" } {
                # search scope
                set vc1k_search_lv_list [qf_listify $vc1k_search_label_val_list]
                set vref 0
                foreach {label vc1k_search_val} $vc1k_search_lv_list {
                    incr vref
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        set field_id $field_id_arr(${label})

                        if { $vc1k_search_val eq "" } {
                            # append vc1k_search_sql " and (field_id='" $field_id "' and f_vc1k is null)"
                            append vc1k_search_sql " and row_id in ("
                            append vc1k_search_sql "
    select row_id from qss_tips_field_values 
    where table_id=:table_id 
        and trashed_p!='1' 
        and row_id not in ("
                            append vc1k_search_sql "
    select row_id from qss_tips_field_values 
    where table_id=:table_id 
        and f_vc1k is not null 
        and field_id='" 
                            append vc1k_search_sql $field_id "' and trashed_p!='1') group by row_id)" 
                        } else {
                            set vc1k_val_${vref} $vc1k_search_val
                            append vc1k_search_sql " and (field_id='" $field_id "' and f_vc1k=:vc1k_val_${vref})" 
                        }
                    } else {
                        ns_log Warning "qss_tips_read.571: no field_id for search label '${label}' \
 table_label '${table_label}' "
                        set vc1k_search_sql "na"
                    }
                }
            }

            if { $row_ids_sql eq "na" || $vc1k_search_sql eq "na" } {
                # do nothing
            } else {
                set db_sql "\
    select row_id, field_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values \
    where table_id=:table_id \
        and instance_id=:instance_id \
        and trashed_p!='1' ${vc1k_search_sql} ${row_ids_sql} order by row_id, field_id asc"
                set values_lists [db_list_of_lists qss_tips_field_values_r_sorted $db_sql]
                
                set row_list [list ]
                set start_cell_list [lindex $values_lists 0]
                set current_row_id [lindex $start_cell_list 0]
                set f_idx 0
                set current_field_id [lindex $label_ids_sorted_list $f_idx]

                foreach cell_list $values_lists {
                    foreach {row_id field_id f_vc1k f_nbr f_txt} $cell_list {
                        if { $row_id ne $current_row_id } {


                            while { $f_idx < $label_ids_list_len } {
                                # add blank cell
                                lappend row_list ""
                                
                                incr f_idx
                                set current_field_id [lindex $label_ids_sorted_list $f_idx]
                            }

                            if { $row_id_column_name_exists_p } {
                                lappend row_list $current_row_id
                            }

                            lappend table_lists $row_list

                            # new row
                            set fid_list [list ]
                            set f_idx_list [list ]
                            set row_list [list ]
                            set current_row_id $row_id
                            set f_idx 0
                            set current_field_id [lindex $label_ids_sorted_list $f_idx]
                        }
                        if { ![qf_is_natural_number $field_id] || ![qf_is_natural_number $current_field_id] } {
                            ns_log Warning "qss_tips_table_read.754: field_id '${field_id} current_field_id '${current_field_id}' This should not happen."
                        }
                        while { $field_id > $current_field_id && $f_idx < $label_ids_list_len } {
                            # add blank cell
                            lappend row_list ""

                            incr f_idx
                            set current_field_id [lindex $label_ids_sorted_list $f_idx]
                        }
                        if { [info exists type_arr(${field_id}) ] } {
                            set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                        } else {
                            ns_log Warning "qss_tips_read.54: field_id does not have a field_type. \
 table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                            set v [qal_first_nonempty_in_list [list $f_nbr $f_vc1k $f_txt]]
                        }
                        # label $label_arr(${field_id})
                        # v is value
                        lappend row_list $v

                        incr f_idx
                        set current_field_id [lindex $label_ids_sorted_list $f_idx]
                    }
                }

                if { [llength $row_list] > 0 } {

                    while { $f_idx < $label_ids_list_len } {
                        # add blank cell
                        lappend row_list ""
                        
                        incr f_idx
                        # following not needed for these cases.
                        #set current_field_id \[lindex $label_ids_sorted_list $f_idx\]
                    }
                    
                    if { $row_id_column_name_exists_p } {
                        lappend row_list $current_row_id
                    }

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
    <br>
    Each field is a column in a table.
    <br>
    <code>args</code> is passed in name value pairs. 
    <br>
    Requires table_label or table_id and field: <code>label name tdt_data_type field_type</code>.
    <br>
    <code>default_val</code> and <code>tdt_dat_type</code> are empty strings unless supplied.
    <br>
    <code>field_type</code> defaults to txt.
    <br>
    <code>field_type</code> is one of 'txt', 'vc1k', or 'nbr'; 
    <ul><li>
    <code>txt</code> is of data type "text", 
    </li><li>
    <code>nbr</code> is of type numeric, and 
    </li><li>
    <code>vc1k</code> is of type varchar(1000).
    </li></ul>
    <p>
    Searches are fastest on vc1k types as these entries are indexed in the data model.
    <br>
    <code>tdt_data_type</code> references an entry in qss_tips_data_types.
    <br>
    @return field_def_id or empty string if unsuccessful.
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
    set req_list [list label name]
    set opt_list [list default_val tdt_data_type field_type]
    set xor_list [list table_id table_label]
    set all_list [concat $req_list $opt_list $xor_list]
    set name_list [list ]

    set field_types_list [list txt vc1k nbr]
    set new_id ""
    # optional values have defaults
    set default_val ""
    set tdt_data_type ""
    set field_type "txt"

    foreach {nam val} $args_list {
        if { $nam in $all_list } {
            if { $nam eq "field_type" && $val ni $field_types_list } {
                # use default
            } else {
                set $nam $val
                lappend name_list $nam
            }
        }
    }
    set success_p 1
    foreach nam $req_list {
        if { $nam ni $name_list } {
            set success_p 0
        }
    }
    if { $success_p && ( "table_id" ni $name_list && "table_label" ni $name_list ) } {
        set success_p 0
    }
    if { $success_p } {
        # since optional values have defaults, no need to customize sql
        if { ![info exists table_id] } {
            set table_id [qss_tips_table_id_of_label $table_label]
        }
        set trashed_p 0
        if { [qf_is_natural_number $table_id] } {
            set new_id [db_nextval qss_tips_id_seq]
            db_dml qss_tips_field_def_cr {insert into qss_tips_field_defs
                (instance_id,id,table_id,created,user_id,label,name,default_val,
                 tdt_data_type,field_type,trashed_p)
                values (:instance_id,:new_id,:table_id,now(),:user_id,:label,:name,:default_val,
                        :tdt_data_type,:field_type,:trashed_p)
            }
        } 
    }
    return $new_id
}


ad_proc -public qss_tips_field_def_trash {
    field_ids
    table_id
} {
    Trashes one or more fields. 
    <br>
    Each field is a column in a table. 
    <br>
    Accepts list or scalar value.
    <br>
    If table_id is supplied, scopes to table_id.
    <br>
    @return 1 if all cases are success,  otherwise returns 0.
} {
    upvar 1 instance_id instance_id
    qss_tips_user_id_set
    set field_ids_list [qf_listify $field_ids]
    set success_p_tot 1
    foreach field_id $field_ids_list {
        set success_p [qss_tips_field_def_id_exists_q $field_id $table_id]
        set success_p_tot [expr { $success_p && $success_p_tot } ]
        if { $success_p } {
            db_dml qss_tips_field_trash_def1 {
                update qss_tips_field_defs 
                set trashed_p='1',trashed_by=:user_id,trashed_dt=now()
                where id=:field_id
                and table_id=:table_id
                and instance_id=:instance_id}
        }
    }
    return $success_p_tot
}

ad_proc -public qss_tips_field_def_update {
    table_id
    args
} {
    Given table_id and field_id or field_label, updates label and/or name.
    <br>
    <code>args</code> can be passed as list or list of args in name value pairs.
    <br>
    Acceptable names are <code>field_id</code> or <code>field_label</code> for referencing field;
    and <code>name_new</code> and/or <code>label_new</code> for setting new values for referenced names.
    <br>
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

        set db_sql "select id as field_id,label,name,default_val,tdt_data_type,\
                        field_type,created as c_date,user_id as c_user_id from qss_tips_field_defs \
                    where instance_id=:instance_id \
                        and table_id=:table_id \
                        and trashed_p!='1' ${extra_ref_sql}" 
        set exists_p [db_0or1row qss_tips_field_def_r_u1 $db_sql]
        if { $exists_p } {
            qss_tips_user_id_set
            if { ![info exists name_new] } {
                set name_new $name
            }
            if { ![info exists label_new] } {
                set label_new $label
            }
            set trashed_p 0
            db_transaction {
                db_dml qss_tips_field_def_u1 { update qss_tips_field_defs 
                    set trashed_p='1',
                    trashed_dt=now(),
                    trashed_by=:user_id
                    where id=:field_id 
                    and instance_id=:instance_id 
                    and table_id=:table_id }
                db_dml qss_tips_field_def_u1_cr {
                    insert into qss_tips_field_defs
                    (instance_id,table_id,id,label,name,user_id,created,
                     trashed_p,default_val,tdt_data_type,field_type)
                    values (:instance_id,:table_id,:field_id,:label_new,:name_new,
                            :user_id,now(),:trashed_p,:default_val,:tdt_data_type,:field_type)
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
    <br>
    Returns an ordered list of lists, where colums are:
    <br>
    field_id,label,name,default_val,tdt_data_type,field_type
    <br>
    or empty list if not found.
    <br>
    If field_labels or field_ids is nonempty (list or scalar), scopes to just these.
} {
    upvar 1 instance_id instance_id
    set fields_lists [list ]
    if {[qf_is_natural_number $table_id ]} {
        set db_sql {
            select id as field_id,label,name,default_val,tdt_data_type,field_type from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id
            and trashed_p!='1'}
        set fields_lists [db_list_of_lists qss_tips_field_defs_r $db_sql]
        # allow glob with field_labels
        set field_label_idx_list [list ]
        set field_label_list [qf_listify $field_labels]
        set field_label_list_len [llength $field_label_list]
        #ns_log Notice "qss_tips_field_def_read.790 field_label_list '${field_label_list}' 
        # field_label_list_len '${field_label_list_len}'"
        if { $field_label_list_len > 0 } {
            # create a searchable list
            set label_search_list [list ]
            foreach field_list $fields_lists {
                lappend label_search_list [lindex $field_list 1]
            }
            foreach field_label $field_label_list {
                set indexes [lsearch -all -glob $label_search_list $field_label]
                set field_label_idx_list [concat $field_label_idx_list $indexes]
            }
            
        }        
        
        set field_id_idx_list [list ]
        set field_id_list [hf_list_filter_by_natural_number [qf_listify $field_ids]]       
        set field_id_list_len [llength $field_id_list]
        #ns_log Notice "qss_tips_field_def_read.808 field_id_list '${field_id_list}' 
        # field_id_list_len '${field_id_list_len}'"
        if { $field_id_list_len > 0 } {
            # create a searchable list
            set id_search_list [list ]
            foreach field_list $fields_lists {
                lappend id_search_list [lindex $field_list 0]
            }
            foreach id $field_id_list {
                set indexes [lsearch -exact -all -integer $id_search_list $id]
                set field_id_idx_list [concat $field_id_idx_list $indexes]
            }
        }
        
        if { $field_id_list_len > 0 || $field_label_list_len > 0 } {
            set field_idx_list [concat $field_id_idx_list $field_label_idx_list]
            # remove duplicates
            set field_idx_list [qf_uniques_of $field_idx_list]
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
    table_id
    args
} {
    Writes a record into table_label. 
    <br>
    Returns row_id if successful, otherwise empty string.
    <br>
    <code>args</code> can be passed as name value list or parameters.
    <br>
    Missing field labels are left blank ie. no default_value subistituion is performed.
} {
    upvar 1 instance_id instance_id
    # args was label_value_list
    # Allow args to be passed as a list or separate parameters
    set label_value_list [list ]
    set arg1 [lindex $args 0]
    if { [llength $arg1] > 1 } {
        set label_value_list $arg1
    }
    set label_value_list [concat $label_value_list $args]
    set new_id ""
    if { [qf_is_natural_number $table_id] } {
        set count [qss_tips_field_defs_maps_set $table_id t_arr l_arr "" "" "" field_labels_list]
        # field_labels_list defined.
        if { $count > 0 } {
            qss_tips_user_id_set
            set new_id [db_nextval qss_tips_id_seq]
            db_transaction {
                foreach {label value} $label_value_list {
                    # if field value is blank, skip..
                    if { $label in $field_labels_list && $value ne "" } {
                        set field_id $l_arr(${label})
                        set field_type $t_arr(${label})
                        set trashed_p 0
                        qss_tips_set_by_field_type $field_type $value f_nbr f_txt f_vc1k
                        ns_log Notice "qss_tips_row_create.911: field_type '${field_type}' \
 value '${value}' f_nbr '${f_nbr}' f_txt '${f_txt}' f_vc1k '${f_vc1k}'"
                        set db_sql {
                            insert into qss_tips_field_values
                            (instance_id,table_id,row_id,trashed_p,created,
                             user_id,field_id,f_vc1k,f_nbr,f_txt)
                            values (:instance_id,:table_id,:new_id,:trashed_p,now(),
                                    :user_id,:field_id,:f_vc1k,:f_nbr,:f_txt) }
                        db_dml qss_tips_field_values_row_cr_1f $db_sql
                    }
                }
            }
        } else {
            ns_log Notice "qss_tips_row_create.908: No fields defined for table_id '${table_id}'."
        }
    } else {
        ns_log Notice "qss_tips_row_create.911: table_id '${table_id}' not a valid number."
    }
    return $new_id
}

ad_proc -private qss_tips_value_of_field_type {
    field_type
    f_nbr
    f_txt
    f_vc1k
} {
    Returns value based on field_type.
} {
    switch -exact -- $field_type {
        vc1k { set v $f_vc1k }
        nbr  { set v $f_nbr }
        txt  { set v $f_txt }
        default {
            set v [qal_first_nonempty_in_list [list $f_nbr $f_vc1k $f_txt]]
            ns_log Warning "qss_tips_value_of_field_type.843: unknown field_type '${field_type}'. \
 Choosing first nonempty value: '${v}'"
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
    Sets value to appropriate variable based on field_type. 
    <br>
    Others are set to empty string.
} {
    upvar 1 $nbr_var_name f_nbr
    upvar 1 $txt_var_name f_txt
    upvar 1 $vc1k_var_name f_vc1k
    set success_p 1
    switch -exact -- $field_type {
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
            ns_log Warning "qss_tips_set_by_field_type.783: field_type '${field_type}' not valid. \
 Defaulting to txt"
            set f_nbr ""
            set f_txt $value
            set f_vc1k ""
            set success_p 0
        }
    }
    ns_log Notice "qss_tips_set_by_field_type.984: field_type '${field_type}' value '${value}' \
 f_nbr '${f_nbr}' f_txt '${f_txt}' f_vc1k '${f_vc1k}'"
    return $success_p
}


ad_proc -public qss_tips_row_update {
    table_id
    row_id
    label_value_list
} {
    Updates a record into table_label. 
    <br>
    @return 1 if successful, otherwise return 0.
} {
    upvar 1 instance_id instance_id
    set success_p 0
    if { [qf_is_natural_number $table_id] && [qf_is_natural_number $row_id ] } {
        set success_p [qss_tips_row_id_exists_q $row_id $table_id ]
        if { $success_p } {
            set count [qss_tips_field_defs_maps_set $table_id t_arr l_arr "" "" "" field_labels_list ]
            if { $count > 0 } { 
                qss_tips_user_id_set
                db_transaction {
                    foreach {label value} $label_value_list {
                        if { $label in $field_labels_list } {
                            #set field_id $l_arr(${label})
                            #set field_type $t_arr(${label})
                            ns_log Notice "qss_tips_row_update.1027 table_id '${table_id}' \
 row_id '${row_id}' label '${label}' t_arr(${label}) '$t_arr(${label})'"
                            qss_tips_set_by_field_type $t_arr(${label}) $value f_nbr f_txt f_vc1k
                            qss_tips_cell_update $table_id $row_id $l_arr(${label}) $value
                        } else {
                            ns_log Notice "qss_tips_row_update.1031 label '${label}' \
 not in table_id '${table_id}'. update to value '${value}' ignored."
                        }
                    }
                }
            }
        }
    } else {
        ns_log Warning "qss_tips_row_udpate.1035: table_id '${table_id}' \
 or row_id '${row_id}' is not a number."
    }
    return $success_p
}



ad_proc -public qss_tips_row_of_table_label_value {
    table_id
    {vc1k_search_label_val_list ""}
    {if_multiple "1"}
    {row_id_var_name ""}
} {
    Reads a row from table_id as a name_value_list.
    <br>
    If more than one row matches, returns 1 row based on value of choosen:
    <ul><li>
    -1 = return empty row
    </li><li>
    0 = row based on earliest value of label
    </li><li>
    1 = row based on latest value of label
    </li></ul>
    If row_id_var_name is not empty string, assigns the row_id to that variable name.
    <br>
    @return name_value_list
} {
    upvar 1 instance_id instance_id
    if { $row_id_var_name ne "" } {
        upvar 1 $row_id_var_name return_row_id
    }
    set return_row_id ""
    set row_list [list ]
    if { [qf_is_natural_number $table_id] } {
        # field_ids_list and field_labels_list are coorelated 1:1
        set label_ids_list_len [qss_tips_field_defs_maps_set $table_id "" field_id_arr type_arr label_arr field_ids_list ""]
        if { $label_ids_list_len > 0 } {
            set vc1k_search_sql ""
            set sort_sql ""
            switch -exact -- $if_multiple {
                1 { 
                    # LIFO
                    set sort_sql "order by created desc"
                }
                -1 {
                    # Reject multiple
                    set sort_sql "order by created asc"
                }
                0 -
                default  { 
                    # FIFO is safest/most reliable. No?
                    set sort_sql "order by created asc"
                    set if_multiple "0" 
                }
            }
            

            if { $vc1k_search_label_val_list ne "" } {
                # search scope
                set vc1k_search_lv_list [qf_listify $vc1k_search_label_val_list]
                ns_log Notice "qss_tips_row_of_table_label_value.1056: vc1k_search_label_val_list  \
 '${vc1k_search_label_val_list}' vc1k_search_lv_list '${vc1k_search_lv_list}'"
                set vref 0
                foreach {label vc1k_search_val} $vc1k_search_lv_list {
                    incr vref
                    if { [info exists field_id_arr(${label}) ] && $vc1k_search_sql ne "na" } {
                        if { $vc1k_search_val eq "" } {
                            #change to add an expression that limits results to row_ids from a general query of
                            # row_ids less row_ids of field_id that have values.
                            # because null and empty values don't exist in table's db.
                            append vc1k_search_sql " and row_id in ("
                            append vc1k_search_sql "select row_id from qss_tips_field_values \
    where table_id=:table_id \
        and trashed_p!='1' \
        and row_id not in ("
                            append vc1k_search_sql "select row_id from qss_tips_field_values \
    where table_id=:table_id \
        and f_vc1k is not null \
        and field_id='" 
                            append vc1k_search_sql $field_id_arr(${label}) 
                            append vc1k_search_sql "' and trashed_p!='1') group by row_id)" 
                        } else {
                            #set field_id $field_id_arr(${label})
                            set vc1k_val_${vref} $vc1k_search_val
                            append vc1k_search_sql " and (field_id='" $field_id_arr(${label}) 
                            append vc1k_search_sql "' and f_vc1k=:vc1k_val_${vref})" 
                        }
                    } else {
                        ns_log Warning "qss_tips_row_of_table_label_value.1067: no field_id \
 for search label '${label}' table_id '${table_id}' "
                        set vc1k_search_sql "na"
                    }
                }
            } else {
                set vck1_search_sql "na"
            }
            
            if { $vc1k_search_sql eq "na" } {
                # do nothing
            } else {
                # get row id, then row
                ns_log Notice "qss_tips_row_of_table_label_value.1084: \
 vc1k_search_sql '${vc1k_search_sql}' sort_sql '${sort_sql}'"
                set db_sql "\
    select row_id from qss_tips_field_values \
    where instance_id=:instance_id \
        and table_id=:table_id \
        and trashed_p!='1' ${vc1k_search_sql} ${sort_sql}"
                set row_ids_list [db_list qss_tips_field_values_row_id_search $db_sql]
                set row_id [lindex $row_ids_list 0]
                if { $row_id ne "" } {
                    set exists_p 1
                } else {
                    set exists_p 0
                }
                if { $exists_p && $if_multiple eq "-1" } {
                    set row_ids_unique_list [qf_uniques_of $row_ids_list]
                    if { [llength $row_ids_unique_list] > 1 } {
                        ns_log Notice "qss_tips_row_of_table_label_value.1094: Rejecting row_id,\
 because if_multiple=-1: row_ids_list '${row_ids_list}' row_ids_unique_list '${row_ids_unique_list}'"
                        #set return_row_id ""
                        set exists_p 0
                    }
                }
                
                if { $exists_p } {
                    # duplicate core of qss_tips_row_read
                    set return_row_id $row_id
                    set db_sql {
                        select field_id, row_id, f_vc1k, f_nbr, f_txt 
                        from qss_tips_field_values 
                        where table_id=:table_id
                        and row_id=:row_id
                        and instance_id=:instance_id
                        and trashed_p!='1'}
                    set values_lists [db_list_of_lists qss_tips_field_values_r1m $db_sql]

                    set used_fields_list [list ]
                    foreach row $values_lists {
                        foreach {field_id row_id f_vc1k f_nbr f_txt} $row {
                            if { [info exists type_arr(${field_id}) ] } {
                                set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                            } else {
                                ns_log Warning "qss_tips_row_of_table_label_value.1092: field_id \
 does not have a field_type. table_id '${table_id}' field_id '${field_id}' row_id '${row_id}'"
                            }
                            # label $label_arr(${field_id})
                            lappend row_list $label_arr(${field_id}) $v
                            lappend used_fields_list $field_id
                        }
                    }
                    set_difference_named_v field_ids_list $used_fields_list
                    foreach field_id $field_ids_list {
                        lappend row_list $label_arr(${field_id}) ""
                    }

                } else {
                    ns_log Notice "qss_tips_row_of_table_label_value.1099: row not found \
 for search '${vc1k_search_label_val_list}'."
                }
            }
        } else {
            ns_log Notice "qss_tips_row_of_table_label_value.1101: no fields defined for table_id '${table_id}'"
        }
    } else {
        ns_log_ Notice "qss_tips_row_of_table_label_value.1104: table_id '${table_id}' not a natural number."
    }
    return $row_list
}

ad_proc -public qss_tips_rows_read {
    table_id
    row_ids_list
} {
    Reads rows from table_id as a list of lists. 
    <br>
    The first row consists of a list of ordered field (ie column) labels for subsequent lists.
    <br>
    <code>row_ids_list</code> is a list of row_ids of table_id.
    <br>
    Returns empty list if table not found.
} {
    upvar 1 instance_id instance_id
    set rows_lists [list ]
    if { [qf_is_natural_number $table_id] && [hf_natural_number_list_validate $row_ids_list] } {
        set count [qss_tips_field_defs_maps_set $table_id "" "" type_arr label_arr "" labels_list]
        if { $count > 0  } {
            lappend rows_lists $labels_list
            set db_sql "select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values \
                where table_id=:table_id \
                and instance_id=:instance_id \
                and trashed_p!='1' \
                and row_id in ([template::util::tcl_to_sql_list $row_id_list])"
            set values_lists [db_list_of_lists qss_tips_field_values_r_mult $db_sql]
            set values_lists [lsort -integer -index 1 $values_lists]
            set row_id [lindex [lindex $values_lists 0] 1]
            set row_id_prev $row_id
            set row_list [list ]
            foreach row $values_lists {
                foreach {field_id row_id f_vc1k f_nbr f_txt} $row {
                    if { [info exists type_arr(${field_id}) ] } {
                        set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                    } else {
                        ns_log Warning "qss_tips_read_from_id.848: field_id does not have a field_type. \
 table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
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
    Reads a row from table_id as a name_value_list of field_label1 field_value1 field_label2 field_label2..
} {
    upvar 1 instance_id instance_id
    set row_list [list ]
    if { [qf_is_natural_number $table_id ] } {
        set count [qss_tips_field_defs_maps_set $table_id "" "" type_arr label_arr field_ids_list ]
        if { $count > 0 } {
            set db_sql {
                select field_id, row_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
                where table_id=:table_id
                and row_id=:row_id
                and instance_id=:instance_id
                and trashed_p!='1'}
            set values_lists [db_list_of_lists qss_tips_field_values_r $db_sql]
            set used_fields_list [list ]
            foreach row $values_lists {
                foreach {field_id row_id f_vc1k f_nbr f_txt} $row {
                    if { [info exists type_arr(${field_id}) ] } {
                        set v [qss_tips_value_of_field_type $type_arr(${field_id}) $f_nbr $f_txt $f_vc1k]
                    } else {
                        ns_log Warning "qss_tips_row_read.848: field_id does not have a field_type. \
 table_label '${table_label}' field_id '${field_id}' row_id '${row_id}'"
                    }
                    # label $label_arr(${field_id})
                    lappend row_list $label_arr(${field_id}) $v
                    lappend used_fields_list $field_id
                }
            }
            set_difference_named_v field_ids_list $used_fields_list
            foreach field_id $field_ids_list {
                lappend row_list $label_arr(${field_id}) ""
            }
        }
    }
    return $row_list
}

ad_proc -public qss_tips_row_trash {
    table_id
    row_id
} {
    Trashes a record of table_id. 
    <br>
    Returns 1 if successful, otherwise 0.
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
    vc1k_search_label_val_list
    return_vals_labels_list
    {if_multiple "1"}
    {row_id_var_name __row_id}
} {
    Returns the values of the field labels in return_val_label_list in order in list.
    <br><br>
    If more than one record matches search_value for search_label, if_multiple
    determines which one is chosen; 
    <br><br>
    If present, returns the row_id to the variable called row_id_var_name. 
    <br>
    @see qss_tips_row_of_table_label_value 
} {
    upvar 1 instance_id instance_id
    upvar 1 $row_id_var_name row_id
    set return_val_list [list ]
    set return_val_label_list [qf_listify $return_vals_labels_list]
    set return_val_label_list_len [llength $return_val_label_list]
    if { $return_val_label_list_len > 0 } {
        set table_id [qss_tips_table_id_of_label $table_label]
        if { $table_id ne "" } {
            set label_value_list [qss_tips_row_of_table_label_value $table_id $vc1k_search_label_val_list $if_multiple row_id]
            set row_labels_list [dict keys $label_value_list]
            foreach label $return_val_label_list {
                if { $label in $row_labels_list } {
                    set label_val [dict get $label_value_list $label]
                } else {
                    set label_val ""
                }
                lappend return_val_list $label_val
            } 
        } else {
            ns_log Notice "qss_tips_cell_read.1327: table_label not found '${table_label}'"
        }
    } else {
        ns_log Notice "qss_tips_cell_read.1329: No cell labels requested; \
 No cell values to return for table_label '${table_label}'."
    }
    
    # if label_val_label_list is one entry,  return a list element only
    if { $return_val_label_list_len == 1 } {
        if { [llength $return_val_list] == 0 } {
            set return_val ""
        } else {
            set return_val [lindex $return_val_list 0]
        }
    } else {
        set return_val $return_val_list
    }
    return $return_val
}

ad_proc -private qss_tips_cell_id_exists_q {
    table_id
    row_id
    field_id
} {
    Returns 1 if cell exists, otherwise returns 0.
} {
    upvar 1 instance_id instance_id
    set db_sql {
        select f_vc1k, f_nbr, f_txt from qss_tips_field_values
        where row_id=:row_id
        and field_id=:field_id
        and table_id=:table_id
        and instance_id=:instance_id
        and trashed_p!='1'}
    set exists_p [db_0or1row qss_tips_field_values_c1_by_id $db_sql]
    return $exists_p
}

ad_proc -public qss_tips_cell_read_by_id {
    table_id
    row_id
    field_id_list
} {
    Returns the values of fields in field_id_list in same order as field_id(s) in list.
    <br>
    Field_ids without values return empty string.
    <br>
    Returns the same number of elements in a list as there are in field_id_list.
} {
    upvar 1 instance_id instance_id
    set return_value_list [list ]
    if { [hf_natural_number_list_validate $field_id_list] } {
        set field_id_list_len [llength $field_id_list]
        set db_sql "\
    select field_id,f_vc1k,f_nbr,f_txt from qss_tips_field_values \
    where row_id=:row_id \
        and table_id=:table_id \
        and instance_id=:instance_id \
        and trashed_p!='1' \
    and field_id in ([template::util::tcl_to_sql_list $field_id_list]) "
        set field_id_values_lists [db_list_of_lists qss_tips_cell_read_by_id $db_sql]
        ns_log Notice "qss_tips_cell_read_by_id field_id_values_lists '${field_id_values_lists}'"
        foreach row_list $field_id_values_lists {
            foreach {field_id f_vc1k f_nbr f_txt} $row_list {
                # It's faster to assume one value, than query db for field_type
                set field_value [qal_first_nonempty_in_list [list $f_vc1k $f_nbr $f_txt] ]
                set v_arr(${field_id}) $field_value
                ns_log Notice "qss_tips_cell_read_by_id.1384 field_id '$field_id' field_value '${field_value}'"
            }
        }
        ns_log Notice "qss_tips_cell_read_by_id.1387 field_id_list '${field_id_list}'"
        foreach field_id $field_id_list {
            set field_value ""
            ns_log Notice "qss_tips_cell_read_by_id.1390: field_id '${field_id}'"
            if { [info exists v_arr(${field_id}) ] } {
                lappend return_value_list $v_arr(${field_id})
            } else {
                ns_log Notice "qss_tips_cell_read_by_id.1394: field_id '${field_id}' \
 not found for row '${row_id}'"
                lappend return_value_list ""
            }
        }
        ns_log Notice "qss_tips_cell_read_by_id.1396 return_value_list '${return_value_list}'"
    } else {
        ns_log Notice "qss_tips_cell_read_by_id.1395 field_id_list did not validate \
 '${field_id_list}' for table_id '${table_id}'"
        set field_id_list_len 0
    } 
    # if label_val_label_list is one entry,  return a list element only
    if { $field_id_list_len == 1 } {
        if { [llength $return_value_list] == 0 } {
            set return_val ""
        } else {
            set return_val [lindex $return_value_list 0]
        }
    } else {
        set return_val $return_value_list
    }
    return $return_val
}

ad_proc -public qss_tips_cell_update {
    table_id
    row_id
    field_id
    new_value
} {
    Updates a cell value.
} {
    upvar 1 instance_id instance_id
    set success_p 0
    #set field_info_list \[qss_tips_field_def_read $table_id "" $field_id\]
    #ns_log Notice "qss_tips_cell_update.1373: field_info_list '${field_info_list}'"
    #if llength $field_info_list > 0 
    set exists_p [db_0or1row qss_tips_field_def_read_ft {
        select field_type from qss_tips_field_defs
        where instance_id=:instance_id
        and table_id=:table_id
        and id=:field_id
        and trashed_p!='1'}]
    if { $exists_p } {
        #set field_type \[lindex \[lindex $field_info_list 0\] 5\]
        qss_tips_set_by_field_type $field_type $new_value f_nbr f_txt f_vc1k
        qss_tips_user_id_set
        set trashed_p 0
        db_transaction {
            set success_p [qss_tips_cell_trash $table_id $row_id $field_id ]
            db_dml qss_tips_field_values_row_up_1f { insert into qss_tips_field_values
                (instance_id,table_id,row_id,trashed_p,created,user_id,field_id,f_vc1k,f_nbr,f_txt)
                values (:instance_id,:table_id,:row_id,:trashed_p,now(),:user_id,:field_id,:f_vc1k,:f_nbr,:f_txt)
            }
        }
    }
    return $success_p
}

ad_proc -public qss_tips_cell_trash {
    table_id
    row_id
    field_id
} {
    @return 1 if successful, otherwise 0
} {
    upvar 1 instance_id instance_id
    set exists_p [qss_tips_cell_id_exists_q $table_id $row_id $field_id]
    if { $exists_p } {
        qss_tips_user_id_set
        db_dml qss_tips_field_values_cell_trash { update qss_tips_field_values
            set trashed_p='1',trashed_by=:user_id,trashed_dt=now()
            where instance_id=:instance_id
            and table_id=:table_id
            and row_id=:row_id
            and field_id=:field_id }
    }
    return $exists_p
}
