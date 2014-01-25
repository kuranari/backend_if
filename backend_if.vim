""
" 現在行から上2行以内に開始文があり，その2行下にend文がある場合を後置表現可能
" と定義
" [返り値]
" 後置表現できない場合：0
" 後置表現できる場合: 開始行番号

let s:words = '\<\%(if\|unless\|while\|until\)\>'
let s:to_one_begin_exp = '^\s*\('. s:words .'.\{-}\)\%(then\)\{-0,1}\s*$'
let s:to_one_end_exp = '^\s*end\s*$'
let s:to_multi_begin_exp = '^\s*\(\S.*\)'. s:words .'\s*\(.*\)$'

" 前後の空白を削除
function! s:strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:serch_begin_state()
  let line_num = line('.')
  let lines = reverse(getline(line_num - 2, line_num))

  let i = 0
  for line in lines
    if line =~ s:to_one_begin_exp
      return line_num - i
    endif
    let i += 1
  endfor

  return 0
endfunction

function! s:getBeginLineOfState()
  let begin_line = s:serch_begin_state()
  if begin_line && getline(begin_line + 2) =~ s:to_one_end_exp
    return begin_line
  else
    return 0
  endif
endfunction

function! s:ToMultilineState()
  let line = getline('.')
  if line =~ s:to_multi_begin_exp
    let list = split(line, '\ze'. s:words)
    call append(line('.')-1, s:strip(list[1]))
    call append(line('.')-1, s:strip(list[0]))
    call setline('.', "end")

    " インデント
    normal! 2k3==
  else
    echo "Cannot multi line state."
  end
endfunction

function! s:ToOnelineState()
  let begin_line = s:getBeginLineOfState()
  if begin_line
    execute ":" . begin_line

    let condition = substitute(getline('.'), s:to_one_begin_exp, '\1', "")
    let body = getline(line('.') + 1)

    let end_line = begin_line + 2
    execute ":". begin_line .",". end_line ."delete"
    call append(line('.')-1, s:strip(body) ." ". s:strip(condition))

    " インデント
    normal! k==
  else
    echo "Cannot one line state."
  endif
endfunction

command! -nargs=0 ToOnelineState call <SID>ToOnelineState()
command! -nargs=0 ToMultilineState call <SID>ToMultilineState()

