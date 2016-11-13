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
            set instance_id [ad_conn package_id]            
# create a scenario to test this api:



# # #
# table definitions
            set flags "test"
            set i 1
            while { ${i} < 4 } {
                # setup table def
                set word_count [randomRange 10]
                incr word_count
                set title [qal_namelur $word_count]
                set labelized [string tolower $title]
                regsub -all { } $labelized {_} labelized
                if { $labelized eq "" } {
                    incr word_count
                    set labelized [ad_generate_random_string $word_count]
                }
                set t_label_arr(${i}) $labelized
                set t_name_arr(${i}) $title
                set t_flags_arr(${i}) $flags
                set t_trashed_p_arr(${i}) 0

                set t_id_arr(${i}) [qss_tips_table_def_create $labelized $title $flags]
                if { $t_id_arr(${i}) ne "" } {
                    set t_id_exists_p 1
                } else {
                    set t_id_exists_p 0
                }
                aa_true "Test.${i} table def. created table_id '$t_id_arr(${i})' label '${labelized}' title ${title}" $t_id_exists_p
                set t_larr(${i}) [qss_tips_table_def_read_by_id $t_id_arr(${i})] 
                set t_i_id ""
                set t_i_label ""
                set t_i_name ""
                set t_i_flags ""
                set t_i_trashed_p ""
                foreach {t_i_id t_i_label t_i_name t_i_flags t_i_trashed_p} $t_larr(${i}) {
                    # set vars
                }
                aa_equals "Test.${i} table def. create/read id" $t_i_id $t_id_arr(${i})
                aa_equals "Test.${i} table def. create/read label" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                set tin_max [expr { [string length $t_i_name] - 3 } ]
                aa_equals "Test.${i} table def. create/read name" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                aa_equals "Test.${i} table def. create/read flags" $t_i_flags $t_flags_arr(${i})
                aa_equals "Test.${i} table def. create/read trashed_p" $t_i_trashed_p $t_trashed_p_arr(${i})
                if { ${i} == 1 } {
                    set success_p [qss_tips_table_def_trash $t_i_id]
                    aa_true "Test.${i} table def. trashed ok" $success_p
                }
                if { ${i} == 2 } {
                    set word_count [randomRange 10]
                    incr word_count
                    set title [qal_namelur $word_count]
                    set labelized [string tolower $title]
                    regsub -all { } $labelized {_} labelized
                    if { $labelized eq "" } {
                        incr word_count
                        set labelized [ad_generate_random_string $word_count]
                    }
                    set t_label_arr(${i}) $labelized
                    set t_name_arr(${i}) $title
                    set t_flags_arr(${i}) $flags
                    set t_trashed_p_arr(${i}) 0
                    
                    qss_tips_table_def_update $t_i_id label $labelized name $title flags $flags
                    set t_larr(${i}) [qss_tips_table_def_read_by_id $t_id_arr(${i})]
                    set t_i_id ""
                    set t_i_label ""
                    set t_i_name ""
                    set t_i_trashed_p ""
                    foreach {t_i_id t_i_label t_i_name t_i_flags t_i_trashed_p} $t_larr(${i}) {
                        # set vars
                    }
                    aa_equals "Test.${i} table def. update/read label by param" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                    set tin_max [expr { [string length $t_i_name] - 3 } ]
                    aa_equals "Test.${i} table def. update/read name by param" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                    aa_equals "Test.${i} table def. update/read flags by param" $t_i_flags $t_flags_arr(${i})
                    aa_equals "Test.${i} table def. update/read trashed_p by param" $t_i_trashed_p $t_trashed_p_arr(${i})
                    
                }
                if { ${i} == 3 } {
                    set word_count [randomRange 10]
                    incr word_count
                    set title [qal_namelur $word_count]
                    set labelized [string tolower $title]
                    regsub -all { } $labelized {_} labelized
                    if { $labelized eq "" } {
                        incr word_count
                        set labelized [ad_generate_random_string $word_count]
                    }
                    set t_label_arr(${i}) $labelized
                    set t_name_arr(${i}) $title
                    set t_flags_arr(${i}) $flags
                    set t_trashed_p_arr(${i}) 0
                    
                    qss_tips_table_def_update $t_i_id [list label $labelized name $title flags $flags]
                    set t_larr(${i}) [qss_tips_table_def_read_by_id $t_id_arr(${i})]
                    set t_i_id ""
                    set t_i_label ""
                    set t_i_name ""
                    set t_i_trashed_p ""
                    foreach {t_i_id t_i_label t_i_name t_i_flags t_i_trashed_p} $t_larr(${i}) {
                        # set vars
                    }
                    aa_equals "Test.${i} table def. update/read label by list" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                    set tin_max [expr { [string length $t_i_name] - 3 } ]
                    aa_equals "Test.${i} table def. update/read name by list" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                    aa_equals "Test.${i} table def. update/read flags by list" $t_i_flags $t_flags_arr(${i})
                    aa_equals "Test.${i} table def. update/read trashed_p by list" $t_i_trashed_p $t_trashed_p_arr(${i})
                }

                incr i
            }
            incr i -1
            set exists_p [qss_tips_table_id_exists_q $t_i_id]
            aa_true "Test.${i} table def. exists_q" $exists_p
            # we have to grab t_i_label to test because create may have modified label..
            set table_list [qss_tips_table_def_read_by_id $t_i_id]
            set t_i_label [lindex $table_list 1]
            set test_t_id [qss_tips_table_id_of_label $t_i_label]
            aa_equals "Test.${i} table_id_of_label" $test_t_id $t_i_id



