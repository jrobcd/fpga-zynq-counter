-- uart_rx.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_rx is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        rx : in STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR(7 downto 0);
        rx_done : out STD_LOGIC
    );
end uart_rx;

architecture Behavioral of uart_rx is
    signal rx_data : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_done_reg : STD_LOGIC := '0';
begin
    process(clk, reset)
        variable bit_count : integer := 0;
        variable rx_buffer : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if reset = '1' then
            rx_done_reg <= '0';
            bit_count := 0;
        elsif rising_edge(clk) then
            if rx = '0' then -- Start bit detected
                bit_count := 0;
                rx_done_reg <= '0';
            elsif bit_count < 8 then
                rx_buffer(bit_count) := rx;
                bit_count := bit_count + 1;
            elsif bit_count = 8 then
                rx_data <= rx_buffer;
                rx_done_reg <= '1';
                bit_count := 0;
            end if;
        end if;
    end process;

    data_out <= rx_data;
    rx_done <= rx_done_reg;
end Behavioral;