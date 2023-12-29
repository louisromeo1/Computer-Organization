/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: This program implements a single-cycle CPU
			using control bits to direct the processor
 */ 
			

#include <stdio.h>
#include "sim4.h"


int CPUControlHelper(int function, CPUControl*controlfields, InstructionFields*fieldsOut);

// This function is passed an instruction as input, must read all
void extract_instructionFields(WORD instruction, InstructionFields*fieldsOut) {
    // Masks and hex values
    int op = (instruction >> 26) & 0x3F; //bits 31-26
    fieldsOut -> opcode = op;
    int rS = (instruction >> 21) & 0x1F; //bits 25-21
    fieldsOut -> rs = rS;
    int rT = (instruction >> 16) & 0x1F; //bits 20-16
    fieldsOut -> rt = rT;
	int rD = (instruction >> 11) & 0x1F; //bits 15-11
    fieldsOut -> rd = rD;
	int shmt = (instruction >> 6) & 0x1F; //bits 10-6
    fieldsOut -> shamt = shmt;
	int func = (instruction) & 0x3F; //bits 5-0
    fieldsOut -> funct = func;
    
	unsigned int imM16 = (instruction) & 0xFFFF; //bits 15-0
    fieldsOut -> imm16 = imM16;
    
    int imM32 = signExtend16to32(imM16); //bits 15-0 (sign extended)
    fieldsOut -> imm32 = imM32;

	int addressBits = (instruction) & 0x3FFFFFF; //bits 25-0
    fieldsOut -> address = addressBits;
}


