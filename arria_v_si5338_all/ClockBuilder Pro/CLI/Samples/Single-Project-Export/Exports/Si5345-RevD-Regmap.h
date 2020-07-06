/*
 * Si5345 Rev D Regmap Header File
 *
 * This file describes the register map for a Silicon Labs
 * Si5345 Rev D. It defines the meta-data for each device setting, 
 * such as number of bits and location with the device address
 * space. It was created by a Silicon Labs ClockBuilder Pro
 * export tool.
 * 
 * Part:	   Si5345 Rev D
 * Created By: CBProRegmapExport v2.23.5 [2018-05-02]
 * Timestamp:  2018-05-02 10:37:56 GMT-05:00
 *
 * A textual, report oriented version of the register map is 
 * included at the end of this header file.
 *
 */

#ifndef SI5345_REVD_REGMAP_HEADER
#define SI5345_REVD_REGMAP_HEADER

#define SI5345_REVD_NUM_SETTINGS				507
#define SI5345_REVD_MAX_NUM_REGS				10

#define SLAB_NVMT_NONE 0
#define SLAB_NVMT_SLAB 1
#define SLAB_NVMT_CUST 2

#define CHAR	char
#define UINT8	unsigned char
#define UINT16	unsigned int

typedef struct
{
	CHAR*  name;								/* Setting/bitfield name                                           */ 
	UINT8  read_only;							/* 1 for read only setting/regs or 0 for read/write                */
	UINT8  self_clearing;						/* 1 for self-clearing setting/registers or 0 otherwise            */
	UINT8  nvm_type;							/* See above                                                       */
	UINT8  bit_length;							/* Number of bits in setting                                       */
	UINT8  start_bit;							/* Least significant bit of the setting                            */
	UINT8  reg_length;							/* Number of registers that the setting is stored in               */
	UINT16 addr[SI5345_REVD_MAX_NUM_REGS];	/* Addresses the setting is contained in						   */
	UINT8  mask[SI5345_REVD_MAX_NUM_REGS];	/* Bitmask for each register containing the setting				   */
} si5345_revd_regmap_t;

/* 
 * Array of setting meta-data; use macros such as SI5345_REVD_DIE_REV defined after
 * this block to index into the array. 
 *
 * E.g. si5345_revd_settings[SI5345_REVD_DIE_REV].bit_length
 *
 * You may need to change "const" keyword to "xdata" or "code" depending 
 * on CPU/compiler/memory constraints.
 */
