;=========================================================================
; Set IRQ7 vector back to BIOS value after DOS set to Dummy Handler
;=========================================================================
cpu	8086

bios_irq_7_isr_off 	equ		0A664h
bios_irq_7_isr_seg	equ 	0F000h

org 100h

	jmp start

;=========================================================================
; Main Program start
;=========================================================================

start:
	xor ax, ax
	mov ds, ax
	mov word [3Ch], bios_irq_7_isr_off
	mov word [3Eh], bios_irq_7_isr_seg
	int 21h
