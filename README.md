Set of TCL XSPEC scripts to help you fit multi-Lorentzian models to the Power Density Spectra (PDS), Cross Density Spectrum (CDS), phase-lags and intrinsic coherence function.

# lorentzians
The functions assume that the Real and Imaginary parts of the CDS were rotated by 45deg. Of course, this can be changed to zero at every function where the term "3.14159265/4.0" was added.

## startlor
Procedure to start a Lorentzian model for 1pds, 2pds, 3rea, 4ima, 5pla and 6coh. 

It assumes that you have loaded PHA data and RMFs for the 6 frequency spectra in the right order (PDS1, PDS2, REAL, IMAG, PLAG, COHE).

## dellor N
Procedure to remove the Nth-Lorentzian from 1pds, 2pds, 3rea, 4ima, 5pla and 6coh.

## addlor N
Procedure to add a Lorentzian at the Nth-position to 1pds, 2pds, 3rea, 4ima, 5pla and 6coh.

## switchlors N M
Procedure to reorder/switch Mth- and Nth- Lorentzians from 1pds, 2pds, 3rea, 4ima, 5pla and 6coh.

## LorInfo N
Procedure to print out information on the Nth- Lorentzian, like the Frequency, Width, Quality Factor and Significances.

## plags N
Procedure to create a PLAG model with N Lorentzians (not directly used by the user). 

## cohes N
Procedure to create a COHE model with N Lorentzians (not directly used by the user). 


# lorentzians_Sqrt
Same as `lorentzians`, but with `Norm CDS = sqrt(Norm PDS1 * Norm PDS2)`, as in eq. (7) from Mendez+2024 (`C=sqrt(AB)`). 


