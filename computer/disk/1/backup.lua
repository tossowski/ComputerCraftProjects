args = {...}
infile = fs.open(args[1], "r")
rednet.open("right")
rednet.broadcast(args[1], "backup")
os.sleep(2)
filestring = infile.readAll()
rednet.broadcast(filestring, "fileInfo")
rednet.close("right")
infile.close()
