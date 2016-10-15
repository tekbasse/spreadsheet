ad_library {

    API for the qss_TIPS api
    @creation-date 12 Oct 2016
    @cs-id $Id:
}

ad_proc -public qss_tips_read {
    name_array
    table_name
    field_name_val_list
    {trashed_p "0"}
} {
    Returns one or more records of table_name as an array
    where field value pairs in field_name_val_list match query.
    array indexes are name_array(row_id,field_label)
    where row_id are in a list in name_array(row_ids)
    If trashed_p is 0, returns only records that are untrashed.
} {
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_id ""
    set success_p 0
    db_0or1_row qss_tips_table_defs_r1 {select id as table_id,label,name,flags,trashed_p from qss_tips_table_defs
        where label=:table_name
        and instance_id=:instance_id}
    if { $table_id ne "" } {
        set fields_lists [db_list_of_lists qss_tips_field_defs_r {select id as field_id,label,field_type from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id}]
        if { [llength $fields_lists ] > 0 } {
            foreach field_list $field_lists {
                foreach {field_id label field_type} $fields_list {
                    set type_arr(${field_id}) $field_type
                    set label_arr(${field_id}) $label
                }
            }
            if { [qf_is_true $trashed_p] } {
                set trashed_sql ""
            } else {
                set trashed_sql "and trashed_p!='1'"
            }
            set values_lists [db_list_of_lists qss_tips_field_values_r "select field_id, f_vc1k, f_nbr, f_txt, row_id from qss_tips_field_values 
        where table_id=:table_id
        and instance_id=:instance_id ${trashed_sql}
        and row_id in ([template::util::tcl_to_sql_list $rows])"]
            # val_i = values initial
            set row_ids_list [list ]
            foreach {field_id f_vc1k f_nbr f_txt row_id} $values_lists {
                lappend row_ids_list $row_id
                # since only one case of field value should be nonempty,
                # following logic could be sped up using qal_first_nonempty_in_list
                if { [info exists type_arr(${field_id}) ] } {
                    switch -exact -- $type_arr(${field_id}) {
                        vc1k { set v $f_vc1k }
                        nbr  { set v $f_nbr }
                        txt  { set v $f_txt }
                        default {
                            ns_log Warning "qss_tips_read.47: unknown type for table_name '${table_name}'  field_id '${field_id}' row_id '${row_id}'"
                        }
                    }
                } else {
                    ns_log Warning "qss_tips_read.54: field_id does not have a field_type. table_name '${table_name}'  field_id '${field_id}' row_id '${row_id}'"
                }
                set label $label_arr(${field_id})
                set n_arr(${label},${row_id}) $v
            }
            set n_arr(row_ids) [lsort -unqiue -integer $row_ids_list]
            if { [llength $values_lists] > 0 } {
                set success_p 1
            }
        }
    }
    return $success_p
}

