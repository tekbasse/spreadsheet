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
            
            ns_log Notice "tcl/test/q-control-procs.tcl.429 test end"
        } \
        -teardown_code {

        }
    #aa_true "Test for .." $passed_p
    #aa_equals "Test for .." $test_value $expected_value


}
