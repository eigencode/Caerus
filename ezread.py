#!/system/xbin/env python3
import fileinput
for line in fileinput.input():
	lout = "[" + line.rstrip() + "]"
	print(lout)
