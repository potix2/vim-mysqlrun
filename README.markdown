mysqlrun.vim
============

Run quickly your editing buffer as a SQL script in a mysql client.

For the latest version please see https://github.com/potix2/mysqlrun-vim.

Usage:
------

- Run current buffer as a SQL script in a mysql client.

        :MySQLRun

- Run selected text as a SQL script in a mysql client.

        :'<,'>MySQLRun

Tips:
-----

- change connection settings

    By default, mysqlrun try to connect to localhost as root. If you want to change
    the connection settings, edit following code and put in your vimrc.

        let g:mysqlrun_current_user = 'root'
        let g:mysqlrun_current_host = 'localhost'
        let g:mysqlrun_current_port = '3316'
        let g:mysqlrun_current_password = ''

- set default database

        let g:mysqlrun_current_db = 'put your database name'

- change the policy of the password requirement

        let g:mysqlrun_require_password = 0

- change the path of the mysql command

        let g:mysqlrun_bin = '/path/to/mysql'

- others

        let g:mysqlrun_bufhidden = ''

Requirements:
--------

- mysql command

License:
--------

    Copyright (c) 2011 Katsunori Kanda

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

Install:
--------
Copy it to your plugin directory.
