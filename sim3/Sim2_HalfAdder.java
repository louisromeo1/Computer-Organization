/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program responsible for simulating a 
 * 			half-adder in java. Takes in two RussWire
 * 			objects as input, and returns two RussWire
 * 			objects as a result (sum and carry are returned).
 */ 

public class Sim2_HalfAdder {
	
	public void execute() {
		
		boolean aGet = a.get();
		boolean bGet = b.get();
		
		xor.a.set(aGet);
		xor.b.set(bGet);
		
		xor.execute();
		
		sum.set(xor.out.get());
		
		and.a.set(aGet);
		and.b.set(bGet);
		
		and.execute();
		
		carry.set(and.out.get()); // carry is 1 if a = b = 1
		
	}
	
	// inputs
	public RussWire a, b;
	public XOR xor;
	public AND and;
	// outputs
	public RussWire sum, carry;
	
	// constructor
	public Sim2_HalfAdder() {
		
		a = new RussWire();
		b = new RussWire();
		xor = new XOR();
		and = new AND();
		
		sum = new RussWire();
		carry = new RussWire();
	}
}
