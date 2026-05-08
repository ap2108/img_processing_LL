
# Logic Locking ASIC Image Processing Project

This project simulates and verifies image-processing hardware designs written in Verilog using a simple Python-based image conversion flow.

The flow:

1.  Convert an input PNG image into HEX pixel data
    
2.  Run Verilog simulation using Icarus Verilog
    
3.  Convert the generated HEX output back into a PNG image
    

The project supports:

-   Edge Detection
    
-   Locked Edge Detection
    
-   Blur Filter
    
-   Locked Blur Filter
    

----------

# Project Structure

```text
.
├── rtl/                  # Verilog RTL designs
│   ├── edge_detector.v
│   ├── edge_detector_locked.v
│   ├── blur.v
│   └── blur_locked.v
│
├── tb/                   # Testbenches
│   ├── tb_edge_detector.v
│   ├── tb_edge_detector_locked.v
│   ├── tb_blur.v
│   └── tb_blur_locked.v
│
├── img/                  # Input/output images and hex data
│   ├── input.png
│   ├── input.hex
│   ├── output.hex
│   └── output.png
│
├── png2hex.py            # Converts PNG → HEX
├── hex2png.py            # Converts HEX → PNG
├── Makefile
└── README.md

```

The directory structure and flow are defined in the `Makefile`. The build system uses:

-   `rtl/` for hardware modules
    
-   `tb/` for simulation testbenches
    
-   `img/` for generated assets
    

----------

# Requirements

## System Packages

Install the following tools:

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv iverilog

```

### Verify Installation

```bash
python3 --version
iverilog -V
vvp -V

```

----------

# Python Dependencies

The Python scripts use the following libraries:

-   `Pillow`
    
-   `NumPy`
    

These imports are used in:

-   `png2hex.py`
    
-   `hex2png.py`
    

Install them using pip.

----------

# Setting Up a Virtual Environment

Create and activate a Python virtual environment:

## Create venv

```bash
python3 -m venv venv

```

## Activate venv

### Linux/macOS

```bash
source venv/bin/activate

```

### Windows

```powershell
venv\Scripts\activate

```

## Install Python Packages

```bash
pip install pillow numpy

```

----------

# Running the Simulation

Place your input image at:

```text
img/input.png

```

Then run:

## Edge Detector

```bash
make TEST=1

```

## Locked Edge Detector

```bash
make TEST=2

```

## Blur Filter

```bash
make TEST=3

```

## Locked Blur Filter

```bash
make TEST=4

```

----------
# Makefile Flow

The `run` target performs:

```bash
python3 png2hex.py $(KERNEL_SIZE)
iverilog -o sim rtl/<design>.v tb/tb_<design>.v
vvp sim
python3 hex2png.py

```

Steps:

1.  Convert input image into HEX pixel data
    
2.  Compile Verilog RTL and testbench
    
3.  Run simulation
    
4.  Generate output image from simulation results
    

----------

# Python Script Details

## png2hex.py

Converts:

-   `img/input.png`  
    →
    
-   `img/input.hex`
    

Features:

-   Converts image to grayscale
    
-   Resizes to `128×128`
    
-   Applies padding based on kernel size
    
-   Writes flattened pixel blocks in HEX format
    

Uses:

-   `Pillow`
    
-   `NumPy`
    

## hex2png.py

Converts:

-   `img/output.hex`  
    →
    
-   `img/output.png`
    

Features:

-   Reads HEX pixel values
    
-   Reconstructs grayscale image
    
-   Saves final PNG output
    

Uses:

-   `Pillow`
    

----------

# Notes

-   Image resolution is fixed at `128×128`
    
-   Grayscale mode (`L`) is used throughout
    
-   Kernel size depends on selected design
    
-   Locked versions are intended for logic-locking experiments

- For locked modules (`edge_detector_locked` and `blur_locked`), the correct key must be set manually inside the corresponding testbench files before running the simulation.
----------

# Example Workflow

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate

# Install dependencies
pip install pillow numpy

# Run simulation
make TEST=1

# View result
xdg-open img/output.png

```

