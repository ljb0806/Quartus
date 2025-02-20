module FFT_demo
(
	input clk,                         // 时钟
	input rst_n,                       // 低电平复位
	input signed [11:0] data_in,       // 输入数据，12位有符号数
	input [31:0] frequency,            // 生成一个正弦波
	
	output signed [24:0] amp           // 输出数据，25位有符号数(FFT计算的幅度结果)
);

//***** 生成正弦波的信号 *****//
wire clk_200M;
wire [31:0] phase;
wire signed [11:0] sin;


/***** FFT_IP核的连接信号 *****/
wire inverse;                     //// 输入，0进行正变换，1进行逆变换
wire sink_ready;                  // 输出，FFT准备好接收数据时置位
wire source_ready;                //// 输入，下传流模块可接收时置位
reg sink_valid;                   // 输入，有效标志信号，与sink_ready都置为后开始数据传输
reg sink_sop;                     // 输入，高电平表示一帧数据载入开始
reg sink_eop;                     // 输入，高电平表示一帧数据载入结束
wire signed [11:0] sink_imag;     //// 输入，虚部数据
wire [1:0] sink_error;            //// 输入，错误标志,一般不用为0
wire [1:0] source_error;          // 输出，错误标志
wire source_sop;                  // 输出，高电平表示一帧数据转换开始
wire source_eop;                  // 输出，高电平表示一帧数据转换结束
wire [5:0] source_exp;            //// 输出，指数
wire source_valid;                // 输出，有效标志信号，与source_valid都置为后开始数据传输
wire signed [11:0] xkre;          // 输出，实部数据,二进制补码数据
wire signed [11:0] xkim;          // 输出，虚部数据

assign sink_error = 2'b00;        // 默认不错
assign source_ready = 1'b1;       // 默认一直准备接收
assign inverse = 1'b0;            // 默认进行正变换
assign sink_imag = 12'b0;         // 虚部接地，一般不考虑相量数据

/***** FFT数据的载入 *****/

// 在sink_valid为高电平期间，通过sink_sop,sink_eop控制载入数据
// 设置FFT变换起始脉冲，两者均高电平后开始载入数据
// Burst模式下，FFT变换延时不超过2048个时钟周期，因此每2048个周期进行一次FFT变换
reg [11:0] cnt; // 不超过2048的计数值

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sink_eop <= 1'b0;
        sink_sop <= 1'b0;
        sink_valid <= 1'b0;
        cnt <= 12'b0;
    end

    else begin
        cnt <= cnt + 12'b1;

        if(cnt == 11'b1) begin
            sink_sop <= 1'b1;
        end
        else begin
            sink_sop <= 1'b0;
        end

        if(cnt == 1024) begin
            sink_eop <= 1'b1;
        end
        else begin
            sink_eop <= 1'b0;
        end

        if(cnt >= 1 && cnt <= 1024) begin
            sink_valid <= 1'b1;
        end
        else begin
            sink_valid <= 1'b0;
        end
        
    end
end



/***** FFT_IP核的调用 *****/
fft u0 (
    .clk          (clk),         
    .reset_n      (rst_n),        
    .sink_valid   (sink_valid),   
    .sink_ready   (sink_ready),   
    .sink_error   (sink_error),   
    .sink_sop     (sink_sop),    
    .sink_eop     (sink_eop),     
    .sink_real    (sin),    
    .sink_imag    (sink_imag),    
    .inverse      (inverse),      
    .source_valid (source_valid), 
    .source_ready (source_ready),
    .source_error (source_error), 
    .source_sop   (source_sop),   
    .source_eop   (source_eop),   
    .source_real  (xkre),  
    .source_imag  (xkim),  
    .source_exp   (source_exp)    
);

/***** 数据处理 *****/
wire signed [23:0] xkre_square;
wire signed [23:0] xkim_square;
assign xkre_square = xkre * xkre;
assign xkim_square = xkim * xkim;
assign amp = xkre_square + xkim_square;

//***** 生成正弦波部分 *****//


PLL_200M	PLL_200M_inst (
	.inclk0 ( clk ),
	.c0 ( clk_200M )
);

SINROM	SINROM_inst (
	.address ( phase[31:20] ),
	.clock ( clk_200M ),
	.q ( sin )
);

get_phase get_phase_inst
(
	.frequency(frequency) ,	// input [31:0] frequency_sig
	.clk_200M(clk_200M) ,	// input  clk_200M_sig
	.rst_n(rst_n) ,	// input  rst_n_sig
	.phase(phase) 	// output [31:0] phase_sig
);

endmodule