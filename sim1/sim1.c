// Author: Louis Romeo
#include "sim1.h"
void execute_add(Sim1Data *obj) {
	int xor_one = 0;
	int xor_two = 0;
	int a_get = 0;
	int b_get = 0;
	int keep_going = 0;
	int sum = 0;
	if(obj -> isSubtraction == 1) {
		keep_going = 1;
	}
	for(int i = 0; i < 32; i++) {
		a_get = (obj -> a >> i) & 0x1;
		b_get = (obj -> b >> i) & 0x1;
		if(obj -> isSubtraction == 1) {
			b_get = !b_get;
		}
		xor_one = a_get ^ b_get;
		xor_two = xor_one ^ keep_going;
		int outcome = obj -> sum >> i | (xor_two << i);
		obj -> sum |= outcome;
		if(a_get & b_get) {
			keep_going = 1;
		} else if((a_get == 0 & b_get == 0) 
					& keep_going == 1) {
			keep_going = 0;
		}
	}
	obj -> carryOut = keep_going;
	int a_get_msb = (obj -> a >> 31) & 0x1;
	int b_get_msb = (obj -> b >> 31) & 0x1; 
	int xor_three = a_get_msb ^ b_get_msb;
	int sum_get_msb = (obj -> sum >> 31) & 0x1;
	if(a_get_msb == 1) {
		obj -> aNonNeg = 0;
	} else {
		obj -> aNonNeg = 1;
	}
	if(b_get_msb == 1) {
		obj -> bNonNeg = 0;
	} else {
		obj -> bNonNeg = 1;
	}
	if(sum_get_msb == 1) {
		obj -> sumNonNeg = 0;
	} else { 
		obj -> sumNonNeg = 1;
	}
	if((obj -> isSubtraction == obj -> sumNonNeg) &(a_get_msb == !sum_get_msb) 
		& (a_get_msb == b_get_msb)) { 
		obj -> overflow = 1;   
	} else { 
		obj -> overflow = 0;
	}	

}
