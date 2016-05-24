# Projekt ScriBt

#####ROM Sync && Build Script for Learning Developers
 
This is still a WiP script. Extensive Testing needed.

The Script consists of five main Actions:

#####1. Init -
 
  a. Choose a ROM

  b. Initialize it's Repo

#####2. Sync - 
  
  a. Add a local_manifest for Device Specfic things

  b. Sync the Sources

#####3. Pre Build - 

  Add Device to the ROM Vendor, that's all

#####4. Build -
  
  a. Build the Entire ROM
  
  b. Clean /out Entirely or only Staging Directories
  
  c. Make a Particular Module

  d. Setup CCACHE
  
#####5. Install Deps and Java

as said before, 
#Extensive Testing is needed.


#####Usage
```
bash ROM.sh
```

##### Why not ./ROM.sh
```exit``` command will close the terminal when script is called in that 
way, bash ROM.sh won't :D
