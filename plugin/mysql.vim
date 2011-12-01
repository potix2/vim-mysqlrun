"=============================================================================
" File: mysql.vim
" Author: Katsunori Kanda <potix2@gmail.com>
" Last Change: 27-Nov-2011.
" WebPage: http://github.com/potix2/mysql-vim
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 0.1
"=============================================================================


if &cp || (exists('s:loaded_mysql_vim') && g:loaded_mysql_vim)
    finish
endif
let s:loaded_mysql_vim = 1

if !executable('mysql') && !exists('g:mysql_bin')
  echohl ErrorMsg | echomsg "MySQL: require 'mysql' command or set g:mysql_bin in your vimrc" | echohl None
  finish
endif

command! -nargs=? -range=% MySQL :call mysql#command(<count>, <line1>, <line2>, <f-args>)

" default key mapping {{{
nnoremap <Leader>mq <Plug>(mysql) :<C-u>MySQL -q
nnoremap <Leader>mb <Plug>(mysql) :<C-u>MySQL -b<CR>
nnoremap <Leader>md <Plug>(mysql) :<C-u>MySQL -d
" }}}

" vim:set et:
