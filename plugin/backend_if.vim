" coding: utf-8

if exists("g:loaded_backend_if")
  finish
endif
let g:loaded_backend_if = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 ToOnelineStatement call backend_if#ToOnelineStatement()
command! -nargs=0 ToMultilineStatement call backend_if#ToMultilineStatement()
command! -nargs=0 ToggleStatement call backend_if#ToggleStatement()

let &cpo = s:save_cpo
unlet s:save_cpo
