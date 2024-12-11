--top_level.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.all;

entity top_level is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        rx : in STD_LOGIC;
        count_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end top_level;

architecture Behavioral of top_level is
    signal control : STD_LOGIC;
    signal vio_clk : STD_LOGIC;
    signal vio_reset : STD_LOGIC;
    signal vio_rx : STD_LOGIC;
    signal vio_control : STD_LOGIC;
    signal vio_count_out : STD_LOGIC_VECTOR(3 downto 0);
    signal control_mux : STD_LOGIC;
    
    COMPONENT vio
        PORT (
            clk : IN STD_LOGIC;
            probe_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
            probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
        );
    END COMPONENT;
    
begin
    -- Multiplexor para seleccionar entre la se�al original y la se�al controlada por el VIO
    control_mux <= vio_control when reset = '0' else '0';

    uart_controller_inst : entity work.uart_controller
        port map (
            clk => vio_clk,
            reset => vio_reset,
            rx => vio_rx,
            control_out => control
        );

    contador_asc_desc_inst : entity work.contador_asc_desc
        port map (
            clk => vio_clk,
            reset => vio_reset,
            control => control_mux,
            count_out => vio_count_out
        );

    vio_inst : vio
        PORT MAP (
            clk => clk,
            probe_in0 => vio_count_out, -- 4 bits para count_out
            probe_out0(0) => vio_clk, -- 1 bit para clk
            probe_out1(0) => vio_reset, -- 1 bit para reset
            probe_out2(0) => vio_rx, -- 1 bit para rx
            probe_out3(0) => vio_control -- 1 bit para control
        );

    count_out <= vio_count_out;
end Behavioral;