import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.dirExists":
  let testDirPath = getCurrentDir() / "./temp/testDirs/dirExistsTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should return true for existing directory when checking for absolute path":
    let dirRelative = "dir1".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.createDir(dirAbsolute)
    check(fs.dirExists dirAbsolute)

  test "should return true for existing directory when checking for relative path":
    let dirRelative = "dir2".Path
    let dirAbsolute = testDirPath / dirRelative
    fs.createDir(dirAbsolute)
    fs.currentDir = testDirPath
    check(fs.dirExists dirRelative)

  test "should return false for non-existing directory when checking for absolute path":
    let dirRelative = "dir3".Path
    let dirAbsolute = testDirPath / dirRelative
    check(not fs.dirExists dirAbsolute)

  test "should return false for non-existing directory when checking for relative path":
    let dirRelative = "dir4".Path
    fs.currentDir = testDirPath
    check(not fs.dirExists dirRelative)

  test "should return false for file when checking for absolute path":
    let fileRelative = "dir5/file.txt".Path
    let fileAbsolute = testDirPath / fileRelative
    fs.currentDir = testDirPath
    fs.createDir("dir5".Path)
    open(fileAbsolute.string, fmWrite).close()
    check(not fs.dirExists fileAbsolute)
    check(fs.fileExists fileAbsolute)
  