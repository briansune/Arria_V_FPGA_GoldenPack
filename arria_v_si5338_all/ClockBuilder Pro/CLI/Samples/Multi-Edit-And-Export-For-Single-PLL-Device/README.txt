This example shows how the CBProMultiEditAndExport.exe tool can be
used to streamline creation of multiple device configurations based
on a base project file and then apply clock frequency or DSPLL bandwidth 
edits.

This workflow/sample is focused on a complete configuration change. To
write the programming register script this sequence creates, the outputs on
all N dividers will be disturbed as the DSPLL is soft reset after programming
is complete due to possible VCO frequency change between plans.

See the FOTF-For-Single-PLL-Device folder for a workflow that targets 
discrete changes to a single N divider, leaving other N dividers undisturbed. 
This is so-called "frequency on the fly."