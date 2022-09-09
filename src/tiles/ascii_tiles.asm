;test tiledefs

;0x00
Tiles_ctrl_char: ;non-printing
    rept 0x20
    rept 8
    dc.l    0x00000000
    endr
    endr

;0x20
TileBlank:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_bang:
    dc.l    0x00111000
    dc.l    0x00111000
    dc.l    0x00111000
    dc.l    0x00010000
    dc.l    0x00000000
    dc.l    0x00010000
    dc.l    0x00111000
    dc.l    0x00010000    

Tile_quote:
    dc.l    0x00101000
    dc.l    0x00101000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_pound:
    dc.l    0x00000000
    dc.l    0x00101000
    dc.l    0x01111100
    dc.l    0x00101000
    dc.l    0x01111100
    dc.l    0x00101000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_dollar:
    dc.l    0x01111110
    dc.l    0x10010000
    dc.l    0x10010000
    dc.l    0x01111100
    dc.l    0x00010010
    dc.l    0x00010010
    dc.l    0x11111100
    dc.l    0x00000000

Tile_percent:
    dc.l    0x01000010
    dc.l    0x10100100
    dc.l    0x01001000
    dc.l    0x00010000
    dc.l    0x00100100
    dc.l    0x01001010
    dc.l    0x10000100
    dc.l    0x00000000

Tile_ampersand:
    dc.l    0x00001100
    dc.l    0x00010010
    dc.l    0x00100000
    dc.l    0x01010000
    dc.l    0x10001010
    dc.l    0x10000100
    dc.l    0x01110010
    dc.l    0x00000000

Tile_apostrophe:
    dc.l    0x01000000
    dc.l    0x00100000
    dc.l    0x00100000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_left_paren:
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x00100000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_right_paren:
    dc.l    0x00010000
    dc.l    0x00001000
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_star:
    dc.l    0x01010100
    dc.l    0x00111000
    dc.l    0x11111110
    dc.l    0x00111000
    dc.l    0x01010100
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_plus:
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x11111110
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_comma:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x10000000

Tile_dash:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x11111110
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_period:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00110000
    dc.l    0x00110000
    dc.l    0x00000000

Tile_slash:
    dc.l    0x00000010
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x10000000
    dc.l    0x00000000

Tile_zero:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10001010
    dc.l    0x10010010
    dc.l    0x10100010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000

Tile_1:
    dc.l    0x00110000
    dc.l    0x01010000
    dc.l    0x10010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x11111110
    dc.l    0x00000000
    
Tile_2:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x00000010
    dc.l    0x00001100
    dc.l    0x00110000
    dc.l    0x01000000
    dc.l    0x11111110
    dc.l    0x00000000
    
Tile_3:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x00000010
    dc.l    0x00111100
    dc.l    0x00000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000
    
Tile_4:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111110
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000000
    
Tile_5:
    dc.l    0x11111110
    dc.l    0x10000000
    dc.l    0x01000000
    dc.l    0x00111100
    dc.l    0x00000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000

Tile_6:
    dc.l    0x01111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000

Tile_7:
    dc.l    0x11111110
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x10000000
    dc.l    0x00000000
    
Tile_8:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000

Tile_9:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111110
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000000

Tile_colon:
    dc.l    0x00000000
    dc.l    0x00110000
    dc.l    0x00110000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00110000
    dc.l    0x00110000
    dc.l    0x00000000

Tile_semicolon:
    dc.l    0x00000000
    dc.l    0x00110000
    dc.l    0x00110000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x10000000

Tile_left_angle:
    dc.l    0x00000110
    dc.l    0x00011000
    dc.l    0x01100000
    dc.l    0x10000000
    dc.l    0x01100000
    dc.l    0x00011000
    dc.l    0x00000110
    dc.l    0x00000000

