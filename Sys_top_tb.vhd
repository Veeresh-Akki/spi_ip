library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Sys_top_tb is
end;

architecture bench of Sys_top_tb is

  component Sys_top
  	port (
  	  clk_st                 : in  std_logic;  
	rst_in                : in  std_logic ; 
    proc_beat			  : out std_logic; 
    sin0		          : in std_logic ;  
    sout0                 : out std_logic;
     --sin1		          : in std_logic ;  
    --sout1                 : out std_logic;
    sclk                    : out std_logic;
    miso                   : in std_logic;
    ss                     : out std_logic;
     mosi                  : out std_logic
      );
  end component;

  signal clk_st     : std_logic := '1';
  signal rst_in    : std_logic := '0';
  signal proc_beat : std_logic;
  signal sin0      : std_logic;
  signal sout0     : std_logic ;
  signal ss        : std_logic;
  signal sclk      : std_logic;
  signal  miso     : std_logic;
  signal mosi      : std_logic;
    --signal wri                   :  std_logic;
     --spi_cs                 : in std_logic;
     --spi_ss0                   : in std_logic_vector(7 downto 0);
     --dout                   : out std_logic;
     
  --signal read_din  : std_logic;
  --signal data_din  : std_logic_vector(31 downto 0);
  --SIGNAL spi_sclk  : std_logic;
  
--  signal sin1     : std_logic;
--  signal sout1    : std_logic;


begin

  uut: Sys_top port map ( 
    clk_st                 => clk_st,    
	rst_in                =>rst_in ,    
    proc_beat			  => proc_beat,			 
    sin0		          => sin0,		       
    sout0                 => sout0,        
  --sin1		          => sin1		       
  --sout1                 => sout1   
    ss                    => ss,
    sclk                  => sclk,         
    miso                 => miso ,       
    mosi                 => mosi       
 -- wri                   => wri          
     --spi_cs             =>  --spi_cs    
     --spi_ss0            =>  --spi_ss0   ic_vector(7 downto 0);
     --dout               =>  --dout      ;
     --read_din           =>  --read_din  
    --data_din            => --data_din   ic_vector(7 downto 0);
  
                        );

  stimulus: process(clk_st)
  begin
    
--clk_st <= not clk_st after 2.5 ns;
clk_st <= not clk_st after 5 ns;
  end process;
  rst_in <= '1' after 200 ns;

end;