# # #
# field definitions

            # initializations (create table)
            incr i
            set word_count [randomRange 10]
            incr word_count
            set title [qal_namelur $word_count]
            set labelized [string tolower $title]
            regsub -all { } $labelized {_} labelized
            if { $labelized eq "" } {
                incr word_count
                set labelized [ad_generate_random_string $word_count]
            }
            set t_label_arr(${i}) $labelized
            set t_name_arr(${i}) $title
            set t_flags_arr(${i}) $flags
            set t_trashed_p_arr(${i}) 0
            set t_id_arr(${i}) [qss_tips_table_def_create $labelized $title $flags]
            set j 0
            set field_defs_by_ones_list [list ]
            foreach field_type [list txt vc1k nbr] {
                incr j
                set name [qal_namelur 2]
                regsub -all { } [string tolower $name] {_} label
                set f_name_arr($j) $name
                set f_label_arr($j) $label
                set f_field_type_arr($j) $field_type
                set f_tdt_data_type_arr($j) ""
                set f_default_value_arr($j) ""
#  qss_tips_field_def_create
                set f_def_id [qss_tips_field_def_create table_id $t_id_arr(${i}) label $label name $name field_type $field_type]
                if { [qf_is_natural_number $f_def_id] } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i}-${j} field_def created label ${label} of type ${field_type} for table_id '$t_id_arr(${i})'" $success_p
#  qss_tips_field_def_read
                set f_def1_list [qss_tips_field_def_read $t_id_arr(${i}) "" $f_def_id]
                set f_def2_list [qss_tips_field_def_read $t_id_arr(${i}) $label]
                if { $f_def1_list eq $f_def2_list } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i}-${j} field_def read via label ${label} VS. via field_id matches" $success_p
                lappend field_defs_by_ones_list $f_def_id
            }
            #  field_id,label,name,default_val,tdt_data_type,field_type or empty list if not found
            set f_def_lists [qss_tips_field_def_read $t_id_arr(${i}) ]
            set f_def_lists_len [llength $f_def_lists]
            set field_defs_by_ones_list_len [llength $field_defs_by_ones_list]
            aa_equals "Test.${i}. qss_tips_field_def_read. Quantity of all same as adding each one" $f_def_lists_len $field_defs_by_ones_list_len
            foreach f_list $f_def_lists {
                set f_def_id_ck [lindex $f_list 0]
                if { $f_def_id_ck in $field_defs_by_ones_list } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i} field_def_id from limit read in bulk read also" $success_p
            }
#  qss_tips_field_def_update  (change the field labels to something predictable)
# qss_tips_field_def_read to confirm
#  qss_tips_field_def_create some new ones
# qss_tips_field_def_read to confirm
#  qss_tips_field_def_trash the new ones
# qss_tips_field_def_read to confirm



#  qss_tips_field_defs_maps_set  (Ignore, because this is intrinsic to other proc operations)
#  qss_tips_field_id_name_list
#  qss_tips_field_label_name_list


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



            
            ns_log Notice "tcl/test/q-control-procs.tcl.429 test end"
        } \
        -teardown_code {

        }
    #aa_true "Test for .." $passed_p
    #aa_equals "Test for .." $test_value $expected_value


}
