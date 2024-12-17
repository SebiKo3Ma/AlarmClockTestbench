module aclock (aclk_if inter);

    // Internal signals
    reg clk_1s;                // 1s clock signal
    reg [3:0] tmp_1s;          // Counter for generating 1s clock
    reg [5:0] tmp_hour, tmp_minute, tmp_second;  // Hour, minute, second counters
    reg [1:0] c_hour1, a_hour1;  // MSB hour for clock and alarm
    reg [3:0] c_hour0, a_hour0;  // LSB hour for clock and alarm
    reg [3:0] c_min1, a_min1;    // MSB minute for clock and alarm
    reg [3:0] c_min0, a_min0;    // LSB minute for clock and alarm
    reg [3:0] c_sec1, a_sec1;    // MSB second for clock and alarm
    reg [3:0] c_sec0, a_sec0;    // LSB second for clock and alarm

    /************************************************/
    /***************** Mod10 function ***************/
    /************************************************/
    function [3:0] mod_10;
        input [5:0] number;
        begin
            mod_10 = (number >= 50) ? 5 : 
                     (number >= 40) ? 4 :
                     (number >= 30) ? 3 : 
                     (number >= 20) ? 2 : 
                     (number >= 10) ? 1 : 0;
        end
    endfunction

    /************************************************/
    /************** Clock operation ****************/
    /************************************************/
    always @(posedge clk_1s or posedge inter.reset) begin
        if (inter.reset) begin
            // Reset all values
            a_hour1 <= 2'b00;
            a_hour0 <= 4'b0000;
            a_min1  <= 4'b0000;
            a_min0  <= 4'b0000;
            a_sec1  <= 4'b0000;
            a_sec0  <= 4'b0000;
            tmp_hour <= inter.H_in1 * 10 + inter.H_in0;
            tmp_minute <= inter.M_in1 * 10 + inter.M_in0;
            tmp_second <= 0;
        end else begin
            if (inter.LD_alarm) begin
                // Set alarm time when LD_alarm is 1
                a_hour1 <= inter.H_in1;
                a_hour0 <= inter.H_in0;
                a_min1  <= inter.M_in1;
                a_min0  <= inter.M_in0;
                a_sec1  <= 4'b0000;
                a_sec0  <= 4'b0000;
            end 
            if (inter.LD_time) begin
                // Set time when LD_time is 1
                tmp_hour <= inter.H_in1 * 10 + inter.H_in0;
                tmp_minute <= inter.M_in1 * 10 + inter.M_in0;
                tmp_second <= 0;
            end else begin
                // Normal clock operation
                tmp_second <= tmp_second + 1;
                if (tmp_second >= 59) begin
                    tmp_minute <= tmp_minute + 1;
                    tmp_second <= 0;
                    if (tmp_minute >= 59) begin
                        tmp_minute <= 0;
                        tmp_hour <= tmp_hour + 1;
                        if (tmp_hour >= 24) begin
                            tmp_hour <= 0;
                        end
                    end
                end
            end
        end
    end

    /************************************************/
    /************ Generate 1-second clock ***********/
    /************************************************/
    always @(posedge inter.clk or posedge inter.reset) begin
        if (inter.reset) begin
            tmp_1s <= 0;
            clk_1s <= 0;
        end else begin
            tmp_1s <= tmp_1s + 1;
            if (tmp_1s <= 5)
                clk_1s <= 0;
            else if (tmp_1s >= 10) begin
                clk_1s <= 1;
                tmp_1s <= 1;
            end else
                clk_1s <= 1;
        end
    end

    /************************************************/
    /************ Clock Output Assignment ***********/
    /************************************************/
    always @(*) begin
        if (tmp_hour >= 20) begin
            c_hour1 = 2;
        end else if (tmp_hour >= 10) begin
            c_hour1 = 1;
        end else begin
            c_hour1 = 0;
        end
        c_hour0 = tmp_hour - c_hour1 * 10; 
        c_min1 = mod_10(tmp_minute); 
        c_min0 = tmp_minute - c_min1 * 10;
        c_sec1 = mod_10(tmp_second);
        c_sec0 = tmp_second - c_sec1 * 10; 
    end

    assign inter.H_out1 = c_hour1;  // Most significant digit of the hour
    assign inter.H_out0 = c_hour0;  // Least significant digit of the hour
    assign inter.M_out1 = c_min1;   // Most significant digit of the minute
    assign inter.M_out0 = c_min0;   // Least significant digit of the minute
    assign inter.S_out1 = c_sec1;   // Most significant digit of the second
    assign inter.S_out0 = c_sec0;   // Least significant digit of the second

    /************************************************/
    /**************** Alarm Function ****************/
    /************************************************/
    always @(posedge clk_1s or posedge inter.reset) begin
        if (inter.reset) 
            inter.Alarm <= 0; 
        else begin
            if ({a_hour1, a_hour0, a_min1, a_min0, a_sec1, a_sec0} == {c_hour1, c_hour0, c_min1, c_min0, c_sec1, c_sec0}) begin
              if (inter.AL_ON) 
                    inter.Alarm <= 1;  // Alarm goes high if time matches and AL_ON is high
            end
            if (inter.STOP_al) 
                inter.Alarm <= 0;  // Alarm goes low when STOP_al is high
        end
    end

endmodule
