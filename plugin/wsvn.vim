"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	author:kisshc
"	version:0.0.1
"	date:2015/11/4 13:14
"	email:kisshc@kisshc.com
"	description:简单操作svn客户端gui实现更新提交等操作
"	doc:
"		vimrc增加:let g:wsvn_gui_path = "{svn客户端安装路径}/bin/TortoiseProc.exe"
"			 	  let g:wsvn_msg_type = number [0,1,2,3]
"	end
"	url:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 只载入一次
if exists("g:loaded_wsvn")
   finish
endif

let g:loaded_wsvn = 1

" 更新项目目录
func! UpdateObjectDir()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . FindObejectRoot() . '"'
	call ExeCmd(w:command)	
endfunc

" 提交项目目录
func! CommitObjectDir()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . FindObejectRoot() . '"'
	call ExeCmd(w:command)	
endfunc

" 更新当前文件目录
func! UpdateCurDirAll()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . getcwd() . '"'
	call ExeCmd(w:command)
endfunc

" 提交当前文件目录
func! CommitCurDirAll()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . getcwd() . '"'
	call ExeCmd(w:command)
endfunc

" 更新当前文件
func! UpdateCurOneFile()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . getcwd() . "\\" . CurFile() . '"'
	call ExeCmd(w:command)
endfunc

" 提交当前文件
func! CommitCurOneFile()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . getcwd() . "\\" . CurFile() . '"'
	call ExeCmd(w:command)
endfunc

" 当前文件名
func! CurFile()
    return expand("%:t")
endfunc

func! Wsvn()
	if !has("win32") && !has("win64") && !has("win95") && !has("win16")
		throw "[WSVN ERROR]:This plugin is only for windows"
	endif
	if !exists("g:wsvn_msg_type")
		let g:wsvn_msg_type = 2
	endif
	if !exists("g:wsvn_gui_path") && !executable("C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe")
		throw "[WSVN ERROR]:set let g:wsvn_gui_path = [path]/TortoiseProc.exe on your vimrc file"
	else
		let g:wsvn_gui_path = "C:/\"Program Files\"/TortoiseSVN/bin/TortoiseProc.exe"
	endif
	
	let w:dialog = ""
	let w:dialog = " /closeonend:" . g:wsvn_msg_type
	let w:route = g:wsvn_gui_path . " /tray " . w:dialog . " "
	return "!" . w:route		
endfunc

func! ExeCmd(cmd)
	silent execute a:cmd
endfunc

func! FindObejectRoot()
	let w:dir = "./"
	let w:root = 0
	let w:i = 0
	let w:path = getcwd()
	let w:curDir = './'
	while isdirectory(w:curDir)
		let w:curDir = getcwd()
		if w:i > 100
			break
		endif
		if isdirectory(w:dir . ".svn")
			let w:root = w:curDir
			break
		endif
		let w:i += 1
		execute "lcd ../"
	endwhile
	execute "lcd " . w:path
	if isdirectory(w:root)
		return w:root
	endif
	throw "[WSVN ERROR]:Not found svn"
endfunc
