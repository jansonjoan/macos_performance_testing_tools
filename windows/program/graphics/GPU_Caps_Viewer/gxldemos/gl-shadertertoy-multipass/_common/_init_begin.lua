--[[
Load and init the GFX v3 helper library.
--]]
local lib_dir = gh_utils.get_scripting_libs_dir() 		
local framework_dir = lib_dir .. "lua/framework_v1/"
dofile(framework_dir .. "kx.lua") -- kx framework.

--dofile(lib_dir .. "lua/gfx03.lua")
dofile(lib_dir .. "lua/keyboard_codes.lua")


kx_init_begin(framework_dir)

kx_set_main_title("Shadertoy demo")

demo_sub_caption = ""


winW, winH = gh_window.getsize(0)


camera_ortho = kx_get_ortho_camera()

g_quad = gh_mesh.create_quad(winW, winH)

function draw_quad(x, y, width, height)
  gh_mesh.update_quad_size(g_quad, width, height)
  gh_object.set_position(g_quad, x, y, 0)
  gh_object.render(g_quad)
end  



rt_viewer = gh_node.getid("rt_viewer")
rt_clear = gh_node.getid("rt_clear")

shadertoy_prog_buf_a = gh_node.getid("shadertoy_prog_buf_a")
shadertoy_prog_buf_b = gh_node.getid("shadertoy_prog_buf_b")
shadertoy_prog_buf_c = gh_node.getid("shadertoy_prog_buf_c")
shadertoy_prog_buf_d = gh_node.getid("shadertoy_prog_buf_d")
shadertoy_prog_img = gh_node.getid("shadertoy_prog_img")




elapsed_time = 0
last_time = 0
time_step = 0
mx = 0
my = 0
mz = 0
frame = 0
is_key_down = 0
do_animation = 1
display_info = 1


-- Create all render targets. ----------------------------------
--
local num_color_targets = 1
local PF_U8_RGBA = 3
local PF_F32_RGBA = 6
local PF_F16_RGBA = 9
local pf = PF_F32_RGBA
local linear_filtering = 1
local clamp_addressing = 1
local samples = 0
local create_depth_texture = 1

buf_A = 0
buf_B = 0
buf_C = 0
buf_D = 0

if (shadertoy_prog_buf_a > 0) then
  buf_A = gh_render_target.create_ex_v4(winW, winH, num_color_targets, pf, linear_filtering, clamp_addressing, samples, create_depth_texture)
end
  
if (shadertoy_prog_buf_b > 0) then
  buf_B = gh_render_target.create_ex_v4(winW, winH, num_color_targets, pf, linear_filtering, clamp_addressing, samples, create_depth_texture)
end
  
if (shadertoy_prog_buf_c > 0) then
  buf_C = gh_render_target.create_ex_v4(winW, winH, num_color_targets, pf, linear_filtering, clamp_addressing, samples, create_depth_texture)
end
  
if (shadertoy_prog_buf_d > 0) then
  buf_D = gh_render_target.create_ex_v4(winW, winH, num_color_targets, pf, linear_filtering, clamp_addressing, samples, create_depth_texture)
end
  
  
img = gh_render_target.create_ex_v4(winW, winH, num_color_targets, PF_U8_RGBA, linear_filtering, clamp_addressing, samples, create_depth_texture)



-- Clear all render targets. ----------------------------------
--
gh_camera.bind(camera_ortho)
gh_renderer.set_depth_test_state(0)

gh_gpu_program.bind(rt_clear)

if (buf_A > 0) then
  gh_render_target.bind(buf_A)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 1.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_A)
end  


if (buf_B > 0) then
  gh_render_target.bind(buf_B)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 1.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_B)
end

if (buf_C > 0) then
  gh_render_target.bind(buf_C)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 1.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_C)
end

if (buf_D > 0) then
  gh_render_target.bind(buf_D)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 1.0, 1.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(buf_D)
end

