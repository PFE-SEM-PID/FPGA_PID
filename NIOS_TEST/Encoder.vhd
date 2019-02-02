library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Encoder is
generic(
	debounce_time	: INTEGER:=10;--500 en conditions réelles
	count_res		: INTEGER:=16 -- resolution du compte
);
port(
	CLK	 : IN STD_LOGIC;
	CHAN_A : IN STD_LOGIC;
	CHAN_B : IN STD_LOGIC;
	RAZ	 : IN STD_LOGIC;
	OUTPUT_COUNT : OUT SIGNED(count_res-1 downto 0)
);
end;

architecture behavior of Encoder is
SIGNAL count     : SIGNED(count_res-1 downto 0):=(others=>'0'); --counter value
--DEBOUNCE
SIGNAL timer : integer range 0 to debounce_time:=0;
SIGNAL A_CURR : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL B_CURR : STD_LOGIC_VECTOR(1 downto 0);
SIGNAL A_LAST : STD_LOGIC;
SIGNAL B_LAST : STD_LOGIC;
SIGNAL DIR : STD_LOGIC;

BEGIN
--PROCESS gerant le compte des ticks
CompteurTicks : PROCESS(CLK, RAZ)
BEGIN
	if RAZ = '0' then
		count<=(others=>'0');
		A_LAST<=CHAN_A;
		B_LAST<=CHAN_B;
		A_CURR<=(others=>CHAN_A);
		B_CURR<=(others=>CHAN_B);
	elsif rising_edge(CLK)then
		A_CURR<=A_CURR(0)&CHAN_A;
		B_CURR<=B_CURR(0)&CHAN_B;
		if(((A_CURR(0) XOR A_CURR(1)) OR (B_CURR(0) XOR B_CURR(1)))='1') then -- changement des chans
			timer<=0;--reset
		elsif(timer=debounce_time) then
			A_LAST<=A_CURR(1);
			B_LAST<=B_CURR(1);
		else
			timer<=timer+1;
		end if;
		
		--pos:
		if(timer=debounce_time AND ((A_LAST XOR A_CURR(1)) OR (B_LAST XOR B_CURR(1)))='1') then
			DIR<=B_CURR(1) XOR A_LAST;
			if((B_LAST XOR A_CURR(1))='1')then
				count<=count+1;
			else
				count<=count-1;
			end if;
		end if;
	end if;
END PROCESS;

--AFFICHAGE DU DECOMPTE EN BINAIRE
OUTPUT_COUNT<=count;

END behavior;