Tile_equals:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x11111110
    dc.l    0x00000000
    dc.l    0x11111110
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_right_angle:
    dc.l    0x11000000
    dc.l    0x00110000
    dc.l    0x00001100
    dc.l    0x00000010
    dc.l    0x00001100
    dc.l    0x00110000
    dc.l    0x11000000
    dc.l    0x00000000

Tile_question:
    dc.l    0x00111000
    dc.l    0x01000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000
    dc.l    0x00010000
    dc.l    0x00000000

;0x40
Tile_at:
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10111010
    dc.l    0x10101010
    dc.l    0x10110100
    dc.l    0x10000000
    dc.l    0x01111100
    dc.l    0x00000000

Tile_A:
    dc.l    0x00010000
    dc.l    0x00101000
    dc.l    0x00101000
    dc.l    0x01000100
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_B:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x00000000
    
Tile_C:
    dc.l    0x00111100
    dc.l    0x01000010
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x01000010
    dc.l    0x00111100
    dc.l    0x00000000

Tile_D:
    dc.l    0x11111000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000100
    dc.l    0x11111000
    dc.l    0x00000000
    
Tile_E:
    dc.l    0x11111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111110
    dc.l    0x00000000
    
Tile_F:
    dc.l    0x11111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x00000000

Tile_G:
    dc.l    0x00111100
    dc.l    0x01000010
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10001110
    dc.l    0x01000010
    dc.l    0x00111010
    dc.l    0x00000000
    
Tile_H:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111110
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_I:
    dc.l    0x11111110
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x11111110
    dc.l    0x00000000

Tile_J:
    dc.l    0x00000110
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x10000100
    dc.l    0x01111000
    dc.l    0x00000000
    
Tile_K:
    dc.l    0x10000010
    dc.l    0x10000100
    dc.l    0x10001000
    dc.l    0x11110000
    dc.l    0x10001000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x00000000

Tile_L:
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111110
    dc.l    0x00000000

Tile_M:
    dc.l    0x10000010
    dc.l    0x11000110
    dc.l    0x10101010
    dc.l    0x10010010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_N:
    dc.l    0x10000010
    dc.l    0x11000010
    dc.l    0x10100010
    dc.l    0x10010010
    dc.l    0x10001010
    dc.l    0x10000110
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_O:
    dc.l    0x00111000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00111000
    dc.l    0x00000000
    
Tile_P:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x00000000
    
Tile_Q:
    dc.l    0x00111000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10001010
    dc.l    0x01000100
    dc.l    0x00111010
    dc.l    0x00000000
    
Tile_R:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10001000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x00000000

Tile_S:
    dc.l    0x01111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x01111100
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x11111100
    dc.l    0x00000000
    
Tile_T:
    dc.l    0x11111110
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_U:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000
    
Tile_V:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00000000
    
Tile_W:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10010010
    dc.l    0x10010010
    dc.l    0x10101010
    dc.l    0x10101010
    dc.l    0x11000110
    dc.l    0x00000000
    
Tile_X:
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00101000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_Y:
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_Z:
    dc.l    0x11111110
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x11111110
    dc.l    0x00000000

Tile_left_square:
    dc.l    0x01110000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x01000000
    dc.l    0x01110000
    dc.l    0x00000000

Tile_backslash:
    dc.l    0x10000000
    dc.l    0x01000000
    dc.l    0x00100000
    dc.l    0x00010000
    dc.l    0x00001000
    dc.l    0x00000100
    dc.l    0x00000010
    dc.l    0x00000000

Tile_right_square:
    dc.l    0x00011100
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00000100
    dc.l    0x00011100
    dc.l    0x00000000

Tile_carat:
    dc.l    0x00010000
    dc.l    0x00101000
    dc.l    0x01000100
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

Tile_underscore:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x11111110
    dc.l    0x00000000

;0x60
Tile_backtick:
    dc.l    0x00001000
    dc.l    0x00000100
    dc.l    0x00000010
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000

