import nico
import os
import random
import sequtils
import strutils

const orgName = "mk-9jira"
const appName = "conway's game of life by mk-9jira"

let wx = 600
let wy = 400
let resoution = 10
let dx = resoution
let dy = resoution
let nx = wx div dx
let ny = wy div dy

var boardCurrent = newSeqWith(nx, newSeq[bool](ny))
var boardNext = newSeqWith(nx, newSeq[bool](ny))
var gen = 0

#[ test -->
boardCurrent[0][0] = true
boardCurrent[nx-1][ny-1] = true
boardCurrent[10][10] = true
<-- test ]#

# proc used in gameInit
proc initBoard()

# procs used in gameUpdate
proc initEmptyBoard()
proc neighbourCount(i, j: int): int
proc toggleCellInCurrent(x, y: int)
proc updateBoard()

# procs used in gameDraw
proc drawBoard() 
proc printGen()

proc gameInit() =
  loadFont(0, "font.png")
  initBoard()

proc gameUpdate(dt: float32) =
  if key(K_SPACE):
    updateBoard()
    sleep(200)
  elif key(K_RETURN):
    initBoard()
    sleep(100)
  elif key(K_0):
    initEmptyBoard()
    sleep(100)
  if mousebtn(0):
    let (x, y) = mouse()
    toggleCellInCurrent(x, y)
    sleep(100)

proc gameDraw() =
  cls()
  # printc("welcome to " & appName, screenWidth div 2, screenHeight div 2)
  drawBoard()
  printGen()

nico.init(orgName, appName)
nico.createWindow(appName, wx, wy, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)


# -------------------
# original procedures
# -------------------
proc drawBoard() = 
  for i in 0..<nx:
    for j in 0..<ny:
      if boardCurrent[i][j] == true:
        setColor(3)
        boxfill(i*dx, j*dy, dx, dy)
      else:
        setColor(7)

proc initBoard() =
  for i in 0..<nx:
    for j in 0..<ny:
      let on = bool(rand(9) div 9)
      boardCurrent[i][j] = on
  gen = 0

proc initEmptyBoard() =
  for i in 0..<nx:
    for j in 0..<ny:
      boardCurrent[i][j] = false
  gen = 0

# count alive/dead cells around the specified cell
proc neighbourCount(i, j: int): int =
  for di in -1..1:
    for dj in -1..1:
      let ii = (i + di + nx) mod nx   # 0 <= ii < nx
      let jj = (j + dj + ny) mod ny   # 0 <= jj < ny
      result += int(boardCurrent[ii][jj])
  result -= int(boardCurrent[i][j])

proc printGen() =
  setColor(2)
  let msg = "Generation = $1" % [$gen]
  print(msg, nx div 10, ny div 10)

proc toggleCellInCurrent(x, y: int) =
  let i = x div dx
  let j = y div dy
  if i < 0 or i >= nx or j < 0 or j >= ny:
    return
  boardCurrent[i][j] = not boardCurrent[i][j]

proc updateBoard() =
  for i in 0..<nx:
    for j in 0..<ny:
      let isAlive = boardCurrent[i][j]
      let n = neighbourCount(i, j)
      if not isAlive and n == 3:
        boardNext[i][j] = true
      elif isAlive and (n < 2 or n > 3):
        boardNext[i][j] = false
      else:
        boardNext[i][j] = boardCurrent[i][j]
#[ debug -->
      if n > 0:
        echo "i = ", i, " j = ", j, " n = ", n
      elif n < 0:
        echo "Error: n should not be negative"
<-- debug ]#
  swap(boardCurrent, boardNext)
  inc gen
