# Minesweeper

This project operates similarily to a VT100 and utilizes a Memory Mapped I/O (MMIO) to change the background, foreground and contents of the cell based on a halfword of information. The program uses a .txt file to place the bombs around the board. The user then has the ability to use keyboard buttons to move the yellow cursor around the MMIO, to flag and to reveal the cells.  If the user manages to win the game, the program will terminate with a happy face and if the user reveals a bomb, the contents on the MMIO will be revealed.   



**Controls**
* [ ] W: Move the cursor up
* [ ] A: Move the cursor left
* [ ] S: Move the cursor down
* [ ] D: Move the cursor right
* [ ] R: Reveal the cell 
* [ ] F: Flag is toggled
