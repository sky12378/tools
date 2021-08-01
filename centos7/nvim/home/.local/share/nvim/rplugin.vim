" node plugins


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/<USER>/.vim/plugged/defx.nvim/rplugin/python3/defx', [
      \ {'sync': v:true, 'name': '_defx_init', 'type': 'function', 'opts': {}},
     \ ])
call remote#host#RegisterPlugin('python3', '/home/<USER>/.vim/plugged/denite.nvim/rplugin/python3/denite', [
      \ {'sync': v:true, 'name': '_denite_init', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


