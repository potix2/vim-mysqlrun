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

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:mysql_current_user")
    let g:mysql_current_user = 'root'
endif
if !exists("g:mysql_require_password")
    let g:mysql_require_password = 1
endif
if !exists("g:mysql_current_host")
    let g:mysql_current_host = ''
endif
if !exists("g:mysql_current_port")
    let g:mysql_current_port = ''
endif
if exists("g:mysql_current_password")
    let g:mysql_require_password = 1
endif

if !exists('g:mysql_bufhidden')
    let g:mysql_bufhidden = ''
endif
if !exists('g:mysql_bin')
    let g:mysql_bin = 'mysql'
endif
if !exists('g:mysql_new_result_buffer')
    let g:mysql_new_result_buffer = 0
endif

let s:bufprefix = 'mysql' . (has('unix') ? ':' : '_')

function! mysql#version()"{{{
  return str2nr(printf('%02d%02d%03d', 0, 1, 0))
endfunction"}}}

function! s:MySQLRunSelectDB(args)
    let g:mysql_current_db = a:args
endfunction

function! s:MySQLRunExecute(content)
    if !exists("g:mysql_current_db")
        let dbname = input("Database> ")
        call s:MySQLRunSelectDB(dbname)
    endif

    let file = tempname()
    call writefile([a:content],file)
    let cmdlist = [g:mysql_bin, "-u " . g:mysql_current_user]
    if g:mysql_require_password
        if exists("g:mysql_current_password")
            if strlen(g:mysql_current_password) > 0
                call add(cmdlist, "-p" . g:mysql_current_password)
            else
                call add(cmdlist, "-p''")
            endif
        else
            call add(cmdlist, "-p")
        endif
    endif
    if strlen(g:mysql_current_host) > 0
        call add(cmdlist, "-h " . g:mysql_current_host)
    endif
    if strlen(g:mysql_current_port) > 0
        call add(cmdlist, "-p " . g:mysql_current_port)
    endif

    call add(cmdlist, g:mysql_current_db)
    redraw
    let res = system(join(cmdlist, " ") . ' < '.file)
    call delete(file)

    call s:MySQLRunOpenResultBuffer(res)
endfunction

function! s:MySQLRunQuery(query)
    call s:MySQLRunExecute(a:query)
endfunction

function! s:MySQLRunQueryBuffer()
    let content = join(getline(1, line('$')), "\n")
    call s:MySQLRunExecute(content)
endfunction

function! s:MySQLRunOpenResultBuffer(content)
    let winnum = bufwinnr(bufnr(s:bufprefix))
    if winnum != -1
        if winnum != bufwinnr('%')
            exe winnum 'wincmd w'
        endif
    else
        exec 'silent noautocmd split' s:bufprefix
    endif

"    if exists('b:is_mysql_msg_buffer') && b:is_mysql_msg_buffer
"        enew!
"    else
"        execute g:mysql_command_edit
"    endif

    setlocal buftype=nofile readonly modifiable
    execute 'setlocal bufhidden=' . g:mysql_bufhidden

    silent put=a:content
    keepjumps 0d
    setlocal nomodifiable

    let b:is_mysql_msg_buffer = 1
endfunction

function! mysql#command(count, line1, line2, ...)"{{{
  redraw

"  let args = (a:0 > 0) ? split(a:1, ' ') : []
  if a:count > 1
      let content = join(getline(a:line1, a:line2), "\n")
  else
      echo a:line1
      echo a:line2
      let content = join(getline(1, line('$')), "\n")
  endif

  call s:MySQLRunQuery(content)
  return 1
endfunction"}}}


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
