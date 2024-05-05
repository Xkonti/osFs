import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.removeDir":
  let testDirPath = getCurrentDir() / "./temp/testDirs/removeDirTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should remove a directory using an absolute path":
    let dirRelative = "testDir1".Path
    let dirAbsolute = testDirPath / dirRelative
    let dir1 = fs.createDir dirAbsolute
    check dir1.exists
    fs.removeDir dirAbsolute
    check not dir1.exists

    let dir2 = fs.createDir dirAbsolute
    check dir2.exists
    dir2.remove
    check not dir2.exists

  test "should remove a directory using a relative path":
    let dirRelative = "testDir2".Path
    let dirAbsolute = testDirPath / dirRelative
    let dir1 = fs.createDir dirAbsolute
    check dir1.exists
    fs.currentDir = testDirPath
    fs.removeDir dirRelative
    check not dir1.exists

    let dir2 = fs.createDir dirAbsolute
    check dir2.exists
    dir2.remove
    check not dir2.exists

  test "should remove an empty directory":
    let dirRelative = "testDir3".Path
    let dirAbsolute = testDirPath / dirRelative
    let dir1 = fs.createDir dirAbsolute
    check dir1.exists
    fs.removeDir dirAbsolute
    check not dir1.exists

    let dir2 = fs.createDir dirAbsolute
    check dir2.exists
    dir2.remove
    check not dir2.exists

  test "should remove a directory with files":
    let dirRelative = "testDir3".Path
    let dirAbsolute = testDirPath / dirRelative
    # Create the dir and a file inside it
    let dir1 = fs.createDir(dirAbsolute)
    check dir1.exists
    let filePath = dirAbsolute / "file.txt".Path
    open(filePath.string, fmWrite).close()
    fs.removeDir dirAbsolute
    check not dir1.exists

    let dir2 = fs.createDir(dirAbsolute)
    check dir2.exists
    open(filePath.string, fmWrite).close()
    dir2.remove
    check not dir2.exists


  test "should remove a directory with subdirectories":
    let dirRelative = "testDir4".Path
    let dirAbsolute = testDirPath / dirRelative
    # Create the dir and a file inside it
    let dir1 = fs.createDir dirAbsolute
    check dir1.exists
    let filePath = dirAbsolute / "file.txt".Path
    open(filePath.string, fmWrite).close()
    # Create a subdirectory and a file inside it
    let subDirPath = dirAbsolute / "subDir".Path
    var subdir = fs.createDir subDirPath
    check subdir.exists
    let subFilePath = subDirPath / "subFile.txt".Path
    open(subFilePath.string, fmWrite).close()
    # Remove the directory (test)
    fs.removeDir dirAbsolute
    check not dir1.exists

    let dir2 = fs.createDir dirAbsolute
    check dir2.exists
    open(filePath.string, fmWrite).close()
    subdir = fs.createDir subDirPath
    check subdir.exists
    open(subFilePath.string, fmWrite).close()
    # Remove the directory (test)
    dir2.remove
    check not dir2.exists

  test "should not throw an error if the directory does not exist":
    let dirRelative = "testDir5".Path
    let dirAbsolute = testDirPath / dirRelative
    check not fs.dirExists dirAbsolute

    # Absolute
    fs.removeDir dirAbsolute
    let dir1 = fs.getDirHandle dirAbsolute
    dir1.remove

    # Relative
    fs.currentDir = testDirPath
    fs.removeDir dirRelative
    let dir2 = fs.getDirHandle dirRelative
    dir2.remove

  test "should throw an error when trying to remove a file":
    let fileRelative = "testFile1".Path
    let fileAbsolute = testDirPath / fileRelative
    open(fileAbsolute.string, fmWrite).close()
    check fs.fileExists fileAbsolute

    expect CatchableError: fs.removeDir fileAbsolute
    let dir = fs.getDirHandle fileAbsolute
    expect CatchableError: dir.remove