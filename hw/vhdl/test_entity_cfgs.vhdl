configuration tb_cfg_8b of test_entity_tb is 
   for a_arch_tb 
      for UUT : test_entity 
         use entity work.test_entity(behavior) 
         generic map ( DWIDTH => 8 ); 
      end for; 
   end for; 
end tb_cfg_8b; 

configuration tb_cfg_32b of test_entity_tb is 
   for a_arch_tb 
      for UUT : test_entity 
         use entity work.test_entity(behavior) 
         generic map ( DWIDTH => 32 ); 
      end for; 
   end for; 
end tb_cfg_32b; 
