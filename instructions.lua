local instructions = {}

local function add(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] + cpu.reg[rt]
end

local function addu(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = (cpu.reg[rs] + cpu.reg[rt]) & 0xffffffff
end

local function addi(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu.reg[rs] + imm
end

local function addiu(cpu, rs, rt, imm)
    cpu.reg[rt] = (cpu.reg[rs] + imm) & 0xffffffff
end

local function _and(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] & cpu.reg[rt]
end

local function andi(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu.reg[rs] & imm
end

local function beq(cpu, rs, rt, imm)
    if cpu.reg[rs] == cpu.reg[rt] then
        cpu:advance_pc((imm << 2) - 4)
    end
end

local function bne(cpu, rs, rt, imm)
    if cpu.reg[rs] >= 0 then
        cpu:advance_pc((imm << 2) - 4)
    end
end

local function j(cpu, target)
    cpu.pc = cpu.npc
    cpu.npc = (cpu.pc & 0xf0000000) | (target << 2)
end

local function jal(cpu, target)
    -- $31 = $ra = return address
    cpu.reg[31] = cpu.pc + 8
    cpu.pc = cpu.npc
    cpu.npc = (cpu.pc & 0xf0000000) | (target << 2)
end

local function jr(cpu, target)
    cpu.pc = cpu.npc
    cpu.npc = target
end

local function lbu(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu:mem_read(cpu.reg[rs] + imm, 1)
end

local function lhu(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu:mem_read(cpu.reg[rs] + imm, 2)
end

local function ll(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu:mem_read(cpu.reg[rs] + imm, 1)
end

local function lui(cpu, rs, rt, imm)
    cpu.reg[rt] = imm << 16
end

local function lw(cpu, rs, rt, imm)
    cpu.reg[rt] = cpu:mem_read(cpu.reg[rs] + imm, 4)
end

local function nor(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = ~(cpu.reg[rs] | cpu.reg[rt])
end

local function _or(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rs] | cpu.reg[rt]
end

local function ori(cpu, rs, rt, imm)
    cpu.reg[rd] = cpu.reg[rs] | imm
end

local function slt(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = (cpu.reg[rs] < cpu.reg[rt]) and 1 or 0
end

local function slti(cpu, rs, rt, imm)
    cpu.reg[rt] = (cpu.reg[rs] < imm) and 1 or 0
end

local function sltu(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = (cpu.reg[rs] < cpu.reg[rt]) and 1 or 0
end

local function sltiu(cpu, rs, rt, imm)
    cpu.reg[rt] = (cpu.reg[rs] < imm) and 1 or 0
end

local function sll(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rt] << shamt
end

local function srl(cpu, rs, rt, rd, shamt)
    cpu.reg[rd] = cpu.reg[rt] >> shamt
end

local function sb(cpu, rs, rt, imm)
    cpu:mem_write(cpu.reg[rs] + imm, cpu.reg[rt] & 0xff, 1)
end

local function sc(cpu, rs, rt, imm)
    cpu:mem_write(cpu.reg[rs] + imm, cpu.reg[rt], 1)
    cpu.reg[rt] = 1
end

local function sh(cpu, rs, rt, imm)
    cpu:mem_write(cpu.reg[rs] + imm, cpu.reg[rt] & 0xffff, 2)
end

local function sw(cpu, rs, rt, imm)
    cpu:mem_write(cpu.reg[rs] + imm, cpu.reg[rt] & 0xffffffff, 4)
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
