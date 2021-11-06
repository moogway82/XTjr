# XTjr

Single board, integrated 8088 PC based on the Xi 8088.

## Specifications

- 8088 with Turbo clock speeds (8/10/13.3 MHz) running in Minimal Mode
- 1MB RAM on board, giving full 640kB + UMBs
- Yamaha YM3812 (Adlib) & SN76496 (PCjr/Tandy)
- 1 Limted ISA Card Slot for Graphics
- 1 Limited ISA Compatible Edge Connector
- Floppy Disk Controller
- Compact Flash
- RS232 Serial Port
- PS/2 Keyboard and Mouse
- No DMA
- 8 IRQs on a Single Programmable Interrupt Controller (no NMI)
- No FPU
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




















