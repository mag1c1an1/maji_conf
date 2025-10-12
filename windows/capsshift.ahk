#Requires AutoHotkey v2.0


#SingleInstance Force

; 后台运行
Persistent

global isCapsPressed := false

CapsLock::
{
	if (KeyWait("CapsLock", "T0.5")) {
		if(!isCapsPressed){
			; 点击CapsLock，切换中英文
			Send "{LAlt down}{Shift}"
			Send "{LAlt up}"
		}
		global isCapsPressed := false
	} else { if(!isCapsPressed){
			global isCapsPressed := true
			; 长按CapsLock，切换大小写锁定
			SetCapsLockState !GetKeyState("CapsLock", "T")
		}
	}
}
