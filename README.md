# Minesweeper

This project operates similarily to a VT100 and utilizes a Memory Mapped I/O (MMIO) to change the background, foreground and contents of the cell based on a halfword of information. The program uses a .txt file to place the bombs around the board. The user then has the ability to use keyboard buttons to move the yellow cursor around the MMIO, to flag and to reveal the cells.  If the user manages to win the game, the program will terminate with a happy face and if the user reveals a bomb, the program will end with the contents of the 10x10 being revealed.



**Controls**
* [x] W: Move the cursor up
* [x] A: Move the cursor left
* [x] S: Move the cursor down
* [x] D: Move the cursor right
* [x] R: Reveal the cell 
* [x] F: Flag is toggled

**Pictures**

Initial Screen
<img src='http://imgur.com/7T45bq3.jpg' title='Initial Screen' width='' alt='Picture' />

Revealing an Empty Cell
<img src='http://imgur.com/ptj8feI.jpg' title='Reveal Screen' width='' alt='Picture' />

Flagging a cell  
<img src='http://imgur.com/toew12x.jpg' title='Flag Screen' width='' alt='Picture' />

All cells revealed after user loses the game 
<img src='http://imgur.com/A49w1Oj.jpg' title='Losing Screen' width='' alt='Picture'/>

User wins the game
<img src='http://imgur.com/smDJVD9.jpg' title='Winning Screen' width='' alt='Picture'/>
