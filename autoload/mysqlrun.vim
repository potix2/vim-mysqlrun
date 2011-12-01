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

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:mysqlrun_current_user")
    let g:mysqlrun_current_user = 'root'
endif
if !exists("g:mysqlrun_require_password")
    let g:mysqlrun_require_password = 1
endif
if !exists("g:mysqlrun_current_host")
    let g:mysqlrun_current_host = ''
endif
if !exists("g:mysqlrun_current_port")
    let g:mysqlrun_current_port = ''
endif
if exists("g:mysqlrun_current_password")
    let g:mysqlrun_require_password = 1
endif

if !exists('g:mysqlrun_bufhidden')
    let g:mysqlrun_bufhidden = ''
endif
if !exists('g:mysqlrun_bin')
    let g:mysqlrun_bin = 'mysql'
endif
"if !exists('g:mysqlrun_new_result_buffer')
"    let g:mysqlrun_new_result_buffer = 0
"endif

let s:bufname = 'mysqlrun' . (has('unix') ? ':' : '_') .'result'

function! mysqlrun#version()
  return str2nr(printf('%02d%02d%03d', 0, 1, 0))
endfunction

function! s:MySQLRunSelectDB(args)
    let g:mysqlrun_current_db = a:args
endfunction

function! s:MySQLRunExecute(content)
    if !exists("g:mysqlrun_current_db")
        redraw
        let dbname = input("Database> ")
        call s:MySQLRunSelectDB(dbname)
    endif

    let file = tempname()
    call writefile(a:content,file)
    let cmdlist = [g:mysqlrun_bin, "-u " . g:mysqlrun_current_user]
    if g:mysqlrun_require_password
        if exists("g:mysqlrun_current_password")
            if strlen(g:mysqlrun_current_password) > 0
                call add(cmdlist, "-p" . g:mysqlrun_current_password)
            else
                call add(cmdlist, "-p''")
            endif
        else
            let password = inputsecret("Password> ")
            call add(cmdlist, "-p'" . password . "'")
        endif
    endif
    if strlen(g:mysqlrun_current_host) > 0
        call add(cmdlist, "-h " . g:mysqlrun_current_host)
    endif
    if strlen(g:mysqlrun_current_port) > 0
        call add(cmdlist, "-p " . g:mysqlrun_current_port)
    endif

    call add(cmdlist, g:mysqlrun_current_db)
    redraw
    let res = system(join(cmdlist, " ") . ' < '.file)
    call delete(file)

    call s:MySQLRunOpenResultBuffer(res)
endfunction

"function! s:MySQLRunQuery(query)
"    call s:MySQLRunExecute(a:query)
"endfunction

"function! s:MySQLRunQueryBuffer()
"    let content = join(getline(1, line('$')), "\n")
"    call s:MySQLRunExecute(content)
"endfunction

function! s:MySQLRunOpenResultBuffer(content)
    let winnum = bufwinnr(bufnr(s:bufname))
    if winnum != -1
        if winnum != bufwinnr('%')
            exe winnum 'wincmd w'
        endif
    else
        exec 'silent noautocmd split' s:bufname
    endif

    setlocal buftype=nofile readonly modifiable
    execute 'setlocal bufhidden=' . g:mysqlrun_bufhidden

    silent put=a:content
    keepjumps 0d
    setlocal nomodifiable
endfunction

function! mysqlrun#command(count, line1, line2, ...)"{{{
  redraw

  "TODO: add select db option
"  let args = (a:0 > 0) ? split(a:1, ' ') : []
  if a:count > 1
      let content = getline(a:line1, a:line2)
  else
      let content = getline(1, line('$'))
  endif

  call s:MySQLRunExecute(content)
  return 1
endfunction"}}}


let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
