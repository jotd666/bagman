import subprocess,os,glob,shutil

progdir = os.path.abspath(os.path.join(os.path.dirname(__file__),os.pardir))

gamename = "bagman"
# JOTD path for cranker, adapt to wh :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",os.path.join(progdir,"makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=os.path.join(progdir,"src"))

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=os.path.join(progdir,"src"))
# create archive

outdir = os.path.join(progdir,f"{gamename}_HD")
if os.path.exists(outdir):
    for x in glob.glob(os.path.join(outdir,"*")):
        os.remove(x)
else:
    os.mkdir(outdir)
for file in ["readme.md","how_to_play.txt","instructions.txt",gamename,f"{gamename}.slave"]:
    shutil.copy(os.path.join(progdir,file),outdir)

shutil.copy(os.path.join(progdir,"assets","amiga","Bagman500.info"),outdir)
shutil.copy(os.path.join(progdir,"assets","amiga","boxart.jpg"),outdir)

# pack the file for floppy
subprocess.check_output(["cranker_windows.exe","-f",os.path.join(progdir,gamename),"-o",os.path.join(progdir,f"{gamename}.rnc")])