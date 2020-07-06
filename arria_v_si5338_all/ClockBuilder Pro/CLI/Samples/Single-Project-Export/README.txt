This example shows how to export an in-system programming configuration "script" 
in two formats: CSV and C header file. This script can be replayed to fully load 
the configuration defined by the CBPro project file (because --include-load-writes 
was specified on the command line). The CBProProjectRegistersExport CLI is used.

This example also dumps the named settings (bitfield) breakout of the registers. 
Note that it does not contain the config load pre-amble/post-amble that gets included
in the script above. The settings export is useful for debugging. The 
CBProProjectSettingsExport CLIs is used.

This example also shows how to export register map (aka regmap) information based on the
device/revision present in a project file. Three table versions are saved: CSV data, 
text report, and HTML report

A "C" code is a header (.h) file is also saved that contains a struct typedef and 
array of settings meta-data. This would simplify creating a bitfield-level API
to a supported device.

The CBProRegmapExport CLI is used to create the regmap files.

The CBPro GUI Export tool provides a GUI front-end to all of the CLIs used in this
example.
