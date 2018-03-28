local instructions = {}

local function add(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] + cpu.reg[rt]
end

local function addu(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = (cpu.reg[rs] + cpu.reg[rt]) & 0xffffffff
end

local function addi(cpu, rt, rs, imm)
    cpu.reg[rt] = cpu.reg[rs] + imm
end

local function addiu(cpu, rt, rs, imm)
    cpu.reg[rt] = (cpu.reg[rs] + imm) & 0xffffffff
end

local function _and(cpu, rt, rs, rd, shamt)
end

local function andi(cpu, rt, rs, imm)
end

local function beq(cpu, rt, rs, imm)
end

local function bne(cpu, rt, rs, imm)
end

local function j(cpu, target)
end

local function jal(cpu, target)
end

local function jr(cpu, target)
end

local function lbu(cpu, rt, rs, imm)
end

local function lhu(cpu, rt, rs, imm)
end

local function ll(cpu, rt, rs, imm)
end

local function lui(cpu, rt, rs, imm)
end

local function lw(cpu, rt, rs, imm)
end

local function nor(cpu, rt, rs, rd, shamt)
end

local function _or(cpu, rt, rs, rd, shamt)
end

local function ori(cpu, rt, rs, imm)
end

local function slt(cpu, rt, rs, rd, shamt)
end

local function slti(cpu, rt, rs, imm)
end

local function sltu(cpu, rt, rs, rd, shamt)
end

local function sltui(cpu, rt, rs, rd, shamt)
end

local function sll(cpu, rt, rs, rd, shamt)
end

local function srl(cpu, rt, rs, rd, shamt)
end

local function sb(cpu, rt, rs, imm)
end

local function sc(cpu, rt, rs, imm)
end

local function sh(cpu, rt, rs, imm)
end

local function sw(cpu, rt, rs, imm)
end

local function sub(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] - cpu.reg[rt]
end

local function subu(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] - cpu.reg[rt]
end

instructions.R = {
    [0x20] = add,
    [0x21] = addu,
    [0x24] = _and,
    [0x08] = jr,
    [0x27] = nor,
    [0x25] = _or,
    [0x2a] = slt,
    [0x2b] = sltu,
    [0x00] = sll,
    [0x02] = srl,
    [0x22] = sub,
    [0x23] = subu,
}

instructions.I = {
    [0x08] = addi,
    [0x09] = addiu,
    [0x0c] = andi,
    [0x04] = beq,
    [0x05] = bne,
    [0x24] = lbu,
    [0x25] = lhu,
    [0x30] = ll,
    [0x0f] = lui,
    [0x23] = lw,
    [0x0d] = ori,
    [0x0a] = slti,
    [0x0b] = sltiu,
    [0x28] = sb,
    [0x38] = sc,
    [0x29] = sh,
    [0x2b] = sw
}

instructions.J = {
    [0x02] = j,
    [0x03] = jal
}

return instructions
