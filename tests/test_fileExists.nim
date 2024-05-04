import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.fileExists":
  let testDirPath = getCurrentDir() / "./temp/testDirs/fileExistsTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should return true for existing file when checking for absolute path":
    let pathRelative = "file1.pdf".Path
    let pathAbsolute = testDirPath / pathRelative
    let file = fs.createFile pathAbsolute
    check fs.fileExists pathAbsolute
    check file.exists

  test "should return true for existing file when checking for relative path":
    let pathRelative = "file2.pdf".Path
    let pathAbsolute = testDirPath / pathRelative
    let file = fs.createFile pathAbsolute
    fs.currentDir = testDirPath
    check fs.fileExists pathRelative
    check file.exists

  test "should return false for non-existing file when checking for absolute path":
    let pathRelative = "file3.pdf".Path
    let pathAbsolute = testDirPath / pathRelative
    check not fs.fileExists pathAbsolute
    let file = fs.getFileHandle pathAbsolute
    check not file.exists

  test "should return false for non-existing file when checking for relative path":
    let pathRelative = "file4.pdf".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.currentDir = testDirPath
    check not fs.fileExists pathRelative
    let file = fs.getFileHandle pathRelative
    check not file.exists

  test "should return false for directory when checking for absolute path":
    let pathRelative = "dir1".Path
    let pathAbsolute = testDirPath / pathRelative
    createDir(pathAbsolute)
    check not fs.fileExists pathAbsolute
    let file = fs.getFileHandle pathAbsolute
    check not file.exists

  test "should return false for directory when checking for relative path":
    let pathRelative = "dir2".Path
    let pathAbsolute = testDirPath / pathRelative
    createDir(pathAbsolute)
    fs.currentDir = testDirPath
    check not fs.fileExists pathRelative
    let file = fs.getFileHandle pathRelative
    check not file.exists