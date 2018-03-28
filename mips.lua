local instructions = require("instructions")

MIPS = {}
MIPS.__index = MIPS

local REGISTER_COUNT = 32
local MEMORY_SIZE = 2^16

function MIPS.new()
    local instance = setmetatable({}, MIPS)
    instance.pc = 0
    instance.npc = 4
    instance.reg = {}
    instance.memory = {}

    for i = 0, REGISTER_COUNT - 1 do
        instance.reg[i] = 0
    end

    for i = 0, MEMORY_SIZE - 1 do
        instance.memory[i] = 0
    end

    return instance
end

function MIPS:fetch()
    return self.reg[self.pc]
end

local function extract_bits(value, right, left)
    -- Mask with only 1s in positions [left, right].
    local mask = ~(~0 << (right - left + 1))

    return (value >> left) & mask
end

function MIPS:decode(instr)
    local opcode = extract_bits(instr, 31, 26)
    local decoded = {}

    if opcode == 0 then
        -- Decode R format.
        decoded.rs = extract_bits(instr, 25, 21)
        decoded.rt = extract_bits(instr, 20, 16)
        decoded.rd = extract_bits(instr, 15, 11)
        decoded.shamt = extract_bits(instr, 10, 6)
        decoded.funct = extract_bits(instr, 5, 0)
    elseif opcode == 1 then
        -- Decode J format.
        decoded.addr = extract_bits(instr, 25, 0)
    else
        -- Decode I format.
        decoded.rs = extract_bits(instr, 25, 21)
        decoded.rt = extract_bits(instr, 20, 16)
        decoded.imm = extract_bits(instr, 15, 0)
    end

    return decoded
end

function MIPS:execute(decoded)
    local instr

    if decoded.addr then
        instr = instructions.J[decoded.opcode]
        instr(self, decoded.addr)

        return
    end

    if decoded.funct then
        -- Decode R instruction.
        instr = instructions.R[decoded.funct]
        instr(self, decoded.rs, decoded.rt, decoded.rd, decoded.shamt)
    else
        -- Decode I instruction.
        instr = instructions.I[decoded.opcode]
        instr(self, decoded.rs, decoded.rt, decoded.imm)
    end

    self:advancePC(4)
end

function MIPS:advancePC(offset)
    self.pc = self.npc
    self.npc = self.npc + offset
end

-- Write 1, 2, or 4 bytes to memory.
function MIPS:mem_write(addr, data, length)
    for offset = length - 1, 0, -1 do
        self.memory[addr + offset] = data
        data = data >> 4
    end
end

-- Read 1, 2, or 4 bytes to memory.
function MIPS:mem_read(addr, length)
    local value = 0

    for offset = 0, length - 1 do
        value = (value << 4) | self.memory[addr + offset]
    end

    return value
end

function MIPS:print()
    local reg_names = {
        "$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
        "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
        "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
        "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
    }

    local out = {"$pc = "..self.pc}
    local column = 1

    for i = 0, REGISTER_COUNT - 1 do
        out[#out + 1] = reg_names[i + 1].." = "..self.reg[i]
        column = column + 1

        if column > 1 then
            out[#out] = "\t\t"..out[#out]
        end

        if column == 3 then
            column = 0
            out[#out + 1] = "\n"
        end
    end

    print(table.concat(out))
end

function MIPS:step()
    self:execute(self:decode(self:fetch()))
end

return MIPS
