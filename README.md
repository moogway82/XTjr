# XTjr

Single board, integrated 8088 PC based on the [Xi 8088](http://www.malinov.com/Home/sergeys-projects/xi-8088). The objective was to
try and create a PC which was more like the 80s Microcomputers at the time with integrated features and small size.

## Specifications

- 8088 CPU with Turbo clock speeds (8/10/13.3 MHz) running in Minimal Mode
- 1MB RAM on board, giving full 640kB + UMBs
- Yamaha YM3812 (Adlib) & SN76496 (PCjr/Tandy) sound
- 1 Limited ISA Card Slot for Graphics
- 1 Limited ISA Compatible Edge Connector
- Floppy Disk Interface
- Compact Flash Slot
- RS232 Serial Port
- PS/2 Keyboard and Mouse
- 8 IRQs on a Single Programmable Interrupt Controller & no NMI support
- No FPU
- No DMA support
- 5V only supply

## IRQs

| no. | XTjr Device |
|-----|-------------|
| 0 | PIT - Channel 0 |
| 1 | KBC - Keyboard |
| 2 | EGA Vsync |
| 3 | NVRAM |
| 4 | Serial COM1 |
| 5 | YM3812 (Adlib) |
| 6 | FDC |
| 7 | KBC - Mouse |

## IO Ports Map

| Addr. | Bit pattern | XTjr Device/Function |
| ------------ | ------------- | -------------------- |
| 0x020-021 | 0 0 \| 0 0 1 0 \| 0 0 0 A0 | PIC 8259A |
| 0x040-043 | 0 0 \| 0 1 0 0 \| 0 0 A1 A0 | PIT 8254 |
| 0x060, 0x064 | 0 0 \| 0 1 1 0 \| 0 A2 0 0 | Keyboard/Mouse Controller 8242 |
| 0x061 | 0 0 \| 0 1 1 0 \| 0 0 0 1 | Port B (Speaker, Turbo)<br/>0. PIT Ch2 on/off<br/>1. Spkr on/off<br/>2. Turbo on/off<br/>3. Spare on/off reg<br/>4. PIT Ch0 output /2<br/>5. PIT Ch2 output<br/>6. Always 0<br/>7. Always 0 |
| 0x070-071 | 0 0 \| 0 1 1 1 \| 0 0 0 A0 | RTC/NVRAM address DS12885 |
| 0x0C0 | 0 0 \| 1 1 0 0 \| 0 0 0 0 | SN76494 PCjr / Tandy 3-Voice Sound |
| 0x080- 0x09F | 0 0 \| 1 0 0 X \| X X X X | POST BIOS Code Register (add-on) - aliases to 0x09F |
| 0x300-31F | 1 1 \| 0 0 0 X \| A3 A2 A1 X | CF HDD (0x300 CS1, 0x310 CS2) |
| 0x388 | 1 1 \| 1 0 0 0 \| 1 0 0 0 | Adlib OLP2 |
| 0x3B0-0x3DF | 1 1 \| 1 0 1 1 \| A3 A2 A1 A0<br/>1 1 \| 1 1 0 0 \| A3 A2 A1 A0<br/>1 1 \| 1 1 0 1 \| A3 A2 A1 A0 | EGA Graphics (Reserved) |
| 0x3F0-3F7 | 1 1 \| 1 1 1 1 \| 0 0 A1 A0 | Floppy DIsc Controller FDC |
| 0x3F8 | 1 1 \| 1 1 1 1 \| 1 0 0 0 | Serial Port (COM1) |

## Memory Map

| Addr.|Bits: A19 A18 A17 A16|Size|Purpose |Comments |
|------|---------------------|----|--------|---------|
| 0x00000 - 0x9FFFF | 0 0 0 0 - 1 0 0 1 | 640 KB | Conventional memory | |
| 0xA0000 - 0xBFFFF | 1 0 1 0 - 1 0 1 1 | 128 KB | Display memory | EGA: A0000h-AFFFFH (64 KB)<br/>MDA: B8000h-BC000h (16 KB)<br/>CGA: B0000h-B4000h (16 KB) |
| 0xC0000 - 0xDFFFF | 1 1 0 0 - 1 1 0 1 | 192 KB | C0000 - C7FFF is EGA/VGA ROM | |
| 0xE0000 - 0xEFFFF | 1 1 1 0 | 64 KB | Selectable between ROM lower 64KB or RAM (UMB) | |
| 0xF0000 - 0xFFFFF | 1 1 0 0 - 1 1 1 1 | 64 KB | ROM - BIOS and Extensions | |


## BIOS

Forked from Serge's excellent [8088_bios](https://github.com/skiselev/8088_bios) used on the Micro8088, Xi8088 and NuXT. Tried to gracefully add support for the XTjr without breaking the other systems. Main features added:

- XTjr configuration
- DMAC optional
- PS/2 Mouse allowed with only 1 PIC using IRQ7
- PIO Floppy support
- SN76496 support (silence it on boot)


## Wait State Generator

Inserts a selectable 1 or 4 WS for each IO Read/Write and Memory Read/Write to AXXXXh & BXXXXh addresses to allow for slower EGA cards at Turbo speeds.

## Ports

- PS/2 Keyboard (internal pin headers also available - don't use both!)
- PS/2 Mouse
- 5V 2.1mm Barrel socket or ATX for Power
- Standard Floppy Connector
- RS232 Serial
- 1x ISA Slot
- 3.5mm Audio Jack for PC Speaker, SN76496 & YM3812 Audio
- 1x ISA Edge Connector
- Compact Flash Card socket

## ISA Bus Changes

The ISA bus is missing some signals and power becuase there is no DMAC (or support for an external one), most interrupts are taken and power is 5V only.

The missing signals/power are:

- -12V
- +12V
- -5V
- DRQ 1
- DRQ 2
- DRQ 3
- DACK 1
- DACK 2
- DACK 3
- TC
- AEN (pin grounded)
- IRQ 2
- IRQ 3
- IRQ 5
- IRQ 6
- I/O Check
- Refresh


## Main Changes from the Xi8088

### Minimal Mode, no-FPU, no-DMA, and 1 PIC

I did a stripping out job to give the simplest PC that would run older games. So I removed many advanced features that were not strictly required, this is where the 'jr' part of the XTjr name comes from.

Running the CPU in Minimal mode meant losing the 8288 bus control chip as the bus is driven directly from the CPU. However, as this chip is required to work with an FPU, that is no longer possible. I also had to figure out how to convert the IO/M, RD and WR signals to IOR, IOW, MEMR and MEMW, which became one of the uses for the ATF16V8 SPLD.

DMA would only have normally been used by the Floppy Disk Controller (FDC), unless an expansion needed it, so I just removed that as it is possible to change the BIOS code to use the FDC with interrupts and polling only. This did a lot to simplify the hardware, even if it did make the BIOS routines for Floppy access more complicated.

As the XTjr comes with most of the basic features you need as standard, I removed the 2nd PIC so that we only have 8 IRQs. This only leaves IRQ 7 as switchable between the PS/2 Mouse and the expansion slot/port. Also, as we have a PS/2 mouse port but no IRQ12 this raises some issues as IRQ12 is usually assumed to be for the PS/2 Mouse. I have only had success using CuteMouse 1.9 which supports EGA and uses BIOS to handle PS/2 mouse interrupts which I can set to use IRQ7. Also, DOS tries to handle IRQ7 so I had to write a small utility to restore the handler back to BIOS after boot, which can be placed into autoexec.bat.

### Chip Selection Logic

This is expanded to  provide enable signals to the extra integrated peripherals and saved the need for each one to have it's own address decoder.

### Wait State Generator

Added a reset to the wait state counter as it would keep counting to 4 even if a smaller number was selected, which might've caused it to provide a incorrect number of wait states when requested.

It will also provide a wait state for accesses to Memory at 0xA0000 - 0xBFFFF. This seems to help accessing slower EGA Graphics cards at the faster CPU speeds.

### 1MB RAM, ROM order and Memory select logic

In my drive to reduce chips, I changed from 2 512kB RAM chips to 1 1MB chip, but I could only get 1MB SRAM in SMD packages, so does make it a little tricker to assemble. But it's not as hard to solder as the Compact Flash slot and they don't come in through hole, so SMD soldering was essential anyway. I also had to change the RAM select logic to handle a sinlge chip but I still wanted to specify UMB ranges. I decided that a SPLD (PAL) would be the simplest and most flexible way to provide custom ranges to map above 0x9FFFF between RAM and ROM. Spare capacity of the SPLD was used to generate the MEMR, MEMW, IOR, IOW and Port B Reading and Writing signals.

I also changed the ROM ordering to keep it simpler too, no inverting of A16, so the BIOS is loaded in at the end of the ROM, not the start as it is on the Xi8088.

### Additional Bus Buffers

There is a single Data, Address and Control Bus on the XTjr, all driven by 1 set of buffers fed from the CPU. XTjr had XDx and XAx buses to drive the integrated devices and kept the Dx and Ax bues to drive the Memory and Expansion Slots. As I only had a single ISA slot I did without these buffers. I also copied the wiring for the PIC from the 5150 and PCjr in that it is wired directly to the CPUs multiplexed Address and Data bus and this seems to work fine and took 1 chip off the main data bus. The buffers get quite warm, but they seems to manage without too much stress. Higher clock speeds may start to struggle with propgation delays, but 10MHz seems stable.



















