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
    let pathRelative = "dir1".Path
    let pathAbsolute = testDirPath / pathRelative
    let dir = fs.createDir(pathAbsolute)
    check fs.dirExists pathAbsolute
    check dir.exists

  test "should return true for existing directory when checking for relative path":
    let pathRelative = "dir2".Path
    let pathAbsolute = testDirPath / pathRelative
    let dir = fs.createDir(pathAbsolute)
    fs.currentDir = testDirPath
    check fs.dirExists pathRelative
    check dir.exists

  test "should return false for non-existing directory when checking for absolute path":
    let pathRelative = "dir3".Path
    let pathAbsolute = testDirPath / pathRelative
    check not fs.dirExists pathAbsolute
    let dir = fs.getDirHandle pathAbsolute
    check not dir.exists

  test "should return false for non-existing directory when checking for relative path":
    let pathRelative = "dir4".Path
    fs.currentDir = testDirPath
    check not fs.dirExists pathRelative
    let dir = fs.getDirHandle pathRelative
    check not dir.exists

  test "should return false for file when checking for absolute path":
    let fileRelative = "dir5/file.txt".Path
    let fileAbsolute = testDirPath / fileRelative
    fs.currentDir = testDirPath
    fs.createDir("dir5".Path)
    let dir = fs.getDirHandle(fileAbsolute)
    open(fileAbsolute.string, fmWrite).close()
    check not fs.dirExists fileAbsolute
    check not dir.exists
    check fs.fileExists fileAbsolute

  test "should return false for file when checking for relative path":
    let fileRelative = "dir6/file.txt".Path
    let fileAbsolute = testDirPath / fileRelative
    fs.currentDir = testDirPath
    fs.createDir("dir6".Path)
    let dir = fs.getDirHandle(fileRelative)
    open(fileAbsolute.string, fmWrite).close()
    check not fs.dirExists fileRelative
    check not dir.exists
    check fs.fileExists fileRelative
  