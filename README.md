# Minesweeper

This project operates similarily to a VT100 and utilizes a Memory Mapped I/O (MMIO) to change the background, foreground and contents of the cell based on a halfword of information. The program uses a .txt file to place the bombs around the board. The user then has the ability to use keyboard buttons to move the yellow cursor around the MMIO, to flag and to reveal the cells.  If the user manages to win the game, the program will terminate with a happy face and if the user reveals a bomb, the program will end with the contents of the 10x10 being revealed.



**Controls**
* [x] W: Move the cursor up
* [x] A: Move the cursor left
* [x] S: Move the cursor down
* [x] D: Move the cursor right
* [x] R: Reveal the cell 
* [x] F: Flag is toggled
