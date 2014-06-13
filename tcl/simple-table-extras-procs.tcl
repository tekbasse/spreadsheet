ad_library {

    API extras for qss_simple_table 
    @creation-date 26 May 2014
    @cs-id $Id:
}

ad_proc -public qss_tables_are_equiv_p {
    table_1_lists
    table_2_lists
} {
    Returns 1 if columns and data between tables are equivalent, but maybe differ in column order. Otherwise returns 0.
} {
    if { $table_1_lists eq $table_2_lists } {
        set equiv_p 1
    } else {
        set equiv_p 0
        set titles_1_list [lsort [lindex $table_1_lists 0]]
        set titles_2_list [lsort [lindex $table_2_lists 0]]
        if { $titles_1_list eq $titles_2_list } {
            # check row data in order, column by column
            set table_1_rows [llength $table_1_lists]
            set table_2_rows [llength $table_2_lists]
            set equiv_p [expr { $table_1_rows == $table_2_rows } ]
            set col_idx 0
            set col_count [llength $titles_1_list]
            set column [lindex $titles_1_list $col_idx]
            while { $equiv_p == 1 && $col_idx < $col_count } {
                set t1_idx [lsearch -exact $table_1_lists $column]
                set t2_idx [lsearch -exact $table_2_lists $column]
                set row_num 1
                while { $equiv_p == 1 && $row_num < $table_1_rows } {
                    set t1_val [lindex [lindex $table_1_lists $row_num] $t1_idx]
                    set t2_val [lindex [lindex $table_2_lists $row_num] $t2_idx]
                    set equiv_p [expr { ( $t1_val eq $t2_val )  } ]
                    incr row_num
                }
                incr col_idx
                set column [lindex $titles_1_list $col_idx]
            }
        }
    }
    return $equiv_p
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
        set table_stats_list [qss_table_stats $table_id $instance_id $user_id]
        # name, title, comments, cell_count, row_count, template_id, flags, trashed, popularity, time last_modified, time created, user_id.
        set table_base_name [lindex $table_stats_list 0]
        set table_title [lindex $table_stats_list 1]
        set table_template_id [lindex $table_stats_list 5]
        set table_flags [lindex $table_stats_list 6]
        set table_comments "Split from '${table_title}' (${table_base_name})"
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
            lappend p_table_lists $row_list
            set title $table_title
            set name $table_base_name
            set suffix "-"
            append suffix $col_val_prev
            append name $suffix
            append title $suffix
            set comments $table_comments
            append comments " @ ${column_name}: ${col_val_prev}"
            foreach row_list [lrange $table_lists 2 end] {
                set col_val [lindex $row_list $column_name_idx]
                if { $col_val ne $col_val_prev } {
                    # if value changes, create save table_name old_column_value, start collecting new
                    set table_id [qss_table_create $p_table_lists $name $title $comments $table_template_id $table_flags $instance_id $user_id]
                    ns_log Notice "qss_table_split.59: new table_id $table_id"
                    set p_table_lists [list ]
                    lappend p_table_lists $title_row
                    lappend p_table_lists $row_list
                    set title $table_title
                    set name $table_base_name
                    set suffix "-"
                    append suffix $col_val
                    append name $suffix
                    append title $suffix
                    set comments $table_comments
                    append comments " @ ${column_name}: ${col_val}"
                } else {
                    # add row to existing partial table
                    lappend p_table_lists $row_list

                }
                set col_val_prev $col_val
            }
            if { [llength $p_table_lists] > 1 } {
                # save final split
                set table_id [qss_table_create $p_table_lists $name $title $comments $table_template_id $table_flags $instance_id $user_id]
                ns_log Notice "qss_table_split.76: new table_id $table_id"
            }
        }
    }
}


