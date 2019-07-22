dir_input = getDirectory("Choose Source Directory");
dir_output = getDirectory("Choose Destination Directory");
list = getFileList(dir_input);
for (i=0; i<list.length; i++) {
open(dir_input+list[i]);
vid1 = getTitle();
run("Duplicate...", " ");
vid2 = getTitle();
selectWindow(vid1);
run("Set Scale...", "distance=1.5509 known=1 pixel=1 unit=[µm]");
run("8-bit");
run("Smooth");
run("Smooth");
setOption("BlackBackground", true);
run("Auto Threshold", "method=Triangle");
run("Fill Holes");
run("Watershed");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=60-Infinity show=Ellipses circularity=0.50-1.00 display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
imageCalculator("AND create", "Drawing of "+list[i], vid2);
saveAs("Jpeg", dir_output +replace(list[i],".tif",".jpg"));
run("Close");
run("Close");
run("Close");
run("Close");
}    
