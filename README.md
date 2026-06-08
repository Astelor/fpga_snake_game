# Snake on DE2_70 from scratch

Goal: build a simple pixel snake game with touch screen controls and LCD monitor display

Project structure
```
📦fpga_snake_game
 ┣ 📂ltm                         // modules from example program
 ┃ ┣ 📜adc_spi_controller.v
 ┃ ┣ 📜lcd_spi_cotroller.v
 ┃ ┣ 📜lcd_timing_controller.v  // <- this is modified slightly for limited color display
 ┃ ┣ 📜Reset_Delay.v
 ┃ ┣ 📜SEG7_LUT.v
 ┃ ┣ 📜SEG7_LUT_8.v
 ┃ ┗ 📜three_wire_controller.v
 ┣ 📂module
 ┃ ┣ 📜dual_ram.v
 ┃ ┗ 📜my_ram.v                 // <- the FPGA ram block used for int map
 ┣ 📂python
 ┃ ┣ 📜gen-test-pattern.ipynb   // <- map generation Python scripts
 ┃ ┣ 📜map20x20.png
 ┃ ┣ 📜map40x20.png
 ┃ ┣ 📜map40x24.png             // <- the map used 
 ┃ ┗ 📜map_new.hex              // <- the map hex data used
 ┣ 📂quartus
 ┃ ┣ 📂ip
 ┃ ┃ ┗ 📜new_fifo.v             // <- Quartus generated IP core (megafunction)
 ┃ ┣ 📂simulation
 ┃ ┃ ┗ 📂modelsim               // Testbench TCL scripts
 ┃ ┃ ┃ ┣ 📜circular_sim.do
 ┃ ┃ ┃ ┗ 📜snake_controller_sim.do
 ┃ ┣ 📜fpga_snake_game.qsf
 ┃ ┗ 📜fpga_snake_game.sdc
 ┣ 📂tb                         // Testbench setup
 ┃ ┣ 📜tb_circular_queue.v
 ┃ ┗ 📜tb_snake_controller.v
 ┣ 📜intmap.hex                 // 
 ┣ 📜map.hex                    // artifacts during dev process
 ┣ 📜dummy.hex                  //
 ┣ 📜README.md
 ┣ 📜arbiter.v                  // written by Astelor
 ┣ 📜coordinate_checker.v       // written by Astelor
 ┣ 📜circular_queue.v           // written by Astelor
 ┣ 📜intmap_lcd_controller.v    // written by Astelor
 ┣ 📜DE2_70_LTM_Ephoto.v        // Top level design (derived from example code)
 ┗ 📜snake_controller.v         // written by Astelor
```