#!/system/xbin/env python3
import fileinput
import re
datalist = ["[" + S.rstrip() + "]\n" for S in fileinput.input() if not re.match("\s*\n",S)  ]
print(*datalist)

