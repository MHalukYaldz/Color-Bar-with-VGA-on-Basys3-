# Color-Bar-with-VGA-on-Basys3

This project implements a VGA Color Bar Generator in VHDL for the Digilent Basys3 FPGA development board. The design generates VGA synchronization signals and displays RGB color bars on a 640×480 @60Hz monitor.

<img width="2390" height="1792" alt="Gemini_Generated_Image_lt1f7wlt1f7wlt1f" src="https://github.com/user-attachments/assets/e54c7aad-8bab-46d2-bce9-dad0370b4617" />

---

## Features

- VGA Resolution: 640×480 @60Hz
- 25 MHz Pixel Clock Generation
- Horizontal and Vertical Synchronization (HSYNC / VSYNC)
- RGB Color Bar Rendering
- Modular VHDL Architecture
- Synthesizable RTL Design
- Verified on Basys3 FPGA Hardware

---

## Hardware

| Item | Description |
|------|-------------|
| FPGA Board | Digilent Basys3 |
| FPGA Device | Xilinx Artix-7 XC7A35T |
| Tool | Vivado 2020.2 |
| Language | VHDL |

---

## Project Structure

```text
src/
├── ClockDivider.vhd      # Generates the 25 MHz pixel clock from the 100 MHz board clock
├── VGAController.vhd     # Generates VGA timing, synchronization signals and pixel counters
└── ColorBar.vhd          # Top-level module and color bar generation logic
```

The top-level entity of the project is `color_bar_top`, which is defined in `ColorBar.vhd`.

---

## Architecture

100 MHz Clock

↓

Clock Divider

↓

VGA Controller

↓

Pixel Generator

↓

RGB Output

↓

VGA Monitor

---

## Result

The design was successfully implemented and tested on the Digilent Basys3 FPGA development board.
