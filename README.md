# Projekt ScriBt

ROM Sync && Build Script for Learning Developers
 
This is still a WiP script. Extensive Testing needed.

The Script consists of three main Actions:

1. Sync - 
  
  a. Choose a ROM

  b. Initialize it's Repo

  c. Add a local_manifest for Device Specfic things

  d. Sync the Sources

2. Pre Build - Add Device to the ROM Vendor, that's all

3. Build -
  
  a. Build the Entire ROM
  
  b. Clean /out Entirely or only Staging Directories
  
  c. Make a Particular Module

as said before, 
#Extensive Testing is needed.


#####Usage
```
bash ROM.sh
```

##### Why not ./ROM.sh
```exit``` command will close the terminal when script it called in that 
way, bash ROM.sh won't :D
