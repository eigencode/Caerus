#!/system/xbin/env python3
import os
import re
import sys
import hashlib
import win_unicode_console
import argparse

win_unicode_console.enable()

def chkSumIsPossible(elementName):
	#
	# Verify that a file can be opened and is not
	# a directory(directory check sums have limited value)
	#
	errMsg = ""
	openSucceeded = True
	if os.path.isfile(elementName):
		try:
			f = open(elementName, 'rb')
		except Exception as e:
			openSucceeded = False
			errMsg  = repr(e)
		finally:
			if openSucceeded:
				f.close()
	else:
		openSucceeded = False
		if os.path.isdir(elementName):
			errMsg = "Skipping directory"
		else:
			errMsg = "       Cannot find"

	if not openSucceeded:
		errMsg += " > "
		errMsg += "[ "
		errMsg += elementName
		errMsg += " ]"

	return {"openSucceeded":openSucceeded, "errMsg":errMsg}

def getChkSum(fH):
	# thanks Martijn Pieters
	blocksize = 65535
	buf = fH.read(blocksize)
	chkSum = hashlib.sha256()
	while len(buf) > 0:
		chkSum.update(buf)
		buf = fH.read(blocksize)
	return chkSum.hexdigest()

parser = argparse.ArgumentParser(description='Get sha256 checksum on some files')

parser.add_argument(dest='fileNames', 
                    metavar='fileName', 
                    nargs='*', 
                    help='Names of all the input files to process')

parser.add_argument('-p', 
                    '--pipestdin', 
                    metavar='pipedIn', 
                    dest='stdin', 
                    action='store_const', 
                    const=True, 
                    default=False,
                    help='Specifies that file list will come from stdin, one filename on each line' )

parser.add_argument('-o',
                    '--outfile',  
                    metavar='outputFile', 
                    dest='outFile',
                    action='store',
                    default='stdout',
                    help='Name of the output file [ default is stdout ]') 

errorList = []
for fName in sys.argv[1:]:
	#
	# Get a list of filenames from the command line
	#
	rslt = chkSumIsPossible(fName)
	if rslt["openSucceeded"]:
		fHandle = open(fName, 'rb')
		print(getChkSum(fHandle) + " > " + fName)
		fHandle.close()
	else:
		errorList.append(rslt["errMsg"])

if len(errorList):
	print("\nError(s):")
	for msg in errorList:
		print("\t" + msg)
		
