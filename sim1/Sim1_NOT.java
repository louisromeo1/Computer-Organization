/* Simulates a physical NOT gate.
 *
 * Author: Louis Romeo
 */

public class Sim1_NOT
{
	public void execute()
	{
		out.set(! in.get());
	}



	public RussWire in;    // input
	public RussWire out;   // output

	public Sim1_NOT()
	{
		in = new RussWire();
		out = new RussWire();
	}
}

