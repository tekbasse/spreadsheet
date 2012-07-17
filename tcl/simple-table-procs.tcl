ad_library {

    API for the qss_simple_table 
    @creation-date 15 May 2012
    @cs-id $Id:
}

ad_proc -public qss_table_create { 
    cells_list_of_lists
    name
    title
    comments
    {template_id ""}
    {flags ""}
    {instance_id ""}
    {user_id ""}
} {
    Creates simple table. returns table_id, or 0 if error. instance_id is usually package_id
} {

#code.  Be sure to check permissions

#CREATE TABLE qss_simple_table (
#        id integer not null primary key,
#        instance_id integer,
#        -- object_id of mounted instance (context_id)
#        user_id integer,
#        -- user_id of user that created spreadsheet
#        name varchar(40),
#        title varchar(80),
#        cell_count integer,
#        row_count integer,
#        trashed varchar(1),
#        popularity integer,
#        flags varchar(12),
#        last_modified timestamptz,
#        created timestamptz,
#        comments text
#     );    

#    CREATE TABLE qss_simple_cells (
#        table_id integer not null,
#        --  should be a value from qss_simple_table.id
#        -- no need to track revisions. Each table is a new revision.
#        cell_rc varchar(20) not null, 
#        cell_value varchar(1025)
#        -- user input value
#        );
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set create_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege create]
    ns_log Notice "qss_table_create: create_p $create_p with raw rows cells_list_of_lists [llength $cells_list_of_lists]"
    if { $create_p } {
        set table_id [db_nextval qss_simple_id_seq]
        ns_log Notice "qss_table_create: new table_id $table_id"
        set table_exists_p [db_0or1row simple_table_get_id {select name from qss_simple_table where id = :table_id } ]
        if { !$table_exists_p } {
            if { $template_id eq "" } {
                set template_id $table_id
            }
            db_transaction {
                db_dml simple_table_create { insert into qss_simple_table
                    (id,template_id,name,title,comments,instance_id,user_id)
                    values (:table_id,:template_id,:name,:title,:comments,:instance_id,:user_id) }
                set row 0
                set cells 0
                foreach row_list $cells_list_of_lists {
                    incr row
                    set column 0
                    foreach cell_value $row_list {
                        incr column
                        incr cells
                        set cell_rc "r[string range "0000" 0 [expr { 3 - [string length $row] } ] ]${row}c[string range "0000" 0 [expr { 3 - [string length $column] } ] ]${column}"
                        # if cell_value has length of zero, then don't insert
                        if { [string length $cell_value] > 0 } {
#ns_log Notice "qss_table_create: cell_rc $cell_rc cell_value $cell_value"
                            db_dml qss_simple_cells_create { insert into qss_simple_cells
                                (table_id,cell_rc,cell_value)
                                values (:table_id,:cell_rc,:cell_value)
                            }
                        }
                    }
                }
ns_log Notice "qss_table_create: total $row rows, $cells cells"
                db_dml simple_table_update_rc { update qss_simple_table
                    set row_count =:row,cell_count =:cells
                    where id = :table_id }

            } on_error {
                set table_id 0
                ns_log Error "qss_table_create: general psql error during db_dml"
            }
        } else {
            set table_id 0
            ns_log Warning "qss_table_create: table already exists for table_id $table_id"
        }
    }
    return $table_id
}

ad_proc -public qss_table_stats { 
    table_id
    {instance_id ""}
    {user_id ""}
} {
    Returns table stats as a list: name, title, comments, cell_count, row_count, template_id, flags, trashed, popularity, time last_modified, time created, user_id.
    Columns not listed, as those might vary.
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    # check permissions
    set read_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege read]

    if { $read_p } {
        set return_list_of_lists [db_list_of_lists simple_table_stats { select name, title, comments, cell_count, row_count, template_id, flags, trashed, popularity, last_modified, created, user_id from qss_simple_table where id = :table_id and instance_id = :instance_id } ] 
        # convert return_lists_of_lists to return_list
        set return_list [lindex $return_list_of_lists 0]
        
    } else {
        set return_list [list ]
    }
    return $return_list
}

