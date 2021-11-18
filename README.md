# XTjr

Single board, integrated 8088 PC based on the [Xi 8088](http://www.malinov.com/Home/sergeys-projects/xi-8088). The objective was to
try and create a PC which was more like an 80s Microcomputers with integrated features, compact size and low cost. This is a bit like
my reimagining of the PCjr, hence XTjr.

![My son having a peek inside the XTjr](/images/xtjr-inside.jpg)
![Front of the XTjr](/images/xtjr-front.jpg)
![Back of the XTjr](/images/xtjr-back.jpg)

## Specifications

- 8088 CPU at 4.77Mhz with optional Turbo clock speeds (8/10MHz), running in Minimal Mode
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

[I will updload my fork of the 8088_bios I'm using soon once I have the code tidied up...]

## Wait State Generator

Inserts a selectable 1 or 4 WS for each IO Read/Write and Memory Read/Write to AXXXXh & BXXXXh addresses to allow for slower EGA cards at Turbo speeds.

## Ports

- PS/2 Keyboard (internal pin headers also available - don't use both!)
- PS/2 Mouse
- 5V 2.1mm Barrel socket or ATX for Power
- Standard Floppy Connector
- RS232 Serial
- 1x ISA Slot
- 3.5mm Audio Jack for PC Speaker, SN76496 & YM3812 Audio Out
- 1x Limited ISA Edge Connector
- Compact Flash Card socket

## ISA Bus Changes

The ISA bus, available on the single ISA Slot or the Edge connector on the back, is missing some signals and power becuase there is no DMAC (or support for an external one), most interrupts are taken and power is 5V only. The ISA Slot was primarily designed to support a CGA/EGA graphics card so has all the signals to support that, the edge connector just copies the signals on that slot.

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

All others are present.

## Jumpers and Headers

Sorry, my designation letters and numbers are a mess here, but they do identify the thing they identify :)

### J1 - Reset switch
Header pins for momentary reset switch

### J2 - Turbo switch / jumper
- none: Turbo off
- 1-2: Turbo always on
- 2-3: Turbo controlled by Port 61h bit 2 (recommended)

### J3 - IRQ 7: Bus or PS/2 Mouse
- 1-2: IRQ7 is PS/2 mouse interrupt - connected to the keyboard controller
- 2-3: IRQ7 is connected to the ISA bus

### J4 - Speaker
- 1: PC Speaker sound signal out
- 2: On-board speaker input
- 3: Ground
- 4: +5V

To enable the on-board speaker connect a jumper across pins 1-2 to route the PC Speaker sound signal out to the on-board speaker input. The PC Speaker data is also routed to the SN76496 sound chip so will also be heard on the external audio out.

### J5 - ATX Power connector
Standard ATX power connector - only +5V lines are used (including the stand-by +5V power)

### J6 - Soft Power Switch
Momentary switch for using the ATX soft power option

### J7 - CGA / MDA Graphics
- none: CGA Graphics is to be used 
- 1-2: MDA Graphics is to be used 

Only for CGA/MDA graphics adapters

### J8 - IO and Video Memory Wait States
- 1-2: 1 Wait State
- 2-3: 2 Wait States
- 3-4: 3 Wait States
- 4-5: 4 Wait States

### J9 - Address range 0xE0000 - 0xEFFFF: Map to ROM or RAM
- 1-2: Mapped to RAM (for UMBs - default)
- 2-3: Mapped to ROM (for extension ROMs)

### J12 - Compact Flash LED Header
- 1: +5V
- 2: GND

### J13 - Chip Select Signal for POST codes
Pin will go high (+5V) when port 0x80 selected. Useful to pick up POST codes on the databus via a Logic Analyser.

### J15 - Hard Power Switch
Toggle switch, should be rated above 2Amps

### J16 - Floppy Drive power connector
- 1: +5V
- 2: GND
- 3: GND
= 4: Not connected

### P3 - DIN Socket Connector
- 1: +5V
- 2: GND

### P4 - Turbo LED Header
1: +5V
2: GND

### P5 - Power LED Header
- 1: +5V
- 2: GND

## Form Factor

The PCB is 440mm x 140mm (with a 7.62mm edge connector protruding from the rear). This is not based on any standard, but chosen by me to fit nicely under a random HP PS/2 keyboard I found on eBay - sorry ;)

## Details and Main Changes from the Xi8088 & Integrated ISA Cards

On the main Xi8088 board I did a stripping out job to give the simplest PC that would run older games. I removed optional 'advanced' features that were not strictly required, this is where the 'jr' part of the XTjr name comes from. In integrating the functionality from several or Sergey's ISA cards I removed their address decoding logic and buffering, set a lot of the IO addresses and IRQs so they were no longer selectable and could reuse logic chips where gates were spare. All this does make it more fixed-spec and much less configurable than a PC, but that's just what old 80's micros were like.

### CPU Minimal Mode, no-FPU, no-DMA, and 1 PIC

Running the CPU in Minimal mode meant losing the 8288 bus control chip as the bus is driven directly from the CPU. However, as this chip is required to work with an FPU, that is no longer possible. I also had to figure out how to convert the IO/M, RD and WR signals to IOR, IOW, MEMR and MEMW, which became one of the uses for the ATF16V8 SPLD.

DMA would only have normally been used by the Floppy Disk Controller (FDC), unless an expansion needed it, so I just removed that as it is possible to change the BIOS code to use the FDC with interrupts and polling only. This did a lot to simplify the hardware, even if it did make the BIOS routines for Floppy access more complicated.

As the XTjr comes with most of the basic features you need as standard, I removed the 2nd PIC so that we only have 8 IRQs. This only leaves IRQ 7 as switchable between the PS/2 Mouse and the expansion slot/port. Also, as we have a PS/2 mouse port but no IRQ12 this raises some issues as IRQ12 is usually assumed to be for the PS/2 Mouse. I have only had success using CuteMouse 1.9 which supports EGA and uses BIOS to handle PS/2 mouse interrupts which I can set to use IRQ7. Also, DOS tries to handle IRQ7 so I had to write [a small utility to restore the handler back to BIOS](https://github.com/moogway82/XTjr/tree/main/restore_bios_irq7_handler) after boot, which can be placed into autoexec.bat.

### Chip Selection Logic

This is expanded to provide enable signals to the extra integrated peripherals and saved the need for each one to have it's own address decoder.

### Wait State Generator

Added a reset to the wait state counter as it would keep counting to 4 even if a smaller number was selected, which might've caused it to provide a incorrect number of wait states when requested.

It will also provide a wait state for accesses to Memory at 0xA0000 - 0xBFFFF. This seems to help accessing slower EGA Graphics cards at the faster CPU speeds.

### 1MB RAM, ROM order and Memory select logic

In my drive to reduce chips, I changed from 2 512kB RAM chips to 1 1MB chip, but I could only get 1MB SRAM in SMD packages, so does make it a little tricker to assemble. But it's not as hard to solder as the Compact Flash slot and they don't come in through hole, so SMD soldering was essential anyway. I also had to change the RAM select logic to handle a sinlge chip but I still wanted to specify UMB ranges. I decided that a SPLD (PAL) would be the simplest and most flexible way to provide custom ranges to map above 0x9FFFF between RAM and ROM. Spare capacity of the SPLD was used to generate the MEMR, MEMW, IOR, IOW and Port B Reading and Writing signals. You can see the code for the SPLD in the [spld folder](https://github.com/moogway82/XTjr/tree/main/spld) in this repo. Logic of it can be tested using the xgpro software by importing the .lgc file in that folder which was generated by the .toml file using the excellent [xgpro-logic](https://github.com/evolutional/xgpro-logic) tool. I crearted thetoml file by first creating a spreadsheet of expected functionality and regexing that in Sublime Text to the .toml format.

I also changed the ROM ordering to keep it simpler too, no inverting of A16, so the BIOS is loaded in at the end of the ROM, not the start as it is on the Xi8088.

### No Additional Bus Buffers

There is a single Data, Address and Control Bus on the XTjr, all driven by 1 set of buffers fed from the CPU. XTjr had XDx and XAx buses to drive the integrated devices and kept the Dx and Ax bues to drive the Memory and Expansion Slots. As I only had a single ISA slot I did without these buffers. I also copied the wiring for the PIC from the 5150 and PCjr in that it is wired directly to the CPUs multiplexed Address and Data bus and this seems to work fine and took 1 chip off the main data bus. The buffers get quite warm, but they seems to manage without too much stress. Higher clock speeds may start to struggle with propgation delays, but 10MHz seems stable.

### YM3812 OPL2 (Adlib) & SN76496 Tandy/PCjr sound

I deviated away a lot in the amplication and filtering part of Serge's [ISA OPL2 Card](http://www.malinov.com/Home/sergeys-projects/isa-opl2-card) to save some components and get away from any amps that required 12V. So I copied an example circuit from the TPA711D datasheet and went with that. Seems to work ok, but I suspect it will not sound as good as a real Adlib card and can be a bit noisy, but the sound from Micros was never the best anyway.

My mixer is very basic using resisters instead of op-amps. 

### Power Supply

The XTjr can take a standard ATX power connector with a 'soft' power switch. Or you can just use a simple 5V 2.1mm barrel jack and a 'hard' power switch, both options work fine but the simple 'hard' barrel jack is easier (and more Micro-like).

### Floppy Disc Controller

I chose to use the SMSC/Microchip FDC37C78-HT for the FDC as when I started building this they could still be purchase new, were quite cheap and I had a couple left over from a previous project. However they are now obsolete and actually quite hard to find for a reasonable price so I will update the design to use the more common 8477AA and clones that Serge used on his Floppy Card.

## The PCB

This is still a WIP. v1 as shown in the images above had a lot of issues and some missing features, you can see the amount of bodge wires and daughterboards on it. I'm working on a v2 at the moment to address these. Once it's ready and tested, I'm hoping to have these for sale somewhere if anyone wants to make their own XTjr and will update that page once it's ready. Feel free to contact me on Twitter at [@mogwaay](https://twitter.com/mogwaay) if you're interested or have any questions.


## Issues / New Features

### Crashes in CGA mode of Price of Persia

I think this might be to do with the Wait States inserted into 0xA0000-0xBFFFF memory read/writes and seems to affect it on 4.77MHz or 10MHz turbo. I also had swapped all the RAM on my EGA card, so that could be the problem too, need to test more. Adlib Jukebox also doing weird things and it's CGA also. Not done much in CGA mode, tested using EGA modes more.

### Can only Read Floppies

Have not implemented PIO Writing, Formatting or Verifying routines in the BIOS yet - they either error out or do nothing at present and DOS shows a disk error. Just need to find time to implement and at the moment I can enjoy loading from floppies, I can make disks using Greaseweasel at the moment.

## Single Joystick Gameport Expansion

I've made a Simple, Single Joystick Gameport Expansion board which an be found in the [joystick](/joystick) directory. It uses only 2 ICs, but one of them is a SPLD which needs to be programmed with something like the TL866. It only supports 1 joystick as only 4 of the data lines are accessed and the TLC556 only has enough 2 timers 1 set of X and Y axis. It responds top IO addresses from 0x200 to 0x207. It is designed to have a 62 pin socket attached so that it can connect to the edge connector on the back of the XTjr - it *might* also work inserted into a standard ISA slot, but I didn't design the PCB for that so would probably need reworking to fit properly.

![Render of the joystick expansion](/joystick/3D-OneJoy-PCB-render.jpg)


## Wee Disclaimer

I'm just a hobbist with no background in Electrical Engineering, there may be issues with this design that I am unaware of and I take no responsibility for any damage caused in trying to build or use your own XTjr. This is just a bit of fun for me and I'm sharing it for anyone else who likes to tinker responsibly with Retro computing.









