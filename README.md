# BASYS 3 Pong Game

This project is a part of term project of Hardware Synthesis Laboratory 1/2023.

We created pong game that can play with 2 players in BASYS 3 board. The objective of this game is to get highest score as much as possible by passing a ball into opponent's goal. The graphic is shown in VGA and players can control using UART serial terminal.

![Overview of Game](/mdasset/ponggame.png)

## Features

- Players can control their paddle by using serial terminal.
    - For player 1, player can control by pressing `W` for moving up and `S` for moving down.
    - For player 2, player can control by pressing `I` for moving up and `K` for moving down.
- The score for each player is in a range of 0 to 99. If score is exceed from 99, it will go back to 0.
- You can reset the game by pressing `btnC` (center button) in BASYS 3 board. The score of both players will be reset to 0.
- Player can activate "Faster Ball" mode by toggling switch 0 (`sw[0]`) in BASYS 3 board. The ball's speed will be double.
- Player can activate "Shorter Paddle" mode by toggling switch 1 (`sw[1]`) in BASYS 3 board. The paddle will be shorter by 33.33%.


## Modular Design

![Modular Design](/mdasset/modular_design.png)

### Input

- `RsRx` - For receiving data from UART interface
- `sw[0]` - For toggling “faster ball” mode
- `sw[1]` - For toggling “shorter paddle” mode
- `btnC` - For resetting game

### Output

- `RsTx` - Echo data from received data
- `Hsync`, `Vsync` - For VGA output
- `vgaBlue`, `vgaGreen`, `vgaRed` - Graphic color for VGA output
- `an`, `seg`, `dp` -  Showing score in 7-segment display

### Modules

|            Module            |                                        Description                                       |
|:----------------------------:|:----------------------------------------------------------------------------------------:|
|     animation_gen.v          |     Generate graphic and animation in game that will show in VGA                         |
|     baudrate_gen.v           |     Generate baud rate for serial communication                                          |
|     binToBCD.v               |     Convert 7-bit binary to 2 digits of BCD                                              |
|     clockDivider.v           |     Divide clock frequency by 2                                                          |
|     font_rom.v               |     ROM that stores text for mapping ASCII codes to 8x16 bits output                     |
|     game_clock.v             |     Generate game clock (20Hz) from 100MHz clock                                         |
|     game_control.v           |     Logic circuit of game including paddle control, ball, and score                      |
|     sevenSegmentEncoder.v    |     Encode 4-bit binary to 7-segment output                                              |
|     sevenSegmentTDM.v        |     Time-division multiplexing for seven segment display                                 |
|     singlePulser.v           |     Create single pulse output                                                           |
|     system.v                 |     Top-level system (connect game controller, UART, VGA, and seven segment together)    |
|     uart.v                   |     Top-level system of UART including receiver and transmitter                          |
|     uart_rx.v                |     UART receiver that receive input from serial terminal                                |
|     uart_tx.v                |     UART transmitter that echo data from receiver                                        |
|     vga_sync.v               |     Synchronization circuit for VGA                                                      |