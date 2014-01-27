" coding: utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:words = '\<\%(if\|unless\|while\|until\)\>'
let s:oneline_begin_exp = '^\s*\('. s:words .'.\{-}\)\%(then\)\{-0,1}\s*$'
let s:oneline_end_exp = '^\s*end\s*$'
let s:multiline_begin_exp = '^\s*\(\S.*\)'. s:words .'\s*\(.*\)$'

" 前後の空白を削除
function! s:strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" 現在行から上2行以内に1行化可能な文があるか
function! s:serch_begin_state()
  let line_num = line('.')
  let lines = reverse(getline(line_num - 2, line_num))

  let i = 0
  for line in lines
    if line =~ s:oneline_begin_exp
      return line_num - i
    endif
    let i += 1
  endfor
  return 0
endfunction

function! s:can_change_to_oneline()
  let begin_line = s:serch_begin_state()
  if begin_line && getline(begin_line + 2) =~ s:oneline_end_exp
    return begin_line
  else
    return 0
  endif
endfunction

function! s:can_change_to_multiline()
  return getline('.') =~ s:multiline_begin_exp
endfunction

function! s:change_to_multiline()
  let line = getline('.')
  let list = split(line, '\ze'. s:words)
  call append(line('.')-1, s:strip(list[1]))
  call append(line('.')-1, s:strip(list[0]))
  call setline('.', "end")

  " インデント
  normal! 2k3==
endfunction

function! s:change_to_oneline(begin_line)
  execute ":" . a:begin_line

  let condition = substitute(getline('.'), s:oneline_begin_exp, '\1', "")
  let body = getline(line('.') + 1)

  let end_line = a:begin_line + 2
  execute ":". a:begin_line .",". end_line ."delete"
  call append(line('.')-1, s:strip(body) ." ". s:strip(condition))

  " インデント
  normal! k==
endfunction

function! backend_if#ToOnelineStatement()
  let begin_line = s:can_change_to_oneline()
  if begin_line
    call s:change_to_oneline(begin_line)
  else
    echo "Cannot one line state."
  endif
endfunction

function! backend_if#ToMultilineStatement()
  let can_change = s:can_change_to_multiline()
  if can_change
    call s:change_to_multiline()
  else
    echo "Cannot multi line state."
  end
endfunction

function! backend_if#ToggleStatement()
  let can_one_line = s:can_change_to_oneline()
  let can_multi_line = s:can_change_to_multiline()
  if can_one_line && can_multi_line
    echo "Something wrong..."
  elseif can_one_line
    call s:change_to_oneline(can_one_line)
  elseif can_multi_line
    call s:change_to_multiline()
  else
    echo "Cannot toggle state."
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
