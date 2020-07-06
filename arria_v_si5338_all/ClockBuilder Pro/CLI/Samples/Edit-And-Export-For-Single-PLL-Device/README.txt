This example shows how edit a CBPro project file from the command line
and then export a configuration script for the new design/plan.
Input/output clock frequency/state can be changed as well as DSPLL 
bandwidth.

This sample is applicable to Si5340/41/42/42H/44/44H/45/80.

This is workflow/sample is focused on a complete configuration change. To
write the programming register script this sequence creates, the outputs on
all N dividers will be disturbed as the DSPLL is soft reset after programming
is complete due to possible VCO frequency change between plans.

See Single-PLL-FOTF for a workflow that targets discrete changes to a single
N divider, leaving other N dividers undisturbed. This is so-called "frequency on the
fly."