This example shows how the CBProMultiEditAndExport.exe tool can be
used to streamline creation of multiple device configurations based
on a base project file and then apply clock frequency, DSPLL MUX, or
DSPLL bandwidth edits.

This is workflow/sample is focused on a complete configuration change. To
write the programming register script this sequence creates, the outputs on
all DSPLLs will be disturbed as the DSPLLs are soft reset.

See the FOTF-For-Multi-PLL-Device folder for a workflow that targets discrete 
changes to a single DSPLL, leaving other DSPLLs undisturbed. This is so-called 
"frequency on the fly."