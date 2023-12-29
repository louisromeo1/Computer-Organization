/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program that simulates an element of the ALU.
 */

public class Sim3_ALUElement {
	
	public void execute_pass1() {
		
		fullAdder.a.set(a.get());
		fullAdder.b.set(b.get() != bInvert.get()); // if b and bInvert are not equal b = 1
		
		fullAdder.carryIn.set(carryIn.get());
		fullAdder.execute();
		
		addResult.set(fullAdder.sum.get());
		carryOut.set(fullAdder.carryOut.get());
	}
	
	public void execute_pass2() {
		
		andVal = fullAdder.a.get() && fullAdder.b.get();
		orVal  = fullAdder.a.get() || fullAdder.b.get();
		xorVal = fullAdder.a.get() != fullAdder.b.get();
		lessVal = less.get();
		
		// setting control bits
		mux.control[0].set(aluOp[0].get());
		mux.control[1].set(aluOp[1].get());
		mux.control[2].set(aluOp[2].get());
		
		// setting in bits for mux to choose 
		mux.in[0].set(andVal);
		mux.in[1].set(orVal);
		mux.in[2].set(addResult.get());
		mux.in[3].set(lessVal);
		mux.in[4].set(xorVal);
		mux.in[5].set(false);
		mux.in[6].set(false);
		mux.in[7].set(false);
		
		mux.execute();
		
		result.set(mux.out.get());
	}
	
	public RussWire[] aluOp;
	public RussWire bInvert;
	public RussWire a;
	public RussWire b;
	public RussWire carryIn;
	public RussWire less;
	public RussWire result;
	public RussWire addResult;
	public RussWire carryOut;
	public Sim3_MUX_8by1 mux;
	public Sim2_FullAdder fullAdder;
	public boolean andVal;
	public boolean orVal;
	public boolean lessVal;
	public boolean xorVal;
	
	public Sim3_ALUElement() {
		aluOp = new RussWire[3];
		for (int i = 0; i < 3; i++) {
			aluOp[i] = new RussWire();
		}
		
		bInvert = new RussWire();
		a = new RussWire();
		b = new RussWire();
		carryIn = new RussWire();
		less = new RussWire();
		result = new RussWire();
		addResult = new RussWire();
		carryOut = new RussWire();
		
		mux = new Sim3_MUX_8by1();
		fullAdder = new Sim2_FullAdder();
		
	}
}