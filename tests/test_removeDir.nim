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
    createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))
    fs.removeDir(dirAbsolute)
    check(not fs.dirExists(dirAbsolute))

  test "should remove a directory using a relative path":
    let dirRelative = "testDir2".Path
    let dirAbsolute = testDirPath / dirRelative
    createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))
    fs.currentDir = testDirPath
    fs.removeDir(dirRelative)
    check(not fs.dirExists(dirAbsolute))

  test "should remove an empty directory":
    let dirRelative = "testDir3".Path
    let dirAbsolute = testDirPath / dirRelative
    createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))
    fs.removeDir(dirAbsolute)
    check(not fs.dirExists(dirAbsolute))

  test "should remove a directory with files":
    let dirRelative = "testDir3".Path
    let dirAbsolute = testDirPath / dirRelative
    # Create the dir and a file inside it
    createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))
    let filePath = dirAbsolute / "file.txt".Path
    open(filePath.string, fmWrite).close()
    fs.removeDir(dirAbsolute)
    check(not fs.dirExists(dirAbsolute))


  test "should remove a directory with subdirectories":
    let dirRelative = "testDir4".Path
    let dirAbsolute = testDirPath / dirRelative
    # Create the dir and a file inside it
    createDir(dirAbsolute)
    check(fs.dirExists(dirAbsolute))
    let filePath = dirAbsolute / "file.txt".Path
    open(filePath.string, fmWrite).close()
    # Create a subdirectory and a file inside it
    let subDirPath = dirAbsolute / "subDir".Path
    createDir(subDirPath)
    check(fs.dirExists(subDirPath))
    let subFilePath = subDirPath / "subFile.txt".Path
    open(subFilePath.string, fmWrite).close()
    # Remove the directory (test)
    fs.removeDir(dirAbsolute)
    check(not fs.dirExists(dirAbsolute))

  test "should not throw an error if the directory does not exist":
    let dirRelative = "testDir5".Path
    let dirAbsolute = testDirPath / dirRelative
    check(not fs.dirExists(dirAbsolute))
    fs.removeDir(dirAbsolute)
    fs.currentDir = testDirPath
    fs.removeDir(dirRelative)

  test "should throw an error when trying to remove a file":
    let fileRelative = "testFile1".Path
    let fileAbsolute = testDirPath / fileRelative
    open(fileAbsolute.string, fmWrite).close()
    check(fs.fileExists(fileAbsolute))
    expect CatchableError: fs.removeDir(fileAbsolute)