#!/system/xbin/env python3
import io
import sys
import codecs
import win_unicode_console
win_unicode_console.enable()
for s in sys.argv:
	print(type(s))
	print(s)
