library ieee; 
use ieee.std_logic_1164.all; 

entity test_entity is 
   generic ( DWIDTH : integer ); 
   port ( 
      clk         : in std_logic; 
      d           : in std_logic_vector(DWIDTH-1 downto 0); 
      q           : out std_logic_vector(DWIDTH-1 downto 0) ); 
end a_ent; 


architecture behavior of test_entity is 
begin  
   test_proc : process (Clk) 
   begin 
      if (Clk'event and Clk = '1') then 
         q <= d; 
      end if; 
   end process test_proc; 
end architecture behavior; 
