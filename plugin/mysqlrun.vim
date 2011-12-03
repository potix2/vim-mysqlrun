"=============================================================================
" File: mysqlrun.vim
" Author: Katsunori Kanda <potix2@gmail.com>
" Last Change: 27-Nov-2011.
" WebPage: http://github.com/potix2/mysqlrun-vim
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


if &cp || (exists('s:loaded_mysqlrun_vim') && s:loaded_mysqlrun_vim)
    finish
endif
let s:loaded_mysqlrun_vim = 1

if !executable('mysql') && !exists('g:mysqlrun_bin')
  echohl ErrorMsg | echomsg "MySQLRun: require 'mysql' command or set g:mysqlrun_bin in your vimrc" | echohl None
  finish
endif

command! -nargs=? -range=% MySQLRun :call mysqlrun#command(<count>, <line1>, <line2>, <f-args>)

" vim:set et:
