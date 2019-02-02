library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NIOS_TEST is
port(
	CLOCK	 	: IN STD_LOGIC;
	RESET	 	: IN STD_LOGIC;
	ENCODER_A: IN  STD_LOGIC;
	ENCODER_B: IN  STD_LOGIC;
	PWM_PIN 	: OUT STD_LOGIC;
	INA_PIN  : OUT STD_LOGIC;
	INB_PIN	: OUT STD_LOGIC;
	LEDS		: OUT STD_LOGIC_VECTOR(9 downto 0)
);
end;

architecture behavior of NIOS_TEST is
--COMPONENTS DECLARATION
component NIOS_Qsys is
	port (
		clk_clk                                 : in  std_logic                     := 'X';             -- clk
		reset_reset_n                           : in  std_logic                     := 'X';             -- reset_n
		pio_kp_external_connection_export       : out std_logic_vector(9 downto 0);                     -- export
		pio_ki_external_connection_export       : out std_logic_vector(9 downto 0);                     -- export
		pio_kd_external_connection_export       : out std_logic_vector(9 downto 0);                     -- export
		pio_setpoint_external_connection_export : out std_logic_vector(9 downto 0);                     -- export
		pio_encoder_external_connection_export  : in  std_logic_vector(15 downto 0) := (others => 'X');  -- export
		pio_reset_pid_external_connection_export: out  std_logic:='X';
		pio_leds_external_connection_export: out  std_logic_vector(9 downto 0):=(others=>'X')
	);
end component NIOS_Qsys;

component PID is
	port (
	 	CLOCK 	: IN	STD_LOGIC;
		RESET 	: IN	STD_LOGIC;
		RESET_PID: IN	STD_LOGIC;
		ENCODER_A: IN	STD_LOGIC;
		ENCODER_B: IN	STD_LOGIC;
		Kp			: IN	SIGNED(9 DOWNTO 0);
		Ki 		: IN	SIGNED(9 DOWNTO 0);
		Kd 		: IN	SIGNED(9 DOWNTO 0);
		SETPOINT	: IN  SIGNED(9 downto 0); -- setpoint sur 16 bits
		COD_OUT	: OUT SIGNED(15 DOWNTO 0);
		PWM_PIN 	: OUT STD_LOGIC;
		INA_PIN  : OUT STD_LOGIC;
		INB_PIN	: OUT STD_LOGIC
	);
end component PID;
--SIGNAL DECLARATION
SIGNAL RESET_PIO : STD_LOGIC:='0';
SIGNAL LEDS_SIG: STD_LOGIC_VECTOR(9 downto 0);
SIGNAL Kp_VEC	:	STD_LOGIC_VECTOR(9 DOWNTO 0):=STD_LOGIC_VECTOR(TO_SIGNED(163,10));
SIGNAL Ki_VEC	:	STD_LOGIC_VECTOR(9 DOWNTO 0):=STD_LOGIC_VECTOR(TO_SIGNED(20,10));
SIGNAL Kd_VEC	:	STD_LOGIC_VECTOR(9 DOWNTO 0):=STD_LOGIC_VECTOR(TO_SIGNED(140,10));
SIGNAL SETPOINT_VEC:STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=>'0');
SIGNAL ENCODER_VEC :STD_LOGIC_VECTOR(15 DOWNTO 0):=(others=>'0');
SIGNAL ENCODER_SIGN:SIGNED(15 DOWNTO 0):=(others=>'0');
BEGIN

nios_inst: component NIOS_Qsys
	port map (
		clk_clk                                 => CLOCK,                                 --                              clk.clk
		reset_reset_n                           => RESET,                           --                            reset.reset_n
		pio_kp_external_connection_export       => Kp_VEC,       --       pio_kp_external_connection.export
		pio_ki_external_connection_export       => Ki_VEC,       --       pio_ki_external_connection.export
		pio_kd_external_connection_export       => Kd_VEC,       --       pio_kd_external_connection.export
		pio_setpoint_external_connection_export => SETPOINT_VEC, -- pio_setpoint_external_connection.export
		pio_encoder_external_connection_export  => ENCODER_VEC,	--  pio_encoder_external_connection.export
		pio_reset_pid_external_connection_export => RESET_PIO,
		pio_leds_external_connection_export => LEDS_SIG
	);

pid_inst: component PID
	port map (
		CLOCK,
		RESET,
		RESET_PIO,
		ENCODER_A,
		ENCODER_B,
		SIGNED(Kp_VEC),
		SIGNED(Ki_VEC),
		SIGNED(Kd_VEC),
		SIGNED(SETPOINT_VEC),
		ENCODER_SIGN,
		PWM_PIN,
		INA_PIN,
		INB_PIN
	);

ENCODER_VEC<=STD_LOGIC_VECTOR(ENCODER_SIGN);
LEDS<=LEDS_SIG;
END behavior;