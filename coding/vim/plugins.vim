"easymotion
map <Leader> <Plug>(easymotion-prefix)
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)


"LaTeX
filetype plugin on
filetype indent on
let g:tex_flavor = 'latex'
"
"let g:Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
"autocompiling latex
set updatetime=2000
nmap <Leader>ll \le
autocmd CursorHold,CursorHoldI * silent! wall
"command Com !termite -e latexmk % &
"command Compile !termite -d %:p:h -e latexmk % &


"compile after writing
"au BufWritePost *.tex ! xelatex %
set runtimepath^=~/.vim/bundle/ctrlp.vim


"jupyter
" Run current file
nnoremap <buffer> <silent> <leader>r :JupyterRunFile<CR>
" Send a selection of lines
nnoremap <buffer> <silent> <leader>c :JupyterSendCell<CR>
nnoremap <buffer> <silent> <leader>l :JupyterSendRange<CR>
nmap     <buffer> <silent> <leader>v <Plug>JupyterRunTextObj
vmap     <buffer> <silent> <leader>v <Plug>JupyterRunVisual


"syntastic
set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_python_checkers = ['mypy']
let g:syntastic_python_mypy_args = "--ignore-missing-imports"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

"CTRL-> help ctrlspace
set hidden
set showtabline=1
hi link CtrlSpaceNormal   PMenu
hi link CtrlSpaceSelected PMenuSel
hi link CtrlSpaceSearch   Search
hi link CtrlSpaceStatus   StatusLine
hi link CtrlSpaceSearch IncSearch
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceSaveWorkspaceOnExit = 1

"vimtex
"nnoremap <leader>ls :VimtexForwardSearch<CR>
let g:tex_flavor = "pdflatex"
let g:vimtex_view_general_viewer = 'open -a preview'
"let g:vimtex_latexmk_progname= '/usr/bin/nvr'
"let g:vimtex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -shell-escape -synctex=1'"
"let g:vimtex_view_general_options_latexmk = '-reuse-instance'
"let g:vimtex_fold_enabled = 0
"let g:vimtex_toc_resize = 0
"let g:vimtex_toc_hide_help = 1
"let g:vimtex_indent_enabled = 1
"let g:vimtex_latexmk_enabled = 1
"let g:vimtex_latexmk_callback = 1
"let g:vimtex_complete_recursive_bib = 0
"let g:vimtex_view_method = 'okular'
"let g:vimtex_complete_close_braces = 1
"let g:vimtex_quickfix_mode = 2
"let g:vimtex_quickfix_open_on_warning = 1
"let g:vimtex_quickfix_ignored_warnings = [
"        \ 'Underfull',
"        \ 'Overfull',
"        \ 'specifier changed to',
"      \ ]


"airline
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#virtualenv#enaled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'jellybeans'
"let g:airline_extensions = []

"autoformat
"au BufWrite * :Autoformat

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'


"ultisnips
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
"let g:UltiSnipsNoPythonWarning = 1
"
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger="<tab>"
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
	let snippet = UltiSnips#ExpandSnippetOrJump()
	if g:ulti_expand_or_jump_res > 0
		return snippet
	else
		return "\<CR>"
	endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"


let g:UltiSnipsJumpForwardTrigger = '<c-k>'
let g:UltiSnipsJumpBackwardTrigger = '<c-l>'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]


"YCM
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_max_num_candidates = 20
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_filetype_whitelist = {
			\ 'python': 1,
			\ 'cpp': 1,
			\ 'r': 1,
			\ 'java': 1
			\}

"map Ö :NERDTree %
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif "autostart NTree if no file specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif "directly close vim if only NTree open
let NERDTreeShowHidden=1
let NERDTreeDirArrows = 1
"let g:NERDTreeChDirMode = 2
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let NERDTreeAutoDeleteBuffer = 1 "autodelete buffer of file just deleted by nerdtree

let g:jedi#use_tabs_not_buffers = 1
"let g:jedi#use_splits_not_buffers = "right"
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = "1"

"let g:jedi#goto_command = "<leader>d"
"let g:jedi#goto_assignments_command = "<leader>g"
"let g:jedi#goto_stubs_command = "<leader>s"
"let g:jedi#goto_definitions_command = ""
"let g:jedi#documentation_command = "K"
"let g:jedi#usages_command = "<leader>n"
"let g:jedi#completions_command = "<C-Space>"
"let g:jedi#rename_command = "<leader>r"


set wildmenu
set cpo-=<
set wcm=<c-z>
map <f4> :emenu <c-z>
