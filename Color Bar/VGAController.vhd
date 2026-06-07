library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        clk_25MHz   : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        hsync       : out STD_LOGIC;
        vsync       : out STD_LOGIC;
        hcount      : out integer range 0 to 799;
        vcount      : out integer range 0 to 524;
        video_on    : out STD_LOGIC
    );
end vga_controller;

architecture Behavioral of vga_controller is

    -- Yatay zamanlama sabitleri (piksel cinsinden)
    constant H_VISIBLE    : integer := 640;
    constant H_FRONT_PORCH: integer := 16;
    constant H_SYNC_PULSE : integer := 96;
    constant H_BACK_PORCH : integer := 48;
    constant H_TOTAL      : integer := 800;  -- 640+16+96+48

    -- Dikey zamanlama sabitleri (satır cinsinden)
    constant V_VISIBLE    : integer := 480;
    constant V_FRONT_PORCH: integer := 10;
    constant V_SYNC_PULSE : integer := 2;
    constant V_BACK_PORCH : integer := 33;
    constant V_TOTAL      : integer := 525;  -- 480+10+2+33

    signal h_cnt : integer range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : integer range 0 to V_TOTAL - 1 := 0;

begin

    -- Sayaçları ilerlet
    process(clk_25MHz, reset)
    begin
        if reset = '1' then
            h_cnt <= 0;
            v_cnt <= 0;
        elsif rising_edge(clk_25MHz) then
            if h_cnt = H_TOTAL - 1 then
                h_cnt <= 0;
                if v_cnt = V_TOTAL - 1 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;
        end if;
    end process;

    -- Sync sinyallerini üret (aktif düşük)
    hsync <= '0' when (h_cnt >= H_VISIBLE + H_FRONT_PORCH) and      --hcnt >= 656 & hcnt < 752
                      (h_cnt <  H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE)
             else '1';

    vsync <= '0' when (v_cnt >= V_VISIBLE + V_FRONT_PORCH) and
                      (v_cnt <  V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE)
             else '1';

    -- Görünür bölge bayrağı
    video_on <= '1' when (h_cnt < H_VISIBLE) and (v_cnt < V_VISIBLE)
                else '0';

    -- Koordinatları dışarı ver
    hcount <= h_cnt;
    vcount <= v_cnt;

end Behavioral;

-- 0-639 arasindayken "video_on = 1", "hsync = 1" olmalidir ve boylece goruntu verilir 
-- 640-655 arasindayken "video_on = 0", "hsync = 1" dir 
-- 656-751 arasindayken "video_on = 0", "hsync = 0" olmalidir
-- 752-799 arasinda "hsync = 1" olur ama 799 a ulaşmadan video_on = 1 olmaz ve 
-- bu bos zaman BACK_PORCH' tur