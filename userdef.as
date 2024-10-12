#define global SWP_NOSIZE		$00000001
#define global SWP_NOMOVE 0x0002
#define global SWP_NOZORDER	$00000004
#define global SWP_FRAMECHANGED	$00000020
#define global SWP_SHOWWINDOW 0x0040
#define global HWND_TOPMOST	$FFFFFFFF

#define global HKM_GETHOTKEY 0x402
#define global HKM_SETHOTKEY 0x401
#define global HOTKEYF_ALT 0x4
#define global HOTKEYF_CONTROL 0x2
#define global HOTKEYF_EXT 0x8
#define global HOTKEYF_SHIFT 0x1
#define global WS_CHILD 0x40000000
#define global WS_VISIBLE 0x10000000

#define DPI_AWARENESS_CONTEXT 0
#define DPI_AWARENESS_CONTEXT_UNAWARE              ((DPI_AWARENESS_CONTEXT)-1)
#define DPI_AWARENESS_CONTEXT_SYSTEM_AWARE         ((DPI_AWARENESS_CONTEXT)-2)
#define DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE    ((DPI_AWARENESS_CONTEXT)-3)
#define DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 ((DPI_AWARENESS_CONTEXT)-4)
#define DPI_AWARENESS_CONTEXT_UNAWARE_GDISCALED    ((DPI_AWARENESS_CONTEXT)-5)

#define global MFS_CHECKED 0x08
#define global MFS_UNCHECKED 0x00
#define global MF_DISABLED 0x02
#define global NOTIFYICONDATA_STRUCTSIZE 88

#define global MOD_ALT 1
#define global MOD_CONTROL 2
#define global MOD_SHIFT 4
#define global MOD_WIN 8

#define DT_TOP              0x00000000
#define DT_LEFT             0x00000000
#define DT_CENTER           0x00000001
#define DT_RIGHT            0x00000002
#define DT_VCENTER          0x00000004
#define DT_BOTTOM           0x00000008
#define DT_WORDBREAK        0x00000010
#define DT_SINGLELINE       0x00000020
#define DT_EXPANDTABS       0x00000040
#define DT_TABSTOP          0x00000080
#define DT_NOCLIP           0x00000100
#define DT_EXTERNALLEADING  0x00000200
#define DT_CALCRECT         0x00000400
#define DT_NOPREFIX         0x00000800
#define DT_INTERNAL         0x00001000

#define DT_EDITCONTROL      0x00002000
#define DT_PATH_ELLIPSIS    0x00004000
#define DT_END_ELLIPSIS     0x00008000
#define DT_MODIFYSTRING     0x00010000
#define DT_RTLREADING       0x00020000
#define DT_WORD_ELLIPSIS    0x00040000
    

#define LOGPIXELSX	$00000058
#define LOGPIXELSY	$0000005A

#define global ctype DPISIZ(%1) int(%1*High_DPI/96)
#define global ctype SIZDPI(%1) int(%1*96/High_DPI)

#define global ctype HIWORD(%1) (%1 >> 16 & $FFFF)
/*
#module
	//標準精度のタイマー
	#uselib "kernel32.dll"
	#cfunc _GetTickCount "GetTickCount"

#deffunc awaitEx int p1
	if p1 < 0 : return
	a_waittick = _GetTickCount()
	e_waittick = a_waittick + p1
	await p1
	repeat
		p_waittick = _GetTickCount()
		c_waittick = e_waittick - p_waittick
		if c_waittick <= 0 : break
		await c_waittick
	loop
return

#deffunc waitEx int p1
	if p1 < 0 : return
	awaitEx (p1 * 10)
return
#global
*/

#module mCOMOBJMACRO
#define global ctype SUCCEEDED(%1) ((%1) >= 0)
#define global SafeRelease(%1) if ((varuse(%1)) && (vartype(%1) == 6)){ \
	delcom %1: \
	%1 = 0 \
}
#global

//ショートカットファイル作成モジュール
//https://hsp.tv/play/pforum.php?mode=pastwch&num=59039
#module mSHORTCUT
#define CLSID_ShellLink "{00021401-0000-0000-C000-000000000046}"
#define IID_IShellLink "{000214EE-0000-0000-C000-000000000046}"
#usecom IShellLink IID_IShellLink CLSID_ShellLink
#comfunc IShellLink_SetArguments 11 str
#comfunc IShellLink_SetIconLocation 17 str, int
#comfunc IShellLink_SetPath 20 str
#define IID_IPersistFile "{0000010b-0000-0000-C000-000000000046}"
#usecom IPersistFile IID_IPersistFile
#comfunc IPersistFile_Save 6 wstr, int
#define IID_IPropertyStore "{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}"
#define CLSID_PropertyStore "{e4796550-df61-448b-9193-13fc1341b163}"
#usecom IPropertyStore IID_IPropertyStore CLSID_PropertyStore
#comfunc IPropertyStore_SetValue 6 sptr, sptr
#comfunc IPropertyStore_Commit 7
#deffunc CreateShortcut str file_path, str arg, str icon_path, int icon_idx,  str out_path, \
	local pShellLink, \
	local pPropStore, \
	local wstring, \
	local wstrings, \
	local ppropvar, \
	local hr

	hr = 0
	pShellLink = 0
	pPropStore = 0

	newcom pShellLink, IShellLink
	if varuse(pShellLink) == 0 : return -1

	IShellLink_SetPath pShellLink, file_path : hr = stat
	if SUCCEEDED(hr){
		IShellLink_SetArguments pShellLink, arg : hr = stat
		if SUCCEEDED(hr){
			IShellLink_SetIconLocation pShellLink, icon_path, icon_idx : hr = stat
			if SUCCEEDED(hr){
				querycom pPropStore, pShellLink, IPropertyStore
				if varuse(pPropStore){
					IPropertyStore_Commit pPropStore : hr = stat
					if SUCCEEDED(hr){
						IPersistFile_Save pShellLink, out_path, 1 : hr = stat
					}
				}
			}
		}
	}
	// SafeRelease
	SafeRelease pPropStore
	SafeRelease pShellLink