;the alphabet again
Tile_a_lower:
    dc.l    0x00010000
    dc.l    0x00101000
    dc.l    0x00101000
    dc.l    0x01000100
    dc.l    0x01111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_b_lower:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x00000000
    
Tile_c_lower:
    dc.l    0x00111100
    dc.l    0x01000010
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x01000010
    dc.l    0x00111100
    dc.l    0x00000000

Tile_d_lower:
    dc.l    0x11111000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000100
    dc.l    0x11111000
    dc.l    0x00000000
    
Tile_e_lower:
    dc.l    0x11111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111110
    dc.l    0x00000000
    
Tile_f_lower:
    dc.l    0x11111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x00000000

Tile_g_lower:
    dc.l    0x00111100
    dc.l    0x01000010
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10001110
    dc.l    0x01000010
    dc.l    0x00111010
    dc.l    0x00000000
    
Tile_h_lower:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111110
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_i_lower:
    dc.l    0x11111110
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x11111110
    dc.l    0x00000000

Tile_j_lower:
    dc.l    0x00000110
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x10000100
    dc.l    0x01111000
    dc.l    0x00000000
    
Tile_k_lower:
    dc.l    0x10000010
    dc.l    0x10000100
    dc.l    0x10001000
    dc.l    0x11110000
    dc.l    0x10001000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x00000000

Tile_l_lower:
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x11111110
    dc.l    0x00000000

Tile_m_lower:
    dc.l    0x10000010
    dc.l    0x11000110
    dc.l    0x10101010
    dc.l    0x10010010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_n_lower:
    dc.l    0x10000010
    dc.l    0x11000010
    dc.l    0x10100010
    dc.l    0x10010010
    dc.l    0x10001010
    dc.l    0x10000110
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_o_lower:
    dc.l    0x00111000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00111000
    dc.l    0x00000000
    
Tile_p_lower:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x00000000
    
Tile_q_lower:
    dc.l    0x00111000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10001010
    dc.l    0x01000100
    dc.l    0x00111010
    dc.l    0x00000000
    
Tile_r_lower:
    dc.l    0x11111100
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x11111100
    dc.l    0x10001000
    dc.l    0x10000100
    dc.l    0x10000010
    dc.l    0x00000000

Tile_s_lower:
    dc.l    0x01111110
    dc.l    0x10000000
    dc.l    0x10000000
    dc.l    0x01111100
    dc.l    0x00000010
    dc.l    0x00000010
    dc.l    0x11111100
    dc.l    0x00000000
    
Tile_t_lower:
    dc.l    0x11111110
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_u_lower:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01111100
    dc.l    0x00000000
    
Tile_v_lower:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00000000
    
Tile_w_lower:
    dc.l    0x10000010
    dc.l    0x10000010
    dc.l    0x10010010
    dc.l    0x10010010
    dc.l    0x10101010
    dc.l    0x10101010
    dc.l    0x11000110
    dc.l    0x00000000
    
Tile_x_lower:
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00101000
    dc.l    0x01000100
    dc.l    0x10000010
    dc.l    0x00000000
    
Tile_y_lower:
    dc.l    0x10000010
    dc.l    0x01000100
    dc.l    0x00101000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_z_lower:
    dc.l    0x11111110
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x11111110
    dc.l    0x00000000
;0x7B
Tile_left_brace:
    dc.l    0x00010000
    dc.l    0x00100000
    dc.l    0x00100000
    dc.l    0x01000000
    dc.l    0x00100000
    dc.l    0x00100000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_pipe:
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_right_brace:
    dc.l    0x00010000
    dc.l    0x00001000
    dc.l    0x00001000
    dc.l    0x00000100
    dc.l    0x00001000
    dc.l    0x00001000
    dc.l    0x00010000
    dc.l    0x00000000

Tile_tilde:
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00110010
    dc.l    0x01001100
    dc.l    0x00000000
    dc.l    0x00000000
    dc.l    0x00000000
    
Tile_del: ;non-printing
    rept 8
    dc.l    0x00000000
    endr
