dir_input = getDirectory("Choose Source Directory");
dir_output = getDirectory("Choose Destination Directory");
list = getFileList(dir_input);
for (i=0; i<list.length; i++) {
open(dir_input+list[i]);
run("Set Scale...", "distance=1.5509 known=1 pixel=1 unit=[µm]");
run("8-bit");
setOption("BlackBackground", false);
run("Make Binary");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=25-Infinity show=Outlines circularity=0.50-1.00 display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
run("Close");
close();

}    
