This example shows how edit a CBPro project file from the command line
and then export a configuration script for the new design/plan.
Input/output clock frequency/state can be changed as well as DSPLL 
bandwidth.

This sample is applicable to Si5346/47/48/83/84.

This is workflow/sample is focused on a complete configuration change. To
write the programming register script this sequence creates, the outputs on
all DSPLLs will be disturbed as the DSPLLs are soft reset.

See Multi-PLL-FOTF for a workflow that targets discrete changes to a single
DSPLL, leaving other DSPLLs undisturbed. This is so-called "frequency on the
fly."