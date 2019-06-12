dir_input = getDirectory("Choose Source Directory");
dir_output = getDirectory("Choose Destination Directory");
list = getFileList(dir_input);
for (i=0; i<list.length; i++) {
open(dir_input+list[i]);
setAutoThreshold("Default dark no-reset");
setOption("BlackBackground", false);
run("Convert to Mask");
run("Watershed");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=10-Infinity show=Nothing display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
run("Close");
close();

}    
