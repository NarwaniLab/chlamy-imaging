dir_input = getDirectory("Choose Source Directory");
dir_output = getDirectory("Choose Destination Directory");
list = getFileList(dir_input);
for (i=0; i<list.length; i++) {
open(dir_input+list[i]);
run("Set Scale...", "distance=1.5509 known=1 pixel=1 unit=[µm]");
run("8-bit");
setOption("BlackBackground", false);
run("Make Binary");
run("Find Edges");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=75-Infinity show=Outlines circularity=0.30-1.00 display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
run("Close");
close();

}    
