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

TDREASON_OK		= -1	|normal termination
TDREASON_DOSREAD	= 1	|error caused by resload_ReadFile
				| primary   = dos errorcode
				| secondary = file name
TDREASON_DOSWRITE	= 2	|error caused by resload_SaveFile or
				|resload_SaveFileOffset
				| primary   = dos errorcode
				| secondary = file name
TDREASON_DEBUG		= 5	|cause WHDLoad to make a coredump and quit
				| primary   = PC (to be written to dump files)
				| secondary = SR (to be written to dump files)
TDREASON_DOSLIST	= 6	|error caused by resload_ListFiles
				| primary   = dos errorcode
				| secondary = directory name
TDREASON_DISKLOAD	= 7	|error caused by resload_DiskLoad
				| primary   = dos errorcode
				| secondary = disk number
TDREASON_DISKLOADDEV	= 8	|error caused by resload_DiskLoadDev
				| primary   = trackdisk errorcode
TDREASON_WRONGVER	= 9	|an version check (e.g. CRC16) has detected an
				|unsupported version of the installed program
TDREASON_OSEMUFAIL	= 10	|error in the OS emulation module
				| primary   = subsystem (e.g. "exec.library")
				| secondary = error number (e.g. _LVOAllocMem)
| version 7
TDREASON_REQ68020	= 11	|installed program requires a MC68020
TDREASON_REQAGA		= 12	|installed program requires the AGA chip set
TDREASON_MUSTNTSC	= 13	|installed program needs NTSC video mode to run
TDREASON_MUSTPAL	= 14	|installed program needs PAL video mode to run
| version 8
TDREASON_MUSTREG	= 15	|WHDLoad must be registered
TDREASON_DELETEFILE	= 27	|error caused by resload_DeleteFile
				| primary   = dos errorcode
				| secondary = file name
| version 14.1
TDREASON_FAILMSG	= 43	|fail with a slave defined message text
				| primary   = text
