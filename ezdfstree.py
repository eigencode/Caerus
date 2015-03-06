#!/system/xbin/env python3
# {{{ imports
import sys
import argparse
import time
import re
import os
import stat
import urllib.request
import errno
import datetime
import tempfile
import shutil
import socket
# }}}
# {{{ 'itemsPerCarton' is the number of lines in each merge file.
# The number of cartons will be the total number of directory
# elements divided by the number 'itemsPerCarton'.
# The memory consumed by the script in each partial sort
# increases as 'itemsPerCarton' is increased.
# The memory consumed by the script in the final merge
# increases as 'itemsPerCarton' is decreased, but since
# the merge is generaly less memory intensive, memory
# is not generally the limiting factor for a merge. OTOH 
# if 'itemsPerCarton' were set to 1, then the merge memory-usage 
# would essentially be the same as if 'itemsPerCarton' were 
# greater than the total number of items to be sorted. 
# See 'Art of Computer Programming, Volume 3: Sorting 
# and Searching' ISBN-13: 978-0201896855
itemsPerCarton = 8191
# }}}
# {{{ 'topNode'
# start directory descend here
#
topNode = os.getcwd()
# }}}
# {{{ 'pantry' is a dictionary whose
# keys are the names of all the 
# merge files
#
pantry = {}
# }}}
# {{{ 'carton' is an array which contains the actual
# directory listing data for each merge file
#
carton = []
# }}}
# {{{ 'cartonIdx' contains the fullpath names of all the
# carton files as 'keys' and the number of entries 
# in each carton as 'values'.
#
cartonIdx = {}
# }}}
# {{{ 'dfsIndex' is a unique base-56 encoded integer
# associated with each unique directory element
# that makes possible, putting directory entries 
# back in (their original pre-sorted) order.
#
dfsIndex = -1
# }}}
# {{{ 'nullstr' syntactic sugar for ''
#
nullstr = ''
# }}}
# {{{ 'space' syntactic sugar for ' '
#
space = str( chr( 32 ) )
# }}}
# {{{ 'Tab' syntactic sugar for tab
#
tabChr = str( chr( 9 ) )
# }}}
# {{{ 'ctrlA' syntactic sugar for control-a
#
ctrlA = str( chr( 1 ) )
# }}}
# {{{ Number Base Alphabets
# I use base 56 for Inode Numbers on NTFS
# because the inodes can get pretty huge
# I only track INodes so I can track hard 
# links on my disk
#
B56 = "0123456789ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz"
#
# I use 3 hex digits to number my carton 
# files ( most people call them buckets 
# but in my mind the bucket does not belong
# in a pantry whereas a carton just might)
#
B16 = "0123456789ABCDEF"
#
# finally I use simple base 10 for nix inodes
# but since I select these encodings via 
# the iNodeBase dictionary, the inline logic is
# same for android and windows
#
B10 = "0123456789"
# }}}
# {{{ 'elementTagHash' 
# an element is either a...
# 'F'ile
# 'D'irectory
# 'L'ink
# 'U'nknown
#
elementTagHash = {  
		0b000:'U',
		0b001:'F',
		0b010:'D',
		0b011:'D',
		0b100:'LU',
		0b101:'LF',
		0b110:'LD',
		0b111:'LD'
} # }}}
# {{{ regular expressions 

#
# documentation claims this is 
# unnecessary. As of 20140325
# python installed on host fultonJSheen
# does not treat <tab> <newline> <cr>
# as whitespace 
#
WS = ' \t\n\r'

leadingDrive = re.compile( r"""
	\A
	( [a-z] )
	:
	[/\\]+
	""".strip( WS ), re.X | re.I )

leadingSlash = re.compile( r"""
	\A
	[/\\]+
	""".strip( WS ), re.X | re.I )

trailingSlash = re.compile( r"""
	[/\\]+
	\Z
	""".strip( WS ), re.X | re.I )

anySlash = re.compile( r"""
	[/\\]+
	""".strip( WS ), re.X | re.I )

anyPeriod = re.compile( r"""
	[.]+
	""".strip( WS ), re.X | re.I )

allDigits = re.compile(  r"""
	\A
	\d+
	\Z
	""".strip( WS ), re.X | re.I )

skiplist = { 
	'/proc':'linux-armv7l',
	'///C:/%24recycle.bin':'win32'
}

alternateLogDirHash = {
 'linux-armv7l':os.getenv( 'EXTERNAL_STORAGE' ),
		'win32':os.getenv( 'TEMP' ),
}

logDirHash = { 
 'linux-armv7l': '/mnt/sdcard/00/log/tox',
		'win32': 'C:/etc/tox'
}

drpBxDirHash = { 
 'linux-armv7l': '/mnt/sdcard/00',
		'win32': 'C:/drpbx/Dropbox/tox'
}

