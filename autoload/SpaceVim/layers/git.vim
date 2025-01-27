"=============================================================================
" git.vim --- SpaceVim git layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Layer Options:
" s:git_plugin which plugin is used as the background plugin in git layer


if has('patch-8.0.0027') || has('nvim')
  let s:git_plugin = 'gina'
else
  let s:git_plugin = 'gita'
endif



function! SpaceVim#layers#git#plugins() abort
  let plugins = [
        \ ['junegunn/gv.vim',      { 'on_cmd' : ['GV']}],
        \ ]
  call add(plugins, ['tpope/vim-fugitive',   { 'merged' : 0}])
  call add(plugins, ['airblade/vim-gitgutter',   { 'merged' : 0}])
  if s:git_plugin ==# 'gina'
    call add(plugins, ['lambdalisue/gina.vim', { 'on_cmd' : 'Gina'}])
  elseif s:git_plugin ==# 'fugitive'
    call add(plugins, ['tpope/vim-dispatch', { 'merged' : 0}])
  else
    call add(plugins, ['lambdalisue/vim-gita', { 'on_cmd' : 'Gita'}])
  endif
  if g:spacevim_filemanager ==# 'nerdtree'
    call add(plugins, ['Xuyuanp/nerdtree-git-plugin', {'merged' : 0}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#git#config() abort
  let g:signify_vcs_list = ['hg']
  let g:_spacevim_mappings_space.g = get(g:_spacevim_mappings_space, 'g',  {'name' : '+VersionControl/git'})
  if s:git_plugin ==# 'gina'
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gina status --opener=10split', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gina add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gina reset -q %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gina commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gina push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gina diff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gina add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gina blame', 'view-git-blame', 1)
  elseif s:git_plugin ==# 'fugitive'
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gstatus', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Git add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Git reset -q %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Git commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gpush', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gdiff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Git add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gblame', 'view-git-blame', 1)
  else
    call SpaceVim#mapping#space#def('nnoremap', ['g', 's'], 'Gita status', 'git-status', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'S'], 'Gita add %', 'stage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'U'], 'Gita reset %', 'unstage-current-file', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'c'], 'Gita commit', 'edit-git-commit', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'p'], 'Gita push', 'git-push', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'd'], 'Gita diff', 'view-git-diff', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'A'], 'Gita add .', 'stage-all-files', 1)
    call SpaceVim#mapping#space#def('nnoremap', ['g', 'b'], 'Gina blame', 'view-git-blame', 1)
  endif
  augroup spacevim_layer_git
    autocmd!
    autocmd FileType diff nnoremap <buffer><silent> q :call SpaceVim#mapping#close_current_buffer()<CR>
    autocmd FileType gitcommit setl omnifunc=SpaceVim#plugins#gitcommit#complete
    autocmd User GitGutter let &l:statusline = SpaceVim#layers#core#statusline#get(1)
    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
  augroup END
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'M'], 'call call('
        \ . string(function('s:display_last_commit_of_current_line')) . ', [])',
        \ 'commit-message-of-current-line', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'V'], 'GV!', 'git-log-of-current-file', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['g', 'v'], 'GV', 'git-log-of-current-repo', 1)
  let g:_spacevim_mappings_space.g.h = {'name' : '+Hunks'}
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', 'a'], '<Plug>(GitGutterStageHunk)', 'stage-current-hunk', 0)
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', 'r'], '<Plug>(GitGutterUndoHunk)', 'undo-cursor-hunk', 0)
  call SpaceVim#mapping#space#def('nmap', ['g', 'h', 'v'], '<Plug>(GitGutterPreviewHunk)', 'preview-cursor-hunk', 0)
endfunction

function! SpaceVim#layers#git#set_variable(var) abort

  let s:git_plugin = get(a:var,
        \ 'git-plugin',
        \ s:git_plugin)

endfunction

function! s:display_last_commit_of_current_line() abort
  let line = line('.')
  let file = expand('%')
  let cmd = 'git log -L ' . line . ',' . line . ':' . file
  let cmd .= ' --pretty=format:"%s" -1'
  let title = systemlist(cmd)[0]
  if v:shell_error == 0
    echo 'Last commit of current line is: ' . title
  endif
endfunction

" vim:set et sw=2 cc=80:
