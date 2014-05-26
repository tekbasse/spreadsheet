ad_library {

    API extras for qss_simple_table 
    @creation-date 26 May 2014
    @cs-id $Id:
}

ad_proc -public qss_table_split { 
    table_id
    column_name
    {instance_id ""}
    {user_id ""}
} {
    Splits a simple table by creating new tables whenever value in column_name changes. Table names are given the name of the original table with the value of the column appended (with a dash separator). Returns a list of the new table_ids, or empty list if no tables created.
} {

#code.  Be sure to check permissions

    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set create_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege create]
    if { $create_p & $column_name ne "" } {
        # read table_tid
        set table_lists [qss_table_read $table_id $instance_id $user_id ]
        # identify column_name_idx
        set title_row [lindex $table_lists 0]
        # if column_name_idx exists, loop through all rows
        set column_name_idx [lsearch -exact $title_row $column_name]
        if { $column_name_idx > -1 } {
            set row_list [lindex $table_lists 1]
            set col_val_prev [lindex $row_list $column_name_idx]
            set p_table_lists [list ]
            lappend p_table_lists $title_row
            foreach row_list [lrange $table_lists 2 end] {
                set col_val [lindex $row_list $column_name_idx]
                if { $col_val <> $col_val_prev } {
                    # if value changes, create save table_name old_column_value, start collecting new

                    ns_log Notice "qss_table_split: new table_id $table_id"
                } else {
                    # add row to existing partial table
                    lappend p_table_lists $row_list
                }
            }
        }
    }
}