iNodeFldWdth = { 
 'linux-armv7l': 10,
		'win32': 12
}

iNodeBase = { 
 'linux-armv7l': B10,
		'win32': B56
}


# }}}
class InputMergeObj:  # {{{
	def __init__( self, fName ):
		self.N = fName
		self.lineKey = ctrlA
		try:
			#
			# at object instantiation read the first 
			# line in the text file and extract the
			# sort key ( full path name )
			#
			self.H = open( fName, 'rt', encoding='utf-8' )
			self.currentLine = self.H.readline()
			if self.currentLine:
				self.lineKey = self.currentLine.split( ctrlA )[ -1 ]
		except:
			errMsg  = "** <openInFile> == "
			errmsg += fName
			errmsg += " cannot read this file **"
			sys.exit( errMsg )

	def nxtLine( self ):
		self.lineKey = ctrlA  # default the key to assume EOF
		if self.currentLine:
			#
			# the current line is not empty
			# so the end of file has not been 
			# reached
			#
			self.currentLine = self.H.readline()
			if self.currentLine:
				self.lineKey = self.currentLine.split( ctrlA )[ -1 ]
			else:
				self.H.close()

		return self.lineKey
		 
	def cleanCurrentLine( self ):
		#
		# clean line contains no ctrlA characters
		# all fields are space seperated except the
		# last field which is seperated with at tab 
		# character
		#
		self.outData = self.currentLine.split( ctrlA )
		self.fullPath = self.outData.pop()
		self.metaData = space.join( self.outData )
		return tabChr.join( [ self.metaData, self.fullPath ] )

#}}}
class FsysElement: # {{{
	def __init__(self):
		self.Size = 0
		self.MTime = time.gmtime( 0 )
		self.TagKey = 0
		self.Inode = 0
		self.Tag = ' U'
		self.LinkPtr = nullstr
		self.dfsIndex = str( int_encode( dfsIndex, B56) ).zfill( 4 )
# }}}
def microSecTS(): # {{{
	return datetime.datetime.now().strftime( 'T%Y%m%d.%H%M%S.%f' + space )
# }}}
def createStamp(): # {{{
	return time.strftime( '.%Y%m%d.%H%M%S.', time.localtime() )
# }}}
def mkdir_p( path ): # {{{
	#
	# I clipped this from somewhere.
	# it seems to work. But I dont
	# know for sure what 'pass' does here
	#
    try:
        os.makedirs( path )
    except OSError as exc: # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir( path ):
            pass
        else: raise
# }}}
def int_encode( num, alphabet=B56 ): # {{{
    #
	# Encode a number in Base X
	# 
	#     `num`: The number to encode
	#     `alphabet`: The alphabet to use for encoding
	#
    if ( num == 0 ):
        return alphabet[ 0 ]
    arr = []
    base = len( alphabet )
    while num:
        rem = num % base
        num = num // base
        arr.append( alphabet[ rem ] )
    arr.reverse()
    return nullstr.join( arr )
# }}}
def establishDestinationDir( dirHash ): # {{{
	# {{{ dst Directory Logic
	if not sys.platform in dirHash:
		errMsg = "[BAILINGOUT]::** sys.platform == " + sys.platform + " is not supported **"
		sys.exit( errMsg )

	directoryPath = dirHash[ sys.platform ]

	if os.path.exists( directoryPath ):
		alternatePath = directoryPath
		altCount = 0
		while os.path.isfile( alternatePath ):
			#
			# prefered directoryPath exists as a file
			#
			alternatePath = directoryPath + "." + str( altCount )
			altCount += 1
		if altCount:
			#
			# Create alternate dst directory
			# 
			directoryPath = alternatePath
			try:
				mkdir_p( directoryPath )
			except:
				directoryPath = alternateLogDirHash[ sys.platform ]
	else:		
		try:
			mkdir_p( directoryPath )
		except:
			directoryPath = alternateLogDirHash[ sys.platform ]

	if not os.path.isdir( directoryPath ):
		errMsg  = "<directoryPath> == "
		errmsg += directoryPath
		errmsg += " must be a directory"
		sys.exit( errMsg )
	else:
		if not os.access( directoryPath, os.W_OK ):
			errMsg  = "<directoryPath> == "
			errmsg += directoryPath
			errmsg += " must be a writable directory"
			sys.exit( errMsg )

	# }}}
	return directoryPath
# }}}
def openOutFile( fN ): # {{{
	try:
		handle = open( fN, 'wt', encoding='utf-8' )
	except:
		errMsg  = "** <openOutFile> == "
		errmsg += fN
		errmsg += " cannot write to this file **"
		sys.exit( errMsg )

	return handle

# }}}
def openInFile( fN ): # {{{
	try:
		handle = open( fN, 'rt', encoding='utf-8' )
	except:
		errMsg  = "** <openInFile> == "
		errmsg += fN
		errmsg += " cannot read this file **"
		sys.exit( errMsg )

	return handle