int fill_CPUControl(InstructionFields*fieldsOut, CPUControl*controlfields) {
    int op = fieldsOut -> opcode; //opcode from fieldsout
    int func = fieldsOut -> funct; //function code from fields out 
    // hardcode all allowed instructions 
    if(op == 0x00){ // if opcode is 0 then it is an r format and the funct field should be read as well
        int isValid = CPUControlHelper(func, controlfields, fieldsOut);
        return isValid;
    } else if (op == 0x08) { //addi
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op == 0x09){ //addiu
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op == 0x0a){ //slti
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 3;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op == 0x23){ //lw
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 1;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 1;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op==0x2b){ //sw
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 1;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 0;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op==0x04){ //beq
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 0;
        controlfields -> branch      = 1;
        controlfields -> jump        = 0;
    } else if (op==0x02){ //j
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 0;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 0;
        controlfields -> branch      = 0;
        controlfields -> jump        = 1;
    } else if (op == 0x0c){//andi
        controlfields -> ALUsrc      = 1;
        controlfields -> ALU.op      = 0;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (op == 0x05){//bne
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 5;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 0;
        controlfields -> regWrite    = 0;
        controlfields -> branch      = 1;
        controlfields -> jump        = 0;      
    }
    else{
        return 0;
    }
    return 1;
}

// Helper function which sets the fields of the CPUControl using the funct bits from the instruction.
/**
     * add: funct = 32
     * addu: funct = 33
     * sub: funct = 34
     * subu: funct = 35
     * addi: 08
     * addiu: 09
     * and: funct = 36
     * or: op = 0, funct = 37
     * xor: op = 0, funct = 38
     * slt: funct = 42
     * slti: 0a
     * lw: 0x23
     * sw: 2b
     * beq: 04
     * j: 02
     */
int CPUControlHelper(int funct, CPUControl*controlfields, InstructionFields*fieldsOut){
    int isValid = 1;
    if (funct == 0x20){ //add
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x21){ //addu
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x22){ //sub
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x23){ //subu
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 2;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x24){ //and
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 0;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x25){ //or
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 1;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x26){ //xor
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 4;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct==0x2A){ //slt
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 3;
        controlfields -> ALU.bNegate = 1;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
    } else if (funct == 0x00){//sll
        controlfields -> ALUsrc      = 0;
        controlfields -> ALU.op      = 6;
        controlfields -> ALU.bNegate = 0;
        controlfields -> memRead     = 0;
        controlfields -> memWrite    = 0;
        controlfields -> memToReg    = 0;
        controlfields -> regDst      = 1;
        controlfields -> regWrite    = 1;
        controlfields -> branch      = 0;
        controlfields -> jump        = 0;
        controlfields -> extra1      = 1;
        controlfields -> extra2      = fieldsOut -> shamt;
    } else {
        isValid = 0;
    }
    return isValid;
}

// Reads the correct word out of instruction memory, given the current Program Counter. Returns the value.
WORD getInstruction(WORD curPC, WORD *instructionMemory)
{   
    return instructionMemory[curPC / 4];
}

WORD getALUinput1(CPUControl *controlIn, InstructionFields *fieldsIn, 
		WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, WORD oldPC) {
    return rsVal;
}

WORD getALUinput2(CPUControl *controlIn, InstructionFields *fieldsIn, WORD rsVal, 
		WORD rtVal, WORD reg32, WORD reg33, WORD oldPC) {
    if (controlIn -> ALUsrc == 0){
        return rtVal;
    } else {
        return fieldsIn -> imm32;
    }
}

void execute_ALU(CPUControl *controlIn, WORD input1, 
		WORD input2, ALUResult  *aluResultOut) {
		// 0 = and 
	    // 1 = or
	    // 2 = add
	    // 3 = less
	    // 4 = xor
		// ANDI
		// BNE
		// SLL
    int operation = controlIn -> ALU.op;
    if (operation == 0){
        ///input2 = input2 & 0x0000FFFF;
        aluResultOut -> result = input1 & input2;

        if (aluResultOut -> result == 0){
            aluResultOut -> zero = 1;
        } else {
            aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
    } else if (operation == 1){
        aluResultOut -> result = input1 | input2;
        if (aluResultOut -> result == 0){
            aluResultOut -> zero = 1;
        } else {
            aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
    } else if (operation == 2){
        if (controlIn -> ALU.bNegate == 1){
            aluResultOut -> result = input1 - input2;
        } else {
            aluResultOut -> result = input1 + input2;
        }
        if (aluResultOut -> result == 0){
            aluResultOut -> zero = 1;
        } else {
            aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
    } else if (operation == 3){
    	aluResultOut -> result = input1 < input2;       
        if (aluResultOut -> result == 0){
            aluResultOut -> zero = 1;
        } else{
            aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
	} else if (operation == 4){
        aluResultOut -> result = input1 ^ input2;
        if (aluResultOut -> result == 0){
            aluResultOut -> zero = 1;
        } else {
            aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
    } else if (operation == 5){
        int check = input1 - input2;
        if (check != 0){
            aluResultOut -> result = 1;
            aluResultOut -> zero = 1;
        } else {
            aluResultOut -> result = 0;
            aluResultOut -> zero = 0;
        }
    } else if (operation == 6){
        aluResultOut -> result = input1 << input2;
        aluResultOut -> zero = 0;
        if (aluResultOut -> result == 0){
                    aluResultOut -> zero = 1;
        } else {
        	aluResultOut -> zero = 0;
        }
        aluResultOut -> extra = 0;
    } else {
    	aluResultOut -> result = 0;
    	if (aluResultOut -> result == 0){
    		aluResultOut -> zero = 1;
    	} else{
    		aluResultOut -> zero = 0;
    	}
    	aluResultOut -> extra = 0;
}
    }

void execute_MEM(CPUControl *controlIn, ALUResult  *aluResultIn, 
		WORD rsVal, WORD rtVal, WORD *memory, MemResult *resultOut)
{   
    if (controlIn -> memRead == 1){
        // the value read from memory at the address provided by the ALU
        // divide by four to convert to words from bytes
        resultOut -> readVal = memory[aluResultIn -> result / 4];
    } else if (controlIn -> memWrite == 1){
        memory[aluResultIn -> result / 4] = rtVal;
    } else {
        resultOut -> readVal = 0;
    }
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal, WORD oldPC)
{
    int newPc = oldPC + 4;
    if (controlIn -> jump == 1){
        newPc = (fields -> address << 2) + (oldPC & 0xF0000000);
    } 
    if (controlIn -> branch == 1 && aluZero == 1){
        newPc = (fields -> imm32 << 2) + oldPC + 4;
    }
    return newPc;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn, 
		ALUResult  *aluResultIn, MemResult *memResultIn, WORD *regs)
{
    if (controlIn -> regWrite == 1){
        int regVal = aluResultIn -> result;
        if (controlIn -> memToReg == 1){
            regVal = memResultIn -> readVal;
        } 
        if (controlIn -> regDst == 1){
            regs[fields -> rd] = regVal;
        } else {
            regs[fields -> rt] = regVal;
        }
    }
}
