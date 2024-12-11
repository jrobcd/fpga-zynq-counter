-- uart_controller.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_controller is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        rx : in STD_LOGIC;
        control_out : out STD_LOGIC
    );
end uart_controller;

architecture Behavioral of uart_controller is
    signal rx_data : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_done : STD_LOGIC;
begin
    uart_rx_inst : entity work.uart_rx
        port map (
            clk => clk,
            reset => reset,
            rx => rx,
            data_out => rx_data,
            rx_done => rx_done
        );

    process(clk, reset)
    begin
        if reset = '1' then
            control_out <= '0';
        elsif rising_edge(clk) then
            if rx_done = '1' then
                if rx_data = "00000000" then -- Comando para contar ascendente
                    control_out <= '0';
                elsif rx_data = "00000001" then -- Comando para contar descendente
                    control_out <= '1';
                end if;
            end if;
        end if;
    end process;
end Behavioral;