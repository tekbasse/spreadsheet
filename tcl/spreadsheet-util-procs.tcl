ad_library {

    misc util procedures..
    @creation-date 2 June 2016
    @Copyright (c) 2016 Benjamin Brink
    @license GNU General Public License 2, see project home
    @project home: http://github.com/tekbasse/spreadsheet
    @address: po box 20, Marylhurst, OR 97036-0020 usa
    @email: tekbasse@yahoo.com

    see: http://wiki.tcl.tk/39012 for interval_*ymdhms procs discussion
}

ad_proc -public qss_lists_to_array {
    array_name
    values_lists
    ref_key
    {key_list ""}
} { 
    Converts a list of lists into an array in the calling environment:  array_name(ref_key,N) where N are elements of key_list.
    Returns 1 if successful, otherwise returns 0.
    Assumes lists in values_lists (a list of lists) are of consistent length as key_list, and that the first list is not a header.
    If key_list is empty, first list of lists will be used as key_list.
    A list of all references of ref_key are returned in array_name(ref_key_list).
} {
    upvar 1 $array_name an_arr
    set success_p 0
    if { $ref_key ne "" } {
        if { $key_list eq "" } {
            set key_list [lindex $values_list 0]
            set values_lists [lrange $values_list 1 end]
        }
        set key_idx [lsearch -exact $key_list $ref_key]
        if { $key_idx > -1 } {
            set ref_key_list [list ]
            foreach row_list $values_lists {
                set row_id [lindex $row_list $key_idx]
                set i 0
                foreach key $key_list {
                    set an_arr(${row_id},${key}) [lindex $row_list $i]
                    incr i
                }
                lappend ref_key_list $row_id
            }
        }
    }
    return $success_p
}
