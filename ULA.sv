module ULA(
	input [5:0] valor_a,
	input [5:0] valor_b,
	input clock,
	input reset,
	input modo,
	input [3:0] operacao,
	output logic [5:0] valor_out,
	output logic overflow,
	output logic is_zero
);

logic extra;

always_ff @* begin //(posedge clock)
	if (reset) begin
		valor_out <= 6'd0;
		overflow <= 1'b0;
		is_zero <= 1'b0;
	end
	
	else begin
		if (modo == 1'b0) begin //operação aritmética			
			case (operacao)
				4'd0: begin //soma os 2 valores
					valor_out <= valor_a + valor_b;
					extra <= valor_a[6'd5] + valor_b[6'd5];
					overflow <= (extra == 1'b0) & (valor_out[6'd5] == 1'b1);
				end
				4'd1: begin //subtrai os 2 valores
					valor_out <= valor_a - valor_b;					
					extra <= valor_a[6'd5] + valor_b[6'd5];
					overflow <= (extra == 1'b1) & (valor_out[6'd5] == 1'b1);
				end
				4'd2: begin //soma valor A com o inverso do valor B
					valor_out <= valor_a + ~valor_b;
					extra <= valor_a[6'd5] + valor_b[6'd5];
					overflow <= (extra == 1'b1) & (valor_out[6'd5] == 1'b1);
				end
				4'd3: begin //subtrai valor A com o inverso do valor B
					valor_out <= valor_a - ~valor_b;
					extra <= valor_a[6'd5] + valor_b[6'd5];
					overflow <= (extra == 1'b0) & (valor_out[6'd5] == 1'b1);
				end
				4'd4: begin //incrementa valor A
					valor_out <= valor_a + 6'd1;
					extra <= valor_a[6'd5];
					overflow <= (extra == 1'b0) & (valor_out[6'd5] == 1'b1);
				end
				4'd5: begin //decrementa valor A
					valor_out <= valor_a - 6'd1;
					overflow <= 1'b0;
				end
				4'd6: begin //incrementa valor B
					valor_out <= valor_b + 6'd1;
					extra <= valor_b[6'd5];
					overflow <= (extra == 1'b0) & (valor_out[6'd5] == 1'b1);
				end
				4'd7: begin //decrementa valor B
					valor_out <= valor_b - 6'd1;
					overflow <= 1'b0;
				end
			endcase
		end
		
		else begin //operação lógica
			case (operacao)
				4'd0: begin //AND entre os 2 valores
					valor_out <= valor_a & valor_b;
				end
				4'd1: begin //inverso do valor A
					valor_out <= ~valor_a;
				end
				4'd2: begin //inverso do valor B
					valor_out <= ~valor_b;
				end
				4'd3: begin //OR entre os 2 valores
					valor_out <= valor_a | valor_b;
				end
				4'd4: begin //XOR entre os 2 valores
					valor_out <= valor_a ^ valor_b;
				end
				4'd5: begin //NAND entre os 2 valores
					valor_out <= ~(valor_a & valor_b);
				end
				4'd6: begin //retorna valor A
					valor_out <= valor_a;
				end
				4'd7: begin //retorna valor B
					valor_out <= valor_b;
				end
			endcase
			
			overflow <= 1'b0;
		end
		
		is_zero <= (valor_out == 6'd0);
	end
end


endmodule
