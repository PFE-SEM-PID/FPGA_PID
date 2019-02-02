LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- L'entité principale gerant le PID, sera instanciée dans une entité instanciant le NIOS et celui-ci
ENTITY PID IS
	GENERIC(
		Kp 				 : INTEGER:= 163;  --1.63*100
		Kp_div			 : INTEGER := 100;
		Ki 				 : INTEGER:= 20 ;  --0.2*100
		Ki_div			 : INTEGER := 100;
		Kd 				 : INTEGER:= 140;  --1.4*100
		Kd_div			 : INTEGER := 100;
		sys_clk         : INTEGER := 50_000_000;	--system clock frequency en Hz
      pwm_freq        : INTEGER := 25_000;    	--PWM switching en Hz
		asserv_freq		 : INTEGER := 100;			--Asservissement à 100Hz
      pwm_resolution	 : INTEGER := 8;  			--Resolution en bits du PWM
		input_resolution: INTEGER := 16  			--Resolution en bits des codeuses et de la consigne
	);
	PORT(
 		CLOCK 	: IN  STD_LOGIC;
		RESET 	: IN  STD_LOGIC;
		ENCODER_A: IN  STD_LOGIC;
		ENCODER_B: IN  STD_LOGIC;
		SETPOINT	: IN  SIGNED(9 downto 0); -- setpoint sur 16 bits
		PWM_PIN 	: OUT STD_LOGIC;
		INA_PIN  : OUT STD_LOGIC;
		INB_PIN	: OUT STD_LOGIC;
		LEDS		: OUT STD_LOGIC_VECTOR(pwm_resolution downto 0)
	);
END PID;

ARCHITECTURE behavior OF PID IS
--COMPONENTS DECLARATION
COMPONENT Encoder
	generic(
		debounce_time	: INTEGER:=10;
		count_res		: INTEGER:=10
	);
	port(
		CLK	 		: IN STD_LOGIC;
		CHAN_A 		: IN STD_LOGIC;
		CHAN_B 		: IN STD_LOGIC;
		RAZ	 		: IN STD_LOGIC;
		OUTPUT_COUNT: OUT SIGNED(input_resolution-1 downto 0)
	);
END COMPONENT;
COMPONENT PWM 
	GENERIC(
      sys_clk        : INTEGER := 50_000_000;
      pwm_freq       : INTEGER := 25_000;
      bits_resolution: INTEGER := 8
	);
	PORT (
      CLK    : IN  STD_LOGIC;                                     --system clock (50MHz on Cyclone III DE3)
      DUTY   : IN  UNSIGNED(pwm_resolution-1 DOWNTO 0); 				--duty cycle of PWM (0 to 2^resolution -1)
      PWM_OUT: OUT STD_LOGIC 
	);
END COMPONENT;

--CONSTANTS
CONSTANT ASSERV_PERIOD	:INTEGER										:=sys_clk/asserv_freq;
CONSTANT PLUS_255_8		:SIGNED(pwm_resolution-1 downto 0)	:=TO_SIGNED(255, pwm_resolution);
CONSTANT MOINS_255_8		:SIGNED(pwm_resolution-1 downto 0)	:=TO_SIGNED(-255, pwm_resolution);
CONSTANT PLUS_255_9		:SIGNED(pwm_resolution downto 0)		:=TO_SIGNED(255, pwm_resolution+1);
CONSTANT MOINS_255_9		:SIGNED(pwm_resolution downto 0)		:=TO_SIGNED(-255, pwm_resolution+1);
CONSTANT PLUS_255_16		:SIGNED(input_resolution-1 downto 0):=TO_SIGNED(255, input_resolution);
CONSTANT MOINS_255_16	:SIGNED(input_resolution-1 downto 0):=TO_SIGNED(-255, input_resolution);
CONSTANT PLUS_255_32		:SIGNED(31 downto 0)						:=TO_SIGNED(255, 32);
CONSTANT MOINS_255_32	:SIGNED(31 downto 0)						:=TO_SIGNED(-255, 32);

