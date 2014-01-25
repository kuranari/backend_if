""
" 現在行から上2行以内に開始文があり，その2行下にend文がある場合を後置表現可能
" と定義
" [返り値]
" 後置表現できない場合：0
" 後置表現できる場合: 開始行番号

let s:words = '\<\(if\|unless\|while\|until\)\>'

function! s:strip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:getBeginLineOfState()
  let line_num = line('.')
  let lines = reverse(getline(line_num - 2, line_num))
  let i = 0
  let begin_num = 0

  for line in lines
    " TODO: if array.nil? thenのようなthenつき表現にも対応する
    if line =~ '\s*'. s:words .'.*'
      let begin_num = line_num - i
      break
    endif
    let i += 1
  endfor

  if !begin_num || getline(begin_num + 2) =~ '\s*end\s*'
    return begin_num
  else
    return 0
  endif
endfunction

function! s:ToMultilineState()
  let line = getline('.')
  if line =~ '\s*\(.*\)'. s:words .'\s*\(.*\)'
    " let list = matchlist(line, '\s*\(.*\)'. s:words .'\s*\(.*\)')
    " echo list[1]
    " echo list[2]
    " echo list[3]
    let list = split(line, '\ze'. s:words)
    call append(line('.')-1, s:strip(list[1]))
    call append(line('.')-1, s:strip(list[0]))
    call setline('.', "end")
    normal! 2k3==
  else
    echo "Cannot multi line state."
  end
endfunction

function! s:ToOnelineState()
  let begin_line = s:getBeginLineOfState()
  if begin_line
    execute ":" . begin_line
    normal! ddpkJ==jddk
  else
    echo "Cannot one line state."
  endif
endfunction

command! -nargs=0 ToOnelineState call <SID>ToOnelineState()
command! -nargs=0 ToMultilineState call <SID>ToMultilineState()

