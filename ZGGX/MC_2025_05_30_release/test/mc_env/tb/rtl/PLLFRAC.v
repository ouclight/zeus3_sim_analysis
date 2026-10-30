`timescale 1 ps / 1 fs		
`define TSTEP 1.0e-12		// Make sure TSTEP always equals timescale reference unit

`define JITTER_EN 1		// Set to 1 to include random jitter, 0 for no jitter

module PLLFRAC (BYPASS, DACPD, DSMPD, FBDIV, FOUTPOSTDIVPD, FOUTVCOPD, FOUT4PHASEPD, 
	FRAC, FREF, PD, POSTDIV1, POSTDIV2, REFDIV, CLKSSCG, FOUT1PH0, 
	FOUT1PH90, FOUT1PH180, FOUT1PH270, FOUT2, FOUT3, FOUT4, FOUTPOSTDIV, FOUTVCO, LOCK);

// Power Supplies
supply1 VDDHV;			// 1.5V/1.8V/2.5V/3.3V Power Supply (set to 1'b1)
supply1 VDDREF;			// 1.1V Power Supply (set to 1'b1)
supply1 VDDPOST;		// 1.1V Power Supply (set to 1'b1)
supply0 VSS;			// 0V Ground 	     (set to 1'b0)

// Input Signals
input FREF;			// Reference Clock (1MHz - 800MHz)
input [5:0] REFDIV;		// Reference Clock Divide Value (1-63)

input [11:0] FBDIV;		// Feedback Divide Value (16-2400 for integer, 20-240 for fractional)
input [23:0] FRAC;		// Fractional part of feedback divide (fraction = FRAC/2^24)

input [2:0] POSTDIV1;		// First Post Divide Value (1-7) 
input [2:0] POSTDIV2;		// Second Post Divide Value (1-7) (Output Frequency is [FVCO / POSTDIV1 / POSTDIV2])

input PD;			// Global power down
input DACPD;			// Power down quantization noise cancellation DAC
input DSMPD;			// Power down delta sigma modulator
input FOUTPOSTDIVPD; 		// Power down all outputs except for buffered VCO clock
input FOUT4PHASEPD; 		// Power down 4-phase clocks and 2X, 3X, 4X clocks
input FOUTVCOPD;		// Power down buffered VCO clock
input BYPASS;			// PLL Bypass.  FREF bypasses PLL to FOUTPOSTDIV. 
			

// Output Signals
output FOUTVCO;			// Buffered VCO Output Clock (600MHz-2400MHz)
output FOUTPOSTDIV;		// Post Divide Clock (12MHz-2400MHz)

output FOUT1PH0;		// Full Rate Output Clock (0 phase)  **Note: Frequency equals FOUTPOSTDIV/2
output FOUT1PH90;		// Full Rate Output Clock (90 phase)
output FOUT1PH180;		// Full Rate Output Clock (180 phase)
output FOUT1PH270;		// Full Rate Output Clock (270 phase)

output FOUT2;			// 1/2 Rate Output Clock (FOUT2=FOUT1PH0/2)
output FOUT3;			// 1/3 Rate Output Clock (FOUT3=FOUT1PH0/3)
output FOUT4;			// 1/4 Rate Output Clock (FOUT4=FOUT1PH0/4)

output LOCK;			// PLL Lock Indicator (LOCK indicates no cycle slips in 256
				//  consecutive FREF/REFDIV cycles)

output CLKSSCG;			// Spread Spectrum Clock Output (frequency = FREF/REFDIV when locked)

// Initialize Output Voltages

wire enable;			// enable == 1 when PD=0, VDDHV=1, VDDREF=1, VDDPOST=1, and VSS=0
assign enable = (~PD && VDDHV && VDDREF && VDDPOST && ~VSS);

reg	FOUTVCOint; 	
assign	FOUTVCO = (enable && ~FOUTVCOPD) ? FOUTVCOint : 1'b0;
reg FOUTPOSTDIVi; 	
reg FOUTPOSTDIVext; 	

reg FOUT1PH0i; 	
reg FOUT1PH0; 	
reg FOUT1PH90i; 	
reg FOUT1PH90; 	
reg FOUT1PH180; 	
reg FOUT1PH270; 	

reg FOUT2i; 	
reg FOUT2; 	
reg FOUT3i; 	
reg FOUT3; 	
reg FOUT4i; 	
reg FOUT4; 	

reg	LOCK;
	

initial begin
	FOUTVCOint 	= 1'b0;
	FOUTPOSTDIVi 	= 1'b0;
	
	FOUT1PH0i 	= 1'b0;
	FOUT1PH90i 	= 1'b0;

	FOUT2i 		= 1'b0;
	FOUT3i 		= 1'b0;
	FOUT4i 		= 1'b0;

	LOCK	 	= 1'b0;

        FOUTPOSTDIVext  = 1'b0;
        FOUT1PH0        = 1'b0;
        FOUT1PH90       = 1'b0;
        FOUT1PH180      = 1'b1;
        FOUT1PH270      = 1'b1;
        FOUT2           = 1'b0;
        FOUT3           = 1'b0;
        FOUT4           = 1'b0;
end

always @(FOUTPOSTDIVi)
	if (enable && ~FOUTPOSTDIVPD) FOUTPOSTDIVext = FOUTPOSTDIVi;
always @(FOUT1PH0i) begin
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT1PH0 = FOUT1PH0i;
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT1PH180 = ~FOUT1PH0i;
end
always @(FOUT1PH90i) begin
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT1PH90 = FOUT1PH90i;
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT1PH270 = ~FOUT1PH90i;
end
always @(FOUT2i)
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT2 = FOUT2i;
always @(FOUT3i)
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT3 = FOUT3i;
always @(FOUT4i)
	if (enable && ~FOUTPOSTDIVPD && ~FOUT4PHASEPD) FOUT4 = FOUT4i;
always @(PD or FOUTPOSTDIVPD or FOUT4PHASEPD) begin
        if (PD || FOUTPOSTDIVPD) begin
                FOUTPOSTDIVext  = 1'b0;
        end
        if (PD || FOUTPOSTDIVPD || FOUT4PHASEPD) begin
                FOUT1PH0        = 1'b0;
                FOUT1PH90       = 1'b0;
                FOUT1PH180      = 1'b1;
                FOUT1PH270      = 1'b1;
                FOUT2           = 1'b0;
                FOUT3           = 1'b0;
                FOUT4           = 1'b0;
        end
end

// Define values for frequency calculations
real toutvco		= 10000.0;	// 100MHz
real toutvco_int	= 10000.0;
real toutvco_jit	= 10000.0;

// generate PFD input voltages (ref_in, div_in)

integer refdivcount = 1;
reg ref_in_int;
wire ref_in;
always @(posedge FREF) begin
	ref_in_int = 0;
	if (refdivcount > 1) refdivcount = refdivcount - 1;
	else begin
		refdivcount = REFDIV;
		ref_in_int = 1;
	end
end
assign ref_in = enable ? ((REFDIV == 6'b1) ? FREF : ref_in_int) : 1'b0;

// Behavioral DSM
wire [35:0]  error1;
wire [35:0]  error2;
wire [35:0]  integrateout1;
reg  [35:0]  integrateout2;
reg  [35:0]  integratefb1;
wire [35:0]  integratefb2;
wire [35:24] fb;
wire [35:24] fbinv;
reg  [3:0]   dither;
wire [15:0]  quant_in;
wire [11:0]  intout;

initial dither = $random;

assign #(1) error1 =  {FBDIV[11:0],FRAC[23:0]} + {fb[35:24],24'b0};
assign #(1) integrateout1 = integratefb1 + error1;
assign #(1) error2 = integrateout1 + {fb[35:24],24'b0};
assign #(1) integratefb2 = integrateout2 + error2;
assign #(1) quant_in = {12'b0,dither} + integrateout2[35:20];
assign #(1) intout = quant_in[15:4];
assign #(1) fbinv = intout + 12'b111111111111;
assign #(1) fb = ~fbinv;
initial begin
	integratefb1 = 36'b0;
	integrateout2 = {12'd16,24'b0};
end

reg div_in;
real pllratio = 16.0;
always @(posedge div_in) begin
	if (~DSMPD) begin
		integratefb1 = integrateout1;	
		integrateout2 = integratefb2;
		if (integratefb1 === 36'bx) integratefb1 = 36'b0;
		if (integrateout2 === 36'bx) integrateout2 = {12'd16,24'b0};
		dither = $random;
	end
	pllratio = DSMPD ? $itor(FBDIV) : $itor({FBDIV[11:8],intout[7:0]});
	if (pllratio < 16.0) pllratio = 16.0;
end

// Feedback Divider

integer fbdivcount = 1;

always @(posedge FOUTVCOint) begin
	div_in = 0;
	if (fbdivcount > 1) fbdivcount = fbdivcount - 1;
	else begin
		if (enable) begin
			div_in = 1;
			fbdivcount = DSMPD ? FBDIV : {FBDIV[11:8],intout[7:0]};
		end
	end
end

// Behavioral Phase/Frequency Detector
real refperiod   = 100000.0;
real phaseerror;
real ivcomax     = 3.0e-3;
real fvcomax     = 4e9;
real icp         = 4.0e-6;
real cint        = 80e-12;
real kvi         = 4.5e9;
real dacratio;
time tref0, tref1;
time tpfd0, tpfd1;
reg pfd_up, pfd_down;
integer refcount;
initial begin
	pfd_up = 0;
	pfd_down = 0;
	refcount = 0;
end
initial dacratio = DSMPD ? (FBDIV[11:8] == 4'b0) ? 0.21 : 0.46 : 0.125;
always @(DSMPD) dacratio = DSMPD ? (FBDIV[11:8] == 4'b0) ? 0.21 : 0.46 : 0.125;
always @(FBDIV) dacratio = DSMPD ? (FBDIV[11:8] == 4'b0) ? 0.21 : 0.46 : 0.125;
always @(enable) begin
	if (~enable) begin
		pfd_up = 0;
        	pfd_down = 0;
		refcount=0;
		LOCK = 0;
		toutvco = 10000;
	end
end

always @(posedge ref_in) begin
	tref1 = $time;
        if (tref0 > 0) refperiod = (tref1 - tref0);
	tref0 = tref1;

	if (enable) begin
		if (pfd_up) begin		// two consecutive ref_in edges with no div_in edge
			tpfd1 = $time;
			refcount = 0;		// cycle slip, reset LOCK detector
			if (tpfd0 > 0) phaseerror = tpfd1 - tpfd0;
			tpfd0 = tpfd1;

			// Calculate period due to integral path  [1 / (old freq + freq step)]
			toutvco_int = (1 / ((1 / (toutvco_int * `TSTEP)) + ((phaseerror * `TSTEP * icp * kvi) / cint))) / `TSTEP;

			// Calculate phase shift due to proportional path and distribute it over subsequent period
			toutvco = toutvco_int - (dacratio * phaseerror / pllratio);
		end
		else begin
			if (pfd_down) begin	// ref_in edge AFTER div_in edge
				tpfd1 = $time;
				phaseerror = tpfd1 - tpfd0;
				pfd_up = 0;	// reset PFD	
				pfd_down = 0;	

				// Calculate period due to integral path  [1 / (old freq - freq step)]
				toutvco_int = (1 / ((1 / (toutvco_int * `TSTEP)) - ((phaseerror * `TSTEP * icp * kvi) / cint))) / `TSTEP;

				// Calculate phase shift due to proportional path and distribute it over subsequent period
				toutvco = toutvco_int + (dacratio * phaseerror / pllratio);
		
				if (refcount < 256) begin	// Lock Detector
					LOCK = 0;
					refcount = refcount + 1;
				end
				else    LOCK = 1; 
			end
			else begin		// ref_in edge BEFORE div_in edge
				pfd_up = 1;
				tpfd0 = $time;
			end
		end
			if (toutvco < 300) begin
				toutvco = 300;
			end
	end
end
always @(posedge div_in) begin
	if (enable) begin
		if (pfd_down) begin		// two consecutive div_in edges with no ref_in edge
			tpfd1 = $time;		
			refcount = 0;		// cycle slip, reset LOCK detector
			if (tpfd0 > 0) phaseerror = tpfd1 - tpfd0;
			tpfd0 = tpfd1;

			// Calculate period due to integral path  [1 / (old freq - freq step)]
			toutvco_int = (1 / ((1 / (toutvco_int * `TSTEP)) - ((phaseerror * `TSTEP * icp * kvi) / cint))) / `TSTEP;

			// Calculate phase shift due to proportional path and distribute it over subsequent period
			toutvco = toutvco_int + (dacratio * phaseerror / pllratio);
		end
		else begin
			if (pfd_up) begin // div_in edge AFTER ref_in edge
				tpfd1 = $time;
				phaseerror = tpfd1 - tpfd0;
				pfd_up = 0;	// reset PFD	
				pfd_down = 0;	

				// Calculate period due to integral path  [1 / (old freq + freq step)]
				toutvco_int = (1 / ((1 / (toutvco_int * `TSTEP)) + ((phaseerror * `TSTEP * icp * kvi) / cint))) / `TSTEP;

				// Calculate phase shift due to proportional path and distribute it over subsequent period
				toutvco = toutvco_int - (dacratio * phaseerror / pllratio);

				if (refcount < 256) begin	// Lock Detector
					LOCK = 0;
					refcount = refcount + 1;
				end
				else    LOCK = 1; 
			end
			else begin
				pfd_down = 1;		// div_in edge BEFORE ref_in edge
				tpfd0 = $time;
			end
		end
			if (toutvco < 300) begin
				toutvco = 300;
			end
	end
end

real icp_int;
always @(toutvco_int) begin
        icp_int = ivcomax / ((fvcomax * toutvco * `TSTEP)**1.5) / 256.0;
        icp = LOCK ? icp_int : (icp_int < 4.0e-6) ? 4.0e-6 : icp_int;
