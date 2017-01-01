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
                            aa_true "Test.A${i} table def. created table_id '$t_id_arr(${i})' label '${labelized}' title ${title}" $t_id_exists_p
                            set t_larr(${i}) [qss_tips_table_def_read_by_id $t_id_arr(${i})] 
                            set t_i_id ""
                            set t_i_label ""
                            set t_i_name ""
                            set t_i_flags ""
                            set t_i_trashed_p ""
                            foreach {t_i_id t_i_label t_i_name t_i_flags t_i_trashed_p} $t_larr(${i}) {
                                # set vars
                            }
                            aa_equals "Test.B${i} table def. create/read id" $t_i_id $t_id_arr(${i})
                            aa_equals "Test.C${i} table def. create/read label" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                            set tin_max [expr { [string length $t_i_name] - 3 } ]
                            aa_equals "Test.D${i} table def. create/read name" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                            aa_equals "Test.E${i} table def. create/read flags" $t_i_flags $t_flags_arr(${i})
                            aa_equals "Test.F${i} table def. create/read trashed_p" $t_i_trashed_p $t_trashed_p_arr(${i})
                            if { ${i} == 1 } {
                                set success_p [qss_tips_table_def_trash $t_i_id]
                                aa_true "Test.G${i} table def. trashed ok" $success_p
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
                                aa_equals "Test.H${i} table def. update/read label by param" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                                set tin_max [expr { [string length $t_i_name] - 3 } ]
                                aa_equals "Test.I${i} table def. update/read name by param" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                                aa_equals "Test.J${i} table def. update/read flags by param" $t_i_flags $t_flags_arr(${i})
                                aa_equals "Test.K${i} table def. update/read trashed_p by param" $t_i_trashed_p $t_trashed_p_arr(${i})
                                
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
                                aa_equals "Test.L${i} table def. update/read label by list" [string range $t_i_label 0 36] [string range $t_label_arr(${i}) 0 36]
                                set tin_max [expr { [string length $t_i_name] - 3 } ]
                                aa_equals "Test.M${i} table def. update/read name by list" [string range $t_i_name 0 $tin_max] [string range $t_name_arr(${i}) 0 $tin_max]
                                aa_equals "Test.N${i} table def. update/read flags by list" $t_i_flags $t_flags_arr(${i})
                                aa_equals "Test.O${i} table def. update/read trashed_p by list" $t_i_trashed_p $t_trashed_p_arr(${i})
                            }

                            incr i
                        }
                        incr i -1
                        set exists_p [qss_tips_table_id_exists_q $t_i_id]
                        aa_true "Test.P${i} table def. exists_q" $exists_p
                        # we have to grab t_i_label to test because create may have modified label..
                        set table_list [qss_tips_table_def_read_by_id $t_i_id]
                        set t_i_label [lindex $table_list 1]
                        set test_t_id [qss_tips_table_id_of_label $t_i_label]
                        aa_equals "Test.Q${i} table_id_of_label" $test_t_id $t_i_id



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
                            aa_true "Test.R${i}-${j} field_def created label ${label} of type ${field_type} for table_id '$t_id_arr(${i})'" $success_p
                            #  qss_tips_field_def_read
                            set f_def1_list [qss_tips_field_def_read $t_id_arr(${i}) "" $f_def_id]
                            set f_def2_list [qss_tips_field_def_read $t_id_arr(${i}) $label]
                            if { $f_def1_list eq $f_def2_list } {
                                set success_p 1
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.S${i}-${j} field_def read via label ${label} VS. via field_id matches" $success_p
                            lappend field_defs_by_ones_list $f_def_id
                        }
                        #  field_id,label,name,default_val,tdt_data_type,field_type or empty list if not found
                        set f_def_lists [qss_tips_field_def_read $t_id_arr(${i}) ]
                        set f_def_lists_len [llength $f_def_lists]
                        set field_defs_by_ones_list_len [llength $field_defs_by_ones_list]
                        aa_equals "Test.T${i}. qss_tips_field_def_read. Quantity of all same as adding each one" $f_def_lists_len $field_defs_by_ones_list_len
                        foreach f_list $f_def_lists {
                            set f_def_id_ck [lindex $f_list 0]
                            if { $f_def_id_ck in $field_defs_by_ones_list } {
                                set success_p 1
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.U${i} field_def_id '${f_def_id_ck}' from single read in bulk read also" $success_p
                        }
                        foreach f_list $f_def_lists {
                            set f_def_id_i [lindex $f_list 0]
                            set f_field_type [lindex $f_list 5]
                            set name_new $f_field_type
                            append name_new "_test"
                            set success_p [qss_tips_field_def_update $t_id_arr(${i}) field_id $f_def_id_i name_new $name_new]
                            aa_true "Test.V${i} field_def_id '${f_def_id_i}' name change to '${name_new}'" $success_p
                            set f2_list [qss_tips_field_def_read $t_id_arr(${i}) "" $f_def_id_i ]
                            set f2_name [lindex [lindex $f2_list 0] 2]
                            if { $f2_name eq $name_new } {
                                set success_p 1
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.W${i} field_def_id '${f_def_id_i}' confirmed name changed to '${name_new}'" $success_p

                            set label_new $f_field_type
                            append label_new "_" $f_def_id_i
                            set success_p [qss_tips_field_def_update $t_id_arr(${i}) field_id $f_def_id_i label_new $label_new]
                            aa_true "Test.X${i} field_def_id '${f_def_id_i}' label change to '${label_new}'" $success_p
                            set f2_list [qss_tips_field_def_read $t_id_arr(${i}) $label_new ]
                            set f2_label [lindex [lindex $f2_list 0] 1]
                            if { $f2_label eq $label_new } {
                                set success_p 1
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.Y${i} field_def_id '${f_def_id_i}' confirmed label changed to '${label_new}'" $success_p
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
                            aa_equals "Test.Z${i}. qss_tips_field_def_create confirm id" $f_def_id2 $f_def_id
                            aa_equals "Test.AA${i}. qss_tips_field_def_create confirm label" $label2 $label
                            aa_equals "Test.AB${i}. qss_tips_field_def_create confirm name" $name2 $name
                            aa_equals "Test.AC${i}. qss_tips_field_def_create confirm default_val" $default_val2 ""
                            aa_equals "Test.AD${i}. qss_tips_field_def_create confirm tdt_data_type" $tdt_data_type2 ""
                            aa_equals "Test.AE${i}. qss_tips_field_def_create confirm field_type" $field_type2 $field_type
                        }
                        #  qss_tips_field_def_trash the old ones
                        set field_id [lindex $field_defs_by_ones_list 0]
                        set field_ids_list [lrange $field_defs_by_ones_list 1 end]
                        set success1_p [qss_tips_field_def_trash $field_id $t_id_arr(${i})]
                        aa_true "Test.AF${i}. qss_tips_field_def_trash one id '${field_id}'" $success1_p
                        set success2_p [qss_tips_field_def_trash $field_ids_list $t_id_arr(${i})]
                        aa_true "Test.AG${i}. qss_tips_field_def_trash list of ids '${field_ids_list}'" $success2_p
                        # qss_tips_field_def_read to confirm
                        set defs_lists [qss_tips_field_def_read $t_id_arr(${i}) ]
                        set success_p 1
                        foreach def_list $defs_lists {
                            set id [lindex $def_list 0]
                            if { $id in $field_defs_by_ones_list } {
                                set success_p 0
                            } 
                        }
                        aa_true "Test.AH${i}. qss_tips_field_def_trash confirm old ones deleted" $success_p

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
                        aa_true "Test.AI${i}. qss_tips_table_def_create for '${labelized}'" $success_p
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
                                set field_id_of_label_arr(${label}) $f_def_id
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.AJ${i}-${j} field_def created label ${label} of type ${field_type} for table_id '$t_id_arr(${i})'" $success_p
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
                                    # next value used in a later test that builds on this row.
                                    set row1_vc1k $value
                                    set row1_vc1k_idx $j
                                    set h_vc1k_at_r_arr(1) $value
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
                        set r 1
                        set f_row_id [qss_tips_row_create $t_id_arr(${i}) $label_value_list]
                        if { $f_row_id ne "" } {
                            set success_p 1
                            set f_row_id_arr(${r}) $f_row_id
                            # first and last occurrance are determined by this ordered list of mapped ids. 0 is first..
                            lappend f_row_nbr_larr(${f_row_id}) $r
                            lappend data_row_id_list $f_row_id
                            set data_row_id_list [list $f_row_id]
                        } else {
                            set success_p 0
                        }
                        set f_row_id_arr($r) $f_row_id
                        set label_value_larr($r) $label_value_list

                        aa_true "Test.AP0${i} row ${r} qss_tips_row_create row_id '${f_row_id}' table_id '$t_id_arr(${i})' data '$label_value_larr(${r})'" $success_p
                        aa_true "Test.AK${i} row created for table_id '$t_id_arr(${i})'" $success_p
                        #  qss_tips_row_id_exists_q
                        set f_row_id_ck [qss_tips_row_id_exists_q $f_row_id $t_id_arr(${i})]
                        aa_true "Test.AL${i} qss_tips_row_id_exists_q for row_id '${f_row_id}' table_id '$t_id_arr(${i})'" $f_row_id_ck
                        #  qss_tips_row_read
                        aa_log "Test.AM${i} qss_tips_row_create fed to row_id '${f_row_id}': '${label_value_list}'"
                        set row_list [qss_tips_row_read $t_id_arr(${i}) ${f_row_id}]
                        aa_log "Test.AN${i} qss_tips_row_read results: '${row_list}'"
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
                            aa_true "Test.AO${i} qss_tips_row_read for table_id '$t_id_arr(${i})' row_id '${f_row_id}' label '${label}'" $success_p
                        }

                        # make some more data rows
                        set r_count_max 39
                        # set the value for vc1k to unique values, except add a duplicate or more to test some api features
                        set duplicate_count [randomRange 3]
                        # Add an extra duplicate, because there is a random chance a duplicate row is deleted later in the testing
                        incr duplicate_count 2
                        set unique_count [expr { $r_count_max - $duplicate_count } ]
                        set r 2
                        set vc1k_val_list [list $row1_vc1k]
                        while { $r < $unique_count } {
                            set value [string range [qal_namelur [randomRange 10]] [randomRange 10] 38]
                            ns_log Notice "test/tips-procs.tcl appended vc1k_val_list with element value '${value}"
                            aa_log "i $i r $r Appending vc1k_val_list with element value '${value}'"
                            lappend vc1k_val_list $value
                            set vc1k_val_list [qf_uniques_of $vc1k_val_list]
                            set r [llength $vc1k_val_list]
                        }

                        # chose one value to duplicate
                        set dup_idx [randomRange $unique_count]
                        set duplicate_val [lindex $vc1k_val_list $dup_idx]
                        set vc1k_val_list [concat $vc1k_val_list [lrepeat $duplicate_count $duplicate_val]]
                        set vc1k_val_list [acc_fin::shuffle_list $vc1k_val_list]
                        
                        for {set r 2} {$r <= $r_count_max } {incr r} {
                            set label_value_larr(${r}) [list ]
                            for {set j 1} {$j < 4} {incr j} {
                                switch -exact $f_field_type_arr($j) {
                                    txt {
                                        set value [qal_namelur [randomRange 20]]
                                    }
                                    vc1k {
                                        #        set value [string range [qal_namelu [randomRange 10]] 0 38]
                                        # pre calculated for testing 
                                        set value [lindex $vc1k_val_list $r]
                                        set h_vc1k_at_r_arr(${r}) $value
                                    }
                                    nbr {
                                        set value [clock microseconds]
                                    }
                                }
                                set label $f_label_arr($j)
                                # retained values by RC reference:
                                set rowck_arr(${r},${label}) $value
                                lappend label_value_larr(${r}) $label $value
                            }
                            #  qss_tips_row_create
                            set row_id_new [qss_tips_row_create $t_id_arr(${i}) $label_value_larr(${r})]
                            if { $row_id_new ne "" } {
                                set success_p [qss_tips_row_id_exists_q $row_id_new $t_id_arr(${i})]
                                if { $success_p } {
                                    set f_row_id_arr(${r}) $row_id_new
                                    # first and last occurrance are determined by this ordered list of mapped ids. 0 is first..
                                    lappend f_row_nbr_larr(${row_id_new}) $r
                                    lappend data_row_id_list $row_id_new
                                }
                            } else {
                                set success_p 0
                            }
                            aa_true "Test.AP${i} row ${r} qss_tips_row_create row_id '${row_id_new}' table_id '$t_id_arr(${i})' data '$label_value_larr(${r})'" $success_p
                            
                        }

                        # # # check a row from nonduplicates, and check duplicate cases.
                        set value_ck $duplicate_val
                        while { $value_ck eq $duplicate_val } {
                            set unique_idx [randomRange 38]
                            set value_ck [lindex $vc1k_val_list $unique_idx]
                        }

                        set val_ck_list [list $value_ck $duplicate_val]
                        set val_dup_ck_list [list 0 1]
                        set vdcli -1
                        set vc1k_label [lindex $field_label_list 1]
                        set test_row_id_list [list ]
                        aa_log "val_ck_list '${val_ck_list}'"
                        foreach v $val_ck_list {
                            incr vdcli

                            if { $v eq $duplicate_val } {
                                set is_duplicate_p 1
                            } else {
                                set is_duplicate_p 0
                            }

                            aa_log "\r\r

BEGIN TEST LOOP for value '${v}'"
                            aa_equals "TEST.AQ0-${i} v is '${v}'  is_duplicate_p '${is_duplicate_p}'" $is_duplicate_p [lindex $val_dup_ck_list $vdcli]

                            for {set if_multiple -1} {$if_multiple < 2} {incr if_multiple} {
                                # have to use the original label value in the search.

                                if { [info exists row_id] } {
                                    unset row_id
                                }
                                set row_label_value_list [qss_tips_row_of_table_label_value $t_id_arr(${i}) [list $vc1k_label $v] $if_multiple row_id]

                                aa_log "Test.AQ${i}.row_id '${row_id}' of qss_tips_row_of_table_label_value table_id '$t_id_arr(${i})' if_multiple '${if_multiple}' row_label_value_list '${row_label_value_list}'"
                                if { $row_id in $data_row_id_list } {
                                    set valid_row_id_p 1
                                    lappend tested_row_id_list $row_id
                                } else { 
                                    set valid_row_id_p 0
                                }
                                set row_label_value_list_len [llength $row_label_value_list]
                                if { $row_label_value_list_len > 0 } {
                                    set data_row_exists_p 1
                                    set expect_row_id_p 1
                                } else {
                                    set data_row_exists_p 0
                                    set expect_row_id_p 0
                                }
                                if { $valid_row_id_p } {
                                    
                                    set r_indexes_list [lsearch -all -exact $vc1k_val_list $v]
                                    #aa_log "f_row_nbr_larr(${row_id}) '$f_row_nbr_larr(${row_id})'"
                                    aa_log "r_indexes_list '${r_indexes_list}' vc1k_val_list '${vc1k_val_list}'"
                                    
                                    set data_row_id_list_len [llength $r_indexes_list]
                                } else {
                                    set data_row_id_list_len 0
                                }
                                if { $data_row_id_list_len > 1 } {
                                    set multiple_rows_match_p 1
                                } else {
                                    set multiple_rows_match_p 0
                                }

                                if { $multiple_rows_match_p && $if_multiple eq "-1" } {
                                    set expect_row_id_p 0
                                }
                                aa_equals "Test.AR${i}.if_multiple '${if_multiple}' multiple_rows_match_p '${multiple_rows_match_p}' qss_tips_row_of_table_label_value returns a row_id '${row_id}' in row_ids of dataset or no row as expected." $valid_row_id_p $expect_row_id_p
                                # check each value for expected value
                                for {set j 1} {$j < 4} {incr j} {
                                    set label $f_label_arr($j)
                                    
                                    # following doesn't work for if_multiple = -1, because no rows are returned.
                                    # if dict fails,  qss_tips_row_of_table_value failed to return an expected field
                                    if { [llength $row_label_value_list] > 0 } {
                                        set vx [dict get $row_label_value_list $label] 
                                    } else {
                                        set vx ""
                                    }

                                    # mapping of row_id and r
                                    #set f_row_id_arr(${r}) $row_id
                                    #lappend f_row_nbr_larr(${row_id_new}) $r
                                    aa_log "row_id '$row_id' "
                                    if { $is_duplicate_p } {
                                        # row_id depends on if_multiple and row
                                        switch -exact -- $if_multiple {
                                            -1 {
                                                # does not return anything when if_multiple = -1
                                                set row_nbr ""
                                                set ck_row_id ""
                                                set v_ck ""
                                                
                                            }
                                            0 {
                                                set row_nbr [lindex $f_row_nbr_larr(${row_id}) 0]
                                                set ck_row_id $f_row_id_arr(${row_nbr})
                                                set v_ck $rowck_arr(${row_nbr},${label})
                                            }
                                            1 {
                                                set row_nbr [lindex $f_row_nbr_larr(${row_id}) end]
                                                set ck_row_id $f_row_id_arr(${row_nbr})
                                                set v_ck $rowck_arr(${row_nbr},${label})
                                            }
                                            default {
                                                ns_log Warning "spreadsheet/tcl/test/tips-procs.tcl.535: This should not happen"
                                            }
                                        }
                                        
                                    } else {
                                        if { $valid_row_id_p } {
                                            # value depends on row_id only
                                            set row_nbr [lindex $f_row_nbr_larr(${row_id}) 0]
                                            set ck_row_id $f_row_id_arr(${row_nbr})
                                            set v_ck $rowck_arr(${row_nbr},${label})
                                        } else {
                                            set row_nbr ""
                                            set ck_row_id ""
                                            set v_ck ""
                                        }
                                    }
                                    aa_equals "Test.AS${i} qss_tips_row_of_table_label_value for table_id '$t_id_arr(${i})' vc1k_label '${vc1k_label}' if_mupltiple '${if_multiple}' row_id check" $row_id $ck_row_id
                                    aa_equals "Test.AT${i} qss_tips_row_of_table_label_value for table_id '$t_id_arr(${i})' vc1k_label '${vc1k_label}' if_mupltiple '${if_multiple}' label '${label}' value '${v_ck}'" $vx $v_ck 

                                }
                            }
                            # back to context of row loop only 

                            # if row_id exists and expected, perform some more tests
                            set ck_update_label_val_list [list ]
                            if { $ck_row_id eq $row_id && $row_id ne "" } {
                                set j_list [list ]
                                # for each label type, check a case. Shuffle list for diagnostics.
                                for {set j 1} {$j < 4} {incr j} {
                                    lappend j_list $j
                                }
                                set j_list [acc_fin::shuffle_list $j_list]
                                ns_log Notice "test/tips-procs.tcl.575: shuffled j_list '${j_list}'"
                                foreach j $j_list {
                                    switch -exact $f_field_type_arr($j) {
                                        txt {
                                            set value [qal_namelur [randomRange 20]]
                                        }
                                        vc1k {
                                            #        set value [string range [qal_namelu [randomRange 10]] 0 38]
                                            # pre calculated for testing 
                                            set value [lindex $vc1k_val_list $r]
                                        }
                                        nbr {
                                            set value [clock microseconds]
                                        }
                                    }
                                    set label $f_label_arr($j)
                                    lappend ck_update_label_val_list $label $value
                                }
                                
                                #  qss_tips_row_update
                                set success_p [qss_tips_row_update $t_id_arr(${i}) $row_id $ck_update_label_val_list ]
                                aa_true "Test.BA${i} qss_tips_row_update table_id '$t_id_arr(${i})' row_id '${row_id}' update_label_val_list '${ck_update_label_val_list}' success_p" $success_p

                                #  qss_tips_rows_read
                                set ck2_update_label_val_list [qss_tips_row_read $t_id_arr(${i}) $row_id]
                                # for each label type, check a case
                                set j_list [acc_fin::shuffle_list $j_list]
                                ns_log Notice "test/tips-procs.tcl.601: shuffled j_list '${j_list}'"
                                foreach j $j_list {
                                    set label $f_label_arr($j)
                                    set v_ck [dict get $ck_update_label_val_list $label] 
                                    if { [llength $ck2_update_label_val_list] > 0 } {
                                        # following doesn't work if no rows are returned.
                                        # if dict fails,  qss_tips_row_of_table_value failed to return an expected field
                                        set v [dict get $ck2_update_label_val_list $label] 
                                        set label_exists_p 1
                                    } else {
                                        set v ""
                                        set label_exists_p 0
                                    }
                                    aa_true "Test.BB${i}. j '${j}' label '${label}' exists" $label_exists_p
                                    aa_equals "Test.BC${i} j '${j}' check label '${label}'s value" $v $v_ck
                                }
                                
                                #  qss_tips_row_trash
                                set success_p [qss_tips_row_trash $t_id_arr(${i}) $row_id]
                                aa_true "Test.BD${i} qss_tips_row_trash table_id '$t_id_arr(${i})' row_id '${row_id}' success_p" $success_p

                                #  qss_tips_row_id_exists_q
                                set exists_p [qss_tips_row_id_exists_q $row_id $t_id_arr(${i})]
                                if { $exists_p } {
                                    set not_exists_p 0
                                } else {
                                    set not_exists_p 1
                                }
                                aa_true "Test.BE${i} qss_tips_row_trash table_id '$t_id_arr(${i})' row_id '${row_id}' not_exists_p" $not_exists_p


                            }
                        }
                        set tested_row_id_list [qf_uniques_of $tested_row_id_list]

                       


                        # # #
                        # cells
                        # $rowck_arr(r,$label) returns initial cell value  
                        # $label_value_larr(r) returns label_value_list for row 
                        # $f_row_id_arr(r) returns row_id for row
                        # $f_row_nbr_larr(r) returns row number(s) for row_id
                        # data_row_id_list is a list of all row_id
                        # tested_row_id_list is a list of row_ids used in prior tests (ie don't reuse)
                        # $field_id_of_label_arr(label)
                        # $t_label_arr(${i}) is table label for case i 
                        # $h_vc1k_at_r_arr(r) is value of vc1k field for row r
                        # choose an untested row_id
                        # $row1_vc1k_idx value of loop index j for vc1k label
                        set test_idx [randomRange $data_row_id_list_len]
                        set test_row_id [lindex $data_row_id_list $test_idx]
                        while { $test_row_id in $tested_row_id_list } {
                            set test_idx [randomRange $data_row_id_list_len]
                            set test_row_id [lindex $data_row_id_list $test_idx]
                        }
                        lappend tested_row_id_list $test_row_id
                        aa_log "tested_row_id_list '${tested_row_id_list}'"
                        set r [lindex $f_row_nbr_larr(${test_row_id}) 0]
                        set vc1k_search_val $h_vc1k_at_r_arr(${r})
                        aa_log "row_id '${test_row_id}' r '$r' vc1k_search_val '${vc1k_search_val}'"
                        set okay_to_v1ck_search_p 1
                        # test for each data type, ie cell in the row
                        foreach j $j_list {
                            set label $f_label_arr($j)
                            set field_id $field_id_of_label_arr(${label})

                            #  qss_tips_cell_read
                            set val_case1 [qss_tips_cell_read $t_label_arr(${i}) [list $f_label_arr(${row1_vc1k_idx}) $vc1k_search_val] $label 1 returned_row_id ]
                            if { $okay_to_v1ck_search_p } {
                                if { $returned_row_id eq $test_row_id } {
                                    aa_equals "Test.CA${i} j '${j}' check qss_tips_cell_read label label '${label}'s value by ref '$f_label_arr(${row1_vc1k_idx})' vc1k_search_val '${vc1k_search_val}'" $val_case1 $rowck_arr(${r},${label}) 
                                } else {
                                    aa_log "Test.CA not possible since vc1k field appears to have duplciates."
                                }
                            } else {
                                aa_log "Test.CA not possible since vc1k field trashed for this row."
                            }

                            #  qss_tips_cell_read_by_id
                            set value_by_id [qss_tips_cell_read_by_id $t_id_arr(${i}) $test_row_id $field_id]
                            aa_equals "Test.CB${i} j '${j}' check qss_tips_cell_read_by_id id '${field_id}' label '${label}'s value" $value_by_id $rowck_arr(${r},${label})

                            #  qss_tips_cell_update
                            # create a new value of same type.
                            switch -exact $f_field_type_arr($j) {
                                txt {
                                    set value [qal_namelur [randomRange 20]]
                                }
                                vc1k {
                                    set value_len [randomRange 20]
                                    set value [ad_generate_random_string $value_len]
                                    
                                }
                                nbr {
                                    set value [clock microseconds]
                                }
                            }

                            qss_tips_cell_update $t_id_arr(${i}) $test_row_id $field_id $value
                            set rowck_arr(${r},${label}) $value
                            #qss_tips_cell_read_by_id to confirm

                            #so for the vc1k test field (and subsequent cell tests, update vc1k_search_val
                            # to new value
                            if { $f_label_arr(${row1_vc1k_idx}) eq $label } {
                                # new vc1k value
                                aa_log "Changing vc1k_search_value to '${value}', since $label is of type vc1k."
                                set vc1k_search_val $value
                            }


                            set value_by_id_ck [qss_tips_cell_read_by_id $t_id_arr(${i}) $test_row_id $field_id]
                            aa_equals "Test.CC${i} j '${j}' check qss_tips_cell_update using  qss_tips_cell_read_by_id field_id '${field_id}' label '${label}'s value" $value $value_by_id_ck
                            set val_case1 [qss_tips_cell_read $t_label_arr(${i}) [list $f_label_arr(${row1_vc1k_idx}) $vc1k_search_val] $label 1 returned_row_id]
                            if { $okay_to_v1ck_search_p } {
                                if { $returned_row_id eq $test_row_id } {
                                    aa_equals "Test.CC2${i} j '${j}' check qss_tips_cell_read label '${label}'s value by ref '$f_label_arr(${row1_vc1k_idx})' ${vc1k_search_val}" $val_case1 $rowck_arr(${r},${label})
                                } else {
                                    aa_log "Test.CC2 not possible since vc1k field appears to have duplciates."
                                }
                            } else {
                                aa_log "Test.CC2 not possible since vc1k field trashed for this row."
                            }



                            #  qss_tips_cell_trash
                            set cell_trashed_p [qss_tips_cell_trash $t_id_arr(${i}) $test_row_id $field_id]
                            aa_true "Test.CD${i} j '${j}' check qss_tips_cell_trash feedback succeeded" $cell_trashed_p
                            if { $j eq $row1_vc1k_idx } {
                                # update search value for this cell to empty cell 
                                set vc1k_search_val ""
                                # But this won't work for many of the cases, because there are likely other empty cell cases.
                                # so set a flag to skip these searches by label.
                                set okay_to_v1ck_search_p 0
                            }
                            #qss_tips_cell_read_by_id to confirm
                            set value_by_id_ck [qss_tips_cell_read_by_id $t_id_arr(${i}) $test_row_id $field_id]
                            aa_equals "Test.CE${i} j '${j}' check qss_tips_cell_read_by_id id '${id}' label '${label}'s value" $value_by_id_ck ""

                            #  qss_tips_cell_trash a trashed
                            set cell_trashed_p [qss_tips_cell_trash $t_id_arr(${i}) $test_row_id $field_id]
                            if { $cell_trashed_p } {
                                set cell_trashed_p 0
                            } else {
                                set cell_trashed_p 1
                            }
                            aa_true "Test.CF${i} j '${j}' check qss_tips_cell_trash feedback failed" $cell_trashed_p

                        }


                        # table read, compare to existing
                        #  qss_tips_table_read
                        # Let's not overcomplicate this.
                        # Compare qss_tips_table_read to qss_tips_table_read_as_array
                        set table1_lists [qss_tips_table_read $t_label_arr(${i}) "" "" "row_id"]

                        # table read as array
                        qss_tips_table_read_as_array table2_arr $t_label_arr(${i}) 
                        #  qss_tips_table_read_as_array

                        # compare table1 to table2
                        # first, convert table2 to table1 format.
                        # table2_arr(row_id,field_label)
                        set table_fields_list [lindex $table1_lists 0]
                        aa_log "table_fields_list '${table_fields_list}'"
                        # We added row_id to the end of table1, but we take it off here, for comparisons
                        set table_fields_list [lrange $table_fields_list 0 end-1]
                        set table_fields_list_len [llength $table_fields_list]
                        # We added row_id to table1_lists, so need to remove it from expected behavior
                        set table1_wo_labels_list [lrange $table1_lists 1 end]

                        set table_labels_list $table2_arr(labels)
                        set table_labels_list_len [llength $table_labels_list]
                        aa_equals "Test.DA${i} qss_table_read label count '${table_fields_list_len}'" $table_fields_list_len $table_labels_list_len 
                        set diff_labels_list [set_difference $table_labels_list $table_fields_list]
                        aa_equals "Test.DB${i} set_difference table_fields table_labels" $diff_labels_list ""

                        set table1_wo_labels_list_len [llength $table1_wo_labels_list]
                        if { $table1_wo_labels_list_len > 0 } {
                            set table_read_returns_rows_p 1
                        } else {
                            set table_read_returns_rows_p 0
                        }
                        aa_true "Test.DC${i} qss_tips_table_read returns rows" $table_read_returns_rows_p
                        aa_log "test.DD${i} table1_lists '${table1_lists}'"
                        aa_log "test.DD${i} array names table2_arr '[array names table2_arr]'"
                        # table_fields_list is ordered

                        foreach row_list $table1_wo_labels_list {
                            set t1_c 0
                            set row_id [lindex $row_list end]
                            aa_log "table1 row_list '${row_list}'"
                            foreach label $table_fields_list {
                                aa_log "table1 label '[lindex $table_fields_list $t1_c]'"
                                set t1_val [lindex $row_list $t1_c]
                                set t2_val $table2_arr(${row_id},${label})
                                aa_equals "test.DE${i} table values same for row_id '${row_id}' label '${label}' t2_val '${t2_val}'" $t1_val $t2_val
                                incr t1_c
                            }
                        }

                           
                        
                        ns_log Notice "tcl/test/q-control-procs.tcl.429 test end"
                    } \
        -teardown_code {

        }
    #aa_true "Test for .." $passed_p
    #aa_equals "Test for .." $test_value $expected_value


}
