


gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

gh_gpu_program.bind(rt_viewer)
gh_texture.rt_color_bind(img, 0)
gh_gpu_program.uniform1i(rt_viewer, "tex0", 0)
gh_object.render(g_quad)


if (display_info == 1) then
  local user_y_offset = winH-100
  if (demo_sub_caption ~= "") then
    kx_write_text(10, user_y_offset, 1.0, 0.75, 0.3, 1, demo_sub_caption)
    user_y_offset = user_y_offset + 20
  end  
  kx_write_text(10, user_y_offset, 1.0, 0.75, 0.3, 1, "[SPACE]: toggle animation")
  user_y_offset = user_y_offset + 20
  kx_write_text(10, user_y_offset, 1.0, 0.75, 0.3, 1, "[I]: toggle info/stats")
end


kx_frame_end(display_info)
  

  
frame = frame + 1

if (do_animation == 1) then
  local cur_time = kx_gettime()
  local dt = kx_getdt()
  time_step = dt
  last_time = elapsed_time
  elapsed_time = elapsed_time + dt
else
  time_step = 0
end  


