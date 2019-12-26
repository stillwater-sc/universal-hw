library ieee; 
use ieee.std_logic_1164.all; 

entity test_entity_tb is 
   generic ( DWIDTH : integer ); 
end test_entity_tb; 

architecture test_tb of test_entity_tb is 
   component test_entity port ( 
      clk         : in std_logic := '0'; 
      d           : in std_logic_vector(DWIDTH-1 downto 0); 
      q           : out std_logic_vector(DWIDTH-1 downto 0) ); 
   end component; 
   signal clk           : std_logic; 
   signal d             : std_logic_vector(DWIDTH-1 downto 0); 
   signal q             : std_logic_vector(DWIDTH-1 downto 0); 
begin  
   UUT : test_entity port map ( 
      clk => clk, d => d, q => q ); 

   main : process 
   begin --  main 
      d <= (others => '0'); 
      wait for 40 ns; 
      d <= (others => '1'); 
      wait; 
   end process main; 

   clock : process 
   begin --  clock 
      clk <= '0'; 
      wait for 20 ns; 
      clk <= '1'; 
      wait for 20 ns; 
   end process clock; 
end test_tb; 
