if { ![info exists ple_max] } {
    set ple_max 10000.
}
if { ![info exists ples_amount_target] } {
 set ples_amount_target 22222.
}

set p_ples_amount_target $ples_amount_target


if { ![info exists p_rewards_list] } {
    set p_rewards_list [list 1 10 25 50 100 200 400 800]
    set project 1
    # p_* refer to customized, project specific calculations
}
# c/pl/pledg/g

if { ![info exists project] } {
    set project 0
}

# randmize rand with seed from clock
 expr { srand([clock clicks]) }
set pct_pooled 1.
set p_pct_pooled 2.
# no need to make a distribution curve, since kickstarter
# gave us the distribution data, we can create a table
# using real data.

# kickstarter data (reward amt, contribution of project)
# rewards must be listed in lowest to highest
set rewards_list [list 1 5 10 12 15 20 25 29 30 35 40 45 50 55 60 65 70 75 80 99 100 101 125 150 200 250 300 350 500 1000 2000]
# last reward is a threashold of a range to 100% that gets interpolated up to $ple_max


# contribution (as a percentage of total contribution) for each reward level measured
# These values must be in 1:1 coorespondence with rewards list
set reward_contribution_pct_list [list 0.53 1.07 2.82 0.15 1.71 3.01 8.14 0.13 2.2 1.31 1.14 0.3 11.44 0.19 0.74 0.31 0.18 2.51 0.22 0.15 16.36 0.2 0.76 2.52 2.81 5.43 1.78 0.59 8.46 8.51 14.33]
if { [llength $rewards_list] ne [llength $reward_contribution_pct_list] } {
   ns_log Error "spreadsheet/lib/aff-calcs: (L27) Reward data out of balance."
   ad_script_abort
}

# build support arrays
# r_amt(index) reward/ple tier amounts
# rcp(index)   percent of total contribution to project by ple amount
# ple_counter(ple) counts the number of times a particular ple is made
# area(index) is the area under the distribution curve to the left of the ple amt
# area_list is the area(array) expressed as an ordered list
# total_pct addus p all the rcp amounts to confirm it is 100%
# count_max is the number of reward/ple tiers
set area(-1) 0
set count 0
set area_list [list]
set total_pct 0
foreach reward $rewards_list {
    set r_amt($count) $reward
    set rcp($count) [lindex $reward_contribution_pct_list $count]
    set ple_counter([lindex $rewards_list $count]) 0
    set area($count) [expr $area([expr { $count -1} ]) + $rcp($count)]
    set total_pct [expr { $total_pct + $rcp($count) } ]
    lappend area_list $area($count)
    set count_max $count    
    incr count
}
# add one more for max possible ple to the right of distribution curve
set area($count) $ple_max

# repeat for project set p_
set p_count 0
foreach p_reward $p_rewards_list {
    set p_r_amt($p_count) $p_reward
    set p_ple_counter([lindex $p_rewards_list $p_count]) 0
    incr p_count
}
set p_count_max [expr { [llength $p_rewards_list] + 1 } ]

# initial project conditions
set ples_bal 0.
set ples_count 0
set p_ples_bal 0.
set p_ples_count 0
# every case assumes to reach target
# projects require more pledges, because the pledge amounts are adjusted to lower reward tier