if (img > 0) then
  gh_render_target.bind(img)
  gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  draw_quad(0, 0, winW, winH)
  gh_render_target.unbind(img)
end
  
-----------------------------------------------------------------





-----------------------------------------------------------------
-- Keyboard texture init
-----------------------------------------------------------------

--[[

-- http://www.geeks3d.com/hacklab/20160128/how-to-read-the-keyboard-in-a-glsl-shader/


-- http://synthclipse.sourceforge.net/user_guide/fragx/uniform_controls.html#keyboard

Keyboard Uniform Control can be used for reading a keyboard state (if a key is pressed or toggled). 
It is exact copy of the Shadertoy's keyboard input. The keyboard state is kept in a texture with dimensions 256 x 2. 
Each row represents the same set of 256 characters. Index (from 0 to 255) of a texel in a row equals to a key code 
which the texel represents. Key codes are compatible with JavaScript and the list of most notable ones can be found here.

Each texel has only one component - R - which can have only one of the two values: 0.0 (off), 1.0 (on). 
The Lower row (the one sampled with y <= 0.5) of the texture keeps track of the pressed (1.0) / released (0.0) key state. 
The upper row (the one sampled with y > 0.5) keeps track of whether a key is toggled or not.
--]]


g_toggle_state = {}
g_keyboard_prev_state = {}

local PF_U8_RGBA = 3
local PF_U8_R = 11
local x_size = 256
local y_size = 2
local k = 0
keyboard_tex = gh_texture.create_2d(x_size, y_size, PF_U8_RGBA)
for i=0, 255 do
  g_toggle_state[k+1] = 0
  g_keyboard_prev_state[k+1] = 0
  k = k + 1
  for j=0, 255 do
    gh_texture.set_texel_2d(keyboard_tex, i, j, 0, 0, 0, 255)
  end
end

local SAMPLER_FILTERING_NEAREST = 1
local SAMPLER_FILTERING_LINEAR = 2
local SAMPLER_ADDRESSING_WRAP = 1
local SAMPLER_ADDRESSING_CLAMP_TO_EDGE = 2
local SAMPLER_ADDRESSING_MIRROR = 3
gh_texture.bind(keyboard_tex, 0)
gh_texture.set_sampler_params(keyboard_tex, SAMPLER_FILTERING_NEAREST, SAMPLER_ADDRESSING_CLAMP_TO_EDGE, 1.0)
gh_texture.bind(0, 0)


g_keyboard_map = {}

for i=1, 256 do
    g_keyboard_map[i] = 0
end


