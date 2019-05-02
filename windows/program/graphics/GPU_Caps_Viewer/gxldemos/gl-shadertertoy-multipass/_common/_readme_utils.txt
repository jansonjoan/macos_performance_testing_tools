
Loading a texture (INIT script)
--------------------------------------------------------------

local abs_path = 0
local PF_U8_RGB = 1
local PF_U8_RGBA = 3
local pixel_format = PF_U8_RGB
local gen_mipmaps = 0
local compressed_texture = 0
local free_cpu_memory = 1
tex0 = gh_texture.create_from_file("./data/tex19.png", pixel_format, abs_path, gen_mipmaps, compressed_texture, free_cpu_memory)



Binding a texture (FRAME script)
--------------------------------------------------------------

gh_texture.bind(tex0, 0)
gh_gpu_program.uniform1i(shadertoy_prog, "iChannel0", 0)



Texture in the pixel shader
-----------------------------

uniform sampler2D iChannel0; 

vec4 c = texture2D(iChannel0, uv);
