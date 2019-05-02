

if ((buf_A > 0) and (shadertoy_prog_buf_a > 0)) then

  gh_render_target.bind(buf_A)

  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)

  gh_gpu_program.bind(shadertoy_prog_buf_a)
  gh_gpu_program.uniform3f(shadertoy_prog_buf_a, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_buf_a, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_a, "iMouse", mx, my, 1, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_a, "iFrame", frame)
  
  --gh_texture.rt_color_bind(img, 0)
  gh_texture.bind(tex0, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_buf_a, "iChannel0", 0)
  --gh_gpu_program.uniform1i(shadertoy_prog_buf_a, "iChannel1", 1)
  gh_gpu_program.uniform4f(shadertoy_prog_buf_a, "iChannelResolution0", 512, 512, 0.0, 0.0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(buf_A)
    
end  


if ((img > 0) and (shadertoy_prog_img > 0)) then

  gh_render_target.bind(img)

  --gh_renderer.clear_color_depth_buffers(0.0, 0.0, 0.0, 0.0, 1.0)
  
  gh_gpu_program.bind(shadertoy_prog_img)
  gh_gpu_program.uniform3f(shadertoy_prog_img, "iResolution", winW, winH, 0.0)
  gh_gpu_program.uniform1f(shadertoy_prog_img, "iGlobalTime", elapsed_time)
  gh_gpu_program.uniform4f(shadertoy_prog_img, "iMouse", mx, my, 0, 0)
  
  gh_texture.rt_color_bind(buf_A, 0)
  gh_gpu_program.uniform1i(shadertoy_prog_img, "iChannel0", 0)
  
  draw_quad(0, 0, winW, winH)  
  
  gh_render_target.unbind(img)
    
end  

