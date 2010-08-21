OUTPUT_FORMAT("binary")
ENTRY(main)
SECTIONS
{
	.text 0x0000000000200000 :
	{
		*(.text)
	}
	.data :
	{
		*(.data)
	}
	.bss :
	{
		*(.bss)
	}
}
