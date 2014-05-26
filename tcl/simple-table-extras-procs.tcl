ad_library {

    API extras for the qss_simple_table 
    @creation-date 26 May 2014
    @cs-id $Id:
}

ad_proc -public qss_table_split { 
    table_id
    {template_id ""}
    {flags ""}
    {instance_id ""}
    {user_id ""}
} {
    Splits a simple table by creating new tables whenever value in column_name changes. Table names are given the name of the original table with the value of the column appended (with a dash separator). Returns 1 if successful, or 0 if error.
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
            set nowts [dt_systime -gmt 1]
            db_transaction {
                db_dml simple_table_create { insert into qss_simple_table
                    (id,template_id,name,title,comments,instance_id,user_id,flags,last_modified,created)
                    values (:table_id,:template_id,:name,:title,:comments,:instance_id,:user_id,:flags,:nowts,:nowts) }
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
                    set row_count =:row,cell_count =:cells, last_modified=:nowts
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


