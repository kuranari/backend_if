backend_if
==========

![](./anime.gif)

このプラグインはRubyの後置記法を支援します．

使用可能なのは本文が1行の`if`,`unless`,`while`,`until`文です．
# Installation

To install using NeoBundle:
Add this line to your .vimrc file

```
NeoBundle "kuranari/backend_if"

autocmd FileType ruby nnoremap <Leader>t :ToggleStatement<CR>
```

# Usage
 Open or create a Ruby File like this:

```
if true
  p "Hello world!"
end
```
Type `<Leader>t` or `:ToggleStatement` on the `if` statement, you will see:

```
p "Hello world!" if true
```
And type `gt` again, you will see:

```
if true
  p "Hello world!"
end
```