return hr
#global

#define global WM_HOTKEY 0x0312
#define global WM_DPICHANGED 0x02E0

//二重起動防止モジュール
//https://chokuto.ifdef.jp/advanced/singleton1.html
#module
#uselib "kernel32.dll"
#func  CloseHandle  "CloseHandle"  int
#cfunc CreateMutex  "CreateMutexW" int, int, wptr
#cfunc GetLastError "GetLastError"

#define ERROR_ALREADY_EXISTS    183

; ミューテックスオブジェクトの名前の定義
; (アプリケーション固有の名前にする必要があります)
#define MUTEX_NAME  "Squaring_HSP3"

; このアプリケーションがすでに起動されているかどうかを取得する関数
#defcfunc AlreadyAppRunning

if (hMutex == 0) {
    ; 名前付きミューテックスオブジェクトの作成
    hMutex = CreateMutex(0, 0, MUTEX_NAME)

    ; オブジェクトがすでに作成されていたかどうかの判別
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        ; すでに同じ名前のオブジェクトが存在する
        alreadyRunning = 1
    } else {
        ; オブジェクトが新しく作成された
        alreadyRunning = 0
    }
}
return alreadyRunning

; クリーンアップ処理（終了時に自動実行）
#deffunc CleanupAppRunChecker// onexit
if (hMutex != 0) {
    ; ミューテックスオブジェクトハンドルのクローズ
    CloseHandle hMutex
    hMutex = 0
}
return

#global ;------------------------モジュール終わり-------------------------

#module

#uselib "kernel32.dll"
#func  CloseHandle  "CloseHandle"  int
#cfunc CreateMutex  "CreateMutexW" int, int, wptr
#cfunc GetLastError "GetLastError"

#define ERROR_ALREADY_EXISTS    183

; ミューテックスオブジェクトの名前の定義
; (アプリケーション固有の名前にする必要があります)
#define MUTEX_NAME  "Squaring_Point"

; このアプリケーションがすでに起動されているかどうかを取得する関数
#defcfunc AlreadyAppRunningPoint

if (hMutex == 0) {
    ; 名前付きミューテックスオブジェクトの作成
    hMutex = CreateMutex(0, 0, MUTEX_NAME)

    ; オブジェクトがすでに作成されていたかどうかの判別
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        ; すでに同じ名前のオブジェクトが存在する
        alreadyRunning = 1
    } else {
        ; オブジェクトが新しく作成された
        alreadyRunning = 0
    }
}
return alreadyRunning

; クリーンアップ処理（終了時に自動実行）
#deffunc CleanupAppRunCheckerPoint// onexit
if (hMutex != 0) {
    ; ミューテックスオブジェクトハンドルのクローズ
    CloseHandle hMutex
    hMutex = 0
}
return

#global

#module
#uselib "kernel32.dll"
// 設定ファイル読み書き
#func WritePrivateProfileString "WritePrivateProfileStringW" wptr,wptr,wptr,wptr
#func GetPrivateProfileString "GetPrivateProfileStringW" wptr,wptr,wptr,wptr,wptr,wptr
#define global INI_SEC  "config"	// 設定ファイルのセクション名

// 設定ファイルから読み出し
// getini ファイル名, キー(文字列), デフォルト値, フラグ(0:数値 1:文字列)
#defcfunc getini str _s1, str _key, int _p1, int _p2
exist _s1
if strsize <= 0:return _p1
	sdim buf,1024	// 必要な文字列サイズ分確保のこと
	GetPrivateProfileString INI_SEC, _key, str(_p1), varptr(buf), 1024, _s1
	buf=cnvwtos(buf)
	//if _p2 { return buf }	// 文字列として返す
	return int(buf)			// 整数値として返す

// 設定ファイルに書き込み
// setini ファイル名, キー(文字列), 値(文字列)
#deffunc setini str _s1, str _key, str _s2
	WritePrivateProfileString INI_SEC, _key, _s2, _s1
	return
#global

#module
#uselib "ADVAPI32.DLL"
#func RegOpenKeyEx "RegOpenKeyExW" int, wptr, int, int,var
#func RegQueryValueEx "RegQueryValueExW" int, wptr, int,int,int,int
#func RegCloseKey "RegCloseKey" int
#define KEY_READ 0x20019
#define HKEY_CURRENT_USER 0x80000001
/**
 * レジストリの取得
 */
#defcfunc get_regedit int h, str key, str name
    RegOpenKeyEx h, key, 0,KEY_READ,hkey
    RegQueryValueEx hkey, name, 0, 0, 0, varptr(sz)
    if stat == 0 {
        sdim data, sz
        RegQueryValueEx hkey, name, 0, 0, varptr(data), varptr(sz)
    } else {
        data = -1
    }
    RegCloseKey hkey
    return data
    
/**
 * システムがダークカラーかどうかをレジストリから取得
 * ダークカラーが有効なら1、無効なら0
 * そもそもダークカラー設定が存在しない場合は -1 を返す
 */
#defcfunc get_dark_color_type
    dark = 0
    key = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize"
    name = "AppsUseLightTheme"
    ret = get_regedit(HKEY_CURRENT_USER, key, name)
    tmpText = ""
    if ret != -1 {
        // ライトカラー設定
        if peek(ret, 0) == 0 {
            dark = 1
        } else {
            dark = 0
        }
    } else {
        dark = -1
    }
    return dark
#global
