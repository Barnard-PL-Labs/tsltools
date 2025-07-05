import sys
from operator import itemgetter
import pygame

class Cop:
    def __init__(self, x):
        self.x = x
        
class _next_Cop:
    def __init__(self, x):
        self.x = x

_MAX_M = None

def MaxX():
    return _MAX_M

def MinX():
    return 0

# BEGIN UPDATESTATE
def updateState(_inputs_and_cells):
  currentState, Cop.x = itemgetter("currentState", "Cop.x")(_inputs_and_cells)

  if currentState == 0:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 3
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x > 10):
      currentState = 9
    elif (0 > Cop.x):
      currentState = 9
  elif currentState == 1:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
  elif currentState == 2:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 5
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 5
    elif (Cop.x != 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 5
    elif (Cop.x != 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 5
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 6
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
  elif currentState == 3:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x == 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 7
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x - 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 8
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
  elif currentState == 4:
    if (Cop.x == 10):
      currentState = 9
    elif (Cop.x != 10):
      currentState = 9
  elif currentState == 5:
    if (Cop.x == 0):
      currentState = 9
    elif (Cop.x != 0):
      currentState = 9
  elif currentState == 6:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 5
    elif (Cop.x != 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 5
    elif (Cop.x != 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 5
    elif (Cop.x != 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x - 1
      _next_Cop.x = Cop.x
      currentState = 5
    elif (Cop.x != 0) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 6
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
  elif currentState == 7:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 8
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 9
  elif currentState == 8:
    if True:
      currentState = 9
    elif True:
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif True:
      _next_Cop.x = Cop.x
      currentState = 9
  elif currentState == 9:
    if (Cop.x == 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 1
    elif (Cop.x != 0) and (Cop.x == 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 2
    elif (Cop.x == 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 4
    elif (Cop.x == 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x
      currentState = 4
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x - 1
      currentState = 8
    elif (Cop.x != 0) and (Cop.x != 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x - 1
      currentState = 8
    elif (Cop.x == 0) and (Cop.x == 10):
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 0) and (Cop.x == 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (Cop.x > 10):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x + 1
      _next_Cop.x = Cop.x - 1
      currentState = 9
    elif (Cop.x == 10) and (0 > Cop.x):
      _next_Cop.x = Cop.x
      currentState = 9
    elif (Cop.x != 0) and (Cop.x != 10) and (Cop.x <= 10) and (0 <= Cop.x):
      _next_Cop.x = Cop.x + 1
      currentState = 9

  return {"currentState": currentState, "Cop.x": _next_Cop.x}
# END UPDATESTATE
####################################################################################
####################################################################################
#######################################GRID SETUP###################################
####################################################################################
####################################################################################
class GridGame:
    def __init__(self, m):
        pygame.init()

        # store dimensions and set global for MaxX
        self.m = m
        global _MAX_M
        _MAX_M = m - 1

        # drawing params
        self.cell_size = 60
        self.padding = 2
        self.WHITE = (255, 255, 255)
        self.BLUE = (0, 0, 255)
        self.RED = (255, 0, 0)
        self.GREEN = (0, 255, 0)
        self.GRAY = (200, 200, 200)

        # screen setup - horizontal layout
        self.width = self.m * self.cell_size + 100
        self.height = 200  # Fixed height for single row
        self.screen = pygame.display.set_mode((self.width, self.height))
        pygame.display.set_caption(f"1D Grid Game ({m} positions)")

        # only track the cop's x position
        self.cop_x = None
        self.game_state = 'placing_cop'
        self.font = pygame.font.SysFont(None, 24)

    def draw_grid(self):
        # clear background
        self.screen.fill(self.GRAY)

        # draw cells in a single row
        y_pos = 100  # Center vertically
        for col in range(self.m):
            rect = pygame.Rect(
                col * self.cell_size + 50,
                y_pos,
                self.cell_size - self.padding,
                self.cell_size - self.padding
            )
            
            # Color coding: red for MinX, green for MaxX, blue for cop, white for empty
            if col == MinX():
                color = self.RED if self.cop_x != col else self.BLUE
            elif col == MaxX():
                color = self.GREEN if self.cop_x != col else self.BLUE
            elif self.cop_x == col:
                color = self.BLUE
            else:
                color = self.WHITE
                
            pygame.draw.rect(self.screen, color, rect)
            
            # Draw position numbers
            text = self.font.render(str(col), True, (0, 0, 0))
            text_rect = text.get_rect(center=rect.center)
            self.screen.blit(text, text_rect)

        # status text
        if self.game_state == "placing_cop":
            status = "Click to place the cop"
        elif self.game_state == "animating":
            status = f"Cop at position {self.cop_x} (Red=MinX, Green=MaxX)"
        else:
            status = f"Cop placed at position {self.cop_x}"
            
        text_surf = self.font.render(status, True, self.BLUE)
        self.screen.blit(text_surf, (10, 10))
        
        # Legend
        legend_y = 30
        legend_text = "Red=MinX(0), Green=MaxX, Blue=Cop"
        legend_surf = self.font.render(legend_text, True, (0, 0, 0))
        self.screen.blit(legend_surf, (10, legend_y))

        pygame.display.flip()

    def get_cell_from_pos(self, pos):
        x, y = pos
        if x < 50 or y < 100 or y > 100 + self.cell_size:
            return None
        col = (x - 50) // self.cell_size
        if 0 <= col < self.m:
            return col
        return None

    def handle_click(self, pos):
        cell = self.get_cell_from_pos(pos)
        if cell is not None and self.game_state == "placing_cop":
            self.cop_x = cell
            self.game_state = "done"
            self.draw_grid()

    def animate_chase(self):
        clock = pygame.time.Clock()
        state = 0
        cop_x = self.cop_x
        self.game_state = "animating"

        for step in range(20):
            for evt in pygame.event.get():
                if evt.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()
                elif evt.type == pygame.KEYDOWN and evt.key == pygame.K_SPACE:
                    return  # Stop animation on spacebar

            # compute the next position
            out = updateState({
                "currentState": state,
                "Cop.x": cop_x
            })
            state = out["currentState"]
            cop_x = out["Cop.x"]
            self.cop_x = cop_x

            # redraw
            self.draw_grid()
            
            # Display step info
            step_text = f"Step {step + 1}: State={state}, Position={cop_x}"
            step_surf = self.font.render(step_text, True, (0, 0, 0))
            self.screen.blit(step_surf, (10, 50))
            pygame.display.flip()
            
            clock.tick(5)  # Slower animation for better observation

    def run(self):
        running = True
        while running:
            for evt in pygame.event.get():
                if evt.type == pygame.QUIT:
                    running = False
                elif evt.type == pygame.MOUSEBUTTONDOWN and evt.button == 1:
                    self.handle_click(evt.pos)
                elif evt.type == pygame.KEYDOWN:
                    if evt.key == pygame.K_ESCAPE:
                        running = False
                    elif evt.key == pygame.K_SPACE and self.game_state == "done":
                        self.animate_chase()

            if self.game_state == "done":
                # Show instructions
                instruction_text = "Press SPACE to start animation, ESC to quit"
                instruction_surf = self.font.render(instruction_text, True, (0, 0, 0))
                self.screen.blit(instruction_surf, (10, self.height - 30))
                pygame.display.flip()
                
            if self.game_state != "animating":
                self.draw_grid()
                
            pygame.time.delay(20)

        pygame.quit()

def main():
    try:
        m = int(input("Enter number of positions (M): "))
        if m <= 0:
            print("Number of positions must be positive")
            return
        if m < 2:
            print("Need at least 2 positions for meaningful movement")
            return

        game = GridGame(m)
        game.run()

    except ValueError:
        print("Please enter a valid number")

if __name__ == "__main__":
    main()