/***
* Name: Festival
* Author: sigrunarnasigurdardottir
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Festival

/* Insert your model definition here */
global {
	
	init {
		int addDist <- 0;
		point agentLocation <- {50, 50};
		point storeLocation1 <- {25, 25};
		create Guests number: 10
		{
			//location <- {50 + addDist, 50 + addDist};
			//addDist <- addDist + 5;
		}
		
		create Stores number: 4
		{
			//location <- {10 + addDist, 10 + addDist};
			//addDist <- addDist + 10;
		}
		
		create Ic number: 1 with: (location: agentLocation)
		{
			
		}

	}
	
}

species Guests skills:[moving]{
//	rgb guestColor <- #green;
	aspect default {
		draw circle(2) color:#green border:#green;
	}
	
	reflex moving {
		do wander;
	}
	
}

species Stores {
//	rgb storesColor <- #blue;
	aspect default {
		draw rectangle(4, 4) color:#blue;
	}
}

species Ic {
	aspect default {
		draw rectangle(4, 4) color:#red;
	}
	
	
	
	//reflex get_store when:  {}
	//ask Stores {
		
	//}
}

experiment festival type:gui{
	output{
		display map type: opengl {
			species Guests;
			species Stores;
			species Ic;
		}
	}
}