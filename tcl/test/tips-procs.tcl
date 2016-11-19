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
                aa_true "Test.${i} field_def_id '${f_def_id_ck}' from single read in bulk read also" $success_p
            }
            foreach f_list $f_def_lists {
                set f_def_id_i [lindex $f_list 0]
                set f_field_type [lindex $f_list 5]
                set name_new $f_field_type
                append name_new "_test"
                set success_p [qss_tips_field_def_update $t_id_arr(${i}) field_id $f_def_id_i name_new $name_new]
                aa_true "Test.${i} field_def_id '${f_def_id_i}' name change to '${name_new}'" $success_p
                set f2_list [qss_tips_field_def_read $t_id_arr(${i}) "" $f_def_id_i ]
                set f2_name [lindex [lindex $f2_list 0] 2]
                if { $f2_name eq $name_new } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i} field_def_id '${f_def_id_i}' confirmed name changed to '${name_new}'" $success_p

                set label_new $f_field_type
                append label_new "_" $f_def_id_i
                set success_p [qss_tips_field_def_update $t_id_arr(${i}) field_id $f_def_id_i label_new $label_new]
                aa_true "Test.${i} field_def_id '${f_def_id_i}' label change to '${label_new}'" $success_p
                set f2_list [qss_tips_field_def_read $t_id_arr(${i}) $label_new ]
                set f2_label [lindex [lindex $f2_list 0] 1]
                if { $f2_label eq $label_new } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i} field_def_id '${f_def_id_i}' confirmed label changed to '${label_new}'" $success_p
            }
            foreach field_type [list txt vc1k nbr] {
                #  qss_tips_field_def_create some new ones
                set label $field_type
                set name [string toupper $field_type]
                set f_def_id [qss_tips_field_def_create table_id $t_id_arr(${i}) label $label name $name field_type $field_type]
                # qss_tips_field_def_read to confirm
                set f_def_list [qss_tips_field_def_read $t_id_arr(${i}) "" $f_def_id]
                set f_def1_list [lindex $f_def_list 0]
                foreach {f_def_id2 label2 name2 default_val2 tdt_data_type2 field_type2} $f_def1_list {
                    # loading vars
                }
                aa_equals "Test.${i}. qss_tips_field_def_create confirm id" $f_def_id2 $f_def_id
                aa_equals "Test.${i}. qss_tips_field_def_create confirm label" $label2 $label
                aa_equals "Test.${i}. qss_tips_field_def_create confirm name" $name2 $name
                aa_equals "Test.${i}. qss_tips_field_def_create confirm default_val" $default_val2 ""
                aa_equals "Test.${i}. qss_tips_field_def_create confirm tdt_data_type" $tdt_data_type2 ""
                aa_equals "Test.${i}. qss_tips_field_def_create confirm field_type" $field_type2 $field_type
            }
            #  qss_tips_field_def_trash the old ones
            set field_id [lindex $field_defs_by_ones_list 0]
            set field_ids_list [lrange $field_defs_by_ones_list 1 end]
            set success1_p [qss_tips_field_def_trash $field_id $t_id_arr(${i})]
            aa_true "Test.${i}. qss_tips_field_def_trash one id '${field_id}'" $success1_p
            set success2_p [qss_tips_field_def_trash $field_ids_list $t_id_arr(${i})]
            aa_true "Test.${i}. qss_tips_field_def_trash list of ids '${field_ids_list}'" $success2_p
            # qss_tips_field_def_read to confirm
            set defs_lists [qss_tips_field_def_read $t_id_arr(${i}) ]
            set success_p 1
            foreach def_list $defs_lists {
                set id [lindex $def_list 0]
                if { $id in $field_defs_by_ones_list } {
                    set success_p 0
                } 
            }
            aa_true "Test.${i}. qss_tips_field_def_trash confirm old ones deleted" $success_p

            #  qss_tips_field_defs_maps_set  (Ignore, because this is intrinsic to other proc operations)
            #  qss_tips_field_id_name_list
            #  qss_tips_field_label_name_list


            # initializations (create table)
            incr i
            set unique [clock seconds]
            set title "Table ${unique}"
            set labelized [string tolower $title]
            regsub -all { } $labelized {_} labelized
            set t_label_arr(${i}) $labelized
            set t_name_arr(${i}) $title
            set t_flags_arr(${i}) $flags
            set t_trashed_p_arr(${i}) 0
            set t_id_arr(${i}) [qss_tips_table_def_create $labelized $title $flags]
            if { $t_id_arr(${i}) > 0 } {
                set success_p 1
            } else {
                set success_p 0
            }
            aa_true "Test.${i}. qss_tips_table_def_create for '${labelized}'" $success_p
            set j 0
            set field_defs_by_ones_list [list ]
            foreach field_type [list txt vc1k nbr] {
                incr j
                set name "Data for "
                append name [string toupper $field_type]
                set label [string tolower $name]
                regsub -all -- { } $label {_} label
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
                lappend field_defs_by_ones_list $f_def_id
            }
            #  field_id,label,name,default_val,tdt_data_type,field_type or empty list if not found