while { ($project == 1 && $p_ples_bal < $p_ples_amount_target ) || ( $project == 0 && $ples_bal < $ples_amount_target) } {

    set ple_seed [expr { [random ] * 100.) } ]
    set count 0
    # We have area under curve, let's find interval ie. ple
    while { $ple_seed > $area($count) } {
	incr count
    }
 
    if {  $count == $count_max } {
	# the last tier is reported as a range (2000+)
	# interpolate a donation distribution
	# slope = Dy/Dx 
#        ns_log Notice "spreadsheet/lib/aff-calcs: ple_max $ple_max r_amt(count) $r_amt($count) rcp(count) $rcp($count)"
	set count_1 [expr { $count - 1 } ]
	set slope [expr { ($ple_max - $r_amt($count)) / $rcp($count) }]
	set x_relative [expr { $ple_seed - $area($count_1) } ]
# we add sqrt of dx in next step to help bias values to lower amounts.
	set reward [expr { $slope * sqrt( $x_relative) + $r_amt($count) } ]
	# clip to nearest cent.
#	set reward [expr { int( 100. * ( $reward)) / 100. } ]
	# clip to dollar amount, like all the other ple/reward tiers
	set reward [expr { int( $reward) } ]
	if { $reward < $r_amt($count) || $reward > $ple_max } {
	    ns_log Warning "spreadsheet/lib/aff-calcs: reward $reward slope $slope x_relative $x_relative"
	    ns_log Error "spreadsheet/lib/aff-calcs: error, interpolated reward is out of range"
	    ad_script_abort
	} 
    } else {
	set reward $r_amt($count)
    }
    # now that we have the reward value, let's match it against the p_rewards_list
    set p_reward 0
    set p_rew_counter 0
    foreach test_reward $p_rewards_list {
	if { $test_reward <= $reward } {
	    set p_reward_index $p_rew_counter
	    set p_reward [lindex $p_rewards_list $p_reward_index]
	}
	incr p_rew_counter
    }

    # set the remaining items in the lop
    incr p_ple_counter($p_r_amt($p_reward_index))
    incr p_ples_count
    incr ple_counter($r_amt($count))
    incr ples_count
    set ple_amt($ples_count) $reward
    set p_ple_amt($p_ples_count) $p_reward
    set ples_bal [expr { $ples_bal + $reward } ]
    set p_ples_bal [expr { $p_ples_bal + $p_reward } ]
    ns_log Notice "spreadsheet/lib/aff-calcs: count ${ples_count} ples_bal ${ples_bal} p_ples_bal ${p_ples_bal}"
#    ns_log Notice "spreadsheet/lib/aff-calcs: count: ${ples_count} area: $area($count) reward: [format "% 8.2f" $reward] pled: [format "% 8.2f" ${ples_bal}]"  

}

#ns_log Notice "spreadsheet/lib/aff-calcs: reward   count  historical"
# make a probability distribution table
set pdt_html "<h3>Probability distribution for this run</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">\n"
set p_pdt_html "<h3>Probability distribution for this run</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">\n"
append pdt_html "<tr><td>Pledge</td><td>Count</td><td>Base line</td></tr>\n"
append p_pdt_html "<tr><td>Pledge</td><td>Count</td><td>Base line</td></tr>\n"
set count 0
set p_count 0
set reward_max [lindex $rewards_list $count_max]
set p_reward_max [lindex $p_rewards_list $p_count_max]
foreach reward_nbr $rewards_list {
    if { $reward_nbr == $reward_max } {
	set reward "${reward_max}+"
    } else {
	set reward $reward_nbr
    }
    append pdt_html "<tr><td align=\"right\">$ [util_commify_number $reward]</td><td align=\"right\">[format "% 3.2f" [expr { 100. * $ple_counter($reward_nbr) / $ples_count } ]]%</td><td align=\"right\">$rcp($count)%</td></tr>\n"
    incr count
}
foreach p_reward_nbr $p_rewards_list {
    set p_reward $reward_nbr
    append p_pdt_html "<tr><td align=\"right\">$ [util_commify_number ${p_reward}]</td><td align=\"right\">[format "% 3.2f" [expr { 100. * $p_ple_counter($p_reward_nbr) / ${p_ples_count} } ]]%</td></tr>\n"
    incr count
}

append pdt_html "</table>\n"

#<p>Total ples this run: $ples_count</p>"


# Now we can play with the affiliate program numbers
#ns_log Notice "spreadsheet/lib/aff-calcs: Affiliate modeling calculations"
#ns_log Notice "spreadsheet/lib/aff-calcs: ples_count $ples_count"
#ns_log Notice "spreadsheet/lib/aff-calcs: ples_bal $ples_bal"

