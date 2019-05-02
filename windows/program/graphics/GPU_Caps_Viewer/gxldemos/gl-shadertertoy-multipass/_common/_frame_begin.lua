
kx_frame_begin(0.0, 0.0, 0.0)


--elapsed_time = kx_gettime()


mx, my = kx_mouse_get_position()
my = winH - my

mz = gh_input.mouse_get_button_state(1)
mz = mz * winW



local platform_windows = 1 
local platform_osx = 2 
local platform_linux = 3 
if (gh_utils.get_platform() == platform_windows) then
  gh_window.keyboard_update_buffer(0)
end



for i=1, 256 do
  local kbcode = i
  local state = gh_input.keyboard_is_key_down(kbcode)
  set_keyboard_texture_v2(kbcode, state)
end



local KC_SPACE = 57
local KC_I = 23

if (is_key_down==0) then
  if (gh_input.keyboard_is_key_down(KC_SPACE) == 1) then
    is_key_down = 1
    if (do_animation == 1) then
      do_animation = 0
    else
      do_animation = 1
    end
  end
  
  if (gh_input.keyboard_is_key_down(KC_I) == 1) then
    is_key_down = 1
    if (display_info == 1) then
      display_info = 0
    else
      display_info = 1
    end
  end
end  
  

if (is_key_down==1) then
  if (gh_input.keyboard_is_key_down(KC_SPACE) == 0 and gh_input.keyboard_is_key_down(KC_I) == 0) then
    is_key_down = 0
  end
end  




		
gh_camera.bind(camera_ortho)
gh_renderer.set_depth_test_state(0)
--gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

