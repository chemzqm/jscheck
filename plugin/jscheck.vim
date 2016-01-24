" ============================================================================
" Description: Javascript syntax check only plugin
" Author: Qiming Zhao <chemzqm@gmail.com>
" Licence: Vim licence
" Version: 0.1
" ============================================================================

if exists('g:jscheck_loaded')
    finish
endif
let g:jscheck_loaded = 1

let s:jscheck = expand('<sfile>:h:h').'/bin/check'
let s:folder = expand('<sfile>:h:h')

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
  let list = map(split(res, '\n'), 's:Parse(v:val)')
  call setloclist(winnr(), list, 'r')
  let rawlist = getloclist(0)
  call s:ShowNotifier(rawlist)
endfunction

function! s:ShowNotifier(rawlist)
  if exists('g:SyntasticSignsNotifier')
    let loclist = g:SyntasticLoclist.New(a:rawlist)
    let b:syntastic_loclist = loclist
    call g:SyntasticSignsNotifier.refresh(loclist)
    if exists('g:SyntasticCursorNotifier') && get(g:, 'syntastic_echo_current_error', 1)
      call g:SyntasticCursorNotifier.refresh(loclist)
    endif
    if exists('g:SyntasticBalloonsNotifier') && get(g:, 'syntastic_enable_balloons', 1)
      call g:SyntasticBalloonsNotifier.refresh(loclist)
    endif
    if exists('g:SyntasticHighlightingNotifier') && get(g:, 'syntastic_enable_highlighting', 1)
      call g:SyntasticHighlightingNotifier.refresh(loclist)
    endif
  endif
endfunction

function! s:Parse(line)
  let item = split(a:line, ':')
  let nr = bufnr('%')
  return {'bufnr': nr,
        \ 'lnum' : item[1],
        \ 'col'  : item[2],
        \ 'text' : item[3],
        \ 'type' : 'E',
        \ }
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
  if !get(g:, 'g:jscheck_no_autocheck', 0)
    autocmd BufWritePost * :call s:CheckCurrentFile()
  endif
  autocmd VimEnter * :call s:InstallDependencies()
augroup end
