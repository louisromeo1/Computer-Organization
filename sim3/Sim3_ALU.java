/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program that simulates a complete ALU.
 */

public class Sim3_ALU {
	
	public void execute() {
		
		boolean carryIn = bNegate.get(); // if bNegate = 1 the first carryIn is 1
		
		// Setting the values for the aluElement at index 0 
		aluArray[0].aluOp[0].set(aluOp[0].get());
		aluArray[0].aluOp[1].set(aluOp[1].get());
		aluArray[0].aluOp[2].set(aluOp[2].get());
		
		// Initialize the two values to add, carryIn and bInvert
		aluArray[0].a.set(a[0].get());
		aluArray[0].b.set(b[0].get());
		aluArray[0].carryIn.set(carryIn);
		aluArray[0].bInvert.set(bNegate.get());
		
		aluArray[0].execute_pass1();
		
		// the new carryIn is the carryOut from the addition 
		
		carryIn = aluArray[0].fullAdder.carryOut.get();
		
		// Set values and execute for all values at indices greater than 0 
		for (int i = 1; i < aluArray.length; i ++) {
			// setting the control bits for each aluElement
			aluArray[i].aluOp[0].set(aluOp[0].get());
			aluArray[i].aluOp[1].set(aluOp[1].get());
			aluArray[i].aluOp[2].set(aluOp[2].get());
			
			aluArray[i].a.set(a[i].get());
			aluArray[i].b.set(b[i].get());
			aluArray[i].carryIn.set(carryIn);
			aluArray[i].bInvert.set(bNegate.get());
			
			aluArray[i].execute_pass1();
			
			carryIn = aluArray[i].fullAdder.carryOut.get();
			aluArray[i].less.set(false);
			aluArray[i].execute_pass2();
			// set the result array at i to result of aluElement
			result[i].set(aluArray[i].result.get());
		}
		aluArray[0].less.set(aluArray[aluArray.length - 1].fullAdder.sum.get());
		
		aluArray[0].execute_pass2();
		result[0].set(aluArray[0].result.get()); // set the result at index 0
		
	}
	
	// inputs
	public RussWire[] 		 aluOp;
	public RussWire[] 		 a;
	public RussWire[] 		 b;
	public Sim3_ALUElement[] aluArray;
	public RussWire 		 bNegate;
	//outputs
	public RussWire[] 		 result;

	public Sim3_ALU(int bits) {
		aluOp = new RussWire[3];
		aluArray = new Sim3_ALUElement[bits];
		a = new RussWire[bits];
		b = new RussWire[bits];
		result = new RussWire[bits];
		
		
		for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}
		
		for (int i = 0; i < bits; i++) {
			aluArray[i] = new Sim3_ALUElement();
			a[i] = new RussWire();
			b[i] = new RussWire();
			result[i] = new RussWire();
		}
		
		bNegate = new RussWire();
	}

}