ad_proc -public qss_tables { 
    {instance_id ""}
    {user_id ""}
    {template_id ""}
} {
    Returns a list of table_ids available. If table_id is included, the results are scoped to tables with same template. If user_id is included, the results are scoped to the user.
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set party_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    } else {
        set party_id $user_id
    }
    set read_p [permission::permission_p -party_id $party_id -object_id $instance_id -privilege read]

    if { $read_p } {
        if { $template_id eq "" } {
            if { $user_id ne "" } {
                set return_list [db_list simple_tables_user_list { select id from qss_simple_table where instance_id = :instance_id and user_id = :user_id } ]
            } else {
                set return_list [db_list simple_tables_list { select id from qss_simple_table where instance_id = :instance_id } ]
            }
        } else {
            set has_template [db_0or1row simple_table_template "select template_id as db_template_id from qss_simple_table where template_id= :template_id"]
            if { $has_template && [info exists db_template_id] && $template_id > 0 } {
                if { $user_id ne "" } {
                    set return_list [db_list simple_tables_t_u_list { select id from qss_simple_table where instance_id = :instance_id and user_id = :user_id and template_id = :template_id } ]
                } else {
                    set return_list [db_list simple_tables_list { select id from qss_simple_table where instance_id = :instance_id and template_id = :template_id } ]
                }
            } else {
                set return_list [list ]
            }
        }
    } else {
        set return_list [list ]
    }
    return $return_list
} 

ad_proc -public qss_table_read { 
    table_id
    {instance_id ""}
    {user_id ""}
    
} {
    Reads table with id. Returns table as list_of_lists of cells.
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set read_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege read]
    set cells_list_of_lists [list ]
    if { $read_p } {

        set cells_data_lists [db_list_of_lists qss_simple_cells_table_read { select cell_rc, cell_value from qss_simple_cells
            where table_id =:table_id order by cell_rc } ]

        set prev_row "0001"
        set row_list [list ]
        foreach cell_list $cells_data_lists {
            set cell_rc [lindex $cell_list 0]
            set cell_value [lindex $cell_list 1]

            # following based on "0000" format used in create/write cell_rc r0001c0001
            set row [string range $cell_rc 1 4]
            set column [string range $cell_rc 6 9]
#            ns_log Notice "qss_table_read: cell ${cell_rc} ($row,$column) value ${cell_value}"     
            # build row list
            if { $row eq $prev_row } {
                # add cell to same row
                set column_next [expr { [llength $row_list ] + 1 } ]
                set cols_to_add [expr { $column - $column_next } ]
                # add blank cells, if needed
                for {set i 1} {$i < $cols_to_add} {incr i } {
                    lappend row_list ""
                }
                lappend row_list $cell_value
            } else {
                # row finished, add row_list to cells_list_of_lists
                lappend cells_list_of_lists $row_list
                # start new row
                set row_list [list $cell_value]
            }
            set prev_row $row
        }
        lappend cells_list_of_lists $row_list
    }
    return $cells_list_of_lists
}

