# Interpretation and proposed next steps

The overall subscription rate is 11.27%. Previous success is the strongest descriptive grouping examined: 65.11% of its 1,373 records subscribed. However, that group is only a small fraction of the dataset, so its rate cannot be applied to the entire customer base.

## Segment size and conversion answer different questions
Students convert at 31.43%, but account for only 275 subscriptions. Administrative occupations convert at 12.97% and account for 1,352 subscriptions. A campaign plan should consider reachable population and product suitability as well as conversion rate. Age and occupation patterns are descriptive, not automatic eligibility rules.

## Channel differences need a better comparison
Cellular has 14.74% conversion versus telephone at 5.23%, a 9.51 percentage-point gap. But within previous-success records, rates are 65.20% and 64.08%. Prior history explains some of the aggregate contrast, and unmeasured differences remain. Test channels with randomized assignment among eligible, consenting contacts; measure conversion and unsubscribe/complaint rates before making a broader change.

## Repeated contacts need a stopping-policy experiment
One-contact records convert at 13.04%; six-plus records convert at 5.49%. These are final campaign groups, not the incremental success probability of the next call. Successful records may exit the campaign early. Randomize an alternative follow-up policy among comparable nonresponders and compare subscriptions per assigned record, contacts per subscription, complaints, and costs. This dataset has no actual cost information.

## Calendar patterns are exploratory
March shows 50.55% conversion across 546 records, while May shows 6.43% across 13,769. Small groups, campaign design, economic conditions, and pooled years make it inappropriate to label March the best future campaign month. Obtain full timestamps before evaluating seasonal patterns.

## Financial exposure is limited
Housing and personal-loan categories show conversion around 10.7–11.7%. They describe existing loan flags, not future loan performance. There are only three known default=yes records and 8,597 unknown statuses. Do not build a credit-risk score from this analysis.

## Suggested experiment order
1. Re-engagement among eligible contacts with previous successful campaigns.
2. Channel allocation within comparable prior-outcome groups.
3. Follow-up stopping policy among nonresponders.

Specify eligibility and success metrics before randomization, estimate sample size using current baseline data and a chosen minimum detectable effect, and evaluate on new observations. No experiment has been run and no uplift or savings is promised.

## Learning outcomes
This project demonstrates reproducible SQL loading, explicit data grain, conditional aggregation, segmentation using CASE, CTEs, ranking with a window function, minimum-support filtering, and translating query results into bounded business recommendations. Every numerical finding can be traced to a CSV in `reports/results/` and its numbered SQL file.