function init_keyboard_map()
  -- http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
  -- http://keycode.info/
  --
  local js_backspace = 8
  local js_tab = 9
  local js_enter = 13
  local js_shift = 16
  local js_ctrl = 17
  local js_alt = 18
  local js_pause_break = 19
  local js_caps_lock = 20
  local js_escape = 27
  local js_space = 32
  local js_page_up = 33
  local js_page_down = 34
  local js_end = 35
  local js_home = 36
  local js_left_arrow =	37
  local js_up_arrow =	38
  local js_right_arrow = 39
  local js_down_arrow = 40
  local js_insert = 45
  local js_delete = 46
  local js_0 = 48
  local js_1 = 49
  local js_2 = 50
  local js_3 = 51
  local js_4 = 52
  local js_5 = 53
  local js_6 = 54
  local js_7 = 55
  local js_8 = 56
  local js_9 = 57
  local js_a = 65
  local js_b = 66
  local js_c = 67
  local js_d = 68
  local js_e = 69
  local js_f = 70
  local js_g = 71
  local js_h = 72
  local js_i = 73
  local js_j = 74
  local js_k = 75
  local js_l = 76
  local js_m = 77
  local js_n = 78
  local js_o = 79
  local js_p = 80
  local js_q = 81
  local js_r = 82
  local js_s = 83
  local js_t = 84
  local js_u = 85
  local js_v = 86
  local js_w = 87
  local js_x = 88
  local js_y = 89
  local js_z = 90
  local js_left_window_key = 91
  local js_right_window_key = 92
  local js_select_key = 93
  local js_numpad_0 = 96
  local js_numpad_1 = 97
  local js_numpad_2 = 98
  local js_numpad_3 = 99
  local js_numpad_4 = 100
  local js_numpad_5 = 101
  local js_numpad_6 = 102
  local js_numpad_7 = 103
  local js_numpad_8 = 104
  local js_numpad_9 = 105
  local js_multiply = 106
  local js_add = 107
  local js_subtract = 109
  local js_decimal_point = 110
  local js_divide = 111
  local js_f1 = 112
  local js_f2 = 113
  local js_f3 = 114
  local js_f4 = 115
  local js_f5 = 116
  local js_f6 = 117
  local js_f7 = 118
  local js_f8 = 119
  local js_f9 = 120
  local js_f10 = 121
  local js_f11 = 122
  local js_f12 = 123
  local js_num_lock = 144
  local js_scroll_lock = 145
  local js_semi_colon = 186
  local js_equal_sign = 187
  local js_comma = 188
  local js_dash = 189
  local js_period = 190
  local js_forward_slash = 191
  local js_grave_accent = 192
  local js_open_bracket = 219
  local js_back_slash = 220
  local js_close_braket = 221
  local js_single_quote = 222

  g_keyboard_map[KC_A] = js_a
  g_keyboard_map[KC_B] = js_b
  g_keyboard_map[KC_C] = js_c
  g_keyboard_map[KC_D] = js_d
  g_keyboard_map[KC_E] = js_e
  g_keyboard_map[KC_F] = js_f
  g_keyboard_map[KC_G] = js_g
  g_keyboard_map[KC_H] = js_h
  g_keyboard_map[KC_I] = js_i
  g_keyboard_map[KC_J] = js_j
  g_keyboard_map[KC_K] = js_k
  g_keyboard_map[KC_L] = js_l
  g_keyboard_map[KC_M] = js_m
  g_keyboard_map[KC_N] = js_n
  g_keyboard_map[KC_O] = js_o
  g_keyboard_map[KC_P] = js_p
  g_keyboard_map[KC_Q] = js_q
  g_keyboard_map[KC_R] = js_r
  g_keyboard_map[KC_S] = js_s
  g_keyboard_map[KC_T] = js_t
  g_keyboard_map[KC_U] = js_u
  g_keyboard_map[KC_V] = js_v
  g_keyboard_map[KC_W] = js_w
  g_keyboard_map[KC_X] = js_x
  g_keyboard_map[KC_Y] = js_y
  g_keyboard_map[KC_Z] = js_z

  g_keyboard_map[KC_0] = js_0
  g_keyboard_map[KC_1] = js_1
  g_keyboard_map[KC_2] = js_2
  g_keyboard_map[KC_3] = js_3
  g_keyboard_map[KC_4] = js_4
  g_keyboard_map[KC_5] = js_5
  g_keyboard_map[KC_6] = js_6
  g_keyboard_map[KC_7] = js_7
  g_keyboard_map[KC_8] = js_8
  g_keyboard_map[KC_9] = js_9

  g_keyboard_map[KC_LEFT] = js_left_arrow
  g_keyboard_map[KC_UP] = js_up_arrow
  g_keyboard_map[KC_RIGHT] = js_right_arrow
  g_keyboard_map[KC_DOWN] = js_down_arrow

  g_keyboard_map[KC_F1] = js_f1
  g_keyboard_map[KC_F2] = js_f2
  g_keyboard_map[KC_F3] = js_f3
  g_keyboard_map[KC_F4] = js_f4
  g_keyboard_map[KC_F5] = js_f5
  g_keyboard_map[KC_F6] = js_f6
  g_keyboard_map[KC_F7] = js_f7
  g_keyboard_map[KC_F8] = js_f8
  g_keyboard_map[KC_F9] = js_f9
  g_keyboard_map[KC_F10] = js_f10
  g_keyboard_map[KC_F11] = js_f11
  g_keyboard_map[KC_F12] = js_f12

  g_keyboard_map[KC_SPACE] = js_space
  g_keyboard_map[KC_LEFT_SHIFT] = js_shift
  g_keyboard_map[KC_RIGHT_SHIFT] = js_shift
  g_keyboard_map[KC_ESCAPE] = js_escape
  g_keyboard_map[KC_BACK] = js_backspace
  g_keyboard_map[KC_TAB] = js_tab
  g_keyboard_map[KC_RETURN] = js_enter
  g_keyboard_map[KC_PGDOWN] = js_page_down
  g_keyboard_map[KC_PGUP] = js_page_up
  g_keyboard_map[KC_HOME] = js_home
  g_keyboard_map[KC_END] = js_end
  g_keyboard_map[KC_INSERT] = js_insert
  g_keyboard_map[KC_DELETE] = js_delete


  g_keyboard_map[KC_ADD] = js_add
  g_keyboard_map[KC_SUBTRACT] = js_subtract
  g_keyboard_map[KC_MULTIPLY] = js_multiply
  g_keyboard_map[KC_DIVIDE] = js_divide

  g_keyboard_map[KC_NUMLOCK] = js_num_lock

  g_keyboard_map[KC_NUMPAD0] = js_numpad_0
  g_keyboard_map[KC_NUMPAD1] = js_numpad_1
  g_keyboard_map[KC_NUMPAD2] = js_numpad_2
  g_keyboard_map[KC_NUMPAD3] = js_numpad_3
  g_keyboard_map[KC_NUMPAD4] = js_numpad_4
  g_keyboard_map[KC_NUMPAD5] = js_numpad_5
  g_keyboard_map[KC_NUMPAD6] = js_numpad_6
  g_keyboard_map[KC_NUMPAD7] = js_numpad_7
  g_keyboard_map[KC_NUMPAD8] = js_numpad_8
  g_keyboard_map[KC_NUMPAD9] = js_numpad_9

  g_keyboard_map[KC_NUMPAD_ENTER] = js_enter