ad_proc -public qss_table_write {
    cells_list_of_lists
    name
    title
    comments
    table_id
    {template_id ""}
    {flags ""}
    {instance_id ""}
    {user_id ""}
} {
    Writes a simple table.
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set write_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege write]
    if { $write_p } {
        set table_exists_p [db_0or1row simple_table_get_id {select user_id as creator_id from qss_simple_table where id = :table_id } ]
        if { $table_exists_p } {
        
            db_transaction {
                db_dml simple_table_update { update qss_simple_table
                    set name =:name,title =:title,comments=:comments 
                    where id = :table_id and instance_id=:instance_id and user_id=:user_id }
                
                # get list of cell_rc referencs in this table. We need to track updates, and delete any remaining ones.
                set cells_list [db_list simple_table_cells_list {select cell_rc from qss_simple_cells where table_id =:table_id } ]
                set cells 0
                set row 0
                foreach row_list $cells_list_of_lists {
                    incr row
                    set column 0
                    foreach cell_value $row_list {
                        incr cells
                        incr column
                        set cell_rc "r[string range "0000" 0 [expr { 3 - [string length $row] } ] ]${row}c[string range "0000" 0 [expr { 3 - [string length $column] } ] ]${column}"
                        set cell_idx [lsearch -exact $cells_list $cell_rc]
                        set cell_length [string length $cell_value]
#          ns_log Notice "qss_table_write: row $row column $column cell_rc $cell_rc cell_idx $cell_idx cell_length $cell_length"
                        # if cell_value has length of zero, then don't update. It will get deleted if it already exists..
                        if { $cell_idx > -1 && $cell_length > 0 } {
                            db_dml qss_simple_cells_update { update qss_simple_cells 
                                set cell_value=:cell_value 
                                where table_id =:table_id and cell_rc =:cell_rc }
                            
                            # remove cell from cell_list, so that we can delete remaining old cells
                            set cells_list [lreplace $cells_list $cell_idx $cell_idx]
                            
                        } elseif { $cell_length > 0 } {
                            db_dml qss_simple_cells_create { insert into qss_simple_cells
                                (table_id,cell_rc,cell_value)
                                values (:table_id,:cell_rc,:cell_value)
                            }
                        }
                    }
                }
                db_dml simple_table_update_rc { update qss_simple_table
                    set row_count =:row,cell_count =:cells
                    where id = :table_id }

                # delete remaining cells in cells_list from qss_simple_cells
                foreach cell_rc $cells_list {
                    db_dml qss_simple_cells_delete { delete from qss_simple_cells
                        where table_id =:table_id and cell_rc=:cell_rc }
                }
                
            } on_error {
                set success 0
                ns_log Error "qss_table_write: general db error during db_dml"
            }
        } else {
            set success 0
            ns_log Warning "qss_table_write: no table exists for table_id $table_id"
        }

        set success 1
    } else {
        set success 0
    }
    return $success
}


ad_proc -public qss_table_delete {
    {table_id ""}
    {instance_id ""}
    {user_id ""}
} {
    Table_id can be a list of table_id's. Deletes table_id (subject to permission check).
    Returns 1 if deleted. Returns 0 if there were any issues.
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set delete_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege delete]
    set success $delete_p
    if { $delete_p } {
        db_transaction {
            db_dml simple_table_delete { delete from qss_simple_table 
                where id=:table_id and instance_id =:instance_id and user_id=:user_id }
            
            db_dml qss_simple_cells_delete_table { delete from qss_simple_cells
                where table_id =:table_id }
            set success 1
        } on_error {
            set success 0
            ns_log Error "qss_table_delete: general db error during db_dml"
        }
    }
        
    return $success
}

ad_proc -public qss_table_trash {
    {trash_p "1"}
    {table_id ""}
    {instance_id ""}
    {user_id ""}
} {
    Table_id can be a list of table_id's. Trashes/untrashes table_id (subject to permission check).
    set trash_p to 1 (default) to trash table. Set trash_p to '0' to untrash. 
    Returns 1 if successful, otherwise returns 0
} {
    if { $instance_id eq "" } {
        # set instance_id package_id
        set instance_id [ad_conn package_id]
    }
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
        set untrusted_user_id [ad_conn untrusted_user_id]
    }
    set delete_p [permission::permission_p -party_id $user_id -object_id $instance_id -privilege delete]
    if { $delete_p } {
        if { $trash_p } {
            db_dml simple_table_trash_tog { update qss_simple_table set trashed = '1'
                where id=:table_id and instance_id =:instance_id and user_id=:user_id }
        } else {
            db_dml simple_table_trash_tog { update qss_simple_table set trashed = '0'
                where id=:table_id and instance_id =:instance_id and user_id=:user_id }
        }
    }
    return $delete_p
}

