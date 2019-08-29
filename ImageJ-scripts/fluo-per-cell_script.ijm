dir_input = getDirectory("Choose Source Directory ");       /// specify input directory
dir_output = getDirectory("Choose Destination Directory "); /// specify output directory
setBatchMode(true);                            /// work in batch mode to prevent display of images and run faster
list = getFileList(dir_input);                 /// create a list of pictures to be analyzed
for (i=0; i<list.length; i++) {                             /// loop over the input directory
open(dir_input+list[i]);                                    /// read reference image to be analyzed
run("Set Scale...", "distance=1221.3 known=1971.4 unit=µm"); /// set scale from pixels to µm
run("Duplicate...", "title");                  /// create duplicate image for later measurements on pixel intensities
setAutoThreshold("Default dark no-reset");                  ///run("Threshold...");
setOption("BlackBackground", true);                         /// black background, light colored cells
run("Convert to Mask");                                     ///binary conversion
run("Watershed");                                           /// split touching objects
run("Set Measurements...", "area mean min display redirect="+replace(list[i],".TIF","-1.TIF")+" decimal=3");/// select window
run("Analyze Particles...", "size=5-75 display exclude clear");          /// settings
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");/// name output results
run("Close");                                               /// close photos and results table
close();
selectWindow(list[i]);
close();

}    


