/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Louis Romeo
 */

public class Sim1_ADD
{
	public void execute()
	{
		boolean keep_going = false;
		for(int i = 0; i < 32; i++) {
			boolean aGet = a[i].get();
			boolean bGet = b[i].get();
			boolean xor_one = aGet != bGet;
			boolean xor_two = xor_one != keep_going;
			sum[i].set(xor_two);
			if(a[i].get() && b[i].get()) {
				keep_going = true;
				//System.out.print(i);
			} else if((a[i].get() == false && b[i].get() 
					== false) && keep_going == true) {
				keep_going = false;
			}
		}
		//overflow.set(false);
		carryOut.set(keep_going);
		boolean xor_three = a[31] != b[31];
		if((a[31].get() == !sum[31].get()) 		// Solid overflow if statement
				&& (a[31].get() == b[31].get())) {
			overflow.set(true); 
		} else {
			overflow.set(false);
		}
		
	}



	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