# }}}
def nextOutFile( nameType, stamp ): # {{{
	baseName = topNode
	baseName = leadingDrive.sub( "\\1.slash.", baseName )
	baseName = leadingSlash.sub( "slash.", baseName )
	baseName = trailingSlash.sub( "", baseName )
	baseName = anySlash.sub( ".", baseName )
	baseName = socket.gethostname() + '.' + baseName

	suffix = ".txt"
	stringMatches = allDigits.match( nameType )
	if stringMatches:
		#
		# A name type of all digits
		# is a temporary carton file.
		#
		# Cartons fill a pantry.
		#
		# All the cartons in the pantry
		# eventually get placed into a 
		# single crate (a srt.txt file).
		#
		nameType = int_encode( int( nameType ), B16 )
		nameType = str( nameType ).zfill( 3 ) 
		suffix = ".tmp"

	outFName  =	establishDestinationDir( logDirHash )
	outFName += "/"
	outFName += baseName

	if "ezn" == nameType:
		outFName += ".toc."
	else:
		outFName += stamp

	outFName += nameType
	outFName += suffix
	outFName  = anyPeriod.sub( ".", outFName )
	outFName  = anySlash.sub( "/", outFName )

	if ".tmp" == suffix:
		pantry[ outFName ] = 0

	if ".ezn" == suffix:
		outFHandle = tempfile.TemporaryFile() 
	else:
		outFHandle = openOutFile( outFName )

	return { "outFHandle":outFHandle, "outFName":outFName, "baseName":baseName }
# }}}
def int_decode( string, alphabet=B56 ): # {{{
	#
	# Decode a Base X encoded string into the number
	#
	#    Arguments:
	#    - `string`: The encoded string
	#    - `alphabet`: The alphabet to use for encoding
	#
    base = len( alphabet )
    strlen = len( string )
    num = 0

    idx = 0
    for char in string:
        power = ( strlen - ( idx + 1 ) )
        num += alphabet.index( char ) * ( base ** power )
        idx += 1

    return num
# }}}
def WriteFsysElementInfo( path, fH, fN ): # {{{
	#
	# send a line to a text file
	#
	e = carton[ cartonIdx[ path ] ]
	iNodeEnc = iNodeBase[ sys.platform ]
	iNodeStr = int_encode( e.Inode, iNodeEnc )
	msg	 = str( e.Tag ).rjust( 2 )
	msg += ctrlA
	msg += e.dfsIndex
	msg += ctrlA
	msg += time.strftime('%Y%m%d.%H%M%S', e.MTime )
	msg += ctrlA
	msg += str( iNodeStr ).zfill( iNodeFldWdth[ sys.platform ] ) 
	msg += ctrlA
	msg += str( e.Size ).zfill( 12 ) 
	msg += ctrlA
	msg += path
	msg += e.LinkPtr
	msg += "\n"
	fH.write( msg )
# }}}
# {{{ Main descent Loop Initialization
cartonNumber = 0
uniqIdStamp = createStamp()
drpBxPath = establishDestinationDir( drpBxDirHash )
#
# error log file is a special carton
#
rslt = nextOutFile( "log", uniqIdStamp )
dstLogFName = rslt[ "outFName" ]
fLog = rslt[ "outFHandle" ]
#
# error log file is a special carton
#
rslt = nextOutFile( "raw", uniqIdStamp )
dstRawFName = rslt[ "outFName" ]
fRaw = rslt[ "outFHandle" ]


