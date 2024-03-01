----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2023 03:27:45 PM
-- Design Name: 
-- Module Name: TaxiMeter_Source - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity TaxiMeter_Source is
    Port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;
        stop    : in  std_logic;
        led    : out std_logic_vector(7 downto 0)
    );
end TaxiMeter_Source;

architecture Behavioral of TaxiMeter_Source is

   constant n_divider : integer :=  10**8;
   signal ce : std_logic := '0'; 


    constant FARE_RATE : unsigned(7 downto 0) := "00001000"; -- Fare rate per minute

    signal time_elapsed : unsigned(31 downto 0) := (others => '0');
    signal fare_reg : unsigned(31 downto 0) := (others => '0');

begin

    process (clk, reset)
      variable fare_reg_local : unsigned(39 downto 0);
    begin
        if reset = '1' then
            time_elapsed <= (others => '0');
            fare_reg <= (others => '0');
        elsif rising_edge(clk) then
          if ce = '1' then
            if start = '1' and stop = '0' then
                time_elapsed <= time_elapsed + 1;
                fare_reg_local := time_elapsed * FARE_RATE;
                fare_reg <= fare_reg_local(31 downto 0);
            end if;
          end if;  
        end if;
    end process;

    led <= std_logic_vector(fare_reg(7 downto 0));
    
    -- divider
    process (reset, clk)
      variable divider : integer := 0;
    begin
      if reset = '1' then
        divider := 0;
        ce <= '0';
      elsif rising_edge(clk) then
        if divider = n_divider - 1 then
          divider := 0;
          ce <= '1';
        else
          divider := divider +1;
          ce <= '0';
        end if;
      end if;
    end process;


end Behavioral;