--SIGNALS
SIGNAL TIMER				:INTEGER RANGE 0 TO ASSERV_PERIOD	:=0; 					--Pour asservir à 1/ASSERV_PERIOD Hz(selon la periode)
SIGNAL ENCODER_COUNT		:SIGNED(input_resolution-1 downto 0):=(others=>'0');
SIGNAL DUTY_CYCLE			:SIGNED(pwm_resolution downto 0)	 	:=(others=>'0'); 	-- Valeur du rapport cyclique, entre -255 et +255
SIGNAL DUTY_CYCLE_OUTPUT:UNSIGNED(pwm_resolution-1 downto 0):=(others=>'0'); 	-- valeur du rapport cyclique, entre 0 et 255
SHARED VARIABLE ERREUR  :SIGNED(input_resolution-1 downto 0):=(others=>'0');	--Ecart entre input et setpoint
SHARED VARIABLE ERREUR_L:SIGNED(input_resolution-1 downto 0):=(others=>'0');	--Derniere erreur
SHARED VARIABLE ERREUR_I:SIGNED(input_resolution-1 downto 0):=(others=>'0');	--Somme des erreurs
SHARED VARIABLE ERREUR_D:SIGNED(input_resolution-1 downto 0):=(others=>'0');	--Ecart entre erreur et derniere erreur
--Erreur n * Ki
SIGNAL ERREUR_KP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KI		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KD		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');

--Somme progressive
--SIGNAL ERREUR_KP_KI_FP	 :STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
--SIGNAL ERREUR_KP_KI_KD_FP:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_TOT_INT	 :STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');

BEGIN
-- SEQUENTIEL: Calcul des erreurs
	Error_Compute: PROCESS(CLOCK, RESET)
	BEGIN
		IF RESET='0' THEN
			ERREUR:=(others=>'0');
			ERREUR_I:=(others=>'0');
			ERREUR_D:=(others=>'0');
			ERREUR_TOT_INT<=(others=>'0');
			TIMER<=0;
		ELSIF rising_edge(CLOCK) THEN
			IF TIMER=ASSERV_PERIOD THEN								--Front d'asservissement
				--CALCUL ET MISE A JOUR DES ERREURS
				ERREUR_L			:=ERREUR;								--Backup pour calcul de dérivée
				ERREUR			:=RESIZE(SETPOINT, ERREUR'length)-SIGNED(ENCODER_COUNT);--Calcul de l'erreur(ecart a la consigne)
				ERREUR_I			:=ERREUR_I+ERREUR;					--Increment de l'erreur integrale
				IF(ERREUR_I<MOINS_255_16) THEN	-- ANTI WINDUP: on evite que l'erreur integrale aille vers +-l'infini
					ERREUR_I		:=MOINS_255_16;
				ELSIF(ERREUR_I>PLUS_255_16) THEN
					ERREUR_I		:=PLUS_255_16;
				END IF;
				ERREUR_D			:=ERREUR-ERREUR_L;					--Erreur derivative
				
				--Calculs en fixed point
				ERREUR_TOT_INT<=STD_LOGIC_VECTOR((Kp*ERREUR/Kp_div)+(Ki*ERREUR_I/Ki_div)+(Kd*ERREUR_D/Kd_div));
				
				TIMER<=0;
			ELSE
				TIMER<=TIMER+1;
			END IF;
		END IF;
	END PROCESS;

-- COMBINATOIRE/Megafunctions/Instances
	--Lecture de la codeuse
	ENCODER_READ: Encoder 
		GENERIC MAP(10,input_resolution)
		PORT MAP(CLOCK, ENCODER_A, ENCODER_B, RESET, ENCODER_COUNT);	
	--Calcul du rapport cyclique
	DUTY_CYCLE<=PLUS_255_9 when(SIGNED(ERREUR_TOT_INT)>PLUS_255_32) else
					MOINS_255_9 when(SIGNED(ERREUR_TOT_INT)<MOINS_255_32) else
					RESIZE(SIGNED(ERREUR_TOT_INT), DUTY_CYCLE'length);
	--Gestion du sens du moteur et de sa vitesse
	INA_PIN<='1' when(signed(DUTY_CYCLE)<0) else '0';
	INB_PIN<='0' when(signed(DUTY_CYCLE)<0) else '1';
	DUTY_CYCLE_OUTPUT<=UNSIGNED("abs"(signed(DUTY_CYCLE))(pwm_resolution-1 downto 0)); --On ne peut pas slicer une conversion(std logic vector(), qui n'est pas une fonction), mais on peut slicer "abs" (nom défini, pas la fonction abs)
	--PWM vers le moteur
	PWM_COMPUTE : PWM PORT MAP (CLOCK, UNSIGNED(DUTY_CYCLE_OUTPUT), PWM_PIN);
	LEDS<=STD_LOGIC_VECTOR(DUTY_CYCLE);
END behavior;