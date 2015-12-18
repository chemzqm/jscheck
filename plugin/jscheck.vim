" ============================================================================
" Description: Javascript syntax check only plugin
" Author: Qiming Zhao <chemzqm@gmail.com>
" Licence: Vim licence
" Version: 0.1
" ============================================================================

if exists('g:jscheck_loaded') && !get(g:, 'jscheck_debug_mode', 0)
    finish
endif
let g:jscheck_loaded = 1

let s:jscheck = expand('<sfile>:h:h').'/bin/check'
let s:folder = expand('<sfile>:h:h')
let s:errorformat = '%E%f|%l col %c Error|%m'

function! s:ShowError(msg)
  echohl ErrorMsg | echon a:msg
endfunction

if !executable(s:jscheck)
  call s:ShowError('executable jscheck not found')
  finish
endif

function! s:CheckCurrentFile()
  if (&filetype !=# 'javascript') | return | endif
  let lines = getline(1, '$')
  let res = system(s:jscheck, lines)
  if v:shell_error && res !=# ""
    call s:ShowError(res)
    return
  endif
  let list = map(split(res, '\n'), 's:Format(v:val)')
  " errorformat
  let old_local_errorformat = &l:errorformat
  let old_errorformat = &errorformat
  let &errorformat = s:errorformat
  let &l:errorformat = s:errorformat
  silent lexpr list
  let rawlist = getloclist(0)
  let &l:errorformat = old_local_errorformat
  let &errorformat = old_errorformat

  call s:ShowNotifier(rawlist)
endfunction

function! s:ShowNotifier(rawlist)
  if exists('g:SyntasticSignsNotifier')
    let loclist = g:SyntasticLoclist.New(a:rawlist)
    let b:syntastic_loclist = loclist
    call g:SyntasticSignsNotifier.refresh(loclist)
    if exists('g:SyntasticCursorNotifier')
      call g:SyntasticCursorNotifier.refresh(loclist)
    endif
    if exists('g:SyntasticBalloonsNotifier')
      call g:SyntasticBalloonsNotifier.refresh(loclist)
    endif
    if exists('g:SyntasticHighlightingNotifier')
      call g:SyntasticHighlightingNotifier.refresh(loclist)
    endif
  endif
endfunction

function! s:Format(line)
  let item = split(a:line, ':')
  return printf('%s|%d col %d Error|%s',
    \ bufname('%'), item[1], item[2], item[3])
endfunction

function! s:InstallDependencies()
  if !isdirectory(s:folder . '/node_modules')
    let install = input('JSCheck dependencies not found, would you like to install [y/n]?')
    if install ==? 'y'
      if !executable('npm')
          echohl ErrorMsg | echon 'npm command not found, install node from https://nodejs.org/'
      else
        let old_cwd = getcwd()
        execute 'cd ' . s:folder
        let output = system('npm install')
        if v:shell_error && output !=# ""
          call s:ShowError(output)
          return
        endif
        echo "install succeed!\n"
        execute 'cd ' . old_cwd
      endif
    endif
  endif
endfunction

command! -nargs=0 JSCheck :call s:CheckCurrentFile ()

augroup jscheck
  autocmd!
  if !exists('g:jscheck_no_autocheck') || get(g:, 'g:jscheck_no_autocheck', 0)
    autocmd BufWritePost * :call s:CheckCurrentFile()
  endif
  autocmd VimEnter * :call s:InstallDependencies()
augroup end
