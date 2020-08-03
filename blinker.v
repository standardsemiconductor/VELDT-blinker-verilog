module top(
	   input clk, // 12mhz
	   output red, green, blue
	   );

   reg [31:0] 	  ctr;
   reg [1:0] 	  phase;
   reg [7:0] 	  pwm_ctr;
   reg 		  pwm_r, pwm_g, pwm_b;

   always @(posedge clk)
     begin
	if (ctr == 12000000) // 12,000,000 cycles == 1 second
		begin
		   ctr <= 0;
		   phase <= phase + 1;
		end
	else 
	  ctr <= ctr + 1;
     end

   wire [7:0] r_val, g_val, b_val;
   
   assign r_val = (phase == 0) ? 255 : 0;
   assign g_val = (phase == 1) ? 255 : 0;
   assign b_val = (phase == 2) ? 255 : 0;
   
   always @(posedge clk)
     begin
	pwm_ctr <= pwm_ctr + 1;
	pwm_r <= (pwm_ctr < r_val) ? 1'b1 : 1'b0;
	pwm_g <= (pwm_ctr < g_val) ? 1'b1 : 1'b0;
	pwm_b <= (pwm_ctr < b_val) ? 1'b1 : 1'b0;
     end

   SB_RGBA_DRV RGBA_DRIVER (
			    .CURREN(1'b1),
			    .RGBLEDEN(1'b1),
			    .RGB0PWM(pwm_r),
			    .RGB1PWM(pwm_g),
			    .RGB2PWM(pwm_b),
			    .RGB0(red),
			    .RGB1(green),
			    .RGB2(blue)
			    );
   defparam RGBA_DRIVER.CURRENT_MODE = "0b1";
   defparam RGBA_DRIVER.RGB0_CURRENT = "0b111111";
   defparam RGBA_DRIVER.RGB1_CURRENT = "0b111111";
   defparam RGBA_DRIVER.RGB2_CURRENT = "0b111111";

endmodule // top


