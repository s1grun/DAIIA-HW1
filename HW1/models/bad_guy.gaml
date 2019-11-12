/***
* Name: Badguy
* Author: sigrunarnasigurdardottir
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Badguy

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
		
		create Security_Guard number: 1
		{
			
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
	int status <- 0;    // var0 equals 0, 1 or 2; 0->nothing,1->thirsty,2->hungry,3 ->bad
	int movingStatus <- 0; // 0-> do wander,1-> go to Ic,2-> go to bar/restaurant,3 -> go back
	point storeDestination <- nil; // To store the location of a store
	point returnBack <- rnd({0.0, 0.0, 0.0},{100.0,100.0,0.0});
	point original_location;
	Guests badguy;
	
	aspect default {
		if(movingStatus=0 or movingStatus=3 or movingStatus=4){
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
		if (status=0 and movingStatus=2){
			draw circle(2) color:#gray;
		}
		if status=3{
			draw circle(2) color:#black;
		}
		
	}
	
	init{
		original_location <-location;
	}
	
	

	//point statusPoint <- nil;
	
//	reflex die when: status = 4 
//	{
//		do die;
//	}
	
	reflex initalize when: status = 0 and movingStatus =0 {
		
		do wander;
		if (flip(0.05)){
			status <- rnd_choice([0.79,0.1,0.1,0.01]);
			original_location <- location;
			if status !=0 and status !=3{
				movingStatus <- 1;
			}
			
		}
		
			
	}
	
	reflex badguywander when:status =3{
		do wander;
	}
	
	reflex meetBadguy when: status = 0 and (movingStatus =0 or movingStatus =3){
		ask Guests at_distance(5){
			if self.status=3 and myself.badguy != self{
				myself.badguy <- self;
				myself.movingStatus <-1;
			}
		}
	}
	
	
	reflex goToIc when: movingStatus =1
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
				 
			}else if (myself.status=0){
				myself.storeDestination <- self.guard;
				
			}
 
		}
		
		movingStatus <- 2;	
		
	}
	
	
	
	reflex goToStoreOrGuard when: movingStatus = 2{
		do goto target:storeDestination;
		
	}
	
	reflex inStore when: location=storeDestination and movingStatus =2 and status!=0{
		movingStatus <-3;
		status <-0;
	}
	
	reflex withGuard when: storeDestination !=nil and (location distance_to storeDestination <5) and movingStatus =2 and status=0{
		ask Security_Guard{
			if myself.badguy = self.target{
				myself.movingStatus <-3;
			}else{
				self.target <- myself.badguy;
				self.status <-1;
				
			}
			
			
		}
		movingStatus <-4;
		status <-0;
		
	}
	reflex goToBadguy when: movingStatus =4{
		do goto target:badguy;
	}
	
	reflex withBadguy when: movingStatus =4 and location distance_to badguy <5{
		movingStatus <-3;
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


species Security_Guard skills:[moving]{
	point my_location;
	Guests target <- nil;
	int status <-0; //0-> wander, 1-> follow guest,2 ->do job, 3-> go back;
	aspect default {
		draw circle(3) color: #gray border: #blue;
	}
	init{
		my_location<- location;
	}
	
//	reflex dowander when: status=0{
//		do wander;
//	}
	reflex follow_guest when: status=1{
		do goto target:target;
//		status <- 2;
//		write target;
	}
	reflex withbadGuy when:target !=nil and location distance_to target <5{
		status<-2;
		
	}
	reflex doJob when: status=2{
		ask one_of (target){
				write "guard meet bad guy";
				do die;
				//self.status<-3;
				
		}
		status <- 3;
	}
	
	reflex goback when: status=3{
		do goto target:my_location;
	}
	
	
	
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
	Security_Guard guard;
//	int guest_ask_guard<-0;
	init{
		ask agents of_species Stores{
			if (self.type = "bar"){
				add location to: myself.bar;
			}
			if (self.type = "restaurant"){
				add location to: myself.restaurant;
			}
			

		}
		
		ask Security_Guard{
			myself.guard <- self;
		}
		
		//write store_location;
	}
//	reflex getGuardLocation when:guest_ask_guard=1{
//		ask Security_Guard{
//			myself.guard <- self.location;
//		}
//		guest_ask_guard<-0;
//	}
	aspect default {
		draw rectangle(4, 4) color:#red;
		
	}
	
	action returnStoreLocation (int statusOfGuest) {
		return 1;
	}
	
	point Guests;
	

}

experiment Badguy type:gui{
	output{
		display map type: opengl {
			species Guests;
			species Stores;
			species Ic;
			species Security_Guard;
		}
	}
}