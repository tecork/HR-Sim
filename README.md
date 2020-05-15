# HR-Sim
<p align="left">
  <a href="https://github.com/tecork/HR-Sim/">
    <img src="docs/HR_Sim_Logo.png" height="110">
  </a>
</p>

A cross platform script for artifical cardiac triggering.

## Features
* Compadible with devices that take a 5V input via RCA plug.
* Script written in both MATLAB and Python.
* Directly writes and saves output for Ardunio (.INO) after running the main script.
* Upload the .INO to the Ardunio via USB.

## Contents
- [Features](#features)
- [Installation](#installation)
- [Demos](#demos)
- [Documentation](#documentation)

## Requirements
* [Open-Source Arduino IDE](https://www.arduino.cc/en/Main/Software)
* [Arduino Uno](https://www.digikey.com/product-detail/en/arduino/A000073/1050-1041-ND/3476357)
* [BNC Connector - Right Angle](https://www.digikey.com/product-detail/en/molex-llc/0731375003/WM5514-ND/1465136)
* [USB Cable A to B - 6 Feet](https://www.digikey.com/product-detail/en/molex/0887329400/WM17134-ND/1212447)
* [25 feet RCA male - BNC female Cable](https://www.cablewholesale.com/specs/11x1-02125.php?utm_source=GoogleShopping&utm_medium=cpc&utm_term=11X1-02125&utm_campaign=RG59U%20Coaxial%20BNC%20to%20RCA%20Video%20Cable%2C%20Black%2C%20BNC%20Male%20to%20RCA%20Male%2C%2075%20Ohm%2C%2064%25%20Braid%2C%2025%20foot&gclid=EAIaIQobChMI_43148Hg3AIVjddkCh0vIwsJEAkYASABEgIqovD_BwE)




## Installation

The optimization is written in C and can be found in the src/ directory.

A very basic idea of how to compile for C is included in src/make.txt, however modifications would need to made for input and output as it only runs a test case when run in C.  For easier usage use one of the wrappers:

### Python

The Python module has been tested primarily with [Anaconda](https://www.anaconda.com/) and Python 3.7, though it should work with any type of Python environment.

The setup.py file will build the python module.  To build you can run 
```bash
python setup.py build_ext --inplace
```
from within the python/ directory.  

This will use Cython to generate the source files for a Python module, and then compile it within the GrOpt folder.  For MacOS this procedure requires Xcode.  For Windows you may need a Visual Studio compiler (the free 2019 community version works just fine).  Some common binaries are included in the repository, which should work without any compilation for most.

### Matlab

Assuming you have mex setup correctly (check with `mex -setup`), the two main functions can be compiled by simply running the `make.m` script. 

## Demos

Example usage cases are provided for the Python and Matlab wrappers.  Examples for C applications are shown at the bottom of `src/optimize_kernel.c`

### Python

Demos for Python are all in the form of Jupyter notebooks (.ipynb files) in the ./python/ folder.  Running `jupyter notebook` in the folder will get you started.  Examples show diffusion and non-diffusion gradient design, and most combinations of constraints.

### Matlab

Demo Matlab scripts start with demo_*, are in the ./matlab/ folder, and can be run as is to see some example usage cases.

## Documentation

Further documentation, including descriptions of all constraints and their arguments and units, can be found at http://gropt.readthedocs.io