dirStack = []
dirStack.insert( 0, topNode )
# }}}
while len( dirStack ): # {{{ Main Outer Loop

	thisDir = dirStack.pop()

	urlPath = urllib.request.pathname2url( thisDir ) 
	if urlPath in skiplist : 
		if skiplist[ urlPath ] == sys.platform :
			continue

	try:
		dirListing = os.listdir( thisDir )
	except:
		fLog.write( microSecTS()								+ 
					str( int_encode( dfsIndex ) ).zfill( 4 )	+
					" <<< [[[Exception 0 Triggered]]]::"		+ 
					thisDir										+ 
					">>>\n" )

		dirListing = []

	for eName in dirListing: # {{{ Main inner Loop
		dfsIndex += 1
		fullPath = os.path.join( thisDir, eName )
		e = FsysElement()

		try:
			e.Size    = os.lstat( fullPath )[ stat.ST_SIZE ]
			e.MTime   = time.localtime( os.path.getmtime( fullPath ) )

			e.TagKey  = 0
			e.TagKey |= os.path.isfile(	fullPath )
			e.TagKey |= os.path.isdir(	fullPath ) << 1
			e.TagKey |= os.path.islink(	fullPath ) << 2

			e.Tag     = elementTagHash[ e.TagKey ]
			e.Inode   = abs( os.stat( fullPath ).st_ino )
			if 'L' == e.Tag[ 0 ]:
				e.LinkPtr = ' -> ' + os.readlink( fullPath ) 
		except:
			# {{{ Exception Triggered
			fLog.write( microSecTS()								+ 
						str( int_encode( dfsIndex ) ).zfill( 4 )	+
						" <<< [[[Exception 1 Triggered]]]::"		+ 
						fullPath									+ 
						">>>\n"  )
			# }}}

		cartonIdx [ fullPath ] = len( carton )
		carton.append( e )
		WriteFsysElementInfo( fullPath, fRaw, dstRawFName )

		if 'D' == e.Tag:
			dirStack.insert( 0, fullPath )

		if itemsPerCarton == len( carton ): # {{{
			rslt = nextOutFile( str( cartonNumber ), uniqIdStamp )
			dstFName = rslt[ "outFName" ]
			fOut = rslt[ "outFHandle" ]
			fLog.write( microSecTS() + '> ' + dstFName + "\n")
			#
			# pantry dictionary contains the full path names 
			# of all the carton files as indexes.
			# associated with each carton file is a linecount
			#
			pantry[ dstFName ] = len( carton )
			for fullPath in sorted( cartonIdx.keys() ): # {{{
				WriteFsysElementInfo( fullPath, fOut, dstFName )
			# }}}
			fOut.close()
			#
			# I only keep the 'active' carton in memory.
			# So, clear out the old. Make room for the new.
			# This python slice semantics will take me
			# some getting-used-to.
			#
			carton[:] = []
			#
			# Carton has been cleared so must also
			# be the carton index.
			#
			cartonIdx.clear()
			cartonNumber += 1
		# }}}
		# }}}
# }}}
# {{{ Main descent Loop Cleanup
if len( carton ): # {{{
	#
	# usually a partially filled carton 
	# will be left over. So, manage that condition.
	#
	rslt = nextOutFile( str( cartonNumber ), uniqIdStamp )
	dstFName = rslt[ "outFName" ]
	fOut = rslt[ "outFHandle" ]
	fLog.write( microSecTS() + '> ' + dstFName  + "\n")
	pantry[ dstFName ] = len( carton )
	for fullPath in sorted( cartonIdx.keys() ): # {{{
		WriteFsysElementInfo( fullPath, fOut, dstFName )
	# }}}
	fOut.close() # }}}
# recursive descent is complete
# now I need to merge all of my
# cartons into a single crate
# which will be sorted by fullpathname
#
fRaw.close()
# }}}
# {{{ Initialize the merge operation
#
# put the names of all
# merge files in the mergeQ
#
mergeQ = []
tmpFileList = list( pantry.keys() )
for fName in tmpFileList:
	#
	# open temp file for reading
	#
	bucket = InputMergeObj( fName )
	#
	# put the handle, FileName pair in the queue
	#
	mergeQ.append( bucket )

rslt = nextOutFile( "srt", uniqIdStamp )
dstSrtFName = rslt[ "outFName" ]
fSrt = rslt[ "outFHandle" ]

therezWork2do = True
# }}}
while therezWork2do: # {{{ Main Merge Loop
	minIdx = 0
	if 1 < len( mergeQ ):
		for idx in list( range( 1, len( mergeQ ) ) ):
			if mergeQ[ idx ].lineKey < mergeQ[ minIdx ].lineKey:
				minIdx = idx
		bucket = mergeQ[ minIdx ]
		fSrt.write( bucket.cleanCurrentLine() )
		if ctrlA == bucket.nxtLine():
			fLog.write( microSecTS() + '< ' + mergeQ[ minIdx ].N + "\n" )
			mergeQ.pop( minIdx )
			minIdx = 0
	else:
		therezWork2do = False
# }}}
# {{{ Merge Cleanup
bucket = mergeQ[ 0 ]
fSrt.write( bucket.cleanCurrentLine() )
while ctrlA != bucket.nxtLine(): # {{{
	#
	# write out all the lines that remain
	# is the last bucket
	#
	fSrt.write(  bucket.cleanCurrentLine() )
	# }}}
fLog.write( microSecTS() + '< ' + mergeQ[ 0 ].N  + "\n")
mergeQ.pop( 0 )
fSrt.close()
fLog.close()
#
# cleanup the temp files
#
tmpFileList = list( pantry.keys() )
for fName in tmpFileList:
	os.remove( fName )

rslt = nextOutFile( "ezn", uniqIdStamp )
dstEzFName = rslt[ "outFName" ]
shutil.copy2(dstSrtFName, dstEzFName)
shutil.copy2(dstEzFName, drpBxPath)

print( dstRawFName )
print( dstSrtFName )
print( dstLogFName )
print( dstEzFName )
