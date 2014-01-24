""
" 現在行から上2行以内に開始文があり，その2行下にend文がある場合を後置表現可能
" と定義
" [返り値]
" 後置表現できない場合：0
" 後置表現できる場合: 開始行番号
function! s:getBeginLineOfState()
  let line_num = line('.')
  let lines = reverse(getline(line_num - 2, line_num))
  let i = 0
  let begin_num = 0

  for line in lines
    " TODO: if array.nil? thenのようなthenつき表現にも対応する
    if line =~ '\s*\(if\|unless\|while\|until\).*'
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

function! ToOnelineState()
  let begin_line = s:getBeginLineOfState()
  if begin_line
    execute ":" . begin_line
    normal! ddpkJjddk==
  else
    echo "Cannot one line state."
  endif
endfunction
