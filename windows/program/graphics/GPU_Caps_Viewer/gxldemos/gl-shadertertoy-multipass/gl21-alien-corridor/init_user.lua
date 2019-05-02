
-- demo_sub_caption = "Hello!"

---[[
local abs_path = 0
local PF_U8_RGB = 1
local PF_U8_RGBA = 3
local pixel_format = PF_U8_RGB
local gen_mipmaps = 0
local compressed_texture = 0
local free_cpu_memory = 1
tex19 = gh_texture.create_from_file("../_data/tex19.png", pixel_format, abs_path, gen_mipmaps, compressed_texture, free_cpu_memory)
--]]