# ples_count
# ples_bal
# ple_amt()
# pot (F3)
set pot [expr $ples_bal * $pct_pooled / 100. ]
set p_pot [expr $p_ples_bal * $p_pct_pooled / 100. ]
#ns_log Notice "spreadsheet/lib/aff-calcs: pot $pot"

set shares_tot 0
set p_shares_tot 0
set b_nbr_rev 1
set p_b_nbr_rev 1
# each donor gets share of own donation and all donations that follow.
for { set b_nbr $ples_count } { $b_nbr > 0 } { incr b_nbr -1 } {
#b_ = backer
#ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr $b_nbr"
#ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr_rev $b_nbr_rev"
# b_nbr (N)
# b_shares (M)
    set shares_b($b_nbr) [expr { int( ( $b_nbr_rev + pow( $b_nbr_rev , 2 ) ) / 2. ) } ]
    set shares_tot [expr { $shares_tot + $shares_b($b_nbr) } ]
    incr b_nbr_rev
}
for { set p_b_nbr $p_ples_count } { $p_b_nbr > 0 } { incr p_b_nbr -1 } {
#b_ = backer
#ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr $b_nbr"
#ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr_rev $b_nbr_rev"
# b_nbr (N)
# b_shares (M)
    set p_shares_b($p_b_nbr) [expr { int( ( $p_b_nbr_rev + pow( $p_b_nbr_rev , 2 ) ) / 2. ) } ]
    set p_shares_tot [expr { $p_shares_tot + $p_shares_b($p_b_nbr) } ]
    incr p_b_nbr_rev
}


# shares_tot
#ns_log Notice "spreadsheet/lib/aff-calcs: shares_tot $shares_tot"
set share_value [expr { $pot / $shares_tot } ]
set p_share_value [expr { $p_pot / $p_shares_tot } ]
# share_value
set shares_tot [expr { int( $shares_tot ) } ]
set p_shares_tot [expr { int( $p_shares_tot ) } ]

#ns_log Notice "spreadsheet/lib/aff-calcs: share_value $share_value"

# now we can make a table with affiliate calculations
set apt_html "<h3>Affiliate data and calculations</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">\n"
set p_apt_html "<h3>Affiliate data and calculations</h3><table border=\"1\" cellspacing=\"0\" cellpadding=\"3\">\n"
append apt_html "<tr><td>Backer number</td><td>Pledge</td><td>Number of parts</td><td>Bonus reward</td></tr>\n"
append p_apt_html "<tr><td>Backer number</td><td>Pledge</td><td>Number of parts</td><td>Bonus reward</td></tr>\n"
set bonuses_tot 0.

