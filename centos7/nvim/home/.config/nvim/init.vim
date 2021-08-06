call plug#begin('~/.config/nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'
Plug 'morhetz/gruvbox'
"主题
Plug 'tomasiser/vim-code-dark'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'preservim/nerdtree'
Plug 'kevinhwang91/rnvimr'
" react jsx语法高亮
"Plug 'yuezk/vim-js'
"Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
"输入( 输出()
Plug 'jiangmiao/auto-pairs'
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
"显示dev图片
Plug 'ryanoasis/vim-devicons'
Plug 'kristijanhusak/defx-icons'
Plug 'jlanzarotta/bufexplorer'
" window管理
Plug 't9md/vim-choosewin'
"显示css的颜色代码的颜色
Plug 'ap/vim-css-color'
"vim内置输入法插件
Plug 'ZSaberLv0/ZFVimIM'
Plug 'ZSaberLv0/ZFVimJob' " 可选, 用于提升词库加载性能
"

call plug#end()
" 使用gruvbox配色
"autocmd vimenter * ++nested colorscheme gruvbox
colorscheme gruvbox
" 强制使用dark/light模式
set bg=dark
" 使用透明背景
hi Normal ctermfg=252 ctermbg=none

"codedark主题，vscode风格
"colorscheme codedark
"let g:airline_theme = 'codedark'


" 让Ranger取代Netrw并成为文件浏览器
let g:rnvimr_enable_ex = 1
" 选择文件后隐藏游侠
let g:rnvimr_enable_picker = 1
" 使用multipane模式启动(单列)可以按~手动切换
let g:rnvimr_ranger_cmd = 'ranger --cmd="set viewmode multipane"'
" JSX 语法高亮
" set filetypes as typescriptreact
autocmd BufNewFile,BufRead *.tsx,*.jsx,*.js set filetype=typescriptreact
"window选择器
" if you want to use overlay feature
let g:choosewin_overlay_enable = 1

source ~/.config/nvim/vimrc
source ~/.config/nvim/vimrc.maps
source ~/.config/nvim/plugins/coc.rc.vim
source ~/.config/nvim/plugins/denite.rc.vim
source ~/.config/nvim/plugins/defx.rc.vim
source ~/.config/nvim/plugins/vim-airline.rc.vim
source ~/.config/nvim/plugins/ZFVimIM_wubi/plugin/ZFVimIM_wubi.vim
"source /Users/itkey/Downloads/ZFVimIM_xiaohe-main/plugin/ZFVimIM_xiaohe.vim