# # # 
# data rows

            set label_value_list [list ]
            set field_label_list [list ]
            # make some data
            for {set j 1} {$j < 4} {incr j} {
                switch -exact $f_field_type_arr($j) {
                    txt {
                        set value [qal_namelur [randomRange 20]]
                    }
                    vc1k {
                        set value [string range [qal_namelur [randomRange 10]] 0 38]
                    }
                    nbr {
                        set value [clock microseconds]
                    }
                }
                set f_value_arr($j) $value
                set label $f_label_arr($j)
                set rowck_arr(1,${label}) $value
                lappend label_value_list $label $value
                lappend field_label_list $label
            }
            #  qss_tips_row_create
            set f_row_id [qss_tips_row_create $t_id_arr(${i}) $label_value_list]
            if { $f_row_id ne "" } {
                set success_p 1
            } else {
                set success_p 0
            }
            aa_true "Test.${i} row created for table_id '$t_id_arr(${i})'" $success_p
            #  qss_tips_row_id_exists_q
            set f_row_id_ck [qss_tips_row_id_exists_q $f_row_id $t_id_arr(${i})]
            aa_true "Test.${i} qss_tips_row_id_exists_q for row_id '${f_row_id}' table_id '$t_id_arr(${i})'" $f_row_id_ck
            #  qss_tips_row_read
            aa_log "Test.${i} qss_tips_row_create fed: '${label_value_list}'"
            set row_list [qss_tips_row_read $t_id_arr(${i}) ${f_row_id}]
            aa_log "Test.${i} qss_tips_row_read results: '${row_list}'"
            foreach {k v} $row_list {
                set row1ck_arr(${k}) $v
            }
            ns_log Notice "test/tips-procs.tcl.357. field_label_list '${field_label_list}'"
            foreach label $field_label_list {
                if { $rowck_arr(1,${label}) eq $row1ck_arr(${label}) } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i} qss_tips_row_read for row_id '${f_row_id}' label '${label}'" $success_p
            }

            # make some more data rows
            set f_row_id_arr(1) $f_row_id
            set label_value_larr(1) $label_value_list
            for {set r 2} {$r < 40} {incr r} {
                set label_value_larr(${r}) [list ]
                for {set j 1} {$j < 4} {incr j} {
                    switch -exact $f_field_type_arr($j) {
                        txt {
                            set value [qal_namelur [randomRange 20]]
                        }
                        vc1k {
                            set value [string range [qal_namelur [randomRange 10]] 0 38]
                        }
                        nbr {
                            set value [clock microseconds]
                        }
                    }
                    set label $f_label_arr($j)
                    # retained values by RC reference:
                    set rowck_arr(${r},${label}) $value
                    lappend label_value_list $label $value
                }
                #  qss_tips_row_create
                set f_row_id_arr(${r}) [qss_tips_row_create $t_id_arr(${i}) $label_value_larr(${r})]
                if { $f_row_id_arr(${r}) ne "" } {
                    set success_p 1
                } else {
                    set success_p 0
                }
                aa_true "Test.${i} row ${r} created for table_id '$t_id_arr(${i})'" $success_p
            }
            # row to check
            set r_ck [randomRange 38]
            incr r_ck
            # to check value, get a label
            set field_label_list_len [llength $field_label_list]
            incr field_label_list_len -1
            # l_idx cannot be random right now. only 1 vc1k field exists. Use it.
            #set l_idx \[randomRange $field_label_list_len\]
            # txt vc1k nbr
            set l_idx [lsearch -glob $field_label_list "*vc1k*"]
            # set l_idx 1
            set l_ck [lindex $field_label_list $l_idx]
            # actual value to test: 
            set v_ck $rowck_arr(${r_ck},${l_ck})
            set row_label_value_list [qss_tips_row_of_table_label_value $t_id_arr(${i}) [list $l_ck $v_ck]]
            aa_log "diagnostic info: field_label_list '${field_label_list}' l_idx '${l_idx}'"
            aa_log "diagnostic info: qss_tips_row_of_table_label_value '$t_id_arr(${i})' '${l_ck}' '${v_ck}' : '${row_label_value_list}'"
            # Following errors if label not found..
            # set v \[dict get $row_label_value_list $l_ck\]
            set l_ck2_idx [lsearch -exact $row_label_value_list $l_ck]
            if { $l_ck2_idx > -1 } {
                set l_ck2 [lindex $row_label_value_list $l_ck2_idx]
                incr l_ck2_idx
                set v [lindex $row_label_value_list $l_ck2_idx]
            } else {
                set l_ck2 ""
                set v ""
            }
            aa_equals "Test.${i} qss_tips_row_of_table_label_value for table_id '$t_id_arr(${i})' label '${l_ck2}'" $v $v_ck


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
