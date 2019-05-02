


if ((buf_A > 0) and (shadertoy_prog_buf_a > 0)) then

  gh_render_target.bind(buf_A)

  gh_gpu_program.bind(shadertoy_prog_buf_a)
  gh_gpu_program.uniform3f(shadertoy_prog_buf_a, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_buf_a, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_a, "iMouse", mx, my, mz, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_a, "iFrame", frame)
  
  --gh_texture.rt_color_bind(buf_A, 0)
  gh_texture.bind(tex19, 0)

  gh_gpu_program.uniform1i(shadertoy_prog_buf_a, "iChannel0", 0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(buf_A)
    
end  


if ((buf_B > 0) and (shadertoy_prog_buf_b > 0)) then

  gh_render_target.bind(buf_B)

  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

  gh_gpu_program.bind(shadertoy_prog_buf_b)
  gh_gpu_program.uniform3f(shadertoy_prog_buf_b, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_buf_b, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_b, "iMouse", mx, my, mz, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_b, "iFrame", frame)
  
  gh_texture.rt_color_bind_v2(buf_A, 0, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_b, "iChannel0", 0)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_b, "iChannelResolution0", winW, winH, 0.0, 0.0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(buf_B)
    
end  



if ((buf_C > 0) and (shadertoy_prog_buf_c > 0)) then

  gh_render_target.bind(buf_C)

  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

  gh_gpu_program.bind(shadertoy_prog_buf_c)
  gh_gpu_program.uniform3f(shadertoy_prog_buf_c, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_buf_c, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_c, "iMouse", mx, my, mz, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_c, "iFrame", frame)
  
  gh_texture.rt_color_bind_v2(buf_B, 0, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_c, "iChannel0", 0)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_c, "iChannelResolution0", winW, winH, 0.0, 0.0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(buf_C)
    
end  

if ((buf_D > 0) and (shadertoy_prog_buf_d > 0)) then

  gh_render_target.bind(buf_D)

  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

  gh_gpu_program.bind(shadertoy_prog_buf_d)
  gh_gpu_program.uniform3f(shadertoy_prog_buf_d, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_buf_d, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_d, "iMouse", mx, my, mz, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_d, "iFrame", frame)
  
  gh_texture.rt_color_bind_v2(buf_C, 0, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_c, "iChannel0", 0)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_c, "iChannelResolution0", winW, winH, 0.0, 0.0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(buf_D)
    
end  


if ((img > 0) and (shadertoy_prog_img > 0)) then

  gh_render_target.bind(img)

  gh_gpu_program.bind(shadertoy_prog_img)
  gh_gpu_program.uniform3f(shadertoy_prog_img, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_img, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_img, "iMouse", mx, my, mz, 0)
  
  gh_texture.rt_color_bind(buf_D, 0)
  gh_texture.rt_color_bind(buf_A, 1)
  gh_gpu_program.uniform1i(shadertoy_prog_img, "iChannel0", 0)
  gh_gpu_program.uniform1i(shadertoy_prog_img, "iChannel1", 1)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(img)
    
end  
