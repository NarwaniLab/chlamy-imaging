dir_input = getDirectory("Choose Source Directory ");
dir_output = getDirectory("Choose Destination Directory ");
setBatchMode(true);
list = getFileList(dir_input);
for (i=0; i<list.length; i++) {
open(dir_input+list[i]);
run("Set Scale...", "distance=1221.3 known=1971.4 unit=µm");
run("Duplicate...", "title"); 
setAutoThreshold("Default dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Set Measurements...", "area mean min display redirect="+replace(list[i],".TIF","-1.TIF")+" decimal=3");
run("Analyze Particles...", "size=25-Infinity show=Outlines circularity=0.50-1.00 display exclude clear");
saveAs("Results", dir_output +replace(list[i],".tif","")+"_results.csv");
run("Close");
close();
selectWindow(list[i]);
close();

}    
