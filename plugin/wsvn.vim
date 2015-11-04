"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"	author:kisshc
"	version:0.0.1
"	date:2015/11/4 13:14
"	email:kisshc@kisshc.com
"	description:�򵥲���svn�ͻ���guiʵ�ָ����ύ�Ȳ���
"	doc:
"		vimrc����:let g:wsvn_gui_path = "{svn�ͻ��˰�װ·��}/bin/TortoiseProc.exe"
"			 	  let g:wsvn_msg_type = number [0,1,2,3]
"	end
"	url:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ֻ����һ��
if exists("g:wsvn_loaded")
   finish
endif

let g:wsvn_loaded = 1

" ������ĿĿ¼
func! UpdateObjectDir()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . FindObejectRoot() . '"'
	call ExeCmd(w:command)	
endfunc

" �ύ��ĿĿ¼
func! CommitObjectDir()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . FindObejectRoot() . '"'
	call ExeCmd(w:command)	
endfunc

" ���µ�ǰ�ļ�Ŀ¼
func! UpdateCurDirAll()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . getcwd() . '"'
	call ExeCmd(w:command)
endfunc

" �ύ��ǰ�ļ�Ŀ¼
func! CommitCurDirAll()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . getcwd() . '"'
	call ExeCmd(w:command)
endfunc

" ���µ�ǰ�ļ�
func! UpdateCurOneFile()
	let w:command = Wsvn()
	let w:command .= " /command:update /path:" . '"' . getcwd() . "\\" . CurFile() . '"'
	call ExeCmd(w:command)
endfunc

" �ύ��ǰ�ļ�
func! CommitCurOneFile()
	let w:command = Wsvn()
	let w:command .= " /command:commit /path:" . '"' . getcwd() . "\\" . CurFile() . '"'
	call ExeCmd(w:command)
endfunc

" ��ǰ�ļ���
func! CurFile()
    return expand("%:t")
endfunc

func! Wsvn()
	if !has("win32") && !has("win64") && !has("win95") && !has("win16")
		throw "[Wsvn ERROR]�����ʱֻ֧��window"
	endif
	if !exists("g:wsvn_msg_type")
		let g:wsvn_msg_type = 2
	endif
	if !exists("g:wsvn_gui_path") && !executable("C:/Program Files/TortoiseSVN/bin/TortoiseProc.exe")
		throw "[Wsvn ERROR]:������let g:wsvn_gui_pathΪTortoiseProc.exe����·��"
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
	while isdirectory(getcwd())
		if w:i > 100
			break
		endif
		if isdirectory(w:dir . ".svn")
			let w:root = getcwd()
			break
		endif
		let w:i += 1
		execute "lcd ../"
	endwhile
	if isdirectory(w:root)
		return w:root
	else
		throw "[Wsvn ERROR]:δ���ҵ���ĿĿ¼"
	endif
endfunc