end  

function set_keyboard_texture_v1(gxl_kb_code, state)
  local k = g_keyboard_map[gxl_kb_code]
  local v = 0
  if (state == 1) then
    v = 255
  end
  gh_texture.set_texel_2d(keyboard_tex, k, 0, v,  255, 255, 255)
  gh_texture.set_texel_2d(keyboard_tex, k, 1, v,  255, 255, 255)
end


function set_keyboard_texture_v2(gxl_kb_code, state)
  local k = g_keyboard_map[gxl_kb_code]
  if (k == nil) then
    return
  end

  local v = 0
  if (state == 1) then
    v = 255
  end
  
  --[[
  if (k == 32) then 
    print("k=".. k .. " - gxl_kb_code=" .. gxl_kb_code .. " - v=" .. v)
  end
  --]]
  
  local row = 1
  gh_texture.set_texel_2d(keyboard_tex, k, row, v,  0, 0, 255)

  row = 0
  --gh_texture.set_texel_2d(keyboard_tex, k, row, v,  0, 0, 255)
  
  ---[[
  local prev_state = g_keyboard_prev_state[k+1]

  if (state == 1 and prev_state == 0) then
    g_keyboard_prev_state[k+1] = 1
    local toggled = g_toggle_state[k+1]
    if (toggled == 0) then
      g_toggle_state[k+1] = 1
      gh_texture.set_texel_2d(keyboard_tex, k, row, 255, 255, 0, 255)
    else 
      g_toggle_state[k+1] = 0
      gh_texture.set_texel_2d(keyboard_tex, k, row, 0, 0, 0, 255)
    end
  end

  if (state == 0) then
    g_keyboard_prev_state[k+1] = 0
  end
  --]]
end


init_keyboard_map()



