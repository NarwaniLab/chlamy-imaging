dir_input = getDirectory("Choose Source Directory");     /// input directory
dir_output = getDirectory("Choose Destination Directory");/// output directory
list = getFileList(dir_input);							  /// create a list of images to be analyzed
for (i=0; i<list.length; i++) {						  /// analyze every photo in the list
open(dir_input+list[i]);							      /// open image
vid1 = getTitle();										  /// get the title of the photo
run("Duplicate...", " ");                                /// create an image duplicate
vid2 = getTitle();									      /// get the title of the duplicate
selectWindow(vid1);									  /// select one of the 2 images to analyze
run("Set Scale...", "distance=1.5509 known=1 pixel=1 unit=[µm]");/// set image scale in µm
run("8-bit");											  /// convert to a 8-bit image
run("Smooth");											  /// smooth background
run("Smooth");											  /// second smoothing
setOption("BlackBackground", true); 			          /// white cells on a black background
run("Auto Threshold", "method=Triangle");				  /// threshold set up
run("Fill Holes");									      /// fill holes to define edges
run("Watershed");									      /// separate touching objects
run("Set Measurements...", "area redirect=None decimal=3");/// set measurements, select window to be analyzed
run("Analyze Particles...", "size=60-Infinity show=Ellipses circularity=0.50-1.00 display exclude clear");/// settings
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");/// name output results
imageCalculator("AND create", "Drawing of "+list[i], vid2);/// creating image with ellipses
saveAs("Jpeg", dir_output +replace(list[i],".tif",".jpg"));/// save images
run("Close");											  /// close images
run("Close");										      /// close results table
run("Close");
run("Close");
}    
