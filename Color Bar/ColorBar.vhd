library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity color_bar_top is
    Port (
        clk       : in  STD_LOGIC;           -- 100 MHz
        reset     : in  STD_LOGIC;           -- btnC (merkez buton)
        vga_hs    : out STD_LOGIC;
        vga_vs    : out STD_LOGIC;
        vga_r     : out STD_LOGIC_VECTOR(3 downto 0);
        vga_g     : out STD_LOGIC_VECTOR(3 downto 0);
        vga_b     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end color_bar_top;

architecture Behavioral of color_bar_top is

    -- Bileşen bildirimleri
    component clk_divider
        Port (
            clk_100MHz : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            clk_25MHz  : out STD_LOGIC
        );
    end component;

    component vga_controller
        Port (
            clk_25MHz : in  STD_LOGIC;
            reset     : in  STD_LOGIC;
            hsync     : out STD_LOGIC;
            vsync     : out STD_LOGIC;
            hcount    : out integer range 0 to 799;
            vcount    : out integer range 0 to 524;
            video_on  : out STD_LOGIC
        );
    end component;

    signal clk_25     : STD_LOGIC;
    signal hsync_s    : STD_LOGIC;
    signal vsync_s    : STD_LOGIC;
    signal h_cnt      : integer range 0 to 799;
    signal v_cnt      : integer range 0 to 524;
    signal video_on_s : STD_LOGIC;

    -- Renk sinyalleri
    signal red_s   : STD_LOGIC_VECTOR(3 downto 0);
    signal green_s : STD_LOGIC_VECTOR(3 downto 0);
    signal blue_s  : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Clock divider 
    U_CLK : clk_divider
        port map (
            clk_100MHz => clk,
            reset      => reset,
            clk_25MHz  => clk_25
        );

    -- VGA controller
    U_VGA : vga_controller
        port map (
            clk_25MHz => clk_25,
            reset     => reset,
            hsync     => hsync_s,
            vsync     => vsync_s,
            hcount    => h_cnt,
            vcount    => v_cnt,
            video_on  => video_on_s
        );

    -- Color Bar
    -- 640 piksel / 8 renk = Her cubuk 80 piksel
    process(h_cnt, video_on_s)
    begin
        if video_on_s = '0' then
            -- Blanking bolgesinde siyah
            red_s   <= "0000";
            green_s <= "0000";
            blue_s  <= "0000";
        else
            if    h_cnt < 80  then   -- Beyaz
                red_s <= "1111"; green_s <= "1111"; blue_s <= "1111";
            elsif h_cnt < 160 then   -- Sarı
                red_s <= "1111"; green_s <= "1111"; blue_s <= "0000";
            elsif h_cnt < 240 then   -- Cyan
                red_s <= "0000"; green_s <= "1111"; blue_s <= "1111";
            elsif h_cnt < 320 then   -- Yeşil
                red_s <= "0000"; green_s <= "1111"; blue_s <= "0000";
            elsif h_cnt < 400 then   -- Macenta
                red_s <= "1111"; green_s <= "0000"; blue_s <= "1111";
            elsif h_cnt < 480 then   -- Kırmızı
                red_s <= "1111"; green_s <= "0000"; blue_s <= "0000";
            elsif h_cnt < 560 then   -- Mavi
                red_s <= "0000"; green_s <= "0000"; blue_s <= "1111";
            else                     -- Siyah
                red_s <= "0000"; green_s <= "0000"; blue_s <= "0000";
            end if;
        end if;
    end process;

    -- Cikisleri bagla
    vga_hs <= hsync_s;
    vga_vs <= vsync_s;
    vga_r  <= red_s;
    vga_g  <= green_s;
    vga_b  <= blue_s;

end Behavioral;