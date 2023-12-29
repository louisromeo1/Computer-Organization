/*
 * Author: Louis Romeo
 * Course: CSC 252
 * Purpose: Program that simulates an 8 by 1 MUX.
 */

public class Sim3_MUX_8by1 {
	public void execute() {
		
		// Each bit will hold the true value of the in bit
		boolean bit0 = !control[2].get() && !control[1].get() 
				&& !control[0].get() && in[0].get();
		boolean bit1 = !control[2].get() && !control[1].get() 
				&&  control[0].get() && in[1].get();
		boolean bit2 = !control[2].get() &&  control[1].get() 
				&& !control[0].get() && in[2].get();
		boolean bit3 = !control[2].get() &&  control[1].get() 
				&&  control[0].get() && in[3].get();
		boolean bit4 =  control[2].get() && !control[1].get() 
				&& !control[0].get() && in[4].get();
		boolean bit5 =  control[2].get() && !control[1].get() 
				&&  control[0].get() && in[5].get();
		boolean bit6 =  control[2].get() &&  control[1].get() 
				&& !control[0].get() && in[6].get();
		boolean bit7 =  control[2].get() &&  control[1].get() 
				&&  control[0].get() && in[7].get();
		
		boolean outVal = bit0 || bit1 || bit2 || bit3 || bit4 || bit5 || bit6 || bit7;
		
		out.set(outVal);
	}
	
	public RussWire[] control;
	public RussWire[] in;
	public RussWire out;
	public RussWire[] not;
	
	public Sim3_MUX_8by1() {
		control = new RussWire[3];
		in = new RussWire[8];
		
		for (int i = 0; i < 8; i++) {
			in[i] = new RussWire();
		}
		
		for (int i = 0; i < 3; i++) {
			control[i] = new RussWire();
			
		}
		out = new RussWire();
	}
}


