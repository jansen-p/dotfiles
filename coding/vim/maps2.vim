"hjkl remaps
noremap ö l
noremap l k
noremap k j
noremap j h
"move to top
noremap J H  
"move to bottom
noremap Ö L 
"remap Join to H
noremap H J  

"remap vert. movement
noremap <C-k> <C-e>
noremap <C-l> <C-y>

nnoremap <C-w>k <C-w>j
nnoremap <C-w>l <C-w>k
nnoremap <C-w>j <C-w>h
nnoremap <C-w>ö <C-w>l

nmap <leader>w :w<cr>
nmap <leader>q :q<cr>
nmap <leader>x :x<cr>
" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

"changes working dir to current dir
nmap cd :cd %:h<cr> 
"nmap bd :bd!<cr> 

"map cd :cd %:p <CR>

"fuzzy search
map ; :Files<CR> 
map _ :History<CR>
map ß :Commands<CR>
map - :Buffers<CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
"map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

"open folds with space
noremap <space> za
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>
vnoremap <Space> zf

"tabs
noremap <S-Tab> gt
noremap <S-j> :bprevious<CR>
noremap <S-K>u: :bnext<CR>
noremap <Tab> <C-w>w

map <leader>f <Nop>
map <leader>f easymotion-bd-w


map <silent> ü :NERDTreeToggle<CR>
map <silent> Ü :Ranger<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>="EXPLAIN"/<CR><CR>


autocmd FileType python map # :exec '!python3' shellescape(@%, 1)<cr>
autocmd FileType r map # :exec '!Rscript' shellescape(@%, 1)<cr>
autocmd Filetype tex map # :call TakeScreenshot()<cr>
autocmd FileType sql map <buffer> # :call SendSQLQuery()<cr>
autocmd FileType text map <buffer> # :call SendmonetDBQuery()<cr>
autocmd FileType cpp map <buffer> # :exec '!make && ./Polyline'<cr>
autocmd FileType sh map # :exec '!sh' shellescape(@%, 1)<cr>

function SendSQLQuery() range
  echo system('psql -U postgres -c '.shellescape(join(getline(a:firstline, a:lastline), "\n")))
endfunction
function SendmonetDBQuery() range
  echo system('mclient -d testdb -s '.shellescape(join(getline(a:firstline, a:lastline), "\n")))
endfunction

function TakeScreenshot() range
	"call append(line('.'),system('~/.bin/screenshot.sh'))
	call append(line('.'),system('~/.bin/screenshot.sh '.shellescape(getcwd())))
	":s/.\{1}$//
endfunction


" to send text to :terminal
"augroup Terminal
"  au!
"  au TermOpen * let g:last_terminal_job_id = b:terminal_job_id
"augroup END

function! REPLSend(lines)
	"open terminal: :vsplit term://zsh
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction

command! REPLSendLine call REPLSend([getline('.')])

nnoremap <silent> <f6> :REPLSendLine<cr>


function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
