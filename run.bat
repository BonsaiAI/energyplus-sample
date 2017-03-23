@echo off

IF "%1"=="train" (
    echo training
    python energyplus_simulator.py --train-brain energyplus
) & goto exit

IF "%1"=="predict" (
    echo predicting
    python energyplus_simulator.py --predict-brain=energyplus --predict-version=latest
) & goto exit

IF "%1"=="clean" (
    echo cleaning
    del output*
    del *.log
) & goto exit

echo usage: run.bat [train|predict|clean]

:exit 
