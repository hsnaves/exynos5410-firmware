OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
SECTIONS
{
  . = 0x02030000;
  .text : { *(.text) }
  .data : { *(.data) }
  .bss : {
    *(.bss)
    . = ALIGN(4);
  }

  /DISCARD/ : { *(.dynstr*) }
  /DISCARD/ : { *(.dynamic*) }
  /DISCARD/ : { *(.plt*) }
  /DISCARD/ : { *(.interp*) }
  /DISCARD/ : { *(.gnu*) }
  /DISCARD/ : { *(.note.gnu.build-id) *(.ARM.attributes) }

  /* Leave some space for the signature */
  . = 0x0206FEFF;
  .fill : {
    BYTE(0);
  }
}
