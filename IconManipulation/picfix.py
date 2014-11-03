#! /usr/bin/python
'''
File Name: pic2array.py
Author:	Paul long <pwl@pdx.edu>
Python Version: 2.7
Date: November 2014
Description:
	This script loads in an image defined by the user and converts it to a
	stuffed array for use in a verilog program
	The vast majority of this code is adapted from:
	https://github.com/Jesse-Millwood/image-2-coe
	which, itself was adapted from a MATLAB script, "IMG2coe8.m",
	that was found in an on-line example at: 
	http://www.lbebooks.com/downloads.htm#vhdlnexys
	The specific example is at:
	http://www.lbebooks.com/downloads/exportal/VHDL_NEXYS_Example24.pdf
	
	I also got some info (which probably should have been obvious)
	from: http://computingvoyage.com/982/color-bit-depth-reducer/
	
TO USE:
	The easiest way to use this script is to copy this module to the directory
	that contains the image that you want to convert. Then run!!!
'''
# Imported Standard Modules
import sys
from PIL import Image 

def Convert (ImageName):
	
	# Open image
	img = Image.open(ImageName)
	# Verify that the image is in the 'RGB' mode, every pixel is described by 
	# three bytes
	if img.mode != 'RGB':
		img = img.convert('RGB')

	# Store Width and height of image
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
	oFile.write('reg	[11:0]	imageArray[{}:0];\n'.format(width * height * 2 - 1))
	
	# Grab the individual pixels and scale them down
	# 

	cnt = 256
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
	
	cnt = 0
	vert = img.rotate(45)
	for r in range(0, height):
		for c in range(0, width):
			# Check for IndexError, usually occurs if the script is trying to 
			# access an element that does not exist
			try:
				R,G,B = vert.getpixel((c,r))
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
	
	
	oFile.close()
	print '\n\n\t***********************************************************\n'
	print '\t\tDONE!!! Saved as: {}\n'.format(filename)
	print '\t\tConverted from {}'.format(filetype)
	print '\t\tOriginal size: {} pixels by {} pixels\n'.format(height,width)
	print '\t\tConstructed array dimentions are [11:0][{}:0]\n'.format(width * height * 2 - 1)
	print '\t***********************************************************\n\n\n'



if __name__ == '__main__':
	ImageName = raw_input('Enter the name of your image: ')
	Convert(ImageName)
