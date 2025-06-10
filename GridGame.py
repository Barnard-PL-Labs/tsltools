import sys
from operator import itemgetter
import pygame

class Cop:
  def __init__(self, x, y):
    self.x = x
    self.y = y
    
class _next_Cop:
  def __init__(self, x, y):
    self.x = x
    self.y = y

_MAX_M = None
_MAX_N = None

def MaxX():
    return _MAX_M

def MaxY():
    return _MAX_N

def MinX():
    return 0

def MinY():
    return 0

# BEGIN UPDATESTATE
def updateState(_inputs_and_cells):
  currentState, Cop.x, Cop.y = itemgetter("currentState", "Cop.x", "Cop.y")(_inputs_and_cells)

  if currentState == 0:
    if (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 2
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 4
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 5
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 6
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 7
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 8
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 9
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 10
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 11
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 12
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 13
  elif currentState == 1:
    if True:
      currentState = 45
    elif True:
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 45
    elif True:
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif True:
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif True:
      currentState = 45
    elif True:
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y - 1
      currentState = 45
    elif True:
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y
      currentState = 45
    elif True:
      _next_Cop.y = Cop.y - 1
      _next_Cop.y = Cop.y
      currentState = 45
  elif currentState == 2:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 19
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 20
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 21
  elif currentState == 3:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 22
  elif currentState == 4:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 4
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
  elif currentState == 5:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 5
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 27
  elif currentState == 6:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 9
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 32
  elif currentState == 7:
    if (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 7
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
  elif currentState == 8:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 8
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 34
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 36
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 36
  elif currentState == 9:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 9
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 37
  elif currentState == 10:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 38
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 39
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 40
  elif currentState == 11:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 11
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 22
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 41
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 42
  elif currentState == 12:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 12
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 38
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 43
  elif currentState == 13:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 13
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 27
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 38
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 14:
    if True:
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif True:
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif True:
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif True:
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif True:
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
  elif currentState == 15:
    if (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x != MaxX()):
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif (Cop.x != MaxX()):
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y - 1
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y
      currentState = 45
    elif (Cop.x != MaxX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.y = Cop.y
      currentState = 45
    elif (Cop.x != MinX()):
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 45
    elif (Cop.x != MinX()):
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y - 1
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.y = Cop.y
      currentState = 45
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.y = Cop.y
      currentState = 45
  elif currentState == 16:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 17:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 8
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 34
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 18:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 4
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 19:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 20:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 9
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 37
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 45
  elif currentState == 21:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 5
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 27
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 22:
    if (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 7
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 23:
    if (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 7
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 24:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 8
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 34
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 36
  elif currentState == 25:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 22
  elif currentState == 26:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 9
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 37
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 45
  elif currentState == 27:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 28:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 29:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
  elif currentState == 30:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 4
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 31:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 8
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 33
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 34
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 35
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 36
  elif currentState == 32:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 5
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 27
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 33:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 22
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
  elif currentState == 34:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 4
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 25
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
  elif currentState == 35:
    if (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 3
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 7
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 29
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 30
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 31
  elif currentState == 36:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 37:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 5
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 18
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 27
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
  elif currentState == 38:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 11
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 22
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 41
  elif currentState == 39:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 40:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 13
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 17
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 26
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 27
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 41
  elif currentState == 41:
    if (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 12
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 23
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 24
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 38
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 42:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 44
  elif currentState == 43:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()) and (Cop.y != MaxY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 16
    elif (Cop.x == MaxX()) and (Cop.x != MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 28
  elif currentState == 44:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.y = Cop.y + 1
      _next_Cop.x = Cop.x
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y + 1
      currentState = 1
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x + 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15
    elif (Cop.x != MaxX()) and (Cop.x == MinX()) and (Cop.y == MinY()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
  elif currentState == 45:
    if (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y + 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y == MaxY()) and (Cop.y != MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x == MaxX()) and (Cop.x == MinX()) and (Cop.y != MaxY()) and (Cop.y == MinY()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 14
    elif (Cop.x != MaxX()) and (Cop.x == MinX()):
      _next_Cop.y = Cop.y - 1
      _next_Cop.x = Cop.x
      currentState = 15
    elif (Cop.x != MinX()):
      _next_Cop.x = Cop.x - 1
      _next_Cop.y = Cop.y - 1
      currentState = 15

  return {"currentState": currentState, "Cop.x": _next_Cop.x, "Cop.y": _next_Cop.y}
# END UPDATESTATE
####################################################################################
####################################################################################
#######################################GRID SETUP###################################
####################################################################################
####################################################################################
class GridGame:
    def __init__(self, n, m):
        pygame.init()

        # store dimensions and set globals for MaxX/MaxY
        self.n, self.m = n, m
        global _MAX_M, _MAX_N
        _MAX_M = m - 1
        _MAX_N = n - 1

        # drawing params
        self.cell_size = 50
        self.padding = 2
        self.WHITE = (255, 255, 255)
        self.BLUE = (0, 0, 255)
        self.GRAY = (200, 200, 200)

        # screen setup
        self.width = self.m * self.cell_size + 100
        self.height = self.n * self.cell_size + 100
        self.screen = pygame.display.set_mode((self.width, self.height))
        pygame.display.set_caption(f"Grid Game ({n}×{m})")

        # only track the cop’s position, not grid cells
        self.cop_pos = None
        self.game_state = 'placing_cop'
        self.font = pygame.font.SysFont(None, 24)

    def draw_grid(self):
        # clear background
        self.screen.fill(self.GRAY)

        # draw empty cells
        for row in range(self.n):
            for col in range(self.m):
                rect = pygame.Rect(
                    col * self.cell_size + 50,
                    row * self.cell_size + 50,
                    self.cell_size - self.padding,
                    self.cell_size - self.padding
                )
                pygame.draw.rect(self.screen, self.WHITE, rect)

        # draw the cop at its current position (if placed)
        if self.cop_pos:
            row, col = self.cop_pos
            rect = pygame.Rect(
                col * self.cell_size + 50,
                row * self.cell_size + 50,
                self.cell_size - self.padding,
                self.cell_size - self.padding
            )
            pygame.draw.rect(self.screen, self.BLUE, rect)

        # status text
        status = "Click to place the cop" if self.game_state == "placing_cop" else "Animating..."
        text_surf = self.font.render(status, True, self.BLUE)
        self.screen.blit(text_surf, (10, 10))

        pygame.display.flip()

    def get_cell_from_pos(self, pos):
        x, y = pos
        if x < 50 or y < 50:
            return None
        col = (x - 50) // self.cell_size
        row = (y - 50) // self.cell_size
        if 0 <= row < self.n and 0 <= col < self.m:
            return (row, col)
        return None

    def handle_click(self, pos):
        cell = self.get_cell_from_pos(pos)
        if cell and self.game_state == "placing_cop":
            self.cop_pos = cell
            self.game_state = "done"
            self.draw_grid()

    def animate_chase(self):
        clock = pygame.time.Clock()
        state = 0
        row, col = self.cop_pos

        for _ in range(100):
            for evt in pygame.event.get():
                if evt.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()

            # compute the next position
            out = updateState({
                "currentState": state,
                "Cop.x": row,
                "Cop.y": col
            })
            state = out["currentState"]
            row = out["Cop.x"]
            col = out["Cop.y"]
            self.cop_pos = (row, col)

            # redraw
            self.draw_grid()
            clock.tick(10)

    def run(self):
        running = True
        while running:
            for evt in pygame.event.get():
                if evt.type == pygame.QUIT:
                    running = False
                elif evt.type == pygame.MOUSEBUTTONDOWN and evt.button == 1:
                    self.handle_click(evt.pos)
                elif evt.type == pygame.KEYDOWN and evt.key == pygame.K_ESCAPE:
                    running = False

            if self.game_state == "done":
                pygame.time.delay(500)
                self.animate_chase()
                running = False
            else:
                self.draw_grid()
                pygame.time.delay(20)

        pygame.quit()

def main():
    try:
        n = int(input("Enter number of rows (N): "))
        m = int(input("Enter number of columns (M): "))
        if n <= 0 or m <= 0:
            print("Grid dimensions must be positive")
            return

        game = GridGame(n, m)
        game.run()

    except ValueError:
        print("Please enter valid numbers")

if __name__ == "__main__":
    main()