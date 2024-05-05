import std/unittest
import std/paths
import std/dirs
import commonFs
from osFs import newOsFs

suite "OsFs.createDir":
  let testDirPath = getCurrentDir() / "./temp/testDirs/currentDirTests".Path
  var fs: FileSystem

  setup:
    createDir(testDirPath)
    fs = newOsFs()

  teardown:
    removeDir(testDirPath, false)

  test "should create a directory using an absolute path":
    let pathRelative = "testDir1".Path
    let pathAbsolute = testDirPath / pathRelative
    let dir = fs.createDir pathAbsolute
    check fs.dirExists pathAbsolute
    check dir.absolutePath == pathAbsolute
    check dir.exists

  test "should create a directory using a relative path":
    let pathRelative = "testDir2".Path
    let pathAbsolute = testDirPath / pathRelative
    fs.currentDir = testDirPath
    let dir = fs.createDir pathRelative 
    check fs.dirExists pathAbsolute
    check dir.absolutePath == pathAbsolute
    check dir.exists

  test "should create a directory using an absolute path when the current directory is set":
    let pathRelative = "testDir3".Path
    let pathAbsolute = testDirPath / pathRelative
    let dir = fs.createDir pathAbsolute
    check fs.dirExists pathAbsolute
    check dir.absolutePath == pathAbsolute
    check dir.exists

  test "should throw an exception when creating a directory with the same name as an existing file":
    let pathRelative = "testDir4".Path
    let pathAbsolute = testDirPath / pathRelative
    open(pathAbsolute.string, fmWrite).close() # Create a file with the same name as the directory
    expect CatchableError:
      fs.createDir pathAbsolute

  test "should not throw an exception when creating a directory that already exists":
    let pathRelative = "testDir5".Path
    let pathAbsolute = testDirPath / pathRelative
    var dir = fs.createDir(pathAbsolute)
    check dir.exists
    dir = fs.createDir(pathAbsolute)
    check dir.exists