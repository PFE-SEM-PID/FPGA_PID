LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- L'entité principale gerant le PID, sera instanciée dans une entité instanciant le NIOS et celui-ci
ENTITY PID IS
	GENERIC(
		Kp 				 : STD_LOGIC_VECTOR := "00111111110100001010001111010111";	--1.63 en float 32 bits
		Ki 				 : STD_LOGIC_VECTOR := "00111110010011001100110011001101";  --0.2
		Kd 				 : STD_LOGIC_VECTOR := "00111111101100110011001100110011";  --1.4
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
		debounce_time	: INTEGER:=500;
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
COMPONENT Convert_FP PORT (CLOCK	: IN STD_LOGIC ;
									DATAA	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
									RESULT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;
COMPONENT Convert_INT PORT (CLOCK: IN STD_LOGIC ;
									DATAA	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
									RESULT: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;
COMPONENT Multiplieur_FP PORT (CLOCK : in  STD_LOGIC;
										 DATAA : in  STD_LOGIC_VECTOR(31 downto 0);
										 DATAB : in  STD_LOGIC_VECTOR(31 downto 0);
										 RESULT: out STD_LOGIC_VECTOR(31 downto 0));
END COMPONENT;
COMPONENT FP_ADD PORT(
		CLOCK		: IN  STD_LOGIC ;
		DATAA		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		DATAB		: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		RESULT	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
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
SIGNAL ERREUR_32BIT		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_I_32BIT	:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_D_32BIT	:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_FP			:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_I_FP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_D_FP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
--Erreur n * Ki
SIGNAL ERREUR_KP_FP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KI_FP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KD_FP		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');

SIGNAL ERREUR_KP_INT		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KI_INT		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');
SIGNAL ERREUR_KD_INT		:STD_LOGIC_VECTOR(31 downto 0)		:=(others=>'0');

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
				--CONVERSIONS EN NOMBRES 32BIT POUR LA CONVERSION EN FLOTTANTS
				ERREUR_32BIT	<=STD_LOGIC_VECTOR(RESIZE(ERREUR, ERREUR_32BIT'length));
				ERREUR_I_32BIT	<=STD_LOGIC_VECTOR(RESIZE(ERREUR_I, ERREUR_I_32BIT'length));
				ERREUR_D_32BIT	<=STD_LOGIC_VECTOR(RESIZE(ERREUR_D, ERREUR_D_32BIT'length));
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
	--Conversions en flottants
	ERREUR_P_CONV_FP: 	Convert_FP  PORT MAP(CLOCK, ERREUR_32BIT, ERREUR_FP);
	ERREUR_I_CONV_FP: 	Convert_FP  PORT MAP(CLOCK, ERREUR_I_32BIT, ERREUR_I_FP);
	ERREUR_D_CONV_FP: 	Convert_FP  PORT MAP(CLOCK, ERREUR_D_32BIT, ERREUR_D_FP);
	--ERREUR_TOT_CONV_INT: Convert_INT PORT MAP(CLOCK, ERREUR_KP_KI_KD_FP, ERREUR_TOT_INT);
	ERREUR_P_CONV_INT: 	Convert_INT PORT MAP(CLOCK, ERREUR_KP_FP, ERREUR_KP_INT);
	ERREUR_I_CONV_INT: 	Convert_INT	PORT MAP(CLOCK, ERREUR_KI_FP, ERREUR_KI_INT);
	ERREUR_D_CONV_INT: 	Convert_INT PORT MAP(CLOCK, ERREUR_KD_FP, ERREUR_KD_INT);
	--Produits Kn * Erreur_n
	PRODUIT_Kp_Erreur_p: Multiplieur_FP PORT MAP(CLOCK, Kp, ERREUR_FP,   ERREUR_KP_FP);
	PRODUIT_Ki_Erreur_i: Multiplieur_FP PORT MAP(CLOCK, Ki, ERREUR_I_FP, ERREUR_KI_FP);
	PRODUIT_Kd_Erreur_d: Multiplieur_FP PORT MAP(CLOCK, Kd, ERREUR_D_FP, ERREUR_KD_FP);
	
	--Calcul du rapport cyclique
	--SOMME_KP_KI: 	FP_ADD PORT MAP(CLOCK, ERREUR_KP_FP, ERREUR_KI_FP, ERREUR_KP_KI_FP);
	--SOMME_KP_KI_KD:FP_ADD PORT MAP(CLOCK, ERREUR_KP_KI_FP, ERREUR_KD_FP, ERREUR_KP_KI_KD_FP);
	ERREUR_TOT_INT<=STD_LOGIC_VECTOR(SIGNED(ERREUR_KP_INT)+SIGNED(ERREUR_KI_INT)+SIGNED(ERREUR_KD_INT));
	--LIMITE_SUP: FP_COMPARE PORT MAP(CLOCK, ERREUR_KP_KI_KD, PLUS_255_FP, SUP255);
	--LIMITE_INF: FP_COMPARE PORT MAP(CLOCK, MOINS_255_FP, ERREUR_KP_KI_KD, INFMOINS255);
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