for { set b_nbr 1 } { $b_nbr <= $ples_count } { incr b_nbr 1 } {
    set b_limit($b_nbr) $ple_amt($b_nbr)
    set b_bonus_pot [expr { int( $share_value * $shares_b($b_nbr) * 100. ) / 100. } ]
#    set b_bonus_pot [format "% 8.2f" $b_bonus_pot]
    # limit bonus reward to the amount of the ple
    if { $b_limit($b_nbr) < $b_bonus_pot } {
	set b_bonus($b_nbr) $b_limit($b_nbr)
#	backer limit exceeded 
#	ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr $b_nbr shares_b $shares_b($b_nbr) ple() $b_limit($b_nbr)  b_bonus()  $b_bonus($b_nbr)*"
    } else {
	# set b_bonus($b_nbr) equal to the reward just under $b_bonus_pot 
	set bonus_i_max [llength $rewards_list]
	set bonus_index 0
	set b_bonus($b_nbr) 0
	while { ( $b_bonus_pot > [lindex $rewards_list $bonus_index] ) && ( $bonus_index <= $bonus_i_max ) } {
	    set b_bonus($b_nbr) [lindex $rewards_list $bonus_index]
	    incr bonus_index
	}
#	ns_log Notice "spreadsheet/lib/aff-calcs: b_nbr $b_nbr shares_b $shares_b($b_nbr) ple() $b_limit($b_nbr)  b_bonus()  $b_bonus($b_nbr) b_pot $b_bonus_pot"
    }
    append apt_html "<tr><td align=\"right\">$b_nbr</td><td align=\"right\">$&nbsp;[util_commify_number $ple_amt($b_nbr)]</td><td align=\"right\">[util_commify_number $shares_b($b_nbr)]</td><td align=\"right\">$&nbsp;[format "%0.0f" $b_bonus($b_nbr)]</td></tr>\n"
    set bonuses_tot [expr { $bonuses_tot + $b_bonus($b_nbr) } ]
}
set p_bonuses_tot 0.
for { set p_b_nbr 1 } { $p_b_nbr <= $p_ples_count } { incr p_b_nbr 1 } {
    set p_b_limit($p_b_nbr) $p_ple_amt($p_b_nbr)
    set p_b_bonus_pot [expr { int( $p_share_value * $p_shares_b($p_b_nbr) * 100. ) / 100. } ]
    # limit bonus reward to the amount of the ple
    if { $p_b_limit($p_b_nbr) < $p_b_bonus_pot } {
#	backer limit exceeded, setting bonus the same as pledge
	set p_b_bonus($p_b_nbr) $p_b_limit($p_b_nbr)
    } else {
	# set b_bonus($b_nbr) equal to the reward just under $b_bonus_pot 
	set p_b_bonus($p_b_nbr) 0
	foreach bonus $p_rewards_list {
	    if { $bonus <= $p_b_bonus_pot } {
		set p_b_bonus($p_b_nbr) $bonus
	    }
	}
    }
    append p_apt_html "<tr><td align=\"right\">${p_b_nbr}</td><td align=\"right\">$&nbsp;[util_commify_number $p_ple_amt($p_b_nbr)]</td><td align=\"right\">[util_commify_number $p_shares_b($p_b_nbr)]</td><td align=\"right\">$&nbsp;[format "%0.0f" $p_b_bonus($p_b_nbr)]</td></tr>\n"
    set p_bonuses_tot [expr { $p_bonuses_tot + $p_b_bonus($p_b_nbr) } ]
}

append apt_html "</table>"
append p_apt_html "</table>"
# bonuses_tot s/b less than $pot
if { $bonuses_tot > $pot } {
    ns_log Error "spreadsheet/lib/aff-calcs: Error: bonuses awarded $bonuses_tot is more than pot $pot"
}
set pct_of_ples "% [format "% 8.2f" [expr { ${bonuses_tot} / ${ples_bal} * 100. } ] ] "
set p_pct_of_ples "% [format "% 8.2f" [expr { ${p_bonuses_tot} / ${p_ples_bal} * 100. } ] ] "
#ns_log Notice "spreadsheet/lib/aff-calcs: bonuses_tot $bonuses_tot pct_of_ples $pct_of_ples"
# make pretty
set bonuses_tot [util_commify_number [format "%0.2f" $bonuses_tot]]
set pot [util_commify_number [format "%0.2f" $pot]]
set ples_bal [util_commify_number [format "%0.2f" $ples_bal]]
set ples_amount_target [util_commify_number [format "%0.2f" $ples_amount_target]]
set shares_tot  [util_commify_number [format "%0.0f" $shares_tot]]
set the_time [clock format [clock seconds] -format "%Y %b %d %H:%M:%S"]

set p_bonuses_tot [util_commify_number [format "%0.2f" $p_bonuses_tot]]
set p_pot [util_commify_number [format "%0.2f" $p_pot]]
set p_ples_bal [util_commify_number [format "%0.2f" $p_ples_bal]]
set p_ples_amount_target [util_commify_number [format "%0.2f" $p_ples_amount_target]]
set p_shares_tot  [util_commify_number [format "%0.0f" $p_shares_tot]]
