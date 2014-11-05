#! /usr/bin/python
'''
File Name: picfix.py
Author:	Paul long <pwl@pdx.edu>

Date: November 2014

Required:
	Python Version: 2.7: https://www.python.org/download/releases/2.7/
	Python image library: http://www.pythonware.com/products/pil/
	
Description:
	This script loads in an image supplied by the user and converts it to a
	stuffed array for use in a verilog module
	The code is heavily modified from:
	https://github.com/Jesse-Millwood/image-2-coe
	which, itself was adapted from a MATLAB script, "IMG2coe8.m",
	that was found in an on-line example at: 
	http://www.lbebooks.com/downloads.htm#vhdlnexys
	The specific example is at:
	http://www.lbebooks.com/downloads/exportal/VHDL_NEXYS_Example24.pdf
	
	I also got some info (which probably should have been obvious)
	from: http://computingvoyage.com/982/color-bit-depth-reducer/
	
	A good PIL guide is at: http://effbot.org/imagingbook/pil-index.htm
	
TO USE:
	The easiest way to use this script is to copy this module to the directory
	that contains the image that you want to convert. Then type picfix.py!!!
	
	The code is easily changed but it is currently set up to work with an original
	image the points north.
	
	User should ensure that the rotated picture will fit in the specified 
	dimensions
	
	
	
'''
# Imported Standard Modules
import sys
from PIL import Image 

def Convert (ImageName):
	
	# Open image, make a  45 deg version, shrink to user-specified size
	# Save these guys out to disk, this gives a preview before you add
	# the array to your verilog project
	img = Image.open(ImageName)
	img45 = img.rotate(315)
	img45 = img45.resize((outWidth,outHeight),Image.ANTIALIAS)
	img = img.resize((outWidth,outHeight),Image.ANTIALIAS)
	img45.save('rotated_'+ImageName, 'png')
	img.save('shrunk_'+ImageName, 'png')
	
	# if necessary, convert to RGB
	if img.mode != 'RGB':
		img = img.convert('RGB')
	if img45.mode != 'RGB':
		img45 = img.convert('RGB')
		
	
	
	# Store Width and height of transformed image
	# If these dont equal the specified size, something went wrong 
	# with the above steps
	width 	= img.size[0]
	height	= img.size[1]

	# Open up the outfile and create the array declaration
	filetype = ImageName[ImageName.find('.'):]
	filename = ImageName.replace(filetype,'.txt')
	oFile	= open(filename,'wb')
	oFile.write('/**********************************************\n')
	oFile.write('*****  Template file for the image array\n')
	oFile.write('*****  Produced from {}\n'.format(ImageName))
	oFile.write('***********************************************/\n\n')
	oFile.write('reg [11:0] iconPixArray[{}:0];\n'.format(width * height * 2 - 1))
	
	# Grab the individual pixels and convert to 12-bit color depth
	cnt = 0
	for i in ['img','img45']:
		for r in range(0, height):
			for c in range(0, width):
				# Check for IndexError, usually occurs if the script is trying to 
				# access an element that does not exist
				try:
					R,G,B = img.getpixel((c,r))
				except IndexError:
					print 'Index Error Occurred At:'
					print 'c: {}, r:{}'.format(c,r)
					sys.exit()
				# convert the value 
				R = hex(R*15/255)[2:]
				G = hex(G*15/255)[2:]
				B = hex(B*15/255)[2:]
				ColorValue = R+G+B
				
				# Check for Value Error, happened when the case of the pixel being 
				# zero was not handled properly	
				try:
					oFile.write("iconPixArray[%d] = 12'h%3.2X;\n"%(cnt, int(ColorValue,16)))
				except ValueError:
					print 'Value Error Occurred At:'
					print 'Contents of ColorValue: {0} at r:{1} c:{2}'.format(ColorValue,r,c)
					print 'R:{0} G:{1} B{2}'.format(R,G,B)
					print 'Rb:{0} Gb:{1} Bb:{2}'.format(Rb,Gb,Bb)
					sys.exit()
				cnt += 1
	
	
	
	
	oFile.write('\n/**********************************************\n')
	oFile.write('*****  End of array template\n')
	oFile.write('***********************************************/\n\n')
	oFile.close()
	print '\n\n\t***********************************************************\n'
	print '\t\tDONE!!! Saved as: {}\n'.format(filename)
	print '\t\tConverted from {}'.format(filetype)
	print '\t\tOriginal size: {} pixels by {} pixels\n'.format(height,width)
	print '\t\tConstructed array dimentions are [11:0][{}:0]\n'.format(width * height * 2 - 1)
	print '\t***********************************************************\n\n\n'



if __name__ == '__main__':
	print '\n\n\n\n\n\n'
	ImageName = raw_input('Enter the name of your image: ')
	outHeight = int(input('Enter desired finished height: '))
	outWidth = int(input('Enter desired finished width: '))
	Convert(ImageName)
