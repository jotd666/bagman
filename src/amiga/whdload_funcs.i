.macro DEF_WHD_OFFSET	name
\name = whd_offset
	.set		whd_offset,whd_offset+4
	.endm
	.set	whd_offset,0
	DEF_WHD_OFFSET	resload_Install
	DEF_WHD_OFFSET	resload_Abort
	DEF_WHD_OFFSET	resload_LoadFile
	DEF_WHD_OFFSET	resload_SaveFile
	DEF_WHD_OFFSET	resload_SetCACR
	DEF_WHD_OFFSET	resload_ListFiles
	DEF_WHD_OFFSET	resload_Decrunch
	DEF_WHD_OFFSET	resload_LoadFileDecrunch
	DEF_WHD_OFFSET	resload_FlushCache
	DEF_WHD_OFFSET	resload_GetFileSize
	DEF_WHD_OFFSET	resload_DiskLoad
	DEF_WHD_OFFSET	resload_DiskLoadDev
	DEF_WHD_OFFSET	resload_CRC16
	DEF_WHD_OFFSET	resload_Control
	DEF_WHD_OFFSET	resload_SaveFileOffset
	DEF_WHD_OFFSET	resload_ProtectRead
	DEF_WHD_OFFSET	resload_ProtectReadWrite
	DEF_WHD_OFFSET	resload_ProtectWrite
	DEF_WHD_OFFSET	resload_ProtectRemove
	DEF_WHD_OFFSET	resload_LoadFileOffset
	DEF_WHD_OFFSET	resload_Relocate
	DEF_WHD_OFFSET	resload_Delay
	DEF_WHD_OFFSET	resload_DeleteFile
	DEF_WHD_OFFSET	resload_ProtectSMC
	DEF_WHD_OFFSET	resload_SetCPU
	DEF_WHD_OFFSET	resload_Patch
	DEF_WHD_OFFSET	resload_LoadKick
	DEF_WHD_OFFSET	resload_Delta
	DEF_WHD_OFFSET	resload_GetFileSizeDec
	DEF_WHD_OFFSET	resload_PatchSeg
	DEF_WHD_OFFSET	resload_Examine
	DEF_WHD_OFFSET	resload_ExNext
	DEF_WHD_OFFSET	resload_GetCustom
	DEF_WHD_OFFSET	resload_VSNPrintF
	DEF_WHD_OFFSET	resload_Log


WHDLTAG_CUSTOM1_GET = 0x88000007
WHDLTAG_CUSTOM2_GET = 0x88000008
WHDLTAG_CUSTOM3_GET = 0x88000009
WHDLTAG_CUSTOM4_GET = 0x8800000A
WHDLTAG_CUSTOM5_GET = 0x8800000B
