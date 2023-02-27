use strict;
use warnings;
use Image::ExifTool qw(:Public);

my $filename = "DJI_0825.JPG"; # assuming the image file is named "image.jpg" and in the same root directory as the script
my $exifTool = new Image::ExifTool;
my $info = $exifTool->ImageInfo($filename); # read the image metadata using exiftool
foreach my $tag (keys %$info) { # print all metadata tags and their values
 print ("$tag: $info->{$tag}\n");
}
