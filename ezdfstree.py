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
# }}}

itemsPerCarton = 8191
topNode = os.getcwd()
pantry = {}
carton = []
cartonIdx = {}
dfsIndex = -1
ctrlA = str( chr( 1 ) )
#
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
# in a pantry whereas a carton jus might)
#
B16 = "0123456789ABCDEF"
#
# finally I use simple base 10 for nix inodes
# but since I select these encodings via 
# the iNodeBase dictionary, the logic is
# same for android and windows
#
B10 = "0123456789"

#
# an element is either a...
# 'F'ile
# 'D'irectory
# 'L'ink
# 'U'nknown
#
elementTagHash = {  # {{{
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
# python installed in fultonJSheen
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

dstAltDirHash = {
 'linux-armv7l':os.getenv( 'EXTERNAL_STORAGE' ),
		'win32':os.getenv( 'TEMP' ),
}

dstDirHash = { 
 'linux-armv7l': '/mnt/sdcard/00/log/tox',
		'win32': 'C:/etc/tox'
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

class InFileTupple:  # {{{
	def __init__( self, fName ):
		self.N = fName
		self.lineCnt = pantry[ fName ]
		try:
			self.H = open( fName, 'rt', encoding='utf-8' )
			self.currentLine = self.H.readline()
			self.lineKey = self.currentLine.split( ctrlA )[ -1 ]
		except:
			errMsg  = "** <openInFile> == "
			errmsg += fName
			errmsg += " cannot read this file**"
			sys.exit( errMsg )

	def nxtLine( self ):
		if self.lineCnt:
			self.currentLine = self.H.readline()
			self.lineKey = self.currentLine.split( ctrlA )[ -1 ]
			self.lineCnt -= 1
			if 0 == self.lineCnt:
				self.H.close()
		else:
			self.currentLine = ""
			self.lineKey = ctrlA
		return self.lineKey
		 
#}}}

class FsysElement: # {{{
	def __init__(self):
		self.Size = 0
		self.MTime = time.gmtime( 0 )
		self.TagKey = 0
		self.Inode = 0
		self.Tag = ' U'
		self.LinkPtr = ""
		self.dfsIndex = str( int_encode( dfsIndex ) ).zfill( 4 )
# }}}

def microSecTS(): # {{{
	return datetime.datetime.now().strftime( 'T%Y%m%d.%H%M%S.%f' )
# }}}

def createStamp(): # {{{
	return time.strftime( '.%Y%m%d.%H%M%S.', time.localtime() )
# }}}

def mkdir_p( path ): # {{{
	#
	# I clipped this from somewhere.
	# is seems to work. But I dont
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
    return ''.join( arr )
# }}}

def getDstDirName(): 
	# {{{ dst Directory Logic
	if not sys.platform in dstDirHash:
		errMsg = "[BAILINGOUT]::** sys.platform == " + sys.platform + " is not supported **"
		sys.exit( errMsg )

	dstDir = dstDirHash[ sys.platform ]

	if os.path.exists( dstDir ):
		dstAlternate = dstDir
		altCount = 0
		while os.path.isfile( dstAlternate ):
			#
			# prefered dstDir exists as a file
			#
			dstAlternate = dstDir + "." + str( altCount )
			altCount += 1
		if altCount:
			#
			# Create alternate dst directory
			# 
			dstDir = dstAlternate
			try:
				mkdir_p( dstDir )
			except:
				dstDir = dstAltDirHash[ sys.platform ]
	else:		
		try:
			mkdir_p( dstDir )
		except:
			dstDir = dstAltDirHash[ sys.platform ]

	if not os.path.isdir( dstDir ):
		errMsg  = "<dstDir> == "
		errmsg += dstDir
		errmsg += " must be a directory"
		sys.exit( errMsg )
	else:
		if not os.access( dstDir, os.W_OK ):
			errMsg  = "<dstDir> == "
			errmsg += dstDir
			errmsg += " must be a writable directory"
			sys.exit( errMsg )

	# }}}
	return dstDir
# }}}

def openOutFile( fN ): # {{{
	try:
		handle = open( fN, 'wt', encoding='utf-8' )
	except:
		errMsg  = "** <openOutFile> == "
		errmsg += fN
		errmsg += " cannot write to this file**"
		sys.exit( errMsg )

	return handle

# }}}

def openInFile( fN ): # {{{
	try:
		handle = open( fN, 'rt', encoding='utf-8' )
	except:
		errMsg  = "** <openInFile> == "
		errmsg += fN
		errmsg += " cannot read this file**"
		sys.exit( errMsg )

	return handle

# }}}


def openNextCarton( nameType, stamp ): # {{{
	baseName = topNode
	baseName = leadingDrive.sub( "\\1.slash.", baseName )
	baseName = leadingSlash.sub( "slash.", baseName )
	baseName = trailingSlash.sub( "", baseName )
	baseName = anySlash.sub( ".", baseName )

	suffix = ".txt"
	stringMatches = allDigits.match( nameType )
	if stringMatches:
		#
		# a name type of all digits
		# is a temporary carton file
		# cartons fill a pantry.
		# All the cartons in the pantry
		# eventually get placed into a 
		# single crate (a srt.txt file).
		#
		nameType = int_encode( int( nameType ), B16 )
		nameType = str( nameType ).zfill( 3 ) 
		suffix = ".tmp"

	outFName  =	getDstDirName()
	outFName += "/"
	outFName += baseName
	outFName += stamp
	outFName += nameType
	outFName += suffix
	outFName  = anyPeriod.sub( ".", outFName )
	outFName  = anySlash.sub( "/", outFName )
	pantry[ outFName ] = -1
	outFHandle = openOutFile( outFName )
	return { "outFHandle":outFHandle, "outFName":outFName }
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

cartonNumber = 0
timeStamp = createStamp()
#
# error log file is a special carton
#
rslt = openNextCarton( "log", timeStamp )
dstLogFName = rslt[ "outFName" ]
fLog = rslt[ "outFHandle" ]
#
# dont confuse carton processing with 
# the error file
#
pantry.pop( dstLogFName )
#
# error log file is a special carton
#
rslt = openNextCarton( "raw", timeStamp )
dstRawFName = rslt[ "outFName" ]
fRaw = rslt[ "outFHandle" ]
#
# dont confuse carton processing with 
# the raw output file
#
pantry.pop( dstRawFName )


dirStack = []
dirStack.insert( 0, topNode )
cartonLevel = -1
while len( dirStack ): # {{{ Main Outer Loop

	thisDir = dirStack.pop()

	urlPath = urllib.request.pathname2url( thisDir ) 
	if urlPath in skiplist : 
		if skiplist[ urlPath ] == sys.platform :
			continue

	try:
		dirListing = os.listdir( thisDir )
	except:
		fLog.write( str( int_encode( dfsIndex ) ).zfill( 4 )	+
					" <<< [[[Exception 0 Triggered]]]::"		+ 
					thisDir									+ 
					">>>\n" )

		dirListing = []

	for eName in dirListing: # {{{ Main inner Loop
		cartonLevel += 1
		dfsIndex += 1
		fullPath = os.path.join( thisDir, eName )
		cartonIdx [ fullPath ] = cartonLevel
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
			fLog.write( str( int_encode( dfsIndex ) ).zfill( 4 )	+
						" <<< [[[Exception 1 Triggered]]]::"		+ 
						fullPath						+ 
						">>>\n"  )
			# }}}

		carton.append( e )
		WriteFsysElementInfo( fullPath, fRaw, dstRawFName )

		if 'D' == e.Tag:
			dirStack.insert( 0, fullPath )


		if cartonLevel >= itemsPerCarton: # {{{
			rslt = openNextCarton( str( cartonNumber ), timeStamp )
			dstFName = rslt[ "outFName" ]
			fOut = rslt[ "outFHandle" ]
			fLog.write( microSecTS() + ' > ' + dstFName + "\n")
			#
			# pantry dictionary contains the full path names 
			# of all the carton files as indexes.
			# associated with each carton file is a linecount
			#
			pantry[ dstFName ] = cartonLevel
			for fullPath in sorted( cartonIdx.keys() ): # {{{
				WriteFsysElementInfo( fullPath, fOut, dstFName )
			# }}}
			fOut.close()
			#
			# I only keep the active carton in memory
			# clear out the old. Make room for the new
			# this python slice semantics will take me
			# some getting-used-to
			#
			carton[:] = []
			#
			# Carton has been cleared so must also
			# be the index
			#
			cartonIdx.clear()
			cartonLevel = -1
			cartonNumber += 1
		# }}}
		# }}}
# }}}

if cartonLevel >= 0:
	#
	# usually a partially filled carton 
	# will be left over. This will cover that
	#
	rslt = openNextCarton( str( cartonNumber ), timeStamp )
	dstFName = rslt[ "outFName" ]
	fOut = rslt[ "outFHandle" ]
	fLog.write( microSecTS() + ' > ' + dstFName  + "\n")
	pantry[ dstFName ] = cartonLevel
	for fullPath in sorted( cartonIdx.keys() ): # {{{
		WriteFsysElementInfo( fullPath, fOut, dstFName )
	# }}}
	fOut.close()
#
# recursive descent is complete
# now I need to merge all of my
# cartons into a single crate
#
fRaw.close()

kList = list( pantry.keys() )
for fName in kList:
	if 0 > pantry[ fName ]:
		pantry.pop( fName )
		
kList[:] = []
mergeQ = []
kList = list( pantry.keys() )
for fName in kList:
	bucket = InFileTupple( fName )
	mergeQ.append( bucket )

rslt = openNextCarton( "srt", timeStamp )
dstSrtFName = rslt[ "outFName" ]
fSrt = rslt[ "outFHandle" ]
#
# dont confuse carton processing with 
# the sorted output file
#
pantry.pop( dstSrtFName )

therezWork2do = True
while therezWork2do:
	minIdx = 0
	if 1 < len( mergeQ ):
		for idx in list( range( 1, len( mergeQ ) ) ):
			if mergeQ[ idx ].lineKey < mergeQ[ minIdx ].lineKey:
				minIdx = idx
		bucket = mergeQ[ minIdx ]
		fSrt.write( bucket.currentLine )
		if ctrlA == bucket.nxtLine():
			fLog.write( microSecTS() + ' < ' + mergeQ[ minIdx ].N + "\n")
			mergeQ.pop( minIdx )
			minIdx = 0
	else:
		therezWork2do = False

bucket = mergeQ[ 0 ]
fSrt.write( bucket.currentLine )
while ctrlA != bucket.nxtLine():
	fSrt.write( bucket.currentLine )

fLog.write( microSecTS() + ' < ' + mergeQ[ 0 ].N  + "\n")
mergeQ.pop( 0 )

fSrt.close()
fLog.close()
#
# cleanup the temp files
#
kList = list( pantry.keys() )
for fName in kList:
	os.remove( fName )

print( dstRawFName )
print( dstSrtFName )
print( dstLogFName )
