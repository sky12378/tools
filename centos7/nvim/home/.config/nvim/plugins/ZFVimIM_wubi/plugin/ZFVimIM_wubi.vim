let s:repoPath=expand('<sfile>:p:h:h')
function! s:dbInit()
    let repoPath = s:repoPath
    "纯五笔
	"let dbFile = '/misc/wubi.txt'
	"纯拼音
    "let dbFile = '/misc/pinyin.txt'
	"五笔拼音
	let dbFile = '/misc/wubi_pinyin.txt'
    let dbCountFile = '/misc/wubi_count.txt'

    let db = ZFVimIM_dbInit({
                \   'name' : '五笔',
                \ })
    call ZFVimIM_cloudRegister({
				\   'mode' : 'local',
                \   'repoPath' : repoPath,
                \   'dbFile' : dbFile,
                \   'dbCountFile' : dbCountFile,
                \   'dbId' : db['dbId'],
                \ })
endfunction

augroup ZFVimIM_wubi_augroup
    autocmd!
    autocmd User ZFVimIM_event_OnDbInit call s:dbInit()
augroup END

