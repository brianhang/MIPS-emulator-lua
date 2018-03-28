local MIPS = require("mips")

local cpu = MIPS.new()
cpu.reg[10] = 123
cpu.reg[11] = 123
local dec = cpu:decode(0x014B4820)
cpu:execute(dec)

cpu:print()
