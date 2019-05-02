
kx_resize()


winW, winH = gh_window.getsize(0)
gh_mesh.update_quad_size(g_quad, winW, winH)



gh_render_target.resize(buf_A, winW, winH)
gh_render_target.resize(buf_B, winW, winH)
gh_render_target.resize(buf_C, winW, winH)
gh_render_target.resize(buf_D, winW, winH)
gh_render_target.resize(img, winW, winH)


