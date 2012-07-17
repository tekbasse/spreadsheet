<p>According to Kickstarter[1] many of the projects have a slowing period in the middle of the pledge process,
 where the pledges trickle in. Various reasons have been theorized by some Kickstarter fans,
but we are not sure why.
</p>

<p>By adding a bonus reward incentive, we're hoping to eliminate the slower pledge period.</p>
<p>The easiest way to explain the program is to show an example.</p>

<p>
Before we can model an incentive program for early backers, we need to make a
reasonable model that resembles how pledges have been made for projects at Kickstarter.
</p>

<p>Since reaching the project's pledge goal is the main indicator of pledging success, and we're
modeling successful projects, we choose the Kickstarter pledging goal as the deciding point for 
the model. When the goal is reached, the model stops making new pledges. With Kickstarter, 
there's a deadline. We're ignoring that time element for now.</p>

<p>After generating a list of pledges and their backers that have reached the goal 
of this pretend scenario, we can compare the distribution
of pledges for this model's "run" against the historical distribution provided by Kickstarter in their blog:
</p>

@pdt_html;noquote@

<h3>Test Scenario pledge results for @the_time@</h3>
<p>Kickstarter goal: $@ples_amount_target@</p>
<p>Number of pledges: @ples_count@</p>
<p>Total pledges made: $@ples_bal@</p>

<p>Basically, we use the computer's linear random number generator to create a number that represents the 
area under the Kickstarter's pledge distribution curve[1] to determine each pledge. 
Since the curve is normalized for total area = 1, we can work backwards along 
the curve to see which pledge contributed that part of the total amount pledged.
</p>

<p>1. <a href="http://www.kickstarter.com/blog/trends-in-pricing-and-duration">http://www.kickstarter.com/blog/trends-in-pricing-and-duration</a></p>

<if @project@ eq 0>

<p>Now that we have a reasonable Kickstarter project pledge scenario,
let's look at the reward bonus program for early backers.</p>

<h3>Affiliate program calculations, assuming a Kickstarter distribution of pledges</h3>
<p>Kickstarter goal: $@ples_amount_target@</p>
<p>Total amount pledged: @ples_bal@</p>
<p>Initial pool to be divided up: $@pot@ ie @pct_pooled@% of pledges.</p>
<p>Number of "quantum" parts: @shares_tot@</p>
<p>Sum of all bonus rewards: $@bonuses_tot@</p>
<p>Each "quantum" part is valued at $@share_value@</p>
<p>Amount of pledges used for bonus program in this run: @pct_of_ples@</p>
@apt_html;noquote@

</if><else>
<p>Notice the difference between the Kickstarter goal and the Total pledges made. 
For this scenario, the project is offering a limited number of reward levels. 
We are adapting the above pledges to fit into this project's reward offerings by
reducing each pledge to the highest pledge that the project offers with a reward that is less than
or equal to the pledge. This means that the amount of pledges for the scenario is
less. Subsequently the number of pledges made had to be higher to reach this project's goal. 
Pragmatically perhaps these results will be a bit pessimistic 
compared to Kickstarter averages, but useful nevertheless.</p>

<p>Now that we have a reasonable Kickstarter project pledge scenario,
let's look at the reward bonus program for early backers.</p>

<h3>Affiliate program calculations using Kickstarter's normalized distribution adapted to this project's rewards</h3>
<p>Kickstarter goal: $@p_ples_amount_target@</p>
<p>Total amount pledged: @p_ples_bal@</p>
<p>Initial pool to be divided up: $@p_pot@ ie @p_pct_pooled@% of pledges.</p>
<p>Number of "quantum" parts: @p_shares_tot@</p>
<p>Sum of all bonus rewards: $@p_bonuses_tot@</p>
<p>Each "quantum" part is valued at $@p_share_value@</p>
<p>Amount of pledges used for bonus program in this run: @p_pct_of_ples@</p>
@p_apt_html;noquote@

</else>
<p>A bonus is rewarded in addition to a backer's pledge reward. The "bonus reward" 
refers to a reward as if the backer made another pledge equal to the "pledge reward" value.
</p><p>
In some cases, a duplicate reward doesn't make sense. We'll do
what we can to provide a substitute of equal or higher value.
</p>

<p>Here's how the bonus reward program works:</p>
<p>Early backers get an extra reward for donating early.</p>
<p>This bonus program uses the amount pooled from the total amount pledged as its high limit. The actual amount used is dependent on the specific data.</p>
<p>Early backers get more of the pool.</p>
<p>The actual calculation is a simple, scalable geometric one,
but we'll save that for another discussion.
You can see the progression by looking at this example 
scenario.</p>

<p>
This bonus reward program provides an incentive to pledge early 
without creating extra overhead to manage the bonus distribution
or causing this bonus reward to be a primary motivation in 
making a pledge.
</p><p>
This bonus is a thank you for being an early adopter,
and giving us the benefit of any doubt you might have in hesitating to make a pledge.
If you have any doubt about this project. We want to engage you, and hear about it, 
so we can be sure you're as convinced about this project as we are.
</p>
<p>A backer's bonus reward is limited to the amount they pledge.</p>
<p>If there is some way you somehow pledge two or more times, 
your earliest pledge counts for your position in the progression. 
The total pledge amount is the sum of all your pledges.</p>

<p>Refreshing the page creates a new scenario with different pledges chosen randomly.</p>

