@echo off
setlocal
set starttime=%time%

:: string begins with a period needs to be quoted
SET directive=
SET otfn=mesmer.test

IF EXIST "../Windows VC12/Mesmer/Mesmer.exe" GOTO VC12
IF EXIST "../Windows VC10/Mesmer/Mesmer.exe" GOTO VC10
IF EXIST "../Windows VC9/Mesmer/Mesmer.exe" GOTO VC9

::For installed version
SET executable="../../Mesmer.exe"
GOTO SETTINGS

:VC9
SET executable="../../Windows VC9/Mesmer/Mesmer.exe"
GOTO SETTINGS

:VC10
SET executable="../../Windows VC10/Mesmer/Mesmer.exe"
GOTO SETTINGS

:VC12
SET executable="../../Windows VC12/Mesmer/Mesmer.exe"
GOTO SETTINGS

:SETTINGS
SET tfn=mesmer.test
SET lfn=mesmer.log
SET bline=baselines/Win32/
SET outf=out.xml

:: This compares the "double quote" altogether with the content
IF "%1"=="" (
SET directive=-q
SET otfn=test.test
echo.
echo -------------------------------------------------------------------------------------------------------------
echo User QA check mode: output will copy to test.test in the baselines folder. Use your own "diff" program to 
echo check changes between test.test and mesmer.test in baseline folders. Please ensure the original files in 
echo the baseline folders were not previously modified by user.
echo -------------------------------------------------------------------------------------------------------------
echo.
GOTO RUNNING
)
IF "%1"=="-o" (
echo.
echo -------------------------------------------------------------------------------
echo Developer QA check mode: output will overwrite the baselines. Use
echo "SVN check for modifications" to check the changes compared with the baselines.
echo -------------------------------------------------------------------------------
echo.
GOTO RUNNING
)

echo.
echo -------------------------------------------------------------------------------------------------------------
echo This file execute mesmer executable on several quality assessment files. There are two options to execute this file:
echo.
echo 1. user test mode; simply to confirm that if the files (mesmer.test) generated by current machine
echo    is identical to the mesmer baselines.
echo.
echo Syntax:
echo.
echo "\MESMER_PATH\MesmerQA>QA"
echo.
echo 2. developer SVN test mode; it overwrites mesmer.test files in the baseline folders, thus the developer can use
echo    SVN check for modifications from the MesmerQA folder to see what files are changed and the detail of the modifications.
echo    To use it in the developer mode simply give a -o directive after QA command.
echo.
echo Syntax:
echo.
echo "\MESMER_PATH\MesmerQA>QA -o"
echo -------------------------------------------------------------------------------------------------------------
echo.
GOTO END


:RUNNING

cd AcetylO2

:: display mesmer version
%executable% -V

%executable% Acetyl_O2_associationEx.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd AcetylPrior
%executable% AcetylPrior.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd Butyl_H_to_Butane
%executable% Butyl_H_to_Butane.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd Ethyl_H_to_Ethane
%executable% Ethyl_H_to_Ethane.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd i-propyl
%executable% ipropyl_LM.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd Methyl_H_to_Methane
%executable% Methyl_H_to_Methane.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"

%executable% -N Methyl_H_to_Methane_FTST.xml %directive%
copy Methyl_H_to_Methane_FTST.test "./%bline%Methyl_H_to_Methane_FTST.test"
IF "%1"=="-o" copy Methyl_H_to_Methane_FTST.log "./%bline%Methyl_H_to_Methane_FTST.log"
cd ..

cd reservoirSink
%executable% reservoirSinkAcetylO2.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd spin_forbidden_kinetics
%executable% -N HCCH_methylene.xml %directive%
copy "./HCCH_methylene.test" "./%bline%HCCH_methylene.test"
IF "%1"=="-o" copy "./HCCH_methylene.log" "./%bline%HCCH_methylene.log"

%executable% -N LZ_test.xml %directive%
copy "./LZ_test.test" "./%bline%LZ_test.test"
IF "%1"=="-o" copy "./LZ_test.log" "./%bline%LZ_test.log"

%executable% -N WKB_test.xml %directive%
copy "./WKB_test.test" "./%bline%WKB_test.test"
IF "%1"=="-o" copy "./WKB_test.log" "./%bline%WKB_test.log"
cd ..

cd "OH_NO_to HONO"
%executable% OH_NO_HONO.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd "OH-acetylene"
%executable% OH_HCCH-irreversibleBim-publish.xml -o %outf% %directive%
copy "./%tfn%" "./%bline%%otfn%"
IF "%1"=="-o" copy "./%lfn%" "./%bline%%lfn%"
cd ..

cd "Methoxymethyl"
set testName="Chebyshev"
%executable% -N %testName%.xml
copy "./%testName%.test" "./%bline%%testName%.test"
IF "%1"=="-o" copy "./%testName%.log" "./%bline%%testName%.log"
set testName="ChebyshevCK"
%executable% -N %testName%.xml
copy "./%testName%.test" "./%bline%%testName%.test"
IF "%1"=="-o" copy "./%testName%.log" "./%bline%%testName%.log"
cd ..

cd "SensitivityAnalysis"
set testName="ipropyl_SA"
%executable% -N %testName%.xml
copy "./%testName%.test" "./%bline%%testName%.test"
IF "%1"=="-o" copy "./%testName%.log" "./%bline%%testName%.log"
set testName="pentyl_isomerization_SA"
%executable% -N %testName%.xml
copy "./%testName%.test" "./%bline%%testName%.test"
IF "%1"=="-o" copy "./%testName%.log" "./%bline%%testName%.log"
cd ..

echo Start Time=%starttime% - End Time=%time%

:: This line below makes DOS to create a system Beep (err yup)
echo 
echo 
echo 

:END
