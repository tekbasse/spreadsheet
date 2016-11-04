ad_library {
    Automated tests for spreadsheet qss_tips_* procedures
    @creation-date 20161104
}

aa_register_case -cats {api smoke} qss_tips_check {
    Test api for tips procs ie qss_tips_*
} {
    aa_run_with_teardown \
        -test_code {
# -rollback \
            ns_log Notice "tcl/test/tips-procs.tcl.12: test begin"
            
# create a scenario to test this api:



# # #
# table definitions
#  qss_tips_table_def_create
#  qss_tips_table_def_read
#  qss_tips_table_def_trash
#  qss_tips_table_def_update
#  qss_tips_table_id_exists_q
#  qss_tips_table_id_of_label


# # #
# create
# read
# update
# trash
# read
# create


# # #
# field definitions
#  qss_tips_field_def_create
#  qss_tips_field_def_read
#  qss_tips_field_def_trash
#  qss_tips_field_def_update
#  qss_tips_field_defs_maps_set
#  qss_tips_field_id_name_list
#  qss_tips_field_label_name_list

# create
# read
# update
# trash
# read
# create


# # # 
# data rows
#  qss_tips_row_create
#  qss_tips_row_id_exists_q
#  qss_tips_row_id_of_table_label_value
#  qss_tips_row_read
#  qss_tips_row_trash
#  qss_tips_row_update
#  qss_tips_rows_read
# create
# read
# update
# read
# trash
# read

# # #
# cells
#  qss_tips_cell_read
#  qss_tips_cell_read_by_id
#  qss_tips_cell_trash
#  qss_tips_cell_update
# read
# update
# read
# trash
# read
# read modified row and check for consistency

# table read, compare to existing
#  qss_tips_table_read

# table read as array, compare to existing
#  qss_tips_table_read_as_array


            set instance_id [ad_conn package_id]
            
            ns_log Notice "tcl/test/q-control-procs.tcl.429 test end"
        } \
        -teardown_code {

        }
    #aa_true "Test for .." $passed_p
    #aa_equals "Test for .." $test_value $expected_value


}
