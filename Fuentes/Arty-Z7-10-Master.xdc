##Arty-Z7-10-Master.xdc

## Clock Signal
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=SYSCLK
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];

## Reset Signal
set_property -dict { PACKAGE_PIN M20    IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L7N_T1_AD2N_35 Sch=SW0

## UART RX Signal
set_property -dict { PACKAGE_PIN M19    IOSTANDARD LVCMOS33 } [get_ports { rx }]; #IO_L7P_T1_AD2P_35 Sch=SW1

## Count Output (LEDs)
set_property -dict { PACKAGE_PIN R14    IOSTANDARD LVCMOS33 } [get_ports { count_out[0] }]; #IO_L6N_T0_VREF_34 Sch=LED0
set_property -dict { PACKAGE_PIN P14    IOSTANDARD LVCMOS33 } [get_ports { count_out[1] }]; #IO_L6P_T0_34 Sch=LED1
set_property -dict { PACKAGE_PIN N16    IOSTANDARD LVCMOS33 } [get_ports { count_out[2] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=LED2
set_property -dict { PACKAGE_PIN M14    IOSTANDARD LVCMOS33 } [get_ports { count_out[3] }]; #IO_L23P_T3_35 Sch=LED3