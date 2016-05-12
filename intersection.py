h1=open('C:/temp/usrbin.txt')
h2=open('C:/temp/otherbin.txt')
h1D={}
h2D={}
for line in h1:
	key=line.rstrip().lstrip()
	h1D[key]=0
for line in h2:
	key=line.rstrip().lstrip()
	h2D[key]=0
for key in h1D.keys():
	if key in h2D:
		print(key)

