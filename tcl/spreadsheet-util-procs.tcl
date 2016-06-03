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
    If key_list is empty, first list of lists will be used as key_list. If first row has duplicates, a sequence of numbers starting with 0 will be used.
    A list of all references of ref_key are returned in array_name(ref_key_list).
} {
    upvar 1 $array_name an_arr
    set success_p 0
    if { $key_list eq "" } {
        set k_list [lindex $values_list 0]
        # any duplicate names?
        if { [llength $k_list] > [llength [lsort -unique $k_list]] } {
            set i 0
            set key_list [list ]
            foreach k $k_list {
                lappend key_list $i
                incr i
            }
        } else {
            set key_list $k_list
            set values_lists [lrange $values_list 1 end]
        }
    }
    set ref_key -1
    if { $ref_key ne "" } {
        set key_idx [lsearch -exact $key_list $ref_key]
    }
    set ref_key_list [list ]
    set j 0
    foreach row_list $values_lists {
        set i 0
        if { $key_idx > -1 } {
            set row_id [lindex $row_list $key_idx]
        } else {
            set row_id $j
        }
        foreach key $key_list {
            set x "${row_id},${key}"
            set an_arr(${x}) [lindex $row_list $i]
            incr i
        }
        lappend ref_key_list $row_id
        incr j
    }
    set an_arr(ref_key_list) $ref_key_list
    return $success_p
}


ad_proc -public qss_lists_to_vars {
    values_lists
    ref_key
    {key_list ""}
} { 
    Converts a list of lists into variables in the calling environment:  Variable {R}_{C} where R is the the value in row R at position of ref_key, and C is the key of the same position.  Each variable returns one element of the list of lists. 

    For example, consider a list of lists:
    { {Aye Bee Main Ville 12345} {Dan Easy Side Troy 23456} {Fred Ghee Ton 34567}}

    key_list is {first_name last street city postcode}

    ref_key is "Last"
    
    Variables with cooresponding values for first row are:  Bee_first_name Bee_last Bee_street Bee_city Bee_postcode

    Returns the list of variable names, or blank if unsuccessful.

    Assumes lists in values_lists (a list of lists) are of consistent length as key_list, and that the first list is not a header.

    If key_list is empty, first list of lists will be used as key_list. If there are duplicates in key_list, then a sequence of numbers are used instead.

    If ref_key is empty, uses a sequence of integers starting with 0. For example, 0_street, 1_street, 2_street, 0_city, 1_city, .. 

    Worst case, list of variables returned are: 0_0 0_1 0_2 0_3 1_0 1_1 1_2 1_3 2_0..

    A list of all variaables are returned as a list. 
} {
    set success_p 0
    set variables_list [list ]
    if { $key_list eq "" } {
        set k_list [lindex $values_list 0]
        # any duplicate names?
        if { [llength $k_list] > [llength [lsort -unique $k_list]] } {
            set i 0
            set key_list [list ]
            foreach k $k_list {
                lappend key_list $i
                incr i
            }
        } else {
            set key_list $k_list
            set values_lists [lrange $values_list 1 end]
        }
    }
    set ref_key -1
    if { $ref_key ne "" } {
        set key_idx [lsearch -exact $key_list $ref_key]
    }
    set ref_key_list [list ]
    set j 0
    foreach row_list $values_lists {
        set i 0
        if { $key_idx > -1 } {
            set row_id [lindex $row_list $key_idx]
        } else {
            set row_id $j
        }
        foreach key $key_list {
            set var_name ${row_id}_${key}
            set $var_name [lindex $row_list $i]
            upvar 1 $var_name $var_name
            lappend variables_list $var_name
            incr i
        }
        incr j
    }
    return $variables_list
}
