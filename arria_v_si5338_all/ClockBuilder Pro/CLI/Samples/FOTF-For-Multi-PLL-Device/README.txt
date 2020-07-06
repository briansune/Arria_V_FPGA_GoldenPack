This Frequency-on-the-Fly (FOTF) sample uses the CBProFOTF1 to create
in-system programming scripts that can be used to change input frequency,
output frequency, and/or DSPLL bandwidth for a single DSPLL, leaving other
DSPLLs on the device undisturbed.

Notes:

   - run.bat is a DOS batch file that that creates the programming files

   - Si5347-RevB.slabtimeproj defines the base configuration: alternate plans
     are always based on this

   - DSPLLA.txt defines 3 alternate configurations for DSPLL A. Therefore the
     batch file will create 4 programming scripts to load any of the base or
     plan 1-3 configurations.

   - DSPLLB.txt defines 6 alternate configurations for DSPLL B. Therefore the
     batch file will create 7 programming scripts to load any of the base or
     plan 1-6 configurations.

Type "CBProFOTF1 --help" from a command prompt to display a detailed
user manual. 
