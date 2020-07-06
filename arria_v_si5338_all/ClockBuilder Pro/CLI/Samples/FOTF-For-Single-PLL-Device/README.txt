This Frequency-on-the-Fly (FOTF) sample uses the CBProFOTF1 to create
in-system programming scripts that can be used to change the output frequency
for a single N divider, leaving other N dividers on the device undisturbed.

Notes:

   - run.bat is a DOS batch file that that creates the programming files

   - Si5345-RevB.slabtimeproj defines the base configuration: alternate plans
     are always based on this

   - N0.txt defines 1 alternate configuration for N0. Therefore the
     batch file will create 2 programming scripts to load any of the base or
     plan 1 configuration.

   - N1.txt defines 1 alternate configuration for N1. Therefore the
     batch file will create 2 programming scripts to load any of the base or
     plan 1 configuration.

   - N2.txt defines 5 alternate configurations for N2. Therefore the
     batch file will create 6 programming scripts to load any of the base or
     plan 1-5 configurations.

This example will apply to other devices like Si5340/41/42/44/91/92/94/95.

Type "CBProFOTF1 --help" from a command prompt to display a detailed
user manual.