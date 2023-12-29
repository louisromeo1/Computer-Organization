/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Louis Romeo
 */

public class Sim1_2sComplement
{
	public void execute()
	{
		for(int i = 0; i < 32; i++) {
			boolean curIn = in[i].get();
			not_array[i].in.set(curIn);
			not_array[i].execute();
		}
		for(int i = 0; i < 32; i++) {
			boolean notGet = not_array[i].out.get();
			sim1_add.a[i].set(notGet);
			if(i == 0) {
				sim1_add.b[0].set(true);
			} else {
				sim1_add.b[0].set(false);
			}
		}
		sim1_add.execute();
		for(int i = 0; i < 32; i++) {
			boolean sum_get = sim1_add.sum[i].get(); // Do
			out[i].set(sum_get);
		}
	}



	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;

	public Sim1_ADD sim1_add;
	public Sim1_NOT[] not_array;
	

	public Sim1_2sComplement()
	{
		in   		= new RussWire[32];
		out   		= new RussWire[32];
		not_array	= new Sim1_NOT[32];
		sim1_add    = new Sim1_ADD();

		for (int i=0; i<32; i++)
		{
			in  	 [i] = new RussWire();
			out  	 [i] = new RussWire();
			not_array[i] = new Sim1_NOT();
	}
	}
}

