module bound_flasher(clk, rst_n, flick, led);

// I/O

	input wire 	clk;				// Clock
	
	input wire 	rst_n;				// Reset
	
	input wire 	flick;				// Special input
	
	output reg 	[15:0]led;			// Output

	
 
// Variables

	reg 		[1:0]led_operation;		// Status of Led operation
	
	reg		[3:0]current_state;		// Current state
	
	reg		[3:0]next_state;		// Next state
	
	integer 	i; 				// Variable use in decode block
	
	integer 	count; 				// Variable use to translate to output LED


	
// LED operation mode

	parameter 	UNCHANGED 	=  2'b00,
	
			UP		=  2'b01,
					
			DOWN 		=  2'b10,
					
			KICKBACK	=  2'b11;
					
	
 
	
// FSM States

	parameter 	INIT         	=  4'b00_01,
	
			ON_0_TO_5 	=  4'b00_10,
					
			OFF_TO_0  	=  4'b00_11,
					
			ON_0_TO_10  	=  4'b01_00,
					
			OFF_TO_5  	=  4'b01_01,
					
			ON_5_TO_15 	=  4'b01_10;


	
	
// Change FSM State and count

always @(negedge rst_n or posedge clk)

begin

	if(~rst_n) begin
 
 		current_state <= INIT;	            	// Reset state
      
    		count <= -1;                        	// Reset "count"
     
  	end				
    
	else begin
 
		current_state <= next_state;		// Assign next state for next time
   
 		if (led_operation == UP) begin
		
			count <= count + 1;		// Increase "count"
			
		end
	
		else if (led_operation == UNCHANGED) begin   
			
			count <= count;			// Keep "count" value
			
		end
		
		else begin				// "KICKBACK" and "DOWN" operation
		
			count <= count - 1;		// Decrease "count" 
		
		end	
   
  	end
	
end




// Logic count

// Determine led operation of the next state

always @(current_state or count or flick) begin

	led_operation = UNCHANGED;
	
	case(current_state)
	
	INIT: begin
	
		if(count >= 0) 			led_operation = DOWN;
		
		else if(flick) 			led_operation = UP;
		
		else 				led_operation = UNCHANGED;
			
	end
	
	
	ON_0_TO_5: begin
	
		if(count < 5) 			led_operation = UP;
		
		else 				led_operation = DOWN;
	
	end
	
	
	OFF_TO_0: begin
	
		if(count >= 0) 			led_operation = DOWN;
		
		else 				led_operation = UP;
	
	end
	
	
	ON_0_TO_10: begin
	
		if(flick) begin
		
			if (count == 5 || count == 10)  led_operation = KICKBACK;	

			else              		led_operation = UP;	
		
		end
		
		else begin
		
			if(count == 10)   	led_operation = DOWN;
				 
			else 	            	led_operation = UP;
		
		end
		
	end
	
	
	OFF_TO_5: begin
	
		if(count >= 5) 			led_operation = DOWN;
		
		else 				led_operation = UP;
	
	end
	
	
	ON_5_TO_15: begin
 
    	if(count == 15)     			led_operation = DOWN;
	
		else if(flick) begin
		
			if (count == 5 || count == 10)  led_operation = KICKBACK;	

			else              		led_operation = UP;	
		
		end
		
		else                		led_operation = UP;
		
	end
		
		
	default: 				led_operation = UNCHANGED;
	
		
	endcase
	
end



// FSM block

// Determine next state of the next time

always @(current_state or led_operation)

begin

	case(current_state)
	
	INIT: begin
	
		if(led_operation == UP) 	next_state = ON_0_TO_5;
   
    		else                          	next_state = INIT;
		
	end
	
	
	ON_0_TO_5: begin

		if(led_operation == DOWN) 	next_state = OFF_TO_0;
   
    		else                          	next_state = ON_0_TO_5;	
    
  	end
  	
	
	OFF_TO_0: begin
	
		if(led_operation == UP) 	next_state = ON_0_TO_10;
   
    		else                          	next_state = OFF_TO_0;
	
	end
	
	
	ON_0_TO_10: begin
	
		if(led_operation == KICKBACK) 	next_state = OFF_TO_0;
   
		else if(led_operation == DOWN)  next_state = OFF_TO_5; 
		
		else                            next_state = ON_0_TO_10;
		
	end
	
	
	OFF_TO_5: begin
		
		if(led_operation == UP) 	next_state = ON_5_TO_15;
   
    		else                          	next_state = OFF_TO_5;
	
	end
	
	
	ON_5_TO_15: begin
		
		if(led_operation == KICKBACK) 	next_state = OFF_TO_5;
   
    		else if(led_operation == DOWN)  next_state = INIT; 
		
		else                            next_state = ON_5_TO_15;
		
	end
 
	
	default: 				next_state = INIT;
	
	
	endcase

end



// Decoder LED
	
// Transfer "count" to led[15:0]

always @(negedge clk)

begin
   
	  if(count <= -1) led <= 16'b0;					// Turn off all Leds
		
	  else
	
		for(i = 0; i < 16; i = i + 1)				// Turn on leds from led[0] to led[count]
		
		begin
		
			if(i <= count) led[i] <= 1'b1;
			
			else led[i] <= 1'b0;
			
		end     

end


	
endmodule












