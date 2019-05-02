echo off
rem Options:
rem /demo_win_width=width                    :   width of the benchmark window 
rem /demo_win_height=height                   :   height of the benchmark window 
rem /demo_fullscreen                             : fullscreen mode   
rem /demo_msaa=msaa                          : msaa level (0, 2, 4 or 8)
rem /benchmark_log_results                    :  write benchmark result in the file _gxl_benchmark_results.csv
rem /benchmark_duration=ms                 :  benchmark duration in milli-seconds
rem /vk_gpu_index=gpu                          : GPU index (zero-based) for Vulkan demos
rem /run_gxl_demo=demo_codename      : run a particular demo from its codename
rem 
rem Demo codenames:
rem vk_shadertoy_geomechanical 
rem vk_shadertoy_seascape        
rem vk_normal_mapping              
rem vk_phong_lighting2  
rem vk_phong_lighting              
rem vk_triangle                         
rem gl_triangle
rem gl32_phong_lighting
rem gl32_geometry_instancing
rem gl32_gs_mesh_exploder        
rem gl21_cellshading
rem gl21_shadertoy_mp_alien_corridor 
rem gl21_shadertoy_mp_rainforest 
rem gl21_shadertoy_mp_radialblur  
rem gl21_shadertoy_mp_rhodium    
rem gl40_tessellation                   
rem gl32_env_sphere_mapping      

call GPU_Caps_Viewer.exe /demo_win_width=1920 /demo_win_height=1080 /demo_fullscreen /run_gxl_demo=vk_shadertoy_geomechanical /benchmark_log_results /benchmark_duration=10000 /demo_msaa=0  /vk_gpu_index=0 
rem call GPU_Caps_Viewer.exe /demo_win_width=1920 /demo_win_height=1080 /demo_fullscreen /run_gxl_demo=vk_shadertoy_seascape /benchmark_log_results /benchmark_duration=10000 /demo_msaa=0  /vk_gpu_index=0 
call GPU_Caps_Viewer.exe /demo_win_width=1920 /demo_win_height=1080 /demo_fullscreen /run_gxl_demo=gl21_cellshading /benchmark_log_results /benchmark_duration=10000 /demo_msaa=0 
rem pause
