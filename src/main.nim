import nico
import os
import sequtils

const orgName = "mk-9jira"
const appName = "conway's game of life by mk-9jira"

let
  wx = 600
  wy = 400
  resoution = 10
  dx = resoution
  dy = resoution
  nx = wx div dx
  ny = wy div dy

var board = newSeqWith(nx, newSeq[bool](ny))
board[0][0] = true
board[10][0] = true
board[0][5] = true

# var buttonDown = false

proc gameInit() =
  loadFont(0, "font.png")

proc toggleCellInCurrent(x, y: int) =
    let i = x div dx
    let j = y div dy
    if i < 0 or i >= nx or j < 0 or j >= ny:
      return
    board[i][j] = not board[i][j]

proc gameUpdate(dt: float32) =
  # buttonDown = btn(pcA)
  if mousebtn(0):
    let (x, y) = mouse()
    toggleCellInCurrent(x, y)
    # echo "(x, y) = (", x, ", ", y, ")"
    sleep(100)

proc gameDraw() =
  cls()
  # setColor(if buttonDown: 7 else: 3)
  # printc("welcome to " & appName, screenWidth div 2, screenHeight div 2)
  for i in 0..<nx:
    for j in 0..<ny:
      if board[i][j] == true:
        setColor(3)
        boxfill(i*dx, j*dy, dx, dy)
      else:
        setColor(7)

nico.init(orgName, appName)
nico.createWindow(appName, wx, wy, 1, false)
nico.run(gameInit, gameUpdate, gameDraw)
