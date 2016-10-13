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
    array indexes are name_array(field_name,row_number)
    where row_number starts with 0.
    If trashed_p is 0, returns only records that are untrashed.
} {
    upvar 1 instance_id instance_id
    upvar 1 $name_array n_arr
    set table_id ""
    db_0or1_row qss_tips_table_defs_r1 {select id as table_id,label,name,flags,trashed_p from qss_tips_table_defs
        where label=:table_name
        and instance_id=:instance_id}
    if { $table_id ne "" } {
        set fields_lists [db_list_of_lists qss_tips_field_defs_r {select id as field_id,label,field_type from qss_tips_field_defs
            where instance_id=:instance_id
            and table_id=:table_id}]
        if { [llength $fields_lists ] > 0 } {
            foreach {field_id label field_type} $fields_lists {
                set type_arr(${field_id}) $field_type
            }

            db_list_of_lists qss_tips_field_values_r "select field_id, f_vc1k, f_nbr, f_txt from qss_tips_field_values 
        where table_id=:table_id
        and instance_id=:instance_id
        and row_id in ([template::util::tcl_to_sql_list $rows])"
        }
    return 1
}

