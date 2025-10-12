#Requires AutoHotKey v2.0


#HotIf WinActive("ahk_class XamlExplorerHostIslandWindow")
  !h::Send("{Alt down}{Left}")
  !l::Send("{Alt down}{Right}")
  !j::Send("{Alt down}{Down}")
  !k::Send("{Alt down}{Up}")
#HotIf