si5345_revd_regmap_t const si5345_revd_settings[SI5345_REVD_NUM_SETTINGS] =
{

	/* DIE_REV */
	{
		"DIE_REV",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0000, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* PAGE */
	{
		"PAGE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0001, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* PN_BASE */
	{
		"PN_BASE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0002, /* Register address 0 b7:0 */
			0x0003, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* GRADE */
	{
		"GRADE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0004, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DEVICE_REV */
	{
		"DEVICE_REV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0005, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* TOOL_VERSION */
	{
		"TOOL_VERSION",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0006, /* Register address 0 b7:0 */
			0x0007, /* Register address 1 b7:0 */
			0x0008, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* TEMP_GRADE */
	{
		"TEMP_GRADE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0009, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* PKG_ID */
	{
		"PKG_ID",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* I2C_ADDR */
	{
		"I2C_ADDR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		7, /* 7 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000B, /* Register address 0 b7:0 */

		},
		{
			0x7F, /* Register mask 0 */

		}
	},

	/* SYSINCAL */
	{
		"SYSINCAL",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000C, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* LOSXAXB */
	{
		"LOSXAXB",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000C, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* SMBUS_TIMEOUT */
	{
		"SMBUS_TIMEOUT",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000C, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS */
	{
		"LOS",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000D, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OOF */
	{
		"OOF",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000D, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL */
	{
		"LOL",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD */
	{
		"HOLD",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000E, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* CAL_PLL */
	{
		"CAL_PLL",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x000F, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* SYSINCAL_FLG */
	{
		"SYSINCAL_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* LOSXAXB_FLG */
	{
		"LOSXAXB_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* SMBUS_TIMEOUT_FLG */
	{
		"SMBUS_TIMEOUT_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0011, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS_FLG */
	{
		"LOS_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OOF_FLG */
	{
		"OOF_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0012, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_FLG */
	{
		"LOL_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_FLG */
	{
		"HOLD_FLG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0013, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* CAL_FLG_PLL */
	{
		"CAL_FLG_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0014, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOL_ON_HOLD */
	{
		"LOL_ON_HOLD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0016, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* SYSINCAL_INTR_MSK */
	{
		"SYSINCAL_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* LOSXAXB_INTR_MSK */
	{
		"LOSXAXB_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* SMB_TMOUT_INTR_MSK */
	{
		"SMB_TMOUT_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0017, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS_INTR_MSK */
	{
		"LOS_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OOF_INTR_MSK */
	{
		"OOF_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0018, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_INTR_MSK */
	{
		"LOL_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_INTR_MSK */
	{
		"HOLD_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0019, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* CAL_INTR_MSK */
	{
		"CAL_INTR_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001A, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* SOFT_RST */
	{
		"SOFT_RST",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* SOFT_RST_ALL */
	{
		"SOFT_RST_ALL",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* SOFTCAL */
	{
		"SOFTCAL",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001C, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* FINC */
	{
		"FINC",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001D, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* FDEC */
	{
		"FDEC",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001D, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* PDN */
	{
		"PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001E, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* HARD_RST */
	{
		"HARD_RST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001E, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* SYNC */
	{
		"SYNC",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x001E, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* SPI_3WIRE */
	{
		"SPI_3WIRE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002B, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* AUTO_NDIV_UPDATE */
	{
		"AUTO_NDIV_UPDATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002B, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS_EN */
	{
		"LOS_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* LOSXAXB_DIS */
	{
		"LOSXAXB_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002C, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* LOS0_VAL_TIME */
	{
		"LOS0_VAL_TIME",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002D, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* LOS1_VAL_TIME */
	{
		"LOS1_VAL_TIME",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002D, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* LOS2_VAL_TIME */
	{
		"LOS2_VAL_TIME",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002D, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* LOS3_VAL_TIME */
	{
		"LOS3_VAL_TIME",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x002D, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* LOS0_TRG_THR */
	{
		"LOS0_TRG_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x002E, /* Register address 0 b7:0 */
			0x002F, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS1_TRG_THR */
	{
		"LOS1_TRG_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0030, /* Register address 0 b7:0 */
			0x0031, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS2_TRG_THR */
	{
		"LOS2_TRG_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0032, /* Register address 0 b7:0 */
			0x0033, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS3_TRG_THR */
	{
		"LOS3_TRG_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0034, /* Register address 0 b7:0 */
			0x0035, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS0_CLR_THR */
	{
		"LOS0_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0036, /* Register address 0 b7:0 */
			0x0037, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS1_CLR_THR */
	{
		"LOS1_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0038, /* Register address 0 b7:0 */
			0x0039, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS2_CLR_THR */
	{
		"LOS2_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x003A, /* Register address 0 b7:0 */
			0x003B, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* LOS3_CLR_THR */
	{
		"LOS3_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x003C, /* Register address 0 b7:0 */
			0x003D, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* OOF_EN */
	{
		"OOF_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x003F, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF_EN */
	{
		"FAST_OOF_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x003F, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* OOF_REF_SEL */
	{
		"OOF_REF_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0040, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OOF0_DIV_SEL */
	{
		"OOF0_DIV_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0041, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF1_DIV_SEL */
	{
		"OOF1_DIV_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0042, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF2_DIV_SEL */
	{
		"OOF2_DIV_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0043, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF3_DIV_SEL */
	{
		"OOF3_DIV_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0044, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOFXO_DIV_SEL */
	{
		"OOFXO_DIV_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0045, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF0_SET_THR */
	{
		"OOF0_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0046, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF1_SET_THR */
	{
		"OOF1_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0047, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF2_SET_THR */
	{
		"OOF2_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0048, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF3_SET_THR */
	{
		"OOF3_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0049, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF0_CLR_THR */
	{
		"OOF0_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF1_CLR_THR */
	{
		"OOF1_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF2_CLR_THR */
	{
		"OOF2_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004C, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF3_CLR_THR */
	{
		"OOF3_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004D, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF0_DETWIN_SEL */
	{
		"OOF0_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004E, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OOF1_DETWIN_SEL */
	{
		"OOF1_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004E, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OOF2_DETWIN_SEL */
	{
		"OOF2_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004F, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OOF3_DETWIN_SEL */
	{
		"OOF3_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x004F, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OOF_ON_LOS */
	{
		"OOF_ON_LOS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0050, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF0_SET_THR */
	{
		"FAST_OOF0_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0051, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF1_SET_THR */
	{
		"FAST_OOF1_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0052, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF2_SET_THR */
	{
		"FAST_OOF2_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0053, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF3_SET_THR */
	{
		"FAST_OOF3_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0054, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF0_CLR_THR */
	{
		"FAST_OOF0_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0055, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF1_CLR_THR */
	{
		"FAST_OOF1_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0056, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF2_CLR_THR */
	{
		"FAST_OOF2_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0057, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF3_CLR_THR */
	{
		"FAST_OOF3_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0058, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FAST_OOF0_DETWIN_SEL */
	{
		"FAST_OOF0_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0059, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* FAST_OOF1_DETWIN_SEL */
	{
		"FAST_OOF1_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0059, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* FAST_OOF2_DETWIN_SEL */
	{
		"FAST_OOF2_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0059, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* FAST_OOF3_DETWIN_SEL */
	{
		"FAST_OOF3_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0059, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OOF0_RATIO_REF */
	{
		"OOF0_RATIO_REF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		26, /* 26 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x005A, /* Register address 0 b7:0 */
			0x005B, /* Register address 1 b7:0 */
			0x005C, /* Register address 2 b7:0 */
			0x005D, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x03, /* Register mask 3 */

		}
	},

	/* OOF1_RATIO_REF */
	{
		"OOF1_RATIO_REF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		26, /* 26 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x005E, /* Register address 0 b7:0 */
			0x005F, /* Register address 1 b7:0 */
			0x0060, /* Register address 2 b7:0 */
			0x0061, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x03, /* Register mask 3 */

		}
	},

	/* OOF2_RATIO_REF */
	{
		"OOF2_RATIO_REF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		26, /* 26 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0062, /* Register address 0 b7:0 */
			0x0063, /* Register address 1 b7:0 */
			0x0064, /* Register address 2 b7:0 */
			0x0065, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x03, /* Register mask 3 */

		}
	},

	/* OOF3_RATIO_REF */
	{
		"OOF3_RATIO_REF",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		26, /* 26 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0066, /* Register address 0 b7:0 */
			0x0067, /* Register address 1 b7:0 */
			0x0068, /* Register address 2 b7:0 */
			0x0069, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x03, /* Register mask 3 */

		}
	},

	/* LOL_FST_EN */
	{
		"LOL_FST_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0092, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* LOL_FST_DETWIN_SEL */
	{
		"LOL_FST_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0093, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_FST_VALWIN_SEL */
	{
		"LOL_FST_VALWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0095, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* LOL_FST_SET_THR_SEL */
	{
		"LOL_FST_SET_THR_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0096, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_FST_CLR_THR_SEL */
	{
		"LOL_FST_CLR_THR_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0098, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_SLOW_EN_PLL */
	{
		"LOL_SLOW_EN_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x009A, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* LOL_SLW_DETWIN_SEL */
	{
		"LOL_SLW_DETWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x009B, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_SLW_VALWIN_SEL */
	{
		"LOL_SLW_VALWIN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x009D, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* LOL_SLW_SET_THR */
	{
		"LOL_SLW_SET_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x009E, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_SLW_CLR_THR */
	{
		"LOL_SLW_CLR_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A0, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_TIMER_EN */
	{
		"LOL_TIMER_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00A2, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* LOL_CLR_DELAY_DIV256 */
	{
		"LOL_CLR_DELAY_DIV256",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		29, /* 29 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x00A9, /* Register address 0 b7:0 */
			0x00AA, /* Register address 1 b7:0 */
			0x00AB, /* Register address 2 b7:0 */
			0x00AC, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x1F, /* Register mask 3 */

		}
	},

	/* ACTIVE_NVM_BANK */
	{
		"ACTIVE_NVM_BANK",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00E2, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FASTLOCK_EXTEND_EN */
	{
		"FASTLOCK_EXTEND_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00E5, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* FASTLOCK_EXTEND */
	{
		"FASTLOCK_EXTEND",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		29, /* 29 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x00EA, /* Register address 0 b7:0 */
			0x00EB, /* Register address 1 b7:0 */
			0x00EC, /* Register address 2 b7:0 */
			0x00ED, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0x1F, /* Register mask 3 */

		}
	},

	/* REG_0XF7_INTR */
	{
		"REG_0XF7_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F6, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* REG_0XF8_INTR */
	{
		"REG_0XF8_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F6, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* REG_0XF9_INTR */
	{
		"REG_0XF9_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F6, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* SYSINCAL_INTR */
	{
		"SYSINCAL_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F7, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* LOSXAXB_INTR */
	{
		"LOSXAXB_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F7, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* LOSREF_INTR */
	{
		"LOSREF_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F7, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* LOSVCO_INTR */
	{
		"LOSVCO_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F7, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* SMBUS_TIME_OUT_INTR */
	{
		"SMBUS_TIME_OUT_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F7, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS_INTR */
	{
		"LOS_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F8, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OOF_INTR */
	{
		"OOF_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F8, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_INTR */
	{
		"LOL_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F9, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_INTR */
	{
		"HOLD_INTR",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x00F9, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* OUTALL_DISABLE_LOW */
	{
		"OUTALL_DISABLE_LOW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0102, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT0_PDN */
	{
		"OUT0_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0108, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT0_OE */
	{
		"OUT0_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0108, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT0_RDIV_FORCE2 */
	{
		"OUT0_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0108, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT0_FORMAT */
	{
		"OUT0_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0109, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT0_SYNC_EN */
	{
		"OUT0_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0109, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT0_DIS_STATE */
	{
		"OUT0_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0109, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT0_CMOS_DRV */
	{
		"OUT0_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0109, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT0_CM */
	{
		"OUT0_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010A, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT0_AMPL */
	{
		"OUT0_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010A, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT0_MUX_SEL */
	{
		"OUT0_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010B, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT0_VDD_SEL */
	{
		"OUT0_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010B, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT0_VDD_SEL_EN */
	{
		"OUT0_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010B, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT0_INV */
	{
		"OUT0_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010B, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT1_PDN */
	{
		"OUT1_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010D, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT1_OE */
	{
		"OUT1_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010D, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT1_RDIV_FORCE2 */
	{
		"OUT1_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010D, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT1_FORMAT */
	{
		"OUT1_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010E, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT1_SYNC_EN */
	{
		"OUT1_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010E, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT1_DIS_STATE */
	{
		"OUT1_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010E, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT1_CMOS_DRV */
	{
		"OUT1_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010E, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT1_CM */
	{
		"OUT1_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010F, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT1_AMPL */
	{
		"OUT1_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x010F, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT1_MUX_SEL */
	{
		"OUT1_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0110, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT1_VDD_SEL */
	{
		"OUT1_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0110, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT1_VDD_SEL_EN */
	{
		"OUT1_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0110, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT1_INV */
	{
		"OUT1_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0110, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT2_PDN */
	{
		"OUT2_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0112, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT2_OE */
	{
		"OUT2_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0112, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT2_RDIV_FORCE2 */
	{
		"OUT2_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0112, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT2_FORMAT */
	{
		"OUT2_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0113, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT2_SYNC_EN */
	{
		"OUT2_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0113, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT2_DIS_STATE */
	{
		"OUT2_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0113, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT2_CMOS_DRV */
	{
		"OUT2_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0113, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT2_CM */
	{
		"OUT2_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0114, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT2_AMPL */
	{
		"OUT2_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0114, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT2_MUX_SEL */
	{
		"OUT2_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0115, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT2_VDD_SEL */
	{
		"OUT2_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0115, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT2_VDD_SEL_EN */
	{
		"OUT2_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0115, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT2_INV */
	{
		"OUT2_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0115, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT3_PDN */
	{
		"OUT3_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0117, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT3_OE */
	{
		"OUT3_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0117, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT3_RDIV_FORCE2 */
	{
		"OUT3_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0117, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT3_FORMAT */
	{
		"OUT3_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0118, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT3_SYNC_EN */
	{
		"OUT3_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0118, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT3_DIS_STATE */
	{
		"OUT3_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0118, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT3_CMOS_DRV */
	{
		"OUT3_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0118, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT3_CM */
	{
		"OUT3_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0119, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT3_AMPL */
	{
		"OUT3_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0119, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT3_MUX_SEL */
	{
		"OUT3_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011A, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT3_VDD_SEL */
	{
		"OUT3_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011A, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT3_VDD_SEL_EN */
	{
		"OUT3_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011A, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT3_INV */
	{
		"OUT3_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011A, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT4_PDN */
	{
		"OUT4_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011C, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT4_OE */
	{
		"OUT4_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011C, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT4_RDIV_FORCE2 */
	{
		"OUT4_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011C, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT4_FORMAT */
	{
		"OUT4_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011D, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT4_SYNC_EN */
	{
		"OUT4_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011D, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT4_DIS_STATE */
	{
		"OUT4_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011D, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT4_CMOS_DRV */
	{
		"OUT4_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011D, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT4_CM */
	{
		"OUT4_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011E, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT4_AMPL */
	{
		"OUT4_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011E, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT4_MUX_SEL */
	{
		"OUT4_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011F, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT4_VDD_SEL */
	{
		"OUT4_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011F, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT4_VDD_SEL_EN */
	{
		"OUT4_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011F, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT4_INV */
	{
		"OUT4_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x011F, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT5_PDN */
	{
		"OUT5_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0121, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT5_OE */
	{
		"OUT5_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0121, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT5_RDIV_FORCE2 */
	{
		"OUT5_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0121, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT5_FORMAT */
	{
		"OUT5_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0122, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT5_SYNC_EN */
	{
		"OUT5_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0122, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT5_DIS_STATE */
	{
		"OUT5_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0122, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT5_CMOS_DRV */
	{
		"OUT5_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0122, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT5_CM */
	{
		"OUT5_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0123, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT5_AMPL */
	{
		"OUT5_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0123, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT5_MUX_SEL */
	{
		"OUT5_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0124, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT5_VDD_SEL */
	{
		"OUT5_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0124, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT5_VDD_SEL_EN */
	{
		"OUT5_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0124, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT5_INV */
	{
		"OUT5_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0124, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT6_PDN */
	{
		"OUT6_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0126, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT6_OE */
	{
		"OUT6_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0126, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT6_RDIV_FORCE2 */
	{
		"OUT6_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0126, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT6_FORMAT */
	{
		"OUT6_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0127, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT6_SYNC_EN */
	{
		"OUT6_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0127, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT6_DIS_STATE */
	{
		"OUT6_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0127, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT6_CMOS_DRV */
	{
		"OUT6_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0127, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT6_CM */
	{
		"OUT6_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0128, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT6_AMPL */
	{
		"OUT6_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0128, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT6_MUX_SEL */
	{
		"OUT6_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0129, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT6_VDD_SEL */
	{
		"OUT6_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0129, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT6_VDD_SEL_EN */
	{
		"OUT6_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0129, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT6_INV */
	{
		"OUT6_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0129, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT7_PDN */
	{
		"OUT7_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012B, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT7_OE */
	{
		"OUT7_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012B, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT7_RDIV_FORCE2 */
	{
		"OUT7_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012B, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT7_FORMAT */
	{
		"OUT7_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012C, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT7_SYNC_EN */
	{
		"OUT7_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT7_DIS_STATE */
	{
		"OUT7_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012C, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT7_CMOS_DRV */
	{
		"OUT7_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012C, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT7_CM */
	{
		"OUT7_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012D, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT7_AMPL */
	{
		"OUT7_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012D, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT7_MUX_SEL */
	{
		"OUT7_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012E, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT7_VDD_SEL */
	{
		"OUT7_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012E, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT7_VDD_SEL_EN */
	{
		"OUT7_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012E, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT7_INV */
	{
		"OUT7_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x012E, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT8_PDN */
	{
		"OUT8_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0130, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT8_OE */
	{
		"OUT8_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0130, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT8_RDIV_FORCE2 */
	{
		"OUT8_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0130, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT8_FORMAT */
	{
		"OUT8_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0131, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT8_SYNC_EN */
	{
		"OUT8_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0131, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT8_DIS_STATE */
	{
		"OUT8_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0131, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT8_CMOS_DRV */
	{
		"OUT8_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0131, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT8_CM */
	{
		"OUT8_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0132, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT8_AMPL */
	{
		"OUT8_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0132, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT8_MUX_SEL */
	{
		"OUT8_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0133, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT8_VDD_SEL */
	{
		"OUT8_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0133, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT8_VDD_SEL_EN */
	{
		"OUT8_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0133, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT8_INV */
	{
		"OUT8_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0133, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT9_PDN */
	{
		"OUT9_PDN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013A, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT9_OE */
	{
		"OUT9_OE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013A, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT9_RDIV_FORCE2 */
	{
		"OUT9_RDIV_FORCE2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013A, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* OUT9_FORMAT */
	{
		"OUT9_FORMAT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013B, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT9_SYNC_EN */
	{
		"OUT9_SYNC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013B, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT9_DIS_STATE */
	{
		"OUT9_DIS_STATE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013B, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT9_CMOS_DRV */
	{
		"OUT9_CMOS_DRV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013B, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUT9_CM */
	{
		"OUT9_CM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013C, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OUT9_AMPL */
	{
		"OUT9_AMPL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013C, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* OUT9_MUX_SEL */
	{
		"OUT9_MUX_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013D, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* OUT9_VDD_SEL */
	{
		"OUT9_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013D, /* Register address 0 b7:0 */

		},
		{
			0x30, /* Register mask 0 */

		}
	},

	/* OUT9_VDD_SEL_EN */
	{
		"OUT9_VDD_SEL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013D, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* OUT9_INV */
	{
		"OUT9_INV",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x013D, /* Register address 0 b7:0 */

		},
		{
			0xC0, /* Register mask 0 */

		}
	},

	/* OUTX_ALWAYS_ON */
	{
		"OUTX_ALWAYS_ON",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x013F, /* Register address 0 b7:0 */
			0x0140, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* OUT_DIS_MSK */
	{
		"OUT_DIS_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0141, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT_DIS_LOL_MSK */
	{
		"OUT_DIS_LOL_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0141, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* OUT_DIS_LOSXAXB_MSK */
	{
		"OUT_DIS_LOSXAXB_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0141, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* OUT_DIS_MSK_LOS_PFD */
	{
		"OUT_DIS_MSK_LOS_PFD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0141, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* OUT_DIS_MSK_LOL */
	{
		"OUT_DIS_MSK_LOL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0142, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* OUT_DIS_MSK_HOLD */
	{
		"OUT_DIS_MSK_HOLD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0142, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* OUT_PDN_ALL */
	{
		"OUT_PDN_ALL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0145, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* OUT_RST */
	{
		"OUT_RST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0146, /* Register address 0 b7:0 */
			0x0147, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* OUT_RDIV_RST */
	{
		"OUT_RDIV_RST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0148, /* Register address 0 b7:0 */
			0x0149, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* PXAXB */
	{
		"PXAXB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0206, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* P0_NUM */
	{
		"P0_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		48, /* 48 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0208, /* Register address 0 b7:0 */
			0x0209, /* Register address 1 b7:0 */
			0x020A, /* Register address 2 b7:0 */
			0x020B, /* Register address 3 b7:0 */
			0x020C, /* Register address 4 b7:0 */
			0x020D, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0xFF, /* Register mask 5 */

		}
	},

	/* P0_DEN */
	{
		"P0_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x020E, /* Register address 0 b7:0 */
			0x020F, /* Register address 1 b7:0 */
			0x0210, /* Register address 2 b7:0 */
			0x0211, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* P1_NUM */
	{
		"P1_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		48, /* 48 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0212, /* Register address 0 b7:0 */
			0x0213, /* Register address 1 b7:0 */
			0x0214, /* Register address 2 b7:0 */
			0x0215, /* Register address 3 b7:0 */
			0x0216, /* Register address 4 b7:0 */
			0x0217, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0xFF, /* Register mask 5 */

		}
	},

	/* P1_DEN */
	{
		"P1_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0218, /* Register address 0 b7:0 */
			0x0219, /* Register address 1 b7:0 */
			0x021A, /* Register address 2 b7:0 */
			0x021B, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* P2_NUM */
	{
		"P2_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		48, /* 48 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x021C, /* Register address 0 b7:0 */
			0x021D, /* Register address 1 b7:0 */
			0x021E, /* Register address 2 b7:0 */
			0x021F, /* Register address 3 b7:0 */
			0x0220, /* Register address 4 b7:0 */
			0x0221, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0xFF, /* Register mask 5 */

		}
	},

	/* P2_DEN */
	{
		"P2_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0222, /* Register address 0 b7:0 */
			0x0223, /* Register address 1 b7:0 */
			0x0224, /* Register address 2 b7:0 */
			0x0225, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* P3_NUM */
	{
		"P3_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		48, /* 48 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0226, /* Register address 0 b7:0 */
			0x0227, /* Register address 1 b7:0 */
			0x0228, /* Register address 2 b7:0 */
			0x0229, /* Register address 3 b7:0 */
			0x022A, /* Register address 4 b7:0 */
			0x022B, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0xFF, /* Register mask 5 */

		}
	},

	/* P3_DEN */
	{
		"P3_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x022C, /* Register address 0 b7:0 */
			0x022D, /* Register address 1 b7:0 */
			0x022E, /* Register address 2 b7:0 */
			0x022F, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* P0_UPDATE */
	{
		"P0_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0230, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* P1_UPDATE */
	{
		"P1_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0230, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* P2_UPDATE */
	{
		"P2_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0230, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* P3_UPDATE */
	{
		"P3_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0230, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* P0_FRACN_MODE */
	{
		"P0_FRACN_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0231, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* P0_FRACN_EN */
	{
		"P0_FRACN_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0231, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* P1_FRACN_MODE */
	{
		"P1_FRACN_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0232, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* P1_FRACN_EN */
	{
		"P1_FRACN_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0232, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* P2_FRACN_MODE */
	{
		"P2_FRACN_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0233, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* P2_FRACN_EN */
	{
		"P2_FRACN_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0233, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* P3_FRACN_MODE */
	{
		"P3_FRACN_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0234, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* P3_FRACN_EN */
	{
		"P3_FRACN_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0234, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* MXAXB_NUM */
	{
		"MXAXB_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0235, /* Register address 0 b7:0 */
			0x0236, /* Register address 1 b7:0 */
			0x0237, /* Register address 2 b7:0 */
			0x0238, /* Register address 3 b7:0 */
			0x0239, /* Register address 4 b7:0 */
			0x023A, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* MXAXB_DEN */
	{
		"MXAXB_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x023B, /* Register address 0 b7:0 */
			0x023C, /* Register address 1 b7:0 */
			0x023D, /* Register address 2 b7:0 */
			0x023E, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* MXAXB_UPDATE */
	{
		"MXAXB_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x023F, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* R0_REG */
	{
		"R0_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x024A, /* Register address 0 b7:0 */
			0x024B, /* Register address 1 b7:0 */
			0x024C, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R1_REG */
	{
		"R1_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x024D, /* Register address 0 b7:0 */
			0x024E, /* Register address 1 b7:0 */
			0x024F, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R2_REG */
	{
		"R2_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0250, /* Register address 0 b7:0 */
			0x0251, /* Register address 1 b7:0 */
			0x0252, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R3_REG */
	{
		"R3_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0253, /* Register address 0 b7:0 */
			0x0254, /* Register address 1 b7:0 */
			0x0255, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R4_REG */
	{
		"R4_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0256, /* Register address 0 b7:0 */
			0x0257, /* Register address 1 b7:0 */
			0x0258, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R5_REG */
	{
		"R5_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0259, /* Register address 0 b7:0 */
			0x025A, /* Register address 1 b7:0 */
			0x025B, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R6_REG */
	{
		"R6_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x025C, /* Register address 0 b7:0 */
			0x025D, /* Register address 1 b7:0 */
			0x025E, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R7_REG */
	{
		"R7_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x025F, /* Register address 0 b7:0 */
			0x0260, /* Register address 1 b7:0 */
			0x0261, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R8_REG */
	{
		"R8_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0262, /* Register address 0 b7:0 */
			0x0263, /* Register address 1 b7:0 */
			0x0264, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* R9_REG */
	{
		"R9_REG",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0268, /* Register address 0 b7:0 */
			0x0269, /* Register address 1 b7:0 */
			0x026A, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* DESIGN_ID0 */
	{
		"DESIGN_ID0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x026B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID1 */
	{
		"DESIGN_ID1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x026C, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID2 */
	{
		"DESIGN_ID2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x026D, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID3 */
	{
		"DESIGN_ID3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x026E, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID4 */
	{
		"DESIGN_ID4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x026F, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID5 */
	{
		"DESIGN_ID5",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0270, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID6 */
	{
		"DESIGN_ID6",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0271, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* DESIGN_ID7 */
	{
		"DESIGN_ID7",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0272, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_ID0 */
	{
		"OPN_ID0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0278, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_ID1 */
	{
		"OPN_ID1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0279, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_ID2 */
	{
		"OPN_ID2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x027A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_ID3 */
	{
		"OPN_ID3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x027B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_ID4 */
	{
		"OPN_ID4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x027C, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OPN_REVISION */
	{
		"OPN_REVISION",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x027D, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* BASELINE_ID */
	{
		"BASELINE_ID",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x027E, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* OOF0_TRG_THR_EXT */
	{
		"OOF0_TRG_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028A, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF1_TRG_THR_EXT */
	{
		"OOF1_TRG_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028B, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF2_TRG_THR_EXT */
	{
		"OOF2_TRG_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028C, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF3_TRG_THR_EXT */
	{
		"OOF3_TRG_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028D, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF0_CLR_THR_EXT */
	{
		"OOF0_CLR_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028E, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF1_CLR_THR_EXT */
	{
		"OOF1_CLR_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x028F, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF2_CLR_THR_EXT */
	{
		"OOF2_CLR_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0290, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF3_CLR_THR_EXT */
	{
		"OOF3_CLR_THR_EXT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0291, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_EXTEND_SCL */
	{
		"FASTLOCK_EXTEND_SCL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0294, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* LOL_SLW_VALWIN_SELX */
	{
		"LOL_SLW_VALWIN_SELX",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0296, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* FASTLOCK_DLY_ONSW_EN */
	{
		"FASTLOCK_DLY_ONSW_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0297, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* FASTLOCK_DLY_ONLOL_EN */
	{
		"FASTLOCK_DLY_ONLOL_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0299, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* FASTLOCK_DLY_ONLOL */
	{
		"FASTLOCK_DLY_ONLOL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x029D, /* Register address 0 b7:0 */
			0x029E, /* Register address 1 b7:0 */
			0x029F, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0x0F, /* Register mask 2 */

		}
	},

	/* FASTLOCK_DLY_ONSW */
	{
		"FASTLOCK_DLY_ONSW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		20, /* 20 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x02A9, /* Register address 0 b7:0 */
			0x02AA, /* Register address 1 b7:0 */
			0x02AB, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0x0F, /* Register mask 2 */

		}
	},

	/* LOL_NOSIG_TIME */
	{
		"LOL_NOSIG_TIME",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x02B7, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* LOL_LOS_REFCLK */
	{
		"LOL_LOS_REFCLK",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x02B8, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* N0_NUM */
	{
		"N0_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0302, /* Register address 0 b7:0 */
			0x0303, /* Register address 1 b7:0 */
			0x0304, /* Register address 2 b7:0 */
			0x0305, /* Register address 3 b7:0 */
			0x0306, /* Register address 4 b7:0 */
			0x0307, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N0_DEN */
	{
		"N0_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0308, /* Register address 0 b7:0 */
			0x0309, /* Register address 1 b7:0 */
			0x030A, /* Register address 2 b7:0 */
			0x030B, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* N0_UPDATE */
	{
		"N0_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x030C, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N1_NUM */
	{
		"N1_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x030D, /* Register address 0 b7:0 */
			0x030E, /* Register address 1 b7:0 */
			0x030F, /* Register address 2 b7:0 */
			0x0310, /* Register address 3 b7:0 */
			0x0311, /* Register address 4 b7:0 */
			0x0312, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N1_DEN */
	{
		"N1_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0313, /* Register address 0 b7:0 */
			0x0314, /* Register address 1 b7:0 */
			0x0315, /* Register address 2 b7:0 */
			0x0316, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* N1_UPDATE */
	{
		"N1_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0317, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N2_NUM */
	{
		"N2_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0318, /* Register address 0 b7:0 */
			0x0319, /* Register address 1 b7:0 */
			0x031A, /* Register address 2 b7:0 */
			0x031B, /* Register address 3 b7:0 */
			0x031C, /* Register address 4 b7:0 */
			0x031D, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N2_DEN */
	{
		"N2_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x031E, /* Register address 0 b7:0 */
			0x031F, /* Register address 1 b7:0 */
			0x0320, /* Register address 2 b7:0 */
			0x0321, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* N2_UPDATE */
	{
		"N2_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0322, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N3_NUM */
	{
		"N3_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0323, /* Register address 0 b7:0 */
			0x0324, /* Register address 1 b7:0 */
			0x0325, /* Register address 2 b7:0 */
			0x0326, /* Register address 3 b7:0 */
			0x0327, /* Register address 4 b7:0 */
			0x0328, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N3_DEN */
	{
		"N3_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0329, /* Register address 0 b7:0 */
			0x032A, /* Register address 1 b7:0 */
			0x032B, /* Register address 2 b7:0 */
			0x032C, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* N3_UPDATE */
	{
		"N3_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x032D, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N4_NUM */
	{
		"N4_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x032E, /* Register address 0 b7:0 */
			0x032F, /* Register address 1 b7:0 */
			0x0330, /* Register address 2 b7:0 */
			0x0331, /* Register address 3 b7:0 */
			0x0332, /* Register address 4 b7:0 */
			0x0333, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N4_DEN */
	{
		"N4_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x0334, /* Register address 0 b7:0 */
			0x0335, /* Register address 1 b7:0 */
			0x0336, /* Register address 2 b7:0 */
			0x0337, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* N4_UPDATE */
	{
		"N4_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0338, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N_UPDATE */
	{
		"N_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0338, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* N_FSTEP_MSK */
	{
		"N_FSTEP_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0339, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N0_FSTEPW */
	{
		"N0_FSTEPW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x033B, /* Register address 0 b7:0 */
			0x033C, /* Register address 1 b7:0 */
			0x033D, /* Register address 2 b7:0 */
			0x033E, /* Register address 3 b7:0 */
			0x033F, /* Register address 4 b7:0 */
			0x0340, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N1_FSTEPW */
	{
		"N1_FSTEPW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0341, /* Register address 0 b7:0 */
			0x0342, /* Register address 1 b7:0 */
			0x0343, /* Register address 2 b7:0 */
			0x0344, /* Register address 3 b7:0 */
			0x0345, /* Register address 4 b7:0 */
			0x0346, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N2_FSTEPW */
	{
		"N2_FSTEPW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0347, /* Register address 0 b7:0 */
			0x0348, /* Register address 1 b7:0 */
			0x0349, /* Register address 2 b7:0 */
			0x034A, /* Register address 3 b7:0 */
			0x034B, /* Register address 4 b7:0 */
			0x034C, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N3_FSTEPW */
	{
		"N3_FSTEPW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x034D, /* Register address 0 b7:0 */
			0x034E, /* Register address 1 b7:0 */
			0x034F, /* Register address 2 b7:0 */
			0x0350, /* Register address 3 b7:0 */
			0x0351, /* Register address 4 b7:0 */
			0x0352, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N4_FSTEPW */
	{
		"N4_FSTEPW",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		44, /* 44 bits in this setting */
		0, /* setting starts at b0 in first register */
		6, /* contained in 6 registers(s) */
		{
			0x0353, /* Register address 0 b7:0 */
			0x0354, /* Register address 1 b7:0 */
			0x0355, /* Register address 2 b7:0 */
			0x0356, /* Register address 3 b7:0 */
			0x0357, /* Register address 4 b7:0 */
			0x0358, /* Register address 5 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0x0F, /* Register mask 5 */

		}
	},

	/* N0_DELAY */
	{
		"N0_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0359, /* Register address 0 b7:0 */
			0x035A, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* N1_DELAY */
	{
		"N1_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x035B, /* Register address 0 b7:0 */
			0x035C, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* N2_DELAY */
	{
		"N2_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x035D, /* Register address 0 b7:0 */
			0x035E, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* N3_DELAY */
	{
		"N3_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x035F, /* Register address 0 b7:0 */
			0x0360, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* N4_DELAY */
	{
		"N4_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0361, /* Register address 0 b7:0 */
			0x0362, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* ZDM_EN */
	{
		"ZDM_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0487, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* ZDM_IN_SEL */
	{
		"ZDM_IN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0487, /* Register address 0 b7:0 */

		},
		{
			0x06, /* Register mask 0 */

		}
	},

	/* ZDM_AUTOSW_EN */
	{
		"ZDM_AUTOSW_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0487, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* BW0_PLL */
	{
		"BW0_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0508, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW1_PLL */
	{
		"BW1_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0509, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW2_PLL */
	{
		"BW2_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050A, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW3_PLL */
	{
		"BW3_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050B, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW4_PLL */
	{
		"BW4_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050C, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW5_PLL */
	{
		"BW5_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050D, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW0_PLL */
	{
		"FASTLOCK_BW0_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050E, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW1_PLL */
	{
		"FASTLOCK_BW1_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x050F, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW2_PLL */
	{
		"FASTLOCK_BW2_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0510, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW3_PLL */
	{
		"FASTLOCK_BW3_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0511, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW4_PLL */
	{
		"FASTLOCK_BW4_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0512, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* FASTLOCK_BW5_PLL */
	{
		"FASTLOCK_BW5_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0513, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* BW_UPDATE_PLL */
	{
		"BW_UPDATE_PLL",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0514, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* M_NUM */
	{
		"M_NUM",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		56, /* 56 bits in this setting */
		0, /* setting starts at b0 in first register */
		7, /* contained in 7 registers(s) */
		{
			0x0515, /* Register address 0 b7:0 */
			0x0516, /* Register address 1 b7:0 */
			0x0517, /* Register address 2 b7:0 */
			0x0518, /* Register address 3 b7:0 */
			0x0519, /* Register address 4 b7:0 */
			0x051A, /* Register address 5 b7:0 */
			0x051B, /* Register address 6 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */
			0xFF, /* Register mask 4 */
			0xFF, /* Register mask 5 */
			0xFF, /* Register mask 6 */

		}
	},

	/* M_DEN */
	{
		"M_DEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		32, /* 32 bits in this setting */
		0, /* setting starts at b0 in first register */
		4, /* contained in 4 registers(s) */
		{
			0x051C, /* Register address 0 b7:0 */
			0x051D, /* Register address 1 b7:0 */
			0x051E, /* Register address 2 b7:0 */
			0x051F, /* Register address 3 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */
			0xFF, /* Register mask 3 */

		}
	},

	/* M_UPDATE */
	{
		"M_UPDATE",
		0, /* 0 = NOT Read Only */
		1, /* 1 = IS Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0520, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* M_FRAC_MODE */
	{
		"M_FRAC_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0521, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* M_FRAC_EN */
	{
		"M_FRAC_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0521, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* PLL_OUT_RATE_SEL */
	{
		"PLL_OUT_RATE_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0521, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* IN_SEL_REGCTRL */
	{
		"IN_SEL_REGCTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052A, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* IN_SEL */
	{
		"IN_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052A, /* Register address 0 b7:0 */

		},
		{
			0x0E, /* Register mask 0 */

		}
	},

	/* FASTLOCK_AUTO_EN */
	{
		"FASTLOCK_AUTO_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052B, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* FASTLOCK_MAN */
	{
		"FASTLOCK_MAN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052B, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_EN */
	{
		"HOLD_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052C, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* HOLD_RAMP_BYP */
	{
		"HOLD_RAMP_BYP",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW_SEL1 */
	{
		"HOLDEXIT_BW_SEL1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052C, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* RAMP_STEP_INTERVAL */
	{
		"RAMP_STEP_INTERVAL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052C, /* Register address 0 b7:0 */

		},
		{
			0xE0, /* Register mask 0 */

		}
	},

	/* HOLD_RAMPBYP_NOHIST */
	{
		"HOLD_RAMPBYP_NOHIST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052D, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_HIST_LEN */
	{
		"HOLD_HIST_LEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052E, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* HOLD_HIST_DELAY */
	{
		"HOLD_HIST_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x052F, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* HOLD_REF_COUNT_FRC */
	{
		"HOLD_REF_COUNT_FRC",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0531, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* HOLD_15M_CYC_COUNT */
	{
		"HOLD_15M_CYC_COUNT",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		24, /* 24 bits in this setting */
		0, /* setting starts at b0 in first register */
		3, /* contained in 3 registers(s) */
		{
			0x0532, /* Register address 0 b7:0 */
			0x0533, /* Register address 1 b7:0 */
			0x0534, /* Register address 2 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */
			0xFF, /* Register mask 2 */

		}
	},

	/* FORCE_HOLD */
	{
		"FORCE_HOLD",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0535, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* CLK_SWITCH_MODE */
	{
		"CLK_SWITCH_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0536, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* HSW_EN */
	{
		"HSW_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0536, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* IN_LOS_MSK */
	{
		"IN_LOS_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0537, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* IN_OOF_MSK */
	{
		"IN_OOF_MSK",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0537, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* IN0_PRIORITY */
	{
		"IN0_PRIORITY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0538, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* IN1_PRIORITY */
	{
		"IN1_PRIORITY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0538, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* IN2_PRIORITY */
	{
		"IN2_PRIORITY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0539, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* IN3_PRIORITY */
	{
		"IN3_PRIORITY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0539, /* Register address 0 b7:0 */

		},
		{
			0x70, /* Register mask 0 */

		}
	},

	/* HSW_MODE */
	{
		"HSW_MODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		2, /* 2 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053A, /* Register address 0 b7:0 */

		},
		{
			0x03, /* Register mask 0 */

		}
	},

	/* HSW_PHMEAS_CTRL */
	{
		"HSW_PHMEAS_CTRL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		2, /* 2 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053A, /* Register address 0 b7:0 */

		},
		{
			0x0C, /* Register mask 0 */

		}
	},

	/* HSW_PHMEAS_THR */
	{
		"HSW_PHMEAS_THR",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_SLAB, /* SiLabs NVM Bank */
		10, /* 10 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x053B, /* Register address 0 b7:0 */
			0x053C, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x03, /* Register mask 1 */

		}
	},

	/* HSW_COARSE_PM_LEN */
	{
		"HSW_COARSE_PM_LEN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053D, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* HSW_COARSE_PM_DLY */
	{
		"HSW_COARSE_PM_DLY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053E, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* HOLD_HIST_VALID */
	{
		"HOLD_HIST_VALID",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053F, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* FASTLOCK_STATUS */
	{
		"FASTLOCK_STATUS",
		1, /* 1 = IS Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_NONE, /* Not stored in NVM */
		1, /* 1 bits in this setting */
		2, /* setting starts at b2 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x053F, /* Register address 0 b7:0 */

		},
		{
			0x04, /* Register mask 0 */

		}
	},

	/* CAP_SHORT_DELAY */
	{
		"CAP_SHORT_DELAY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		13, /* 13 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0589, /* Register address 0 b7:0 */
			0x058A, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x1F, /* Register mask 1 */

		}
	},

	/* INIT_LP_CLOSE_HO */
	{
		"INIT_LP_CLOSE_HO",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		1, /* setting starts at b1 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059B, /* Register address 0 b7:0 */

		},
		{
			0x02, /* Register mask 0 */

		}
	},

	/* HOLD_PRESERVE_HIST */
	{
		"HOLD_PRESERVE_HIST",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059B, /* Register address 0 b7:0 */

		},
		{
			0x10, /* Register mask 0 */

		}
	},

	/* HOLD_FRZ_WITH_INTONLY */
	{
		"HOLD_FRZ_WITH_INTONLY",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059B, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW_SEL0 */
	{
		"HOLDEXIT_BW_SEL0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		6, /* setting starts at b6 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059B, /* Register address 0 b7:0 */

		},
		{
			0x40, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_STD_BO */
	{
		"HOLDEXIT_STD_BO",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		7, /* setting starts at b7 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059B, /* Register address 0 b7:0 */

		},
		{
			0x80, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW0 */
	{
		"HOLDEXIT_BW0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059D, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW1 */
	{
		"HOLDEXIT_BW1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059E, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW2 */
	{
		"HOLDEXIT_BW2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x059F, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW3 */
	{
		"HOLDEXIT_BW3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x05A0, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW4 */
	{
		"HOLDEXIT_BW4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x05A1, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* HOLDEXIT_BW5 */
	{
		"HOLDEXIT_BW5",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		6, /* 6 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x05A2, /* Register address 0 b7:0 */

		},
		{
			0x3F, /* Register mask 0 */

		}
	},

	/* RAMP_STEP_SIZE */
	{
		"RAMP_STEP_SIZE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		3, /* 3 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x05A6, /* Register address 0 b7:0 */

		},
		{
			0x07, /* Register mask 0 */

		}
	},

	/* RAMP_SWITCH_EN */
	{
		"RAMP_SWITCH_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x05A6, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* FIXREGSA0 */
	{
		"FIXREGSA0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0802, /* Register address 0 b7:0 */
			0x0803, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD0 */
	{
		"FIXREGSD0",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0804, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA1 */
	{
		"FIXREGSA1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0805, /* Register address 0 b7:0 */
			0x0806, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD1 */
	{
		"FIXREGSD1",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0807, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA2 */
	{
		"FIXREGSA2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0808, /* Register address 0 b7:0 */
			0x0809, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD2 */
	{
		"FIXREGSD2",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x080A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA3 */
	{
		"FIXREGSA3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x080B, /* Register address 0 b7:0 */
			0x080C, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD3 */
	{
		"FIXREGSD3",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x080D, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA4 */
	{
		"FIXREGSA4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x080E, /* Register address 0 b7:0 */
			0x080F, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD4 */
	{
		"FIXREGSD4",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0810, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA5 */
	{
		"FIXREGSA5",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0811, /* Register address 0 b7:0 */
			0x0812, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD5 */
	{
		"FIXREGSD5",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0813, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA6 */
	{
		"FIXREGSA6",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0814, /* Register address 0 b7:0 */
			0x0815, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD6 */
	{
		"FIXREGSD6",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0816, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA7 */
	{
		"FIXREGSA7",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0817, /* Register address 0 b7:0 */
			0x0818, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD7 */
	{
		"FIXREGSD7",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0819, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA8 */
	{
		"FIXREGSA8",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x081A, /* Register address 0 b7:0 */
			0x081B, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD8 */
	{
		"FIXREGSD8",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x081C, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA9 */
	{
		"FIXREGSA9",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x081D, /* Register address 0 b7:0 */
			0x081E, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD9 */
	{
		"FIXREGSD9",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x081F, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA10 */
	{
		"FIXREGSA10",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0820, /* Register address 0 b7:0 */
			0x0821, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD10 */
	{
		"FIXREGSD10",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0822, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA11 */
	{
		"FIXREGSA11",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0823, /* Register address 0 b7:0 */
			0x0824, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD11 */
	{
		"FIXREGSD11",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0825, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA12 */
	{
		"FIXREGSA12",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0826, /* Register address 0 b7:0 */
			0x0827, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD12 */
	{
		"FIXREGSD12",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0828, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA13 */
	{
		"FIXREGSA13",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0829, /* Register address 0 b7:0 */
			0x082A, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD13 */
	{
		"FIXREGSD13",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x082B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA14 */
	{
		"FIXREGSA14",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x082C, /* Register address 0 b7:0 */
			0x082D, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD14 */
	{
		"FIXREGSD14",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x082E, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA15 */
	{
		"FIXREGSA15",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x082F, /* Register address 0 b7:0 */
			0x0830, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD15 */
	{
		"FIXREGSD15",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0831, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA16 */
	{
		"FIXREGSA16",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0832, /* Register address 0 b7:0 */
			0x0833, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD16 */
	{
		"FIXREGSD16",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0834, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA17 */
	{
		"FIXREGSA17",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0835, /* Register address 0 b7:0 */
			0x0836, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD17 */
	{
		"FIXREGSD17",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0837, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA18 */
	{
		"FIXREGSA18",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0838, /* Register address 0 b7:0 */
			0x0839, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD18 */
	{
		"FIXREGSD18",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x083A, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA19 */
	{
		"FIXREGSA19",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x083B, /* Register address 0 b7:0 */
			0x083C, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD19 */
	{
		"FIXREGSD19",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x083D, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA20 */
	{
		"FIXREGSA20",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x083E, /* Register address 0 b7:0 */
			0x083F, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD20 */
	{
		"FIXREGSD20",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0840, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA21 */
	{
		"FIXREGSA21",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0841, /* Register address 0 b7:0 */
			0x0842, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD21 */
	{
		"FIXREGSD21",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0843, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA22 */
	{
		"FIXREGSA22",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0844, /* Register address 0 b7:0 */
			0x0845, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD22 */
	{
		"FIXREGSD22",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0846, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA23 */
	{
		"FIXREGSA23",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0847, /* Register address 0 b7:0 */
			0x0848, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD23 */
	{
		"FIXREGSD23",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0849, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA24 */
	{
		"FIXREGSA24",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x084A, /* Register address 0 b7:0 */
			0x084B, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD24 */
	{
		"FIXREGSD24",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x084C, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA25 */
	{
		"FIXREGSA25",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x084D, /* Register address 0 b7:0 */
			0x084E, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD25 */
	{
		"FIXREGSD25",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x084F, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA26 */
	{
		"FIXREGSA26",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0850, /* Register address 0 b7:0 */
			0x0851, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD26 */
	{
		"FIXREGSD26",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0852, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA27 */
	{
		"FIXREGSA27",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0853, /* Register address 0 b7:0 */
			0x0854, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD27 */
	{
		"FIXREGSD27",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0855, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA28 */
	{
		"FIXREGSA28",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0856, /* Register address 0 b7:0 */
			0x0857, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD28 */
	{
		"FIXREGSD28",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0858, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA29 */
	{
		"FIXREGSA29",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0859, /* Register address 0 b7:0 */
			0x085A, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD29 */
	{
		"FIXREGSD29",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x085B, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA30 */
	{
		"FIXREGSA30",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x085C, /* Register address 0 b7:0 */
			0x085D, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD30 */
	{
		"FIXREGSD30",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x085E, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* FIXREGSA31 */
	{
		"FIXREGSA31",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		16, /* 16 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x085F, /* Register address 0 b7:0 */
			0x0860, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0xFF, /* Register mask 1 */

		}
	},

	/* FIXREGSD31 */
	{
		"FIXREGSD31",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		8, /* 8 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0861, /* Register address 0 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */

		}
	},

	/* XAXB_EXTCLK_EN */
	{
		"XAXB_EXTCLK_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x090E, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* IO_VDD_SEL */
	{
		"IO_VDD_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0943, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* IN_EN */
	{
		"IN_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0949, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* IN_PULSED_CMOS_EN */
	{
		"IN_PULSED_CMOS_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		4, /* setting starts at b4 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0949, /* Register address 0 b7:0 */

		},
		{
			0xF0, /* Register mask 0 */

		}
	},

	/* INX_TO_PFD_EN */
	{
		"INX_TO_PFD_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x094A, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* REFCLK_HYS_SEL */
	{
		"REFCLK_HYS_SEL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x094E, /* Register address 0 b7:0 */
			0x094F, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

	/* MXAXB_INTEGER */
	{
		"MXAXB_INTEGER",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x095E, /* Register address 0 b7:0 */

		},
		{
			0x01, /* Register mask 0 */

		}
	},

	/* N_ADD_0P5 */
	{
		"N_ADD_0P5",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A02, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N_CLK_TO_OUTX_EN */
	{
		"N_CLK_TO_OUTX_EN",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A03, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N_PIBYP */
	{
		"N_PIBYP",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A04, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N_PDNB */
	{
		"N_PDNB",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A05, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N0_HIGH_FREQ */
	{
		"N0_HIGH_FREQ",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A14, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* N1_HIGH_FREQ */
	{
		"N1_HIGH_FREQ",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A1A, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* N2_HIGH_FREQ */
	{
		"N2_HIGH_FREQ",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A20, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* N3_HIGH_FREQ */
	{
		"N3_HIGH_FREQ",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A26, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* N4_HIGH_FREQ */
	{
		"N4_HIGH_FREQ",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		3, /* setting starts at b3 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0A2C, /* Register address 0 b7:0 */

		},
		{
			0x08, /* Register mask 0 */

		}
	},

	/* PDIV_FRACN_CLK_DIS */
	{
		"PDIV_FRACN_CLK_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B44, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* FRACN_CLK_DIS_PLL */
	{
		"FRACN_CLK_DIS_PLL",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		1, /* 1 bits in this setting */
		5, /* setting starts at b5 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B44, /* Register address 0 b7:0 */

		},
		{
			0x20, /* Register mask 0 */

		}
	},

	/* LOS_CLK_DIS */
	{
		"LOS_CLK_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		4, /* 4 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B46, /* Register address 0 b7:0 */

		},
		{
			0x0F, /* Register mask 0 */

		}
	},

	/* OOF_CLK_DIS */
	{
		"OOF_CLK_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B47, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* OOF_DIV_CLK_DIS */
	{
		"OOF_DIV_CLK_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B48, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* N_CLK_DIS */
	{
		"N_CLK_DIS",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		5, /* 5 bits in this setting */
		0, /* setting starts at b0 in first register */
		1, /* contained in 1 registers(s) */
		{
			0x0B4A, /* Register address 0 b7:0 */

		},
		{
			0x1F, /* Register mask 0 */

		}
	},

	/* VCO_RESET_CALCODE */
	{
		"VCO_RESET_CALCODE",
		0, /* 0 = NOT Read Only */
		0, /* 0 = NOT Self Clearing */
		SLAB_NVMT_CUST, /* Customer NVM Bank */
		12, /* 12 bits in this setting */
		0, /* setting starts at b0 in first register */
		2, /* contained in 2 registers(s) */
		{
			0x0B57, /* Register address 0 b7:0 */
			0x0B58, /* Register address 1 b7:0 */

		},
		{
			0xFF, /* Register mask 0 */
			0x0F, /* Register mask 1 */

		}
	},

};

/* Setting indexes into si5345_revd_settings array */
#define            SI5345_REVD_DIE_REV 0
#define               SI5345_REVD_PAGE 1
#define            SI5345_REVD_PN_BASE 2
#define              SI5345_REVD_GRADE 3
#define         SI5345_REVD_DEVICE_REV 4
#define       SI5345_REVD_TOOL_VERSION 5
#define         SI5345_REVD_TEMP_GRADE 6
#define             SI5345_REVD_PKG_ID 7
#define           SI5345_REVD_I2C_ADDR 8
#define           SI5345_REVD_SYSINCAL 9
#define            SI5345_REVD_LOSXAXB 10
#define      SI5345_REVD_SMBUS_TIMEOUT 11
#define                SI5345_REVD_LOS 12
#define                SI5345_REVD_OOF 13
#define                SI5345_REVD_LOL 14
#define               SI5345_REVD_HOLD 15
#define            SI5345_REVD_CAL_PLL 16
#define       SI5345_REVD_SYSINCAL_FLG 17
#define        SI5345_REVD_LOSXAXB_FLG 18
#define  SI5345_REVD_SMBUS_TIMEOUT_FLG 19
#define            SI5345_REVD_LOS_FLG 20
#define            SI5345_REVD_OOF_FLG 21
#define            SI5345_REVD_LOL_FLG 22
#define           SI5345_REVD_HOLD_FLG 23
#define        SI5345_REVD_CAL_FLG_PLL 24
#define        SI5345_REVD_LOL_ON_HOLD 25
#define  SI5345_REVD_SYSINCAL_INTR_MSK 26
#define   SI5345_REVD_LOSXAXB_INTR_MSK 27
#define SI5345_REVD_SMB_TMOUT_INTR_MSK 28
#define       SI5345_REVD_LOS_INTR_MSK 29
#define       SI5345_REVD_OOF_INTR_MSK 30
#define       SI5345_REVD_LOL_INTR_MSK 31
#define      SI5345_REVD_HOLD_INTR_MSK 32
#define       SI5345_REVD_CAL_INTR_MSK 33
#define           SI5345_REVD_SOFT_RST 34
#define       SI5345_REVD_SOFT_RST_ALL 35
#define            SI5345_REVD_SOFTCAL 36
#define               SI5345_REVD_FINC 37
#define               SI5345_REVD_FDEC 38
#define                SI5345_REVD_PDN 39
#define           SI5345_REVD_HARD_RST 40
#define               SI5345_REVD_SYNC 41
#define          SI5345_REVD_SPI_3WIRE 42
#define   SI5345_REVD_AUTO_NDIV_UPDATE 43
#define             SI5345_REVD_LOS_EN 44
#define        SI5345_REVD_LOSXAXB_DIS 45
#define      SI5345_REVD_LOS0_VAL_TIME 46
#define      SI5345_REVD_LOS1_VAL_TIME 47
#define      SI5345_REVD_LOS2_VAL_TIME 48
#define      SI5345_REVD_LOS3_VAL_TIME 49
#define       SI5345_REVD_LOS0_TRG_THR 50
#define       SI5345_REVD_LOS1_TRG_THR 51
#define       SI5345_REVD_LOS2_TRG_THR 52
#define       SI5345_REVD_LOS3_TRG_THR 53
#define       SI5345_REVD_LOS0_CLR_THR 54
#define       SI5345_REVD_LOS1_CLR_THR 55
#define       SI5345_REVD_LOS2_CLR_THR 56
#define       SI5345_REVD_LOS3_CLR_THR 57
#define             SI5345_REVD_OOF_EN 58
#define        SI5345_REVD_FAST_OOF_EN 59
#define        SI5345_REVD_OOF_REF_SEL 60
#define       SI5345_REVD_OOF0_DIV_SEL 61
#define       SI5345_REVD_OOF1_DIV_SEL 62
#define       SI5345_REVD_OOF2_DIV_SEL 63
#define       SI5345_REVD_OOF3_DIV_SEL 64
#define      SI5345_REVD_OOFXO_DIV_SEL 65
#define       SI5345_REVD_OOF0_SET_THR 66
#define       SI5345_REVD_OOF1_SET_THR 67
#define       SI5345_REVD_OOF2_SET_THR 68
#define       SI5345_REVD_OOF3_SET_THR 69
#define       SI5345_REVD_OOF0_CLR_THR 70
#define       SI5345_REVD_OOF1_CLR_THR 71
#define       SI5345_REVD_OOF2_CLR_THR 72
#define       SI5345_REVD_OOF3_CLR_THR 73
#define    SI5345_REVD_OOF0_DETWIN_SEL 74
#define    SI5345_REVD_OOF1_DETWIN_SEL 75
#define    SI5345_REVD_OOF2_DETWIN_SEL 76
#define    SI5345_REVD_OOF3_DETWIN_SEL 77
#define         SI5345_REVD_OOF_ON_LOS 78
#define  SI5345_REVD_FAST_OOF0_SET_THR 79
#define  SI5345_REVD_FAST_OOF1_SET_THR 80
#define  SI5345_REVD_FAST_OOF2_SET_THR 81
#define  SI5345_REVD_FAST_OOF3_SET_THR 82
#define  SI5345_REVD_FAST_OOF0_CLR_THR 83
#define  SI5345_REVD_FAST_OOF1_CLR_THR 84
#define  SI5345_REVD_FAST_OOF2_CLR_THR 85
#define  SI5345_REVD_FAST_OOF3_CLR_THR 86
#define SI5345_REVD_FAST_OOF0_DETWIN_SEL 87
#define SI5345_REVD_FAST_OOF1_DETWIN_SEL 88
#define SI5345_REVD_FAST_OOF2_DETWIN_SEL 89
#define SI5345_REVD_FAST_OOF3_DETWIN_SEL 90
#define     SI5345_REVD_OOF0_RATIO_REF 91
#define     SI5345_REVD_OOF1_RATIO_REF 92
#define     SI5345_REVD_OOF2_RATIO_REF 93
#define     SI5345_REVD_OOF3_RATIO_REF 94
#define         SI5345_REVD_LOL_FST_EN 95
#define SI5345_REVD_LOL_FST_DETWIN_SEL 96
#define SI5345_REVD_LOL_FST_VALWIN_SEL 97
#define SI5345_REVD_LOL_FST_SET_THR_SEL 98
#define SI5345_REVD_LOL_FST_CLR_THR_SEL 99
#define    SI5345_REVD_LOL_SLOW_EN_PLL 100
#define SI5345_REVD_LOL_SLW_DETWIN_SEL 101
#define SI5345_REVD_LOL_SLW_VALWIN_SEL 102
#define    SI5345_REVD_LOL_SLW_SET_THR 103
#define    SI5345_REVD_LOL_SLW_CLR_THR 104
#define       SI5345_REVD_LOL_TIMER_EN 105
#define SI5345_REVD_LOL_CLR_DELAY_DIV256 106
#define    SI5345_REVD_ACTIVE_NVM_BANK 107
#define SI5345_REVD_FASTLOCK_EXTEND_EN 108
#define    SI5345_REVD_FASTLOCK_EXTEND 109
#define      SI5345_REVD_REG_0XF7_INTR 110
#define      SI5345_REVD_REG_0XF8_INTR 111
#define      SI5345_REVD_REG_0XF9_INTR 112
#define      SI5345_REVD_SYSINCAL_INTR 113
#define       SI5345_REVD_LOSXAXB_INTR 114
#define        SI5345_REVD_LOSREF_INTR 115
#define        SI5345_REVD_LOSVCO_INTR 116
#define SI5345_REVD_SMBUS_TIME_OUT_INTR 117
#define           SI5345_REVD_LOS_INTR 118
#define           SI5345_REVD_OOF_INTR 119
#define           SI5345_REVD_LOL_INTR 120
#define          SI5345_REVD_HOLD_INTR 121
#define SI5345_REVD_OUTALL_DISABLE_LOW 122
#define           SI5345_REVD_OUT0_PDN 123
#define            SI5345_REVD_OUT0_OE 124
#define   SI5345_REVD_OUT0_RDIV_FORCE2 125
#define        SI5345_REVD_OUT0_FORMAT 126
#define       SI5345_REVD_OUT0_SYNC_EN 127
#define     SI5345_REVD_OUT0_DIS_STATE 128
#define      SI5345_REVD_OUT0_CMOS_DRV 129
#define            SI5345_REVD_OUT0_CM 130
#define          SI5345_REVD_OUT0_AMPL 131
#define       SI5345_REVD_OUT0_MUX_SEL 132
#define       SI5345_REVD_OUT0_VDD_SEL 133
#define    SI5345_REVD_OUT0_VDD_SEL_EN 134
#define           SI5345_REVD_OUT0_INV 135
#define           SI5345_REVD_OUT1_PDN 136
#define            SI5345_REVD_OUT1_OE 137
#define   SI5345_REVD_OUT1_RDIV_FORCE2 138
#define        SI5345_REVD_OUT1_FORMAT 139
#define       SI5345_REVD_OUT1_SYNC_EN 140
#define     SI5345_REVD_OUT1_DIS_STATE 141
#define      SI5345_REVD_OUT1_CMOS_DRV 142
#define            SI5345_REVD_OUT1_CM 143
#define          SI5345_REVD_OUT1_AMPL 144
#define       SI5345_REVD_OUT1_MUX_SEL 145
#define       SI5345_REVD_OUT1_VDD_SEL 146
#define    SI5345_REVD_OUT1_VDD_SEL_EN 147
#define           SI5345_REVD_OUT1_INV 148
#define           SI5345_REVD_OUT2_PDN 149
#define            SI5345_REVD_OUT2_OE 150
#define   SI5345_REVD_OUT2_RDIV_FORCE2 151
#define        SI5345_REVD_OUT2_FORMAT 152
#define       SI5345_REVD_OUT2_SYNC_EN 153
#define     SI5345_REVD_OUT2_DIS_STATE 154
#define      SI5345_REVD_OUT2_CMOS_DRV 155
#define            SI5345_REVD_OUT2_CM 156
#define          SI5345_REVD_OUT2_AMPL 157
#define       SI5345_REVD_OUT2_MUX_SEL 158
#define       SI5345_REVD_OUT2_VDD_SEL 159
#define    SI5345_REVD_OUT2_VDD_SEL_EN 160
#define           SI5345_REVD_OUT2_INV 161
#define           SI5345_REVD_OUT3_PDN 162
#define            SI5345_REVD_OUT3_OE 163
#define   SI5345_REVD_OUT3_RDIV_FORCE2 164
#define        SI5345_REVD_OUT3_FORMAT 165
#define       SI5345_REVD_OUT3_SYNC_EN 166
#define     SI5345_REVD_OUT3_DIS_STATE 167
#define      SI5345_REVD_OUT3_CMOS_DRV 168
#define            SI5345_REVD_OUT3_CM 169
#define          SI5345_REVD_OUT3_AMPL 170
#define       SI5345_REVD_OUT3_MUX_SEL 171
#define       SI5345_REVD_OUT3_VDD_SEL 172
#define    SI5345_REVD_OUT3_VDD_SEL_EN 173
#define           SI5345_REVD_OUT3_INV 174
#define           SI5345_REVD_OUT4_PDN 175
#define            SI5345_REVD_OUT4_OE 176
#define   SI5345_REVD_OUT4_RDIV_FORCE2 177
#define        SI5345_REVD_OUT4_FORMAT 178
#define       SI5345_REVD_OUT4_SYNC_EN 179
#define     SI5345_REVD_OUT4_DIS_STATE 180
#define      SI5345_REVD_OUT4_CMOS_DRV 181
#define            SI5345_REVD_OUT4_CM 182
#define          SI5345_REVD_OUT4_AMPL 183
#define       SI5345_REVD_OUT4_MUX_SEL 184
#define       SI5345_REVD_OUT4_VDD_SEL 185
#define    SI5345_REVD_OUT4_VDD_SEL_EN 186
#define           SI5345_REVD_OUT4_INV 187
#define           SI5345_REVD_OUT5_PDN 188
#define            SI5345_REVD_OUT5_OE 189
#define   SI5345_REVD_OUT5_RDIV_FORCE2 190
#define        SI5345_REVD_OUT5_FORMAT 191
#define       SI5345_REVD_OUT5_SYNC_EN 192
#define     SI5345_REVD_OUT5_DIS_STATE 193
#define      SI5345_REVD_OUT5_CMOS_DRV 194
#define            SI5345_REVD_OUT5_CM 195
#define          SI5345_REVD_OUT5_AMPL 196
#define       SI5345_REVD_OUT5_MUX_SEL 197
#define       SI5345_REVD_OUT5_VDD_SEL 198
#define    SI5345_REVD_OUT5_VDD_SEL_EN 199
#define           SI5345_REVD_OUT5_INV 200
#define           SI5345_REVD_OUT6_PDN 201
#define            SI5345_REVD_OUT6_OE 202
#define   SI5345_REVD_OUT6_RDIV_FORCE2 203
#define        SI5345_REVD_OUT6_FORMAT 204
#define       SI5345_REVD_OUT6_SYNC_EN 205
#define     SI5345_REVD_OUT6_DIS_STATE 206
#define      SI5345_REVD_OUT6_CMOS_DRV 207
#define            SI5345_REVD_OUT6_CM 208
#define          SI5345_REVD_OUT6_AMPL 209
#define       SI5345_REVD_OUT6_MUX_SEL 210
#define       SI5345_REVD_OUT6_VDD_SEL 211
#define    SI5345_REVD_OUT6_VDD_SEL_EN 212
#define           SI5345_REVD_OUT6_INV 213
#define           SI5345_REVD_OUT7_PDN 214
#define            SI5345_REVD_OUT7_OE 215
#define   SI5345_REVD_OUT7_RDIV_FORCE2 216
#define        SI5345_REVD_OUT7_FORMAT 217
#define       SI5345_REVD_OUT7_SYNC_EN 218
#define     SI5345_REVD_OUT7_DIS_STATE 219
#define      SI5345_REVD_OUT7_CMOS_DRV 220
#define            SI5345_REVD_OUT7_CM 221
#define          SI5345_REVD_OUT7_AMPL 222
#define       SI5345_REVD_OUT7_MUX_SEL 223
#define       SI5345_REVD_OUT7_VDD_SEL 224
#define    SI5345_REVD_OUT7_VDD_SEL_EN 225
#define           SI5345_REVD_OUT7_INV 226
#define           SI5345_REVD_OUT8_PDN 227
#define            SI5345_REVD_OUT8_OE 228
#define   SI5345_REVD_OUT8_RDIV_FORCE2 229
#define        SI5345_REVD_OUT8_FORMAT 230
#define       SI5345_REVD_OUT8_SYNC_EN 231
#define     SI5345_REVD_OUT8_DIS_STATE 232
#define      SI5345_REVD_OUT8_CMOS_DRV 233
#define            SI5345_REVD_OUT8_CM 234
#define          SI5345_REVD_OUT8_AMPL 235
#define       SI5345_REVD_OUT8_MUX_SEL 236
#define       SI5345_REVD_OUT8_VDD_SEL 237
#define    SI5345_REVD_OUT8_VDD_SEL_EN 238
#define           SI5345_REVD_OUT8_INV 239
#define           SI5345_REVD_OUT9_PDN 240
#define            SI5345_REVD_OUT9_OE 241
#define   SI5345_REVD_OUT9_RDIV_FORCE2 242
#define        SI5345_REVD_OUT9_FORMAT 243
#define       SI5345_REVD_OUT9_SYNC_EN 244
#define     SI5345_REVD_OUT9_DIS_STATE 245
#define      SI5345_REVD_OUT9_CMOS_DRV 246
#define            SI5345_REVD_OUT9_CM 247
#define          SI5345_REVD_OUT9_AMPL 248
#define       SI5345_REVD_OUT9_MUX_SEL 249
#define       SI5345_REVD_OUT9_VDD_SEL 250
#define    SI5345_REVD_OUT9_VDD_SEL_EN 251
#define           SI5345_REVD_OUT9_INV 252
#define     SI5345_REVD_OUTX_ALWAYS_ON 253
#define        SI5345_REVD_OUT_DIS_MSK 254
#define    SI5345_REVD_OUT_DIS_LOL_MSK 255
#define SI5345_REVD_OUT_DIS_LOSXAXB_MSK 256
#define SI5345_REVD_OUT_DIS_MSK_LOS_PFD 257
#define    SI5345_REVD_OUT_DIS_MSK_LOL 258
#define   SI5345_REVD_OUT_DIS_MSK_HOLD 259
#define        SI5345_REVD_OUT_PDN_ALL 260
#define            SI5345_REVD_OUT_RST 261
#define       SI5345_REVD_OUT_RDIV_RST 262
#define              SI5345_REVD_PXAXB 263
#define             SI5345_REVD_P0_NUM 264
#define             SI5345_REVD_P0_DEN 265
#define             SI5345_REVD_P1_NUM 266
#define             SI5345_REVD_P1_DEN 267
#define             SI5345_REVD_P2_NUM 268
#define             SI5345_REVD_P2_DEN 269
#define             SI5345_REVD_P3_NUM 270
#define             SI5345_REVD_P3_DEN 271
#define          SI5345_REVD_P0_UPDATE 272
#define          SI5345_REVD_P1_UPDATE 273
#define          SI5345_REVD_P2_UPDATE 274
#define          SI5345_REVD_P3_UPDATE 275
#define      SI5345_REVD_P0_FRACN_MODE 276
#define        SI5345_REVD_P0_FRACN_EN 277
#define      SI5345_REVD_P1_FRACN_MODE 278
#define        SI5345_REVD_P1_FRACN_EN 279
#define      SI5345_REVD_P2_FRACN_MODE 280
#define        SI5345_REVD_P2_FRACN_EN 281
#define      SI5345_REVD_P3_FRACN_MODE 282
#define        SI5345_REVD_P3_FRACN_EN 283
#define          SI5345_REVD_MXAXB_NUM 284
#define          SI5345_REVD_MXAXB_DEN 285
#define       SI5345_REVD_MXAXB_UPDATE 286
#define             SI5345_REVD_R0_REG 287
#define             SI5345_REVD_R1_REG 288
#define             SI5345_REVD_R2_REG 289
#define             SI5345_REVD_R3_REG 290
#define             SI5345_REVD_R4_REG 291
#define             SI5345_REVD_R5_REG 292
#define             SI5345_REVD_R6_REG 293
#define             SI5345_REVD_R7_REG 294
#define             SI5345_REVD_R8_REG 295
#define             SI5345_REVD_R9_REG 296
#define         SI5345_REVD_DESIGN_ID0 297
#define         SI5345_REVD_DESIGN_ID1 298
#define         SI5345_REVD_DESIGN_ID2 299
#define         SI5345_REVD_DESIGN_ID3 300
#define         SI5345_REVD_DESIGN_ID4 301
#define         SI5345_REVD_DESIGN_ID5 302
#define         SI5345_REVD_DESIGN_ID6 303
#define         SI5345_REVD_DESIGN_ID7 304
#define            SI5345_REVD_OPN_ID0 305
#define            SI5345_REVD_OPN_ID1 306
#define            SI5345_REVD_OPN_ID2 307
#define            SI5345_REVD_OPN_ID3 308
#define            SI5345_REVD_OPN_ID4 309
#define       SI5345_REVD_OPN_REVISION 310
#define        SI5345_REVD_BASELINE_ID 311
#define   SI5345_REVD_OOF0_TRG_THR_EXT 312
#define   SI5345_REVD_OOF1_TRG_THR_EXT 313
#define   SI5345_REVD_OOF2_TRG_THR_EXT 314
#define   SI5345_REVD_OOF3_TRG_THR_EXT 315
#define   SI5345_REVD_OOF0_CLR_THR_EXT 316
#define   SI5345_REVD_OOF1_CLR_THR_EXT 317
#define   SI5345_REVD_OOF2_CLR_THR_EXT 318
#define   SI5345_REVD_OOF3_CLR_THR_EXT 319
#define SI5345_REVD_FASTLOCK_EXTEND_SCL 320
#define SI5345_REVD_LOL_SLW_VALWIN_SELX 321
#define SI5345_REVD_FASTLOCK_DLY_ONSW_EN 322
#define SI5345_REVD_FASTLOCK_DLY_ONLOL_EN 323
#define SI5345_REVD_FASTLOCK_DLY_ONLOL 324
#define  SI5345_REVD_FASTLOCK_DLY_ONSW 325
#define     SI5345_REVD_LOL_NOSIG_TIME 326
#define     SI5345_REVD_LOL_LOS_REFCLK 327
#define             SI5345_REVD_N0_NUM 328
#define             SI5345_REVD_N0_DEN 329
#define          SI5345_REVD_N0_UPDATE 330
#define             SI5345_REVD_N1_NUM 331
#define             SI5345_REVD_N1_DEN 332
#define          SI5345_REVD_N1_UPDATE 333
#define             SI5345_REVD_N2_NUM 334
#define             SI5345_REVD_N2_DEN 335
#define          SI5345_REVD_N2_UPDATE 336
#define             SI5345_REVD_N3_NUM 337
#define             SI5345_REVD_N3_DEN 338
#define          SI5345_REVD_N3_UPDATE 339
#define             SI5345_REVD_N4_NUM 340
#define             SI5345_REVD_N4_DEN 341
#define          SI5345_REVD_N4_UPDATE 342
#define           SI5345_REVD_N_UPDATE 343
#define        SI5345_REVD_N_FSTEP_MSK 344
#define          SI5345_REVD_N0_FSTEPW 345
#define          SI5345_REVD_N1_FSTEPW 346
#define          SI5345_REVD_N2_FSTEPW 347
#define          SI5345_REVD_N3_FSTEPW 348
#define          SI5345_REVD_N4_FSTEPW 349
#define           SI5345_REVD_N0_DELAY 350
#define           SI5345_REVD_N1_DELAY 351
#define           SI5345_REVD_N2_DELAY 352
#define           SI5345_REVD_N3_DELAY 353
#define           SI5345_REVD_N4_DELAY 354
#define             SI5345_REVD_ZDM_EN 355
#define         SI5345_REVD_ZDM_IN_SEL 356
#define      SI5345_REVD_ZDM_AUTOSW_EN 357
#define            SI5345_REVD_BW0_PLL 358
#define            SI5345_REVD_BW1_PLL 359
#define            SI5345_REVD_BW2_PLL 360
#define            SI5345_REVD_BW3_PLL 361
#define            SI5345_REVD_BW4_PLL 362
#define            SI5345_REVD_BW5_PLL 363
#define   SI5345_REVD_FASTLOCK_BW0_PLL 364
#define   SI5345_REVD_FASTLOCK_BW1_PLL 365
#define   SI5345_REVD_FASTLOCK_BW2_PLL 366
#define   SI5345_REVD_FASTLOCK_BW3_PLL 367
#define   SI5345_REVD_FASTLOCK_BW4_PLL 368
#define   SI5345_REVD_FASTLOCK_BW5_PLL 369
#define      SI5345_REVD_BW_UPDATE_PLL 370
#define              SI5345_REVD_M_NUM 371
#define              SI5345_REVD_M_DEN 372
#define           SI5345_REVD_M_UPDATE 373
#define        SI5345_REVD_M_FRAC_MODE 374
#define          SI5345_REVD_M_FRAC_EN 375
#define   SI5345_REVD_PLL_OUT_RATE_SEL 376
#define     SI5345_REVD_IN_SEL_REGCTRL 377
#define             SI5345_REVD_IN_SEL 378
#define   SI5345_REVD_FASTLOCK_AUTO_EN 379
#define       SI5345_REVD_FASTLOCK_MAN 380
#define            SI5345_REVD_HOLD_EN 381
#define      SI5345_REVD_HOLD_RAMP_BYP 382
#define   SI5345_REVD_HOLDEXIT_BW_SEL1 383
#define SI5345_REVD_RAMP_STEP_INTERVAL 384
#define SI5345_REVD_HOLD_RAMPBYP_NOHIST 385
#define      SI5345_REVD_HOLD_HIST_LEN 386
#define    SI5345_REVD_HOLD_HIST_DELAY 387
#define SI5345_REVD_HOLD_REF_COUNT_FRC 388
#define SI5345_REVD_HOLD_15M_CYC_COUNT 389
#define         SI5345_REVD_FORCE_HOLD 390
#define    SI5345_REVD_CLK_SWITCH_MODE 391
#define             SI5345_REVD_HSW_EN 392
#define         SI5345_REVD_IN_LOS_MSK 393
#define         SI5345_REVD_IN_OOF_MSK 394
#define       SI5345_REVD_IN0_PRIORITY 395
#define       SI5345_REVD_IN1_PRIORITY 396
#define       SI5345_REVD_IN2_PRIORITY 397
#define       SI5345_REVD_IN3_PRIORITY 398
#define           SI5345_REVD_HSW_MODE 399
#define    SI5345_REVD_HSW_PHMEAS_CTRL 400
#define     SI5345_REVD_HSW_PHMEAS_THR 401
#define  SI5345_REVD_HSW_COARSE_PM_LEN 402
#define  SI5345_REVD_HSW_COARSE_PM_DLY 403
#define    SI5345_REVD_HOLD_HIST_VALID 404
#define    SI5345_REVD_FASTLOCK_STATUS 405
#define    SI5345_REVD_CAP_SHORT_DELAY 406
#define   SI5345_REVD_INIT_LP_CLOSE_HO 407
#define SI5345_REVD_HOLD_PRESERVE_HIST 408
#define SI5345_REVD_HOLD_FRZ_WITH_INTONLY 409
#define   SI5345_REVD_HOLDEXIT_BW_SEL0 410
#define    SI5345_REVD_HOLDEXIT_STD_BO 411
#define       SI5345_REVD_HOLDEXIT_BW0 412
#define       SI5345_REVD_HOLDEXIT_BW1 413
#define       SI5345_REVD_HOLDEXIT_BW2 414
#define       SI5345_REVD_HOLDEXIT_BW3 415
#define       SI5345_REVD_HOLDEXIT_BW4 416
#define       SI5345_REVD_HOLDEXIT_BW5 417
#define     SI5345_REVD_RAMP_STEP_SIZE 418
#define     SI5345_REVD_RAMP_SWITCH_EN 419
#define          SI5345_REVD_FIXREGSA0 420
#define          SI5345_REVD_FIXREGSD0 421
#define          SI5345_REVD_FIXREGSA1 422
#define          SI5345_REVD_FIXREGSD1 423
#define          SI5345_REVD_FIXREGSA2 424
#define          SI5345_REVD_FIXREGSD2 425
#define          SI5345_REVD_FIXREGSA3 426
#define          SI5345_REVD_FIXREGSD3 427
#define          SI5345_REVD_FIXREGSA4 428
#define          SI5345_REVD_FIXREGSD4 429
#define          SI5345_REVD_FIXREGSA5 430
#define          SI5345_REVD_FIXREGSD5 431
#define          SI5345_REVD_FIXREGSA6 432
#define          SI5345_REVD_FIXREGSD6 433
#define          SI5345_REVD_FIXREGSA7 434
#define          SI5345_REVD_FIXREGSD7 435
#define          SI5345_REVD_FIXREGSA8 436
#define          SI5345_REVD_FIXREGSD8 437
#define          SI5345_REVD_FIXREGSA9 438
#define          SI5345_REVD_FIXREGSD9 439
#define         SI5345_REVD_FIXREGSA10 440
#define         SI5345_REVD_FIXREGSD10 441
#define         SI5345_REVD_FIXREGSA11 442
#define         SI5345_REVD_FIXREGSD11 443
#define         SI5345_REVD_FIXREGSA12 444
#define         SI5345_REVD_FIXREGSD12 445
#define         SI5345_REVD_FIXREGSA13 446
#define         SI5345_REVD_FIXREGSD13 447
#define         SI5345_REVD_FIXREGSA14 448
#define         SI5345_REVD_FIXREGSD14 449
#define         SI5345_REVD_FIXREGSA15 450
#define         SI5345_REVD_FIXREGSD15 451
#define         SI5345_REVD_FIXREGSA16 452
#define         SI5345_REVD_FIXREGSD16 453
#define         SI5345_REVD_FIXREGSA17 454
#define         SI5345_REVD_FIXREGSD17 455
#define         SI5345_REVD_FIXREGSA18 456
#define         SI5345_REVD_FIXREGSD18 457
#define         SI5345_REVD_FIXREGSA19 458
#define         SI5345_REVD_FIXREGSD19 459
#define         SI5345_REVD_FIXREGSA20 460
#define         SI5345_REVD_FIXREGSD20 461
#define         SI5345_REVD_FIXREGSA21 462
#define         SI5345_REVD_FIXREGSD21 463
#define         SI5345_REVD_FIXREGSA22 464
#define         SI5345_REVD_FIXREGSD22 465
#define         SI5345_REVD_FIXREGSA23 466
#define         SI5345_REVD_FIXREGSD23 467
#define         SI5345_REVD_FIXREGSA24 468
#define         SI5345_REVD_FIXREGSD24 469
#define         SI5345_REVD_FIXREGSA25 470
#define         SI5345_REVD_FIXREGSD25 471
#define         SI5345_REVD_FIXREGSA26 472
#define         SI5345_REVD_FIXREGSD26 473
#define         SI5345_REVD_FIXREGSA27 474
#define         SI5345_REVD_FIXREGSD27 475
#define         SI5345_REVD_FIXREGSA28 476
#define         SI5345_REVD_FIXREGSD28 477
#define         SI5345_REVD_FIXREGSA29 478
#define         SI5345_REVD_FIXREGSD29 479
#define         SI5345_REVD_FIXREGSA30 480
#define         SI5345_REVD_FIXREGSD30 481
#define         SI5345_REVD_FIXREGSA31 482
#define         SI5345_REVD_FIXREGSD31 483
#define     SI5345_REVD_XAXB_EXTCLK_EN 484
#define         SI5345_REVD_IO_VDD_SEL 485
#define              SI5345_REVD_IN_EN 486
#define  SI5345_REVD_IN_PULSED_CMOS_EN 487
#define      SI5345_REVD_INX_TO_PFD_EN 488
#define     SI5345_REVD_REFCLK_HYS_SEL 489
#define      SI5345_REVD_MXAXB_INTEGER 490
#define          SI5345_REVD_N_ADD_0P5 491
#define   SI5345_REVD_N_CLK_TO_OUTX_EN 492
#define            SI5345_REVD_N_PIBYP 493
#define             SI5345_REVD_N_PDNB 494
#define       SI5345_REVD_N0_HIGH_FREQ 495
#define       SI5345_REVD_N1_HIGH_FREQ 496
#define       SI5345_REVD_N2_HIGH_FREQ 497
#define       SI5345_REVD_N3_HIGH_FREQ 498
#define       SI5345_REVD_N4_HIGH_FREQ 499
#define SI5345_REVD_PDIV_FRACN_CLK_DIS 500
#define  SI5345_REVD_FRACN_CLK_DIS_PLL 501
#define        SI5345_REVD_LOS_CLK_DIS 502
#define        SI5345_REVD_OOF_CLK_DIS 503
#define    SI5345_REVD_OOF_DIV_CLK_DIS 504
#define          SI5345_REVD_N_CLK_DIS 505
#define  SI5345_REVD_VCO_RESET_CALCODE 506
/*
 * Regmap Report Corresponding to Above
 *
 * Setting Name           Location      Start Address  Start Bit  Num Bits  NVM    Type
 * ---------------------  ------------  -------------  ---------  --------  -----  ----
 * DIE_REV                0x0000[3:0]   0x0000         0          4         None   R/O 
 * PAGE                   0x0001[7:0]   0x0001         0          8         None   R/W 
 * PN_BASE                0x0002[15:0]  0x0002         0          16        SiLab  R/O 
 * GRADE                  0x0004[7:0]   0x0004         0          8         User   R/W 
 * DEVICE_REV             0x0005[7:0]   0x0005         0          8         SiLab  R/O 
 * TOOL_VERSION           0x0006[23:0]  0x0006         0          24        User   R/W 
 * TEMP_GRADE             0x0009[7:0]   0x0009         0          8         SiLab  R/O 
 * PKG_ID                 0x000A[7:0]   0x000A         0          8         SiLab  R/O 
 * I2C_ADDR               0x000B[6:0]   0x000B         0          7         SiLab  R/W 
 * SMBUS_TIMEOUT          0x000C[5]     0x000C         5          1         None   R/O 
 * LOSXAXB                0x000C[1]     0x000C         1          1         None   R/O 
 * SYSINCAL               0x000C[0]     0x000C         0          1         None   R/O 
 * OOF                    0x000D[7:4]   0x000D         4          4         None   R/O 
 * LOS                    0x000D[3:0]   0x000D         0          4         None   R/O 
 * HOLD                   0x000E[5]     0x000E         5          1         None   R/O 
 * LOL                    0x000E[1]     0x000E         1          1         None   R/O 
 * CAL_PLL                0x000F[5]     0x000F         5          1         None   R/O 
 * SMBUS_TIMEOUT_FLG      0x0011[5]     0x0011         5          1         None   R/W 
 * LOSXAXB_FLG            0x0011[1]     0x0011         1          1         None   R/W 
 * SYSINCAL_FLG           0x0011[0]     0x0011         0          1         None   R/W 
 * OOF_FLG                0x0012[7:4]   0x0012         4          4         None   R/W 
 * LOS_FLG                0x0012[3:0]   0x0012         0          4         None   R/W 
 * HOLD_FLG               0x0013[5]     0x0013         5          1         None   R/W 
 * LOL_FLG                0x0013[1]     0x0013         1          1         None   R/W 
 * CAL_FLG_PLL            0x0014[5]     0x0014         5          1         None   R/W 
 * LOL_ON_HOLD            0x0016[1]     0x0016         1          1         User   R/W 
 * SMB_TMOUT_INTR_MSK     0x0017[5]     0x0017         5          1         User   R/W 
 * LOSXAXB_INTR_MSK       0x0017[1]     0x0017         1          1         User   R/W 
 * SYSINCAL_INTR_MSK      0x0017[0]     0x0017         0          1         User   R/W 
 * OOF_INTR_MSK           0x0018[7:4]   0x0018         4          4         User   R/W 
 * LOS_INTR_MSK           0x0018[3:0]   0x0018         0          4         User   R/W 
 * HOLD_INTR_MSK          0x0019[5]     0x0019         5          1         User   R/W 
 * LOL_INTR_MSK           0x0019[1]     0x0019         1          1         User   R/W 
 * CAL_INTR_MSK           0x001A[5]     0x001A         5          1         User   R/W 
 * SOFTCAL                0x001C[5]     0x001C         5          1         None   S/C 
 * SOFT_RST               0x001C[2]     0x001C         2          1         None   S/C 
 * SOFT_RST_ALL           0x001C[0]     0x001C         0          1         None   S/C 
 * FDEC                   0x001D[1]     0x001D         1          1         None   S/C 
 * FINC                   0x001D[0]     0x001D         0          1         None   S/C 
 * SYNC                   0x001E[2]     0x001E         2          1         None   S/C 
 * HARD_RST               0x001E[1]     0x001E         1          1         None   R/W 
 * PDN                    0x001E[0]     0x001E         0          1         None   R/W 
 * AUTO_NDIV_UPDATE       0x002B[5]     0x002B         5          1         User   R/W 
 * SPI_3WIRE              0x002B[3]     0x002B         3          1         User   R/W 
 * LOSXAXB_DIS            0x002C[4]     0x002C         4          1         User   R/W 
 * LOS_EN                 0x002C[3:0]   0x002C         0          4         User   R/W 
 * LOS3_VAL_TIME          0x002D[7:6]   0x002D         6          2         User   R/W 
 * LOS2_VAL_TIME          0x002D[5:4]   0x002D         4          2         User   R/W 
 * LOS1_VAL_TIME          0x002D[3:2]   0x002D         2          2         User   R/W 
 * LOS0_VAL_TIME          0x002D[1:0]   0x002D         0          2         User   R/W 
 * LOS0_TRG_THR           0x002E[15:0]  0x002E         0          16        User   R/W 
 * LOS1_TRG_THR           0x0030[15:0]  0x0030         0          16        User   R/W 
 * LOS2_TRG_THR           0x0032[15:0]  0x0032         0          16        User   R/W 
 * LOS3_TRG_THR           0x0034[15:0]  0x0034         0          16        User   R/W 
 * LOS0_CLR_THR           0x0036[15:0]  0x0036         0          16        User   R/W 
 * LOS1_CLR_THR           0x0038[15:0]  0x0038         0          16        User   R/W 
 * LOS2_CLR_THR           0x003A[15:0]  0x003A         0          16        User   R/W 
 * LOS3_CLR_THR           0x003C[15:0]  0x003C         0          16        User   R/W 
 * FAST_OOF_EN            0x003F[7:4]   0x003F         4          4         User   R/W 
 * OOF_EN                 0x003F[3:0]   0x003F         0          4         User   R/W 
 * OOF_REF_SEL            0x0040[2:0]   0x0040         0          3         User   R/W 
 * OOF0_DIV_SEL           0x0041[4:0]   0x0041         0          5         User   R/W 
 * OOF1_DIV_SEL           0x0042[4:0]   0x0042         0          5         User   R/W 
 * OOF2_DIV_SEL           0x0043[4:0]   0x0043         0          5         User   R/W 
 * OOF3_DIV_SEL           0x0044[4:0]   0x0044         0          5         User   R/W 
 * OOFXO_DIV_SEL          0x0045[4:0]   0x0045         0          5         User   R/W 
 * OOF0_SET_THR           0x0046[7:0]   0x0046         0          8         User   R/W 
 * OOF1_SET_THR           0x0047[7:0]   0x0047         0          8         User   R/W 
 * OOF2_SET_THR           0x0048[7:0]   0x0048         0          8         User   R/W 
 * OOF3_SET_THR           0x0049[7:0]   0x0049         0          8         User   R/W 
 * OOF0_CLR_THR           0x004A[7:0]   0x004A         0          8         User   R/W 
 * OOF1_CLR_THR           0x004B[7:0]   0x004B         0          8         User   R/W 
 * OOF2_CLR_THR           0x004C[7:0]   0x004C         0          8         User   R/W 
 * OOF3_CLR_THR           0x004D[7:0]   0x004D         0          8         User   R/W 
 * OOF1_DETWIN_SEL        0x004E[6:4]   0x004E         4          3         User   R/W 
 * OOF0_DETWIN_SEL        0x004E[2:0]   0x004E         0          3         User   R/W 
 * OOF3_DETWIN_SEL        0x004F[6:4]   0x004F         4          3         User   R/W 
 * OOF2_DETWIN_SEL        0x004F[2:0]   0x004F         0          3         User   R/W 
 * OOF_ON_LOS             0x0050[3:0]   0x0050         0          4         User   R/W 
 * FAST_OOF0_SET_THR      0x0051[3:0]   0x0051         0          4         User   R/W 
 * FAST_OOF1_SET_THR      0x0052[3:0]   0x0052         0          4         User   R/W 
 * FAST_OOF2_SET_THR      0x0053[3:0]   0x0053         0          4         User   R/W 
 * FAST_OOF3_SET_THR      0x0054[3:0]   0x0054         0          4         User   R/W 
 * FAST_OOF0_CLR_THR      0x0055[3:0]   0x0055         0          4         User   R/W 
 * FAST_OOF1_CLR_THR      0x0056[3:0]   0x0056         0          4         User   R/W 
 * FAST_OOF2_CLR_THR      0x0057[3:0]   0x0057         0          4         User   R/W 
 * FAST_OOF3_CLR_THR      0x0058[3:0]   0x0058         0          4         User   R/W 
 * FAST_OOF3_DETWIN_SEL   0x0059[7:6]   0x0059         6          2         User   R/W 
 * FAST_OOF2_DETWIN_SEL   0x0059[5:4]   0x0059         4          2         User   R/W 
 * FAST_OOF1_DETWIN_SEL   0x0059[3:2]   0x0059         2          2         User   R/W 
 * FAST_OOF0_DETWIN_SEL   0x0059[1:0]   0x0059         0          2         User   R/W 
 * OOF0_RATIO_REF         0x005A[25:0]  0x005A         0          26        User   R/W 
 * OOF1_RATIO_REF         0x005E[25:0]  0x005E         0          26        User   R/W 
 * OOF2_RATIO_REF         0x0062[25:0]  0x0062         0          26        User   R/W 
 * OOF3_RATIO_REF         0x0066[25:0]  0x0066         0          26        User   R/W 
 * LOL_FST_EN             0x0092[1]     0x0092         1          1         User   R/W 
 * LOL_FST_DETWIN_SEL     0x0093[7:4]   0x0093         4          4         User   R/W 
 * LOL_FST_VALWIN_SEL     0x0095[3:2]   0x0095         2          2         User   R/W 
 * LOL_FST_SET_THR_SEL    0x0096[7:4]   0x0096         4          4         User   R/W 
 * LOL_FST_CLR_THR_SEL    0x0098[7:4]   0x0098         4          4         User   R/W 
 * LOL_SLOW_EN_PLL        0x009A[1]     0x009A         1          1         User   R/W 
 * LOL_SLW_DETWIN_SEL     0x009B[7:4]   0x009B         4          4         User   R/W 
 * LOL_SLW_VALWIN_SEL     0x009D[3:2]   0x009D         2          2         User   R/W 
 * LOL_SLW_SET_THR        0x009E[7:4]   0x009E         4          4         User   R/W 
 * LOL_SLW_CLR_THR        0x00A0[7:4]   0x00A0         4          4         User   R/W 
 * LOL_TIMER_EN           0x00A2[1]     0x00A2         1          1         User   R/W 
 * LOL_CLR_DELAY_DIV256   0x00A9[28:0]  0x00A9         0          29        User   R/W 
 * ACTIVE_NVM_BANK        0x00E2[7:0]   0x00E2         0          8         None   R/O 
 * FASTLOCK_EXTEND_EN     0x00E5[5]     0x00E5         5          1         User   R/W 
 * FASTLOCK_EXTEND        0x00EA[28:0]  0x00EA         0          29        User   R/W 
 * REG_0XF9_INTR          0x00F6[2]     0x00F6         2          1         None   R/O 
 * REG_0XF8_INTR          0x00F6[1]     0x00F6         1          1         None   R/O 
 * REG_0XF7_INTR          0x00F6[0]     0x00F6         0          1         None   R/O 
 * SMBUS_TIME_OUT_INTR    0x00F7[5]     0x00F7         5          1         None   R/O 
 * LOSVCO_INTR            0x00F7[4]     0x00F7         4          1         None   R/O 
 * LOSREF_INTR            0x00F7[2]     0x00F7         2          1         None   R/O 
 * LOSXAXB_INTR           0x00F7[1]     0x00F7         1          1         None   R/O 
 * SYSINCAL_INTR          0x00F7[0]     0x00F7         0          1         None   R/O 
 * OOF_INTR               0x00F8[7:4]   0x00F8         4          4         None   R/O 
 * LOS_INTR               0x00F8[3:0]   0x00F8         0          4         None   R/O 
 * HOLD_INTR              0x00F9[5]     0x00F9         5          1         None   R/O 
 * LOL_INTR               0x00F9[1]     0x00F9         1          1         None   R/O 
 * OUTALL_DISABLE_LOW     0x0102[0]     0x0102         0          1         User   R/W 
 * OUT0_RDIV_FORCE2       0x0108[2]     0x0108         2          1         User   R/W 
 * OUT0_OE                0x0108[1]     0x0108         1          1         User   R/W 
 * OUT0_PDN               0x0108[0]     0x0108         0          1         User   R/W 
 * OUT0_CMOS_DRV          0x0109[7:6]   0x0109         6          2         User   R/W 
 * OUT0_DIS_STATE         0x0109[5:4]   0x0109         4          2         User   R/W 
 * OUT0_SYNC_EN           0x0109[3]     0x0109         3          1         User   R/W 
 * OUT0_FORMAT            0x0109[2:0]   0x0109         0          3         User   R/W 
 * OUT0_AMPL              0x010A[6:4]   0x010A         4          3         User   R/W 
 * OUT0_CM                0x010A[3:0]   0x010A         0          4         User   R/W 
 * OUT0_INV               0x010B[7:6]   0x010B         6          2         User   R/W 
 * OUT0_VDD_SEL           0x010B[5:4]   0x010B         4          2         User   R/W 
 * OUT0_VDD_SEL_EN        0x010B[3]     0x010B         3          1         User   R/W 
 * OUT0_MUX_SEL           0x010B[2:0]   0x010B         0          3         User   R/W 
 * OUT1_RDIV_FORCE2       0x010D[2]     0x010D         2          1         User   R/W 
 * OUT1_OE                0x010D[1]     0x010D         1          1         User   R/W 
 * OUT1_PDN               0x010D[0]     0x010D         0          1         User   R/W 
 * OUT1_CMOS_DRV          0x010E[7:6]   0x010E         6          2         User   R/W 
 * OUT1_DIS_STATE         0x010E[5:4]   0x010E         4          2         User   R/W 
 * OUT1_SYNC_EN           0x010E[3]     0x010E         3          1         User   R/W 
 * OUT1_FORMAT            0x010E[2:0]   0x010E         0          3         User   R/W 
 * OUT1_AMPL              0x010F[6:4]   0x010F         4          3         User   R/W 
 * OUT1_CM                0x010F[3:0]   0x010F         0          4         User   R/W 
 * OUT1_INV               0x0110[7:6]   0x0110         6          2         User   R/W 
 * OUT1_VDD_SEL           0x0110[5:4]   0x0110         4          2         User   R/W 
 * OUT1_VDD_SEL_EN        0x0110[3]     0x0110         3          1         User   R/W 
 * OUT1_MUX_SEL           0x0110[2:0]   0x0110         0          3         User   R/W 
 * OUT2_RDIV_FORCE2       0x0112[2]     0x0112         2          1         User   R/W 
 * OUT2_OE                0x0112[1]     0x0112         1          1         User   R/W 
 * OUT2_PDN               0x0112[0]     0x0112         0          1         User   R/W 
 * OUT2_CMOS_DRV          0x0113[7:6]   0x0113         6          2         User   R/W 
 * OUT2_DIS_STATE         0x0113[5:4]   0x0113         4          2         User   R/W 
 * OUT2_SYNC_EN           0x0113[3]     0x0113         3          1         User   R/W 
 * OUT2_FORMAT            0x0113[2:0]   0x0113         0          3         User   R/W 
 * OUT2_AMPL              0x0114[6:4]   0x0114         4          3         User   R/W 
 * OUT2_CM                0x0114[3:0]   0x0114         0          4         User   R/W 
 * OUT2_INV               0x0115[7:6]   0x0115         6          2         User   R/W 
 * OUT2_VDD_SEL           0x0115[5:4]   0x0115         4          2         User   R/W 
 * OUT2_VDD_SEL_EN        0x0115[3]     0x0115         3          1         User   R/W 
 * OUT2_MUX_SEL           0x0115[2:0]   0x0115         0          3         User   R/W 
 * OUT3_RDIV_FORCE2       0x0117[2]     0x0117         2          1         User   R/W 
 * OUT3_OE                0x0117[1]     0x0117         1          1         User   R/W 
 * OUT3_PDN               0x0117[0]     0x0117         0          1         User   R/W 
 * OUT3_CMOS_DRV          0x0118[7:6]   0x0118         6          2         User   R/W 
 * OUT3_DIS_STATE         0x0118[5:4]   0x0118         4          2         User   R/W 
 * OUT3_SYNC_EN           0x0118[3]     0x0118         3          1         User   R/W 
 * OUT3_FORMAT            0x0118[2:0]   0x0118         0          3         User   R/W 
 * OUT3_AMPL              0x0119[6:4]   0x0119         4          3         User   R/W 
 * OUT3_CM                0x0119[3:0]   0x0119         0          4         User   R/W 
 * OUT3_INV               0x011A[7:6]   0x011A         6          2         User   R/W 
 * OUT3_VDD_SEL           0x011A[5:4]   0x011A         4          2         User   R/W 
 * OUT3_VDD_SEL_EN        0x011A[3]     0x011A         3          1         User   R/W 
 * OUT3_MUX_SEL           0x011A[2:0]   0x011A         0          3         User   R/W 
 * OUT4_RDIV_FORCE2       0x011C[2]     0x011C         2          1         User   R/W 
 * OUT4_OE                0x011C[1]     0x011C         1          1         User   R/W 
 * OUT4_PDN               0x011C[0]     0x011C         0          1         User   R/W 
 * OUT4_CMOS_DRV          0x011D[7:6]   0x011D         6          2         User   R/W 
 * OUT4_DIS_STATE         0x011D[5:4]   0x011D         4          2         User   R/W 
 * OUT4_SYNC_EN           0x011D[3]     0x011D         3          1         User   R/W 
 * OUT4_FORMAT            0x011D[2:0]   0x011D         0          3         User   R/W 
 * OUT4_AMPL              0x011E[6:4]   0x011E         4          3         User   R/W 
 * OUT4_CM                0x011E[3:0]   0x011E         0          4         User   R/W 
 * OUT4_INV               0x011F[7:6]   0x011F         6          2         User   R/W 
 * OUT4_VDD_SEL           0x011F[5:4]   0x011F         4          2         User   R/W 
 * OUT4_VDD_SEL_EN        0x011F[3]     0x011F         3          1         User   R/W 
 * OUT4_MUX_SEL           0x011F[2:0]   0x011F         0          3         User   R/W 
 * OUT5_RDIV_FORCE2       0x0121[2]     0x0121         2          1         User   R/W 
 * OUT5_OE                0x0121[1]     0x0121         1          1         User   R/W 
 * OUT5_PDN               0x0121[0]     0x0121         0          1         User   R/W 
 * OUT5_CMOS_DRV          0x0122[7:6]   0x0122         6          2         User   R/W 
 * OUT5_DIS_STATE         0x0122[5:4]   0x0122         4          2         User   R/W 
 * OUT5_SYNC_EN           0x0122[3]     0x0122         3          1         User   R/W 
 * OUT5_FORMAT            0x0122[2:0]   0x0122         0          3         User   R/W 
 * OUT5_AMPL              0x0123[6:4]   0x0123         4          3         User   R/W 
 * OUT5_CM                0x0123[3:0]   0x0123         0          4         User   R/W 
 * OUT5_INV               0x0124[7:6]   0x0124         6          2         User   R/W 
 * OUT5_VDD_SEL           0x0124[5:4]   0x0124         4          2         User   R/W 
 * OUT5_VDD_SEL_EN        0x0124[3]     0x0124         3          1         User   R/W 
 * OUT5_MUX_SEL           0x0124[2:0]   0x0124         0          3         User   R/W 
 * OUT6_RDIV_FORCE2       0x0126[2]     0x0126         2          1         User   R/W 
 * OUT6_OE                0x0126[1]     0x0126         1          1         User   R/W 
 * OUT6_PDN               0x0126[0]     0x0126         0          1         User   R/W 
 * OUT6_CMOS_DRV          0x0127[7:6]   0x0127         6          2         User   R/W 
 * OUT6_DIS_STATE         0x0127[5:4]   0x0127         4          2         User   R/W 
 * OUT6_SYNC_EN           0x0127[3]     0x0127         3          1         User   R/W 
 * OUT6_FORMAT            0x0127[2:0]   0x0127         0          3         User   R/W 
 * OUT6_AMPL              0x0128[6:4]   0x0128         4          3         User   R/W 
 * OUT6_CM                0x0128[3:0]   0x0128         0          4         User   R/W 
 * OUT6_INV               0x0129[7:6]   0x0129         6          2         User   R/W 
 * OUT6_VDD_SEL           0x0129[5:4]   0x0129         4          2         User   R/W 
 * OUT6_VDD_SEL_EN        0x0129[3]     0x0129         3          1         User   R/W 
 * OUT6_MUX_SEL           0x0129[2:0]   0x0129         0          3         User   R/W 
 * OUT7_RDIV_FORCE2       0x012B[2]     0x012B         2          1         User   R/W 
 * OUT7_OE                0x012B[1]     0x012B         1          1         User   R/W 
 * OUT7_PDN               0x012B[0]     0x012B         0          1         User   R/W 
 * OUT7_CMOS_DRV          0x012C[7:6]   0x012C         6          2         User   R/W 
 * OUT7_DIS_STATE         0x012C[5:4]   0x012C         4          2         User   R/W 
 * OUT7_SYNC_EN           0x012C[3]     0x012C         3          1         User   R/W 
 * OUT7_FORMAT            0x012C[2:0]   0x012C         0          3         User   R/W 
 * OUT7_AMPL              0x012D[6:4]   0x012D         4          3         User   R/W 
 * OUT7_CM                0x012D[3:0]   0x012D         0          4         User   R/W 
 * OUT7_INV               0x012E[7:6]   0x012E         6          2         User   R/W 
 * OUT7_VDD_SEL           0x012E[5:4]   0x012E         4          2         User   R/W 
 * OUT7_VDD_SEL_EN        0x012E[3]     0x012E         3          1         User   R/W 
 * OUT7_MUX_SEL           0x012E[2:0]   0x012E         0          3         User   R/W 
 * OUT8_RDIV_FORCE2       0x0130[2]     0x0130         2          1         User   R/W 
 * OUT8_OE                0x0130[1]     0x0130         1          1         User   R/W 
 * OUT8_PDN               0x0130[0]     0x0130         0          1         User   R/W 
 * OUT8_CMOS_DRV          0x0131[7:6]   0x0131         6          2         User   R/W 
 * OUT8_DIS_STATE         0x0131[5:4]   0x0131         4          2         User   R/W 
 * OUT8_SYNC_EN           0x0131[3]     0x0131         3          1         User   R/W 
 * OUT8_FORMAT            0x0131[2:0]   0x0131         0          3         User   R/W 
 * OUT8_AMPL              0x0132[6:4]   0x0132         4          3         User   R/W 
 * OUT8_CM                0x0132[3:0]   0x0132         0          4         User   R/W 
 * OUT8_INV               0x0133[7:6]   0x0133         6          2         User   R/W 
 * OUT8_VDD_SEL           0x0133[5:4]   0x0133         4          2         User   R/W 
 * OUT8_VDD_SEL_EN        0x0133[3]     0x0133         3          1         User   R/W 
 * OUT8_MUX_SEL           0x0133[2:0]   0x0133         0          3         User   R/W 
 * OUT9_RDIV_FORCE2       0x013A[2]     0x013A         2          1         User   R/W 
 * OUT9_OE                0x013A[1]     0x013A         1          1         User   R/W 
 * OUT9_PDN               0x013A[0]     0x013A         0          1         User   R/W 
 * OUT9_CMOS_DRV          0x013B[7:6]   0x013B         6          2         User   R/W 
 * OUT9_DIS_STATE         0x013B[5:4]   0x013B         4          2         User   R/W 
 * OUT9_SYNC_EN           0x013B[3]     0x013B         3          1         User   R/W 
 * OUT9_FORMAT            0x013B[2:0]   0x013B         0          3         User   R/W 
 * OUT9_AMPL              0x013C[6:4]   0x013C         4          3         User   R/W 
 * OUT9_CM                0x013C[3:0]   0x013C         0          4         User   R/W 
 * OUT9_INV               0x013D[7:6]   0x013D         6          2         User   R/W 
 * OUT9_VDD_SEL           0x013D[5:4]   0x013D         4          2         User   R/W 
 * OUT9_VDD_SEL_EN        0x013D[3]     0x013D         3          1         User   R/W 
 * OUT9_MUX_SEL           0x013D[2:0]   0x013D         0          3         User   R/W 
 * OUTX_ALWAYS_ON         0x013F[11:0]  0x013F         0          12        User   R/W 
 * OUT_DIS_MSK_LOS_PFD    0x0141[7]     0x0141         7          1         User   R/W 
 * OUT_DIS_LOSXAXB_MSK    0x0141[6]     0x0141         6          1         User   R/W 
 * OUT_DIS_LOL_MSK        0x0141[5]     0x0141         5          1         User   R/W 
 * OUT_DIS_MSK            0x0141[1]     0x0141         1          1         User   R/W 
 * OUT_DIS_MSK_HOLD       0x0142[5]     0x0142         5          1         User   R/W 
 * OUT_DIS_MSK_LOL        0x0142[1]     0x0142         1          1         User   R/W 
 * OUT_PDN_ALL            0x0145[0]     0x0145         0          1         None   R/W 
 * OUT_RST                0x0146[11:0]  0x0146         0          12        None   R/W 
 * OUT_RDIV_RST           0x0148[11:0]  0x0148         0          12        None   R/W 
 * PXAXB                  0x0206[1:0]   0x0206         0          2         User   R/W 
 * P0_NUM                 0x0208[47:0]  0x0208         0          48        User   R/W 
 * P0_DEN                 0x020E[31:0]  0x020E         0          32        User   R/W 
 * P1_NUM                 0x0212[47:0]  0x0212         0          48        User   R/W 
 * P1_DEN                 0x0218[31:0]  0x0218         0          32        User   R/W 
 * P2_NUM                 0x021C[47:0]  0x021C         0          48        User   R/W 
 * P2_DEN                 0x0222[31:0]  0x0222         0          32        User   R/W 
 * P3_NUM                 0x0226[47:0]  0x0226         0          48        User   R/W 
 * P3_DEN                 0x022C[31:0]  0x022C         0          32        User   R/W 
 * P3_UPDATE              0x0230[3]     0x0230         3          1         None   S/C 
 * P2_UPDATE              0x0230[2]     0x0230         2          1         None   S/C 
 * P1_UPDATE              0x0230[1]     0x0230         1          1         None   S/C 
 * P0_UPDATE              0x0230[0]     0x0230         0          1         None   S/C 
 * P0_FRACN_EN            0x0231[4]     0x0231         4          1         User   R/W 
 * P0_FRACN_MODE          0x0231[3:0]   0x0231         0          4         User   R/W 
 * P1_FRACN_EN            0x0232[4]     0x0232         4          1         User   R/W 
 * P1_FRACN_MODE          0x0232[3:0]   0x0232         0          4         User   R/W 
 * P2_FRACN_EN            0x0233[4]     0x0233         4          1         User   R/W 
 * P2_FRACN_MODE          0x0233[3:0]   0x0233         0          4         User   R/W 
 * P3_FRACN_EN            0x0234[4]     0x0234         4          1         User   R/W 
 * P3_FRACN_MODE          0x0234[3:0]   0x0234         0          4         User   R/W 
 * MXAXB_NUM              0x0235[43:0]  0x0235         0          44        User   R/W 
 * MXAXB_DEN              0x023B[31:0]  0x023B         0          32        User   R/W 
 * MXAXB_UPDATE           0x023F[0]     0x023F         0          1         None   S/C 
 * R0_REG                 0x024A[23:0]  0x024A         0          24        User   R/W 
 * R1_REG                 0x024D[23:0]  0x024D         0          24        User   R/W 
 * R2_REG                 0x0250[23:0]  0x0250         0          24        User   R/W 
 * R3_REG                 0x0253[23:0]  0x0253         0          24        User   R/W 
 * R4_REG                 0x0256[23:0]  0x0256         0          24        User   R/W 
 * R5_REG                 0x0259[23:0]  0x0259         0          24        User   R/W 
 * R6_REG                 0x025C[23:0]  0x025C         0          24        User   R/W 
 * R7_REG                 0x025F[23:0]  0x025F         0          24        User   R/W 
 * R8_REG                 0x0262[23:0]  0x0262         0          24        User   R/W 
 * R9_REG                 0x0268[23:0]  0x0268         0          24        User   R/W 
 * DESIGN_ID0             0x026B[7:0]   0x026B         0          8         User   R/W 
 * DESIGN_ID1             0x026C[7:0]   0x026C         0          8         User   R/W 
 * DESIGN_ID2             0x026D[7:0]   0x026D         0          8         User   R/W 
 * DESIGN_ID3             0x026E[7:0]   0x026E         0          8         User   R/W 
 * DESIGN_ID4             0x026F[7:0]   0x026F         0          8         User   R/W 
 * DESIGN_ID5             0x0270[7:0]   0x0270         0          8         User   R/W 
 * DESIGN_ID6             0x0271[7:0]   0x0271         0          8         User   R/W 
 * DESIGN_ID7             0x0272[7:0]   0x0272         0          8         User   R/W 
 * OPN_ID0                0x0278[7:0]   0x0278         0          8         SiLab  R/W 
 * OPN_ID1                0x0279[7:0]   0x0279         0          8         SiLab  R/W 
 * OPN_ID2                0x027A[7:0]   0x027A         0          8         SiLab  R/W 
 * OPN_ID3                0x027B[7:0]   0x027B         0          8         SiLab  R/W 
 * OPN_ID4                0x027C[7:0]   0x027C         0          8         SiLab  R/W 
 * OPN_REVISION           0x027D[7:0]   0x027D         0          8         SiLab  R/W 
 * BASELINE_ID            0x027E[7:0]   0x027E         0          8         SiLab  R/W 
 * OOF0_TRG_THR_EXT       0x028A[4:0]   0x028A         0          5         User   R/W 
 * OOF1_TRG_THR_EXT       0x028B[4:0]   0x028B         0          5         User   R/W 
 * OOF2_TRG_THR_EXT       0x028C[4:0]   0x028C         0          5         User   R/W 
 * OOF3_TRG_THR_EXT       0x028D[4:0]   0x028D         0          5         User   R/W 
 * OOF0_CLR_THR_EXT       0x028E[4:0]   0x028E         0          5         User   R/W 
 * OOF1_CLR_THR_EXT       0x028F[4:0]   0x028F         0          5         User   R/W 
 * OOF2_CLR_THR_EXT       0x0290[4:0]   0x0290         0          5         User   R/W 
 * OOF3_CLR_THR_EXT       0x0291[4:0]   0x0291         0          5         User   R/W 
 * FASTLOCK_EXTEND_SCL    0x0294[7:4]   0x0294         4          4         User   R/W 
 * LOL_SLW_VALWIN_SELX    0x0296[1]     0x0296         1          1         User   R/W 
 * FASTLOCK_DLY_ONSW_EN   0x0297[1]     0x0297         1          1         User   R/W 
 * FASTLOCK_DLY_ONLOL_EN  0x0299[1]     0x0299         1          1         User   R/W 
 * FASTLOCK_DLY_ONLOL     0x029D[19:0]  0x029D         0          20        User   R/W 
 * FASTLOCK_DLY_ONSW      0x02A9[19:0]  0x02A9         0          20        User   R/W 
 * LOL_NOSIG_TIME         0x02B7[3:2]   0x02B7         2          2         User   R/W 
 * LOL_LOS_REFCLK         0x02B8[1]     0x02B8         1          1         None   R/O 
 * N0_NUM                 0x0302[43:0]  0x0302         0          44        User   R/W 
 * N0_DEN                 0x0308[31:0]  0x0308         0          32        User   R/W 
 * N0_UPDATE              0x030C[0]     0x030C         0          1         User   S/C 
 * N1_NUM                 0x030D[43:0]  0x030D         0          44        User   R/W 
 * N1_DEN                 0x0313[31:0]  0x0313         0          32        User   R/W 
 * N1_UPDATE              0x0317[0]     0x0317         0          1         User   S/C 
 * N2_NUM                 0x0318[43:0]  0x0318         0          44        User   R/W 
 * N2_DEN                 0x031E[31:0]  0x031E         0          32        User   R/W 
 * N2_UPDATE              0x0322[0]     0x0322         0          1         User   S/C 
 * N3_NUM                 0x0323[43:0]  0x0323         0          44        User   R/W 
 * N3_DEN                 0x0329[31:0]  0x0329         0          32        User   R/W 
 * N3_UPDATE              0x032D[0]     0x032D         0          1         User   S/C 
 * N4_NUM                 0x032E[43:0]  0x032E         0          44        User   R/W 
 * N4_DEN                 0x0334[31:0]  0x0334         0          32        User   R/W 
 * N_UPDATE               0x0338[1]     0x0338         1          1         User   S/C 
 * N4_UPDATE              0x0338[0]     0x0338         0          1         User   S/C 
 * N_FSTEP_MSK            0x0339[4:0]   0x0339         0          5         User   R/W 
 * N0_FSTEPW              0x033B[43:0]  0x033B         0          44        User   R/W 
 * N1_FSTEPW              0x0341[43:0]  0x0341         0          44        User   R/W 
 * N2_FSTEPW              0x0347[43:0]  0x0347         0          44        User   R/W 
 * N3_FSTEPW              0x034D[43:0]  0x034D         0          44        User   R/W 
 * N4_FSTEPW              0x0353[43:0]  0x0353         0          44        User   R/W 
 * N0_DELAY               0x0359[15:0]  0x0359         0          16        User   R/W 
 * N1_DELAY               0x035B[15:0]  0x035B         0          16        User   R/W 
 * N2_DELAY               0x035D[15:0]  0x035D         0          16        User   R/W 
 * N3_DELAY               0x035F[15:0]  0x035F         0          16        User   R/W 
 * N4_DELAY               0x0361[15:0]  0x0361         0          16        User   R/W 
 * ZDM_AUTOSW_EN          0x0487[4]     0x0487         4          1         User   R/W 
 * ZDM_IN_SEL             0x0487[2:1]   0x0487         1          2         User   R/W 
 * ZDM_EN                 0x0487[0]     0x0487         0          1         User   R/W 
 * BW0_PLL                0x0508[5:0]   0x0508         0          6         User   R/W 
 * BW1_PLL                0x0509[5:0]   0x0509         0          6         User   R/W 
 * BW2_PLL                0x050A[5:0]   0x050A         0          6         User   R/W 
 * BW3_PLL                0x050B[5:0]   0x050B         0          6         User   R/W 
 * BW4_PLL                0x050C[5:0]   0x050C         0          6         User   R/W 
 * BW5_PLL                0x050D[5:0]   0x050D         0          6         User   R/W 
 * FASTLOCK_BW0_PLL       0x050E[5:0]   0x050E         0          6         User   R/W 
 * FASTLOCK_BW1_PLL       0x050F[5:0]   0x050F         0          6         User   R/W 
 * FASTLOCK_BW2_PLL       0x0510[5:0]   0x0510         0          6         User   R/W 
 * FASTLOCK_BW3_PLL       0x0511[5:0]   0x0511         0          6         User   R/W 
 * FASTLOCK_BW4_PLL       0x0512[5:0]   0x0512         0          6         User   R/W 
 * FASTLOCK_BW5_PLL       0x0513[5:0]   0x0513         0          6         User   R/W 
 * BW_UPDATE_PLL          0x0514[0]     0x0514         0          1         None   S/C 
 * M_NUM                  0x0515[55:0]  0x0515         0          56        User   R/W 
 * M_DEN                  0x051C[31:0]  0x051C         0          32        User   R/W 
 * M_UPDATE               0x0520[0]     0x0520         0          1         None   S/C 
 * PLL_OUT_RATE_SEL       0x0521[5]     0x0521         5          1         User   R/W 
 * M_FRAC_EN              0x0521[4]     0x0521         4          1         User   R/W 
 * M_FRAC_MODE            0x0521[3:0]   0x0521         0          4         User   R/W 
 * IN_SEL                 0x052A[3:1]   0x052A         1          3         User   R/W 
 * IN_SEL_REGCTRL         0x052A[0]     0x052A         0          1         User   R/W 
 * FASTLOCK_MAN           0x052B[1]     0x052B         1          1         User   R/W 
 * FASTLOCK_AUTO_EN       0x052B[0]     0x052B         0          1         User   R/W 
 * RAMP_STEP_INTERVAL     0x052C[7:5]   0x052C         5          3         User   R/W 
 * HOLDEXIT_BW_SEL1       0x052C[4]     0x052C         4          1         User   R/W 
 * HOLD_RAMP_BYP          0x052C[3]     0x052C         3          1         User   R/W 
 * HOLD_EN                0x052C[0]     0x052C         0          1         User   R/W 
 * HOLD_RAMPBYP_NOHIST    0x052D[1]     0x052D         1          1         User   R/W 
 * HOLD_HIST_LEN          0x052E[4:0]   0x052E         0          5         User   R/W 
 * HOLD_HIST_DELAY        0x052F[4:0]   0x052F         0          5         User   R/W 
 * HOLD_REF_COUNT_FRC     0x0531[4:0]   0x0531         0          5         User   R/W 
 * HOLD_15M_CYC_COUNT     0x0532[23:0]  0x0532         0          24        User   R/W 
 * FORCE_HOLD             0x0535[0]     0x0535         0          1         None   R/W 
 * HSW_EN                 0x0536[2]     0x0536         2          1         User   R/W 
 * CLK_SWITCH_MODE        0x0536[1:0]   0x0536         0          2         User   R/W 
 * IN_OOF_MSK             0x0537[7:4]   0x0537         4          4         User   R/W 
 * IN_LOS_MSK             0x0537[3:0]   0x0537         0          4         User   R/W 
 * IN1_PRIORITY           0x0538[6:4]   0x0538         4          3         User   R/W 
 * IN0_PRIORITY           0x0538[2:0]   0x0538         0          3         User   R/W 
 * IN3_PRIORITY           0x0539[6:4]   0x0539         4          3         User   R/W 
 * IN2_PRIORITY           0x0539[2:0]   0x0539         0          3         User   R/W 
 * HSW_PHMEAS_CTRL        0x053A[3:2]   0x053A         2          2         SiLab  R/W 
 * HSW_MODE               0x053A[1:0]   0x053A         0          2         SiLab  R/W 
 * HSW_PHMEAS_THR         0x053B[9:0]   0x053B         0          10        SiLab  R/W 
 * HSW_COARSE_PM_LEN      0x053D[4:0]   0x053D         0          5         User   R/W 
 * HSW_COARSE_PM_DLY      0x053E[4:0]   0x053E         0          5         User   R/W 
 * FASTLOCK_STATUS        0x053F[2]     0x053F         2          1         None   R/O 
 * HOLD_HIST_VALID        0x053F[1]     0x053F         1          1         None   R/O 
 * CAP_SHORT_DELAY        0x0589[12:0]  0x0589         0          13        User   R/W 
 * HOLDEXIT_STD_BO        0x059B[7]     0x059B         7          1         User   R/W 
 * HOLDEXIT_BW_SEL0       0x059B[6]     0x059B         6          1         User   R/W 
 * HOLD_FRZ_WITH_INTONLY  0x059B[5]     0x059B         5          1         User   R/W 
 * HOLD_PRESERVE_HIST     0x059B[4]     0x059B         4          1         User   R/W 
 * INIT_LP_CLOSE_HO       0x059B[1]     0x059B         1          1         User   R/W 
 * HOLDEXIT_BW0           0x059D[5:0]   0x059D         0          6         User   R/W 
 * HOLDEXIT_BW1           0x059E[5:0]   0x059E         0          6         User   R/W 
 * HOLDEXIT_BW2           0x059F[5:0]   0x059F         0          6         User   R/W 
 * HOLDEXIT_BW3           0x05A0[5:0]   0x05A0         0          6         User   R/W 
 * HOLDEXIT_BW4           0x05A1[5:0]   0x05A1         0          6         User   R/W 
 * HOLDEXIT_BW5           0x05A2[5:0]   0x05A2         0          6         User   R/W 
 * RAMP_SWITCH_EN         0x05A6[3]     0x05A6         3          1         User   R/W 
 * RAMP_STEP_SIZE         0x05A6[2:0]   0x05A6         0          3         User   R/W 
 * FIXREGSA0              0x0802[15:0]  0x0802         0          16        User   R/W 
 * FIXREGSD0              0x0804[7:0]   0x0804         0          8         User   R/W 
 * FIXREGSA1              0x0805[15:0]  0x0805         0          16        User   R/W 
 * FIXREGSD1              0x0807[7:0]   0x0807         0          8         User   R/W 
 * FIXREGSA2              0x0808[15:0]  0x0808         0          16        User   R/W 
 * FIXREGSD2              0x080A[7:0]   0x080A         0          8         User   R/W 
 * FIXREGSA3              0x080B[15:0]  0x080B         0          16        User   R/W 
 * FIXREGSD3              0x080D[7:0]   0x080D         0          8         User   R/W 
 * FIXREGSA4              0x080E[15:0]  0x080E         0          16        User   R/W 
 * FIXREGSD4              0x0810[7:0]   0x0810         0          8         User   R/W 
 * FIXREGSA5              0x0811[15:0]  0x0811         0          16        User   R/W 
 * FIXREGSD5              0x0813[7:0]   0x0813         0          8         User   R/W 
 * FIXREGSA6              0x0814[15:0]  0x0814         0          16        User   R/W 
 * FIXREGSD6              0x0816[7:0]   0x0816         0          8         User   R/W 
 * FIXREGSA7              0x0817[15:0]  0x0817         0          16        User   R/W 
 * FIXREGSD7              0x0819[7:0]   0x0819         0          8         User   R/W 
 * FIXREGSA8              0x081A[15:0]  0x081A         0          16        User   R/W 
 * FIXREGSD8              0x081C[7:0]   0x081C         0          8         User   R/W 
 * FIXREGSA9              0x081D[15:0]  0x081D         0          16        User   R/W 
 * FIXREGSD9              0x081F[7:0]   0x081F         0          8         User   R/W 
 * FIXREGSA10             0x0820[15:0]  0x0820         0          16        User   R/W 
 * FIXREGSD10             0x0822[7:0]   0x0822         0          8         User   R/W 
 * FIXREGSA11             0x0823[15:0]  0x0823         0          16        User   R/W 
 * FIXREGSD11             0x0825[7:0]   0x0825         0          8         User   R/W 
 * FIXREGSA12             0x0826[15:0]  0x0826         0          16        User   R/W 
 * FIXREGSD12             0x0828[7:0]   0x0828         0          8         User   R/W 
 * FIXREGSA13             0x0829[15:0]  0x0829         0          16        User   R/W 
 * FIXREGSD13             0x082B[7:0]   0x082B         0          8         User   R/W 
 * FIXREGSA14             0x082C[15:0]  0x082C         0          16        User   R/W 
 * FIXREGSD14             0x082E[7:0]   0x082E         0          8         User   R/W 
 * FIXREGSA15             0x082F[15:0]  0x082F         0          16        User   R/W 
 * FIXREGSD15             0x0831[7:0]   0x0831         0          8         User   R/W 
 * FIXREGSA16             0x0832[15:0]  0x0832         0          16        User   R/W 
 * FIXREGSD16             0x0834[7:0]   0x0834         0          8         User   R/W 
 * FIXREGSA17             0x0835[15:0]  0x0835         0          16        User   R/W 
 * FIXREGSD17             0x0837[7:0]   0x0837         0          8         User   R/W 
 * FIXREGSA18             0x0838[15:0]  0x0838         0          16        User   R/W 
 * FIXREGSD18             0x083A[7:0]   0x083A         0          8         User   R/W 
 * FIXREGSA19             0x083B[15:0]  0x083B         0          16        User   R/W 
 * FIXREGSD19             0x083D[7:0]   0x083D         0          8         User   R/W 
 * FIXREGSA20             0x083E[15:0]  0x083E         0          16        User   R/W 
 * FIXREGSD20             0x0840[7:0]   0x0840         0          8         User   R/W 
 * FIXREGSA21             0x0841[15:0]  0x0841         0          16        User   R/W 
 * FIXREGSD21             0x0843[7:0]   0x0843         0          8         User   R/W 
 * FIXREGSA22             0x0844[15:0]  0x0844         0          16        User   R/W 
 * FIXREGSD22             0x0846[7:0]   0x0846         0          8         User   R/W 
 * FIXREGSA23             0x0847[15:0]  0x0847         0          16        User   R/W 
 * FIXREGSD23             0x0849[7:0]   0x0849         0          8         User   R/W 
 * FIXREGSA24             0x084A[15:0]  0x084A         0          16        User   R/W 
 * FIXREGSD24             0x084C[7:0]   0x084C         0          8         User   R/W 
 * FIXREGSA25             0x084D[15:0]  0x084D         0          16        User   R/W 
 * FIXREGSD25             0x084F[7:0]   0x084F         0          8         User   R/W 
 * FIXREGSA26             0x0850[15:0]  0x0850         0          16        User   R/W 
 * FIXREGSD26             0x0852[7:0]   0x0852         0          8         User   R/W 
 * FIXREGSA27             0x0853[15:0]  0x0853         0          16        User   R/W 
 * FIXREGSD27             0x0855[7:0]   0x0855         0          8         User   R/W 
 * FIXREGSA28             0x0856[15:0]  0x0856         0          16        User   R/W 
 * FIXREGSD28             0x0858[7:0]   0x0858         0          8         User   R/W 
 * FIXREGSA29             0x0859[15:0]  0x0859         0          16        User   R/W 
 * FIXREGSD29             0x085B[7:0]   0x085B         0          8         User   R/W 
 * FIXREGSA30             0x085C[15:0]  0x085C         0          16        User   R/W 
 * FIXREGSD30             0x085E[7:0]   0x085E         0          8         User   R/W 
 * FIXREGSA31             0x085F[15:0]  0x085F         0          16        User   R/W 
 * FIXREGSD31             0x0861[7:0]   0x0861         0          8         User   R/W 
 * XAXB_EXTCLK_EN         0x090E[0]     0x090E         0          1         User   R/W 
 * IO_VDD_SEL             0x0943[0]     0x0943         0          1         User   R/W 
 * IN_PULSED_CMOS_EN      0x0949[7:4]   0x0949         4          4         User   R/W 
 * IN_EN                  0x0949[3:0]   0x0949         0          4         User   R/W 
 * INX_TO_PFD_EN          0x094A[3:0]   0x094A         0          4         User   R/W 
 * REFCLK_HYS_SEL         0x094E[11:0]  0x094E         0          12        User   R/W 
 * MXAXB_INTEGER          0x095E[0]     0x095E         0          1         User   R/W 
 * N_ADD_0P5              0x0A02[4:0]   0x0A02         0          5         User   R/W 
 * N_CLK_TO_OUTX_EN       0x0A03[4:0]   0x0A03         0          5         User   R/W 
 * N_PIBYP                0x0A04[4:0]   0x0A04         0          5         User   R/W 
 * N_PDNB                 0x0A05[4:0]   0x0A05         0          5         User   R/W 
 * N0_HIGH_FREQ           0x0A14[3]     0x0A14         3          1         User   R/W 
 * N1_HIGH_FREQ           0x0A1A[3]     0x0A1A         3          1         User   R/W 
 * N2_HIGH_FREQ           0x0A20[3]     0x0A20         3          1         User   R/W 
 * N3_HIGH_FREQ           0x0A26[3]     0x0A26         3          1         User   R/W 
 * N4_HIGH_FREQ           0x0A2C[3]     0x0A2C         3          1         User   R/W 
 * FRACN_CLK_DIS_PLL      0x0B44[5]     0x0B44         5          1         User   R/W 
 * PDIV_FRACN_CLK_DIS     0x0B44[3:0]   0x0B44         0          4         User   R/W 
 * LOS_CLK_DIS            0x0B46[3:0]   0x0B46         0          4         User   R/W 
 * OOF_CLK_DIS            0x0B47[4:0]   0x0B47         0          5         User   R/W 
 * OOF_DIV_CLK_DIS        0x0B48[4:0]   0x0B48         0          5         User   R/W 
 * N_CLK_DIS              0x0B4A[4:0]   0x0B4A         0          5         User   R/W 
 * VCO_RESET_CALCODE      0x0B57[11:0]  0x0B57         0          12        User   R/W 
 * 
 *
 */

#endif