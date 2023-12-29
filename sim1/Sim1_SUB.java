/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Louis Romeo
 */

public class Sim1_SUB
{
	public void execute()
	{
		for(int i = 0; i < 32; i++) {
			boolean curB = b[i].get();
			twos_complement.in[i].set(curB);
		}
		twos_complement.execute();
		for(int i = 0; i < 32; i++) {
			boolean curA = a[i].get();
			boolean curTwo = twos_complement.out[i].get();
			sim1_add.a[i].set(curA);
			sim1_add.b[i].set(curTwo);
		}
		sim1_add.execute();
		for(int i = 0; i < 32; i++) {
			boolean curAdd = sim1_add.sum[i].get();
			sum[i].set(curAdd);
		}
	}



	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a,b;

	// output
	public RussWire[] sum;

	public Sim1_ADD sim1_add;
	public Sim1_2sComplement twos_complement;



	public Sim1_SUB()
	{
		a   			= new RussWire[32];
		b   			= new RussWire[32];
		sum 			= new RussWire[32];
		sim1_add    	= new Sim1_ADD();
		twos_complement = new Sim1_2sComplement();

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}
	}
}

