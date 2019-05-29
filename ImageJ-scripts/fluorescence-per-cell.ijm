// **********************************************************************************************************************
// ** Pennekamp & Schtickzelle (2013)                                                                                  **
// ** Implementing image analysis in laboratory-based experimental systems for ecology and evolution: a hands-on guide **
// ** ImageJ script for digital image analysis                                                                         **   
// **********************************************************************************************************************

// **************************************************************************** 
// **                    Start of USER SECTION                               **
// ****************************************************************************

// specify input directory
dir_input = getDirectory("Choose Source Directory ");

// specify directory with photos for comparison
// dir_compare = 'c:\\MEE\\Images\\2 - Photos for comparison\\'

// specify output directory
dir_output = getDirectory("Choose Destination Directory ");

// specify segmentation approach (i.e. 'threshold', 'difference image' or 'edge detection')
// seg = 'threshold'

// specify whether you want to split objects by watershed after segmentation (if yes, put 'ws', else '_')
// ws = '_ws_'; 

// specify size boundaries to exclude objects that are smaller/bigger than the min_size/max_size
// min_size = 15
// max_size = 200

// **************************************************************************** 
// **                    End of USER SECTION                                 **
// ****************************************************************************

// work in batch mode to prevent display of images and run faster
setBatchMode(true);

// 1. LOOPING OVER THE IMAGE DIRECTORY AND READING OF IMAGE DATA
//--------------------------------------------------------------

list = getFileList(dir_input);

// loop over the input directory
for (i=0; i<list.length; i++) {

// check that one segmentation approach is selected
// if (seg == 'threshold' || seg == 'watershed' || seg == 'edge detection' || seg == 'difference image'){
    
// read reference image to be analyzed (the image origin (0,0) is the upper left corner)
open(dir_input+list[i]);
	
// create duplicate image for later measurements on pixel intensities
run("Duplicate...", "title"); 

// 2a. SEGMENTING IMAGE DATA BY THRESHOLDING, DIFFERENCE IMAGE OR EDGE DETECTION
//------------------------------------------------------------------------------

 setAutoThreshold("Default dark no-reset");
//run("Threshold...");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");

run("Set Measurements...", "area mean min display redirect="+replace(list[i],".TIF","-1.TIF")+" decimal=3");

run("Analyze Particles...", "display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
run("Close");
close();
selectWindow(list[i]);
close();
}    


