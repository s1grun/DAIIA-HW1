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
	//int environment_size <- 100;
    //geometry shape <- cube(environment_size);
    file map_init <- image_file("../includes/data/grass.jpeg");
	init {
		
		
		int addDist <- 0;
		
		point storeLocation1 <- {25, 25};
		create Guests number: 10
		{
			//location <- {50 + addDist, 50 + addDist};
			//addDist <- addDist + 5;
		}
		
		create Stores number: 2 with: (type: "bar")
		{
			//location <- {10 + addDist, 10 + addDist};
			//addDist <- addDist + 10;
		}
				create Stores number: 2 with: (type: "restaurant")
		{
			//location <- {10 + addDist, 10 + addDist};
			//addDist <- addDist + 10;
		}
		list<Stores> bar <- Stores where (each.type="Bar");
    	list<Stores> restaurant <- Stores where (each.type="Restaurant");
    	
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
	int status <- 0;    // var0 equals 0, 1 or 2; 0->nothing,1->thirsty,2->hungry
	int movingStatus <- 0; // 0-> do wander,1-> go to Ic,2-> go to bar/restaurant,3 -> go back
	point storeDestination <- nil; // To store the location of a store
	point returnBack <- rnd({0.0, 0.0, 0.0},{100.0,100.0,0.0});
	point original_location;
	
	aspect default {
		if(movingStatus=0 or movingStatus=3){
			draw circle(2) color:#green;
		}else if(movingStatus=1){
			draw circle(2) color:#red;
		}else if(movingStatus=2){
			if(status=1){
				draw circle(2) color:#blue;
			}else{
				draw circle(2) color:#yellow;
			}
			
		}
		
	}

	//point statusPoint <- nil;
	
//	reflex statusIdle when: statusPoint = nil 
//	{
//		do wander;
//	}
	
	reflex initalize when: status = 0 and movingStatus =0 {
		
		do wander;
		if (flip(0.05)){
			status <- rnd_choice([0.8,0.1,0.1]);
			original_location <- location;
			if status !=0{
				movingStatus <- 1;
			}
			
		}
		
		
			
	}
	
	reflex goToIc when: status != 0 and movingStatus =1
	{
		
		do goto target:agentLocation;
				
	}
	
	reflex atIc when: ((movingStatus=1) and (location = agentLocation)) {
		
		ask Ic {
			//myself.storeDestination <- self.store_location;
			if (myself.status=1){
				myself.storeDestination <- one_of(self.bar);
//			 write  "go to "+myself.storeDestination;
			 
			}else if(myself.status=2){
				myself.storeDestination <- one_of(self.restaurant);
//				 write  "go to "+myself.storeDestination;
				 
			}
 
		}
		movingStatus <- 2;	
		
	}
	
	reflex goToStore when: movingStatus = 2 and status !=0{
		do goto target:storeDestination;
		
	}
	
	reflex inStore when: location=storeDestination and movingStatus =2{
		movingStatus <-3;
		status <-0;
	}
	
	reflex returnback when: movingStatus =3{
		do goto target:original_location;
	}
	
	reflex inOriginal_location when: movingStatus =3 and location=original_location{
		 movingStatus <-0;
	}
	
	
	
	
//	reflex goOutOfStore when: status =0{
//		
//	}
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
	string type;
	

	aspect default {
		draw rectangle(4, 4) color: (type = "bar")? #blue : #yellow;
	}
}

species Ic {
	list bar;
	list restaurant;
	init{
		ask agents of_species Stores{
			if (self.type = "bar"){
				add location to: myself.bar;
			}
			if (self.type = "restaurant"){
				add location to: myself.restaurant;
			}
			
			
//			write location;
		}
		//write store_location;
	}
	aspect default {
		draw rectangle(4, 4) color:#red;
		
	}
	
//	action returnStoreLocation (int statusOfGuest) {
//		return 1;
//	}
//	
//	point Guests;
	
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
			//graphics "env" {
        	//	draw cube(environment_size) color: #black empty: true;
        	//}
        
		}
		display chart {
			chart "How often guests get thirsty" {
				data "thirsty guests" value: length (Guests where (each.status = 1));
			}
		}
	}
}