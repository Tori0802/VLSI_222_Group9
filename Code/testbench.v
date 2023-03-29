`timescale 1ns/1ns

module testbench();

  // I/O
  
	reg flick;
	
	reg clk;
	
	reg rst_n;
	
	wire [15:0]led;
	
	// Module
 
	bound_flasher uut(clk, rst_n, flick, led);
	
	
	// Always
 
	always begin
	
		clk = 1;
		
		#1 clk = 0;
		
		#1;
		
	end
	
	
	// Begin simulation
 
	initial begin
 
 
    // Setup
	
		#1; rst_n = 0;
     
		#1; rst_n = 1; 
   
    		#1; flick = 1;
        		
		$monitor("At %0t: clk = %b, flick = %b, led = %b", $time, clk, flick, led);
   
   
   
    // Testcase 1
 
		$display("Testcase 1: Normal_flow");
		
		#2; flick = 0;
		
		#150;
		
   
   
    // Testcase 2
    
		$display("Testcase 2: Flick_kickback_led5_state4_ON_0_TO_10");
		
		flick = 1;
		
		#2; flick = 0;
		
		#34; flick = 1;
		
		#2; flick = 0;
		
		#150;
   
   
		
    // Testcase 3
    
		$display("Testcase 3: Flick_kickback_led10_state4_ON_0_TO_10");
		
		flick = 1;
		
		#2; flick = 0;
		
		#44; flick = 1;
		
		#2; flick = 0;
		
		#180;
   
   
   
    // Testcase 4	
    	
		$display("Testcase 4: Flick_kickback_led5_state6_ON_5_TO_15");
		
		flick = 1;
		
		#2; flick = 0;
		
		#58; flick = 1;
		
		#2; flick = 0;
		
		#120;
   
   
   
		// Testcase 5
   
		$display("Testcase 5: Flick_kickback_led10_state6_ON_5_TO_15");
	
		flick = 1;
		
		#2; flick = 0;
		
		#68; flick = 1;
		
		#2; flick = 0;
		
		#120;
		
   
   
		// Testcase 6
   
		$display("Testcase 6: Twice_flick");
	
		flick = 1;
		
		#2; flick = 0;
		
		#34; flick = 1;
		
		#2; flick = 0;
		
		#56; flick = 1;
		
		#2; flick = 0;
		
		#120;
    
      
   
    // Testcase 7
    
		$display("Testcase 7: Flick at non kickback points");
		
		flick = 1;
		
		#2; flick = 0;
		
		#46; flick = 1;
		
		#2; flick = 0;
		
		#120;
		
   
    // Testcase 8
       
		$display("Testcase 8: Check_reset");
		
		flick = 1;
		
		#2; flick = 0;
		
		#44; flick = 1;
		
		#2; flick = 0;
		
		#15; rst_n = 0;
		
		#2; rst_n = 1;
		
		#5; flick = 1;
		
		#2; flick = 0;
		
		#120;
   
		$finish;
		
	end

	
	
 
	initial begin
	
  		$recordfile ("waves");
		
  		$recordvars ("depth=0", testbench);
		
	end

	
	
endmodule
