/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program that implements a multi-bit or
 * 			"ripple carry" adder, by utilizing many
 * 			full adders together.
 */ 

public class Sim2_AdderX {
	public void execute() { 
		
		adders[0].carryIn.set(false); // initial carry in is 0
				
		adders[0].a.set(a[0].get());
		adders[0].b.set(b[0].get());

		adders[0].execute();

		sum[0].set(adders[0].sum.get());
		
		for (int i = 1; i < adders.length; i++) {
		
			boolean aGet = a[i].get();
			boolean bGet = b[i].get();
			
			adders[i].a.set(aGet); // set current adder to a val
			adders[i].b.set(bGet); // set current adder to b val
			adders[i].carryIn.set(adders[i - 1].carryOut.get());
			
			adders[i].execute();
			
			sum[i].set(adders[i].sum.get()); // set sum to result of adder
			
		}
		carryOut.set(adders[adders.length - 1].carryOut.get()); // sum.length - 1
		
		xor.a.set(a[adders.length - 1].get()); // check for a != b
		xor.b.set(b[adders.length - 1].get()); 
		
		xor.execute();
		
		not.in.set(xor.out.get()); 
		not.execute();
		
		xor2.a.set(sum[adders.length - 1].get()); // true when sum bit != a
		xor2.b.set(b[adders.length - 1].get());
		
		xor2.execute();
		
		and.a.set(not.out.get()); // true when a = b and sum != a
		and.b.set(xor2.out.get());
		
		and.execute();

		overflow.set(and.out.get());
	}
	
	// inputs
	public RussWire[] a, b;
	public Sim2_FullAdder[] adders;
	private AND and;
	private XOR xor, xor2;
	private NOT not;
	// outputs
	public RussWire[] sum;
	public RussWire carryOut, overflow;
	
	public Sim2_AdderX(int x) {
		
		a = new RussWire[x];
		b = new RussWire[x];
		sum = new RussWire[x];
		adders = new Sim2_FullAdder[x];
		and = new AND();
		xor = new XOR();
		xor2 = new XOR();
		not = new NOT();
		
		for (int i = 0; i < x; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			sum[i] = new RussWire();
			adders[i] = new Sim2_FullAdder();
		}
		
		carryOut = new RussWire();
		overflow = new RussWire();
		
	}
}