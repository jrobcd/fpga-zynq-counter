-- contador_asc_desc.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_asc_desc is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        control : in STD_LOGIC; -- '0' para ascendente, '1' para descendente
        count_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end contador_asc_desc;

architecture Behavioral of contador_asc_desc is
    signal count : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= "0000";
        elsif rising_edge(clk) then
            if control = '0' then
                count <= count + 1;
            else
                count <= count - 1;
            end if;
        end if;
    end process;

    count_out <= count;
end Behavioral;