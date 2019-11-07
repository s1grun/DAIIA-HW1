/***
* Name: Festival
* Author: sigrunarnasigurdardottir
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Festival

/* Insert your model definition here */
global {
	point agentLocation <- {50, 50};
	init {
		int addDist <- 0;
		
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
	
//	action move (list<agent> movingGuest){
//		
//	}
	
}

species Guests skills:[moving]{
//	rgb guestColor <- #green;
	bool thirsty <- flip(0.5); //50% chance to be thirsty true;
	bool hungry <- flip(0.5);	//50% chance to be hungry true;
	//or use int status
	int status <- rnd (2);    // var0 equals 0, 1 or 2; 0->nothing,1->thirsty,2->hungry
	
	aspect default {
		draw circle(2) color:#green border:#green;
	}
	
	point statusPoint <- nil;
	
//	reflex statusIdle when: statusPoint = nil 
//	{
//		do wander;
//	}
	
	reflex goToIc when: statusPoint = nil
	{
		do goto target:agentLocation;
		
	}
	
//	reflex goToStore when: statusPoint != nil
//	{
//		do goto target:statusPoint;
//	}
//	
//	reflex atStore when: location distance_to(statusPoint) < 2
//	{
		
//	}
	
}

species Stores {
//	rgb storesColor <- #blue;
	aspect default {
		draw rectangle(4, 4) color:#blue;
	}
}

species Ic {
	list store_location;
	init{
		ask agents of_species Stores{
			add location to: myself.store_location;
//			write location;
		}
		write store_location;
	}
	aspect default {
		draw rectangle(4, 4) color:#red;
		
	} 
	
	point Guests;
	
//	reflex get_store when: Guests != nil 
//	{
//		do goto target
//	}
//	ask Stores at_distance Guests{
//		
//	}
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