/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program that implements a full adder,
 * 			in this case by linking two half-adders
 * 			together.
 */ 
public class Sim2_FullAdder {
	
	public void execute() {
		
		boolean aGet = a.get();
		boolean bGet = b.get();
		
		first.a.set(aGet); 				// Set first half adder to inputs
		first.b.set(bGet);
		
		first.execute();

		second.a.set(carryIn.get()); 	// carryIn = second half adder
		second.b.set(first.sum.get());	// first sum = input b
		
		second.execute();
		
		sum.set(second.sum.get());
		
		or.a.set(first.carry.get());
		or.b.set(second.carry.get());
		
		or.execute();
		carryOut.set(or.out.get()); 	// carryIn is 1 when a = b = 1

	}
	
	// inputs
	public RussWire a, b, carryIn;
	public OR or;
	// outputs
	public RussWire sum, carryOut;
	
	public Sim2_HalfAdder first, second;
	
	public Sim2_FullAdder() {
		
		a = new RussWire();
		b = new RussWire();
		carryIn = new RussWire();
		
		or = new OR();
		
		sum = new RussWire();
		carryOut = new RussWire();
		
		first = new Sim2_HalfAdder();
		second = new Sim2_HalfAdder();
	}
}