end


parameter two_to_31 = 2147483648.0;
real jitter = 0.3; // jitter [ps/cycle]
real tjit, rand1;
always @(posedge FOUTVCOint) begin
        // each of $random/2^31 in range [-1 .. 1] with std of 2/(12^0.5)
        // for nine, to correct std back to 1, divide by 2 * ((9 / 12) ^ 0.5)
        rand1 = ( $random / two_to_31 + $random / two_to_31 + $random / two_to_31
                + $random / two_to_31 + $random / two_to_31 + $random / two_to_31
                + $random / two_to_31 + $random / two_to_31 + $random / two_to_31
                ) / 1.73205;

        tjit = jitter*rand1*`JITTER_EN;
        toutvco_jit = toutvco + tjit;
end


// Set Parameter Limits

always @(toutvco_int) begin
	// Cap VCO frequency
	if (toutvco_int < 300) begin
		toutvco_int = 300;	
	end

	if (toutvco_int > 10000) begin
		toutvco_int = 10000;	
	end
end


// Define Output Clocks 

wire FREFi;
assign #(1000) FREFi = FREF;
assign FOUTPOSTDIV = (BYPASS ? FREFi : FOUTPOSTDIVext);

always 
	#(toutvco_jit / 2.0)	FOUTVCOint = ~FOUTVCOint;
integer postdivcount = 1;
always @(FOUTVCOint) begin
	
	if (postdivcount > 1) postdivcount = postdivcount - 1;
	else begin
		FOUTPOSTDIVi = ~FOUTPOSTDIVi;
		postdivcount = POSTDIV1 * POSTDIV2;
	end
end	

integer postdiv1count = 1;
reg FOUTPOSTDIV1;
initial FOUTPOSTDIV1 = 0;
always @(FOUTVCOint) begin
	
	if (postdiv1count > 1) postdiv1count = postdiv1count - 1;
	else begin
		FOUTPOSTDIV1 = ~FOUTPOSTDIV1;
		postdiv1count = POSTDIV1;
	end
end	

always @(posedge FOUTPOSTDIV) begin
	FOUT1PH0i = ~FOUT1PH0i;
end	
always @(negedge FOUTPOSTDIV) begin
	FOUT1PH90i = FOUT1PH0i;
end	

integer fout3count = 1;

always @(posedge FOUT1PH0i) begin
	#(350)	FOUT2i = ~FOUT2i;
end	
always @(FOUT1PH0i) begin
		if (fout3count == 3) begin
	#(400)			FOUT3i = FOUT1PH0i;
				fout3count = 1;
		end
		else			
				fout3count = fout3count + 1;
end	
always @(posedge FOUT2i) begin
	FOUT4i = ~FOUT4i;
end	

// Define Spread Spectrum Clock
reg 	clksscg_int;
integer clksscg_count =	0;

initial begin
	clksscg_int = 0;
end

always @(posedge div_in) begin
	clksscg_int = 1;
	clksscg_count = 3;
end

always @(posedge FOUTVCOint) begin
	if (clksscg_count > 0) clksscg_count = clksscg_count - 1;
	else clksscg_int = 0;
end
assign CLKSSCG = DSMPD ? 1'b0 : clksscg_int;

endmodule
