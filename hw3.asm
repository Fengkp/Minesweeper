##############################################################
# Homework #3
# name: NAVIN_ABICHANDANI
##############################################################

.text

##############################
# PART 1 FUNCTIONS
##############################

smiley:
   	la $t0, 0xffff0000 # Holds the ascii register for the first cell. 
   	la $t1, 0xffff0001 # Holds the color register for the first cell.
   	la $t2, 0xffff00c7 # Holds the last byte if the last cell
   	li $t3, 15	#Holds the black background, white foreground color
   	
blank_cells:
	bgt $t0,$t2, make_smiley # This loops turns all of the cells blank with black and white colors 
	sb $0, ($t0)
	sb $t3, ($t1) 
	addi $t0, $t0, 2
	addi $t1, $t1, 2
	j blank_cells
	
make_smiley:
	li $t3, 'b' #Holds the bomb display
	li $t4, 183  #Holds the yellow background and grey foreground for eyes
	
	la $t0, 0xffff002E #For (2,3)
	la $t1, 0xffff002F
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0042 #For (3,3)
	la $t1, 0xffff0043
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0034 #For (2,6)
	la $t1, 0xffff0035
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0048 #For (3.6)
	la $t1, 0xffff0049
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	li $t3, 'e' #Holds exploded bomb display
	li $t4, 31  #Holds the red backgroud and white foreground for mouth
	
	la $t0, 0xffff007C  #For (6,2)
	la $t1, 0xffff007D
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0092 #For (7,3)
	la $t1, 0xffff0093
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff00A8 #For (8,4)
	la $t1, 0xffff00A9
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff00AA #For (8,5)
	la $t1, 0xffff00AB
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0098 #For (7,6)
	la $t1, 0xffff0099
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	la $t0, 0xffff0086 #For (6,7)
	la $t1, 0xffff0087
	sb $t3, ($t0)
	sb $t4, ($t1)
	
	jr $ra
	

##############################
# PART 2 FUNCTIONS
##############################

open_file:
    #Method for opening the file
    li $a1, 0
    li $a2, 0
    li $v0, 13
    syscall 
    jr $ra

close_file:
    #Method for closing the file
    li $v0, 16
    syscall
    jr $ra

load_map:
   #Ckears out temp registers
   move $t8, $a1 #Moves address of the cell array to $t8
   li $t0, 0
   li $t1, 0
   li $t2, 0
   li $t3, 0
   li $t4, 0
   li $t7, 0
   move $t1, $t8 	#loads cell array into $t1
	
clean_array:
	sb $0, ($t1)		#This loops clears out all of the cells in the array.
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	beq $t0, 100, after_clean
	j clean_array

after_clean: 
   move $t0, $v0 #Puts the file descripter into $t0
   li $t2, 10	#Holds constant 10
   li $t3, '0'	#Holds constant '0'
   li $t4, 0	#Holds first input
   li $t5, 0	#Holds second input

get_input:
   move $a0, $t0  #Puts file descripter into $a0
   la $a1, input_buffer  #input buffer goes into $a1
   li $a2, 1	#Reads only 1 char
   li $v0, 14
   syscall  #Runs syscall 14
   
   lb $t1, ($a1)  #Loads first input buffer into $t4
   beqz $v0, after_input   #If the input buffer is 0, end the loop
 
   blt $t1, 33, get_input #If the input buffer is less than '!' in ascii table, repeat loop.
   blt $t1, '0', error_in_load  #If the input buffer is b/w '!' and '0', it is an invalid char and hence, load_map will stop.
   bgt $t1, '9', error_in_load #If input buffer is greater than 9, it is an illegal char and hence, load_map will stop.
  
    move $t4, $t1
    sub $t4, $t4, $t3	#Turns first input buffer to int
 
 
get_input_2:  
   la $a1, input_buffer  #input buffer goes into $a1
   li $a2, 1	#Reads only 1 char
   li $v0, 14
   syscall  #Runs syscall 14
   
   lb $t1, ($a1)  #Loads second input buffer into $t5
   beqz $v0, error_in_load  #If the input buffer is 0, end the loop and program
 
   blt $t1, 33, get_input_2  #If the input buffer is less than '!' in ascii table, repeat loop.
   blt $t1, '0', error_in_load  #If the input buffer is b/w '!' and '0', it is an invalid char and hence, load_map will stop.
   bgt $t1, '9', error_in_load #If input buffer is greater than 9, it is an illegal char and hence, load_map will stop.
   move $t5, $t1
   
   sub $t5, $t5, $t3	#Turns second input buffer to int
   
   mul $t4, $t4, $t2	#$t4 = 1st input x 10
   add $t4, $t4, $t5	#$t4 = $t4 + second input
   
   li $t6, 32		#32 is used to indicate that there is a bomb in that particular cell.
   move $t1, $t8	#Used to reset the offset of the array after loop ends	
   add $t1, $t1, $t4	#Add $t4 to array to get to the correct cell
   lb $t9, ($t1)
   beq $t9, 32, get_input
   sb $t6, ($t1)		#Places bomb within this cell.
   
   
   
   j get_input  #Repeat the loop
   
after_input:	
	move $t1, $t8	#Used to reset the offset of the array after loop ends
	li $t0, 10	#Holds constant 10
	li $t2, 0	#Row counter
	li $t3, 0	#Column Counter
	
	
fill_rest_of_array: 		 #Loop fills the rest of the cells. 
	beq $t3, 10, inc_row			#Since column can only be less than 10, inc the row
	beq $t2, 10, set_bomb_32
	move $t1, $t8	#Used to reset the offset of the array	
	mul $t4, $t2, $t0	 #Cell num = (row x 10) + col
	add $t4, $t4, $t3
	add $t1, $t1, $t4	#adds the cell num to array address to move to that cell	
	lb $t7, ($t1)		#loads the byte into $t7
		
	bge $t7, 32, adjust_corners_to_bomb	#if $t7, it contains a bomb and jump to loop
	addi $t3, $t3, 1			#add 1 to column
	j fill_rest_of_array
	
	
inc_row:			#Increments the row, sets col to 0, and if row is 10, end loop
	addi $t2, $t2, 1
	li $t3, 0
	beq $t2, 10, set_bomb_32	#EXIT LOO{P CONDITION- if row = 10
	j fill_rest_of_array

inc_col:			#Increments the column by 1, and will only be jumped to if there is a bomb 
	addi $t3, $t3, 1
	move $t1, $t8	#Used to reset the offset of the array after loop ends
	j fill_rest_of_array
	
end_fill:
	
adjust_corners_to_bomb:
	beq $t3, 0, column_check_0	#These branches check if the columns or rows are rither 0 or 9.
	beq $t3, 9, column_check_9
	beq $t2, 0, row_check_0
	beq $t2, 9, row_check_9 

	#for right of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom right of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top right of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	j inc_col	
	
column_check_0:
	beq $t2, 0, is00		#If cell is 00, jump to that label
	beq $t2, 9, is09		#If cell is 09, jump to that label
	
	#for bottom left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)


	j inc_col
	
column_check_9:
	beq $t2, 0, is90		#If cell is 90, jump to label 
	beq $t2, 9, is99		#If cell is 99, jump to label
	
	#for bottom left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	

	j inc_col
	
row_check_0:
	#for bottom left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	j inc_col
row_check_9:
	#for bottom left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)


	j inc_col
is00:
	#for right of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom right of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)


	j inc_col
	
	
is09:
	#for left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom left of bomb
	addi $t1, $t1, 10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for bottom of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	

	j inc_col
	
	
is90:
	#for right of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top right of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)


	j inc_col
	
	
is99:
	#for left of bomb
	addi $t1, $t1, -1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top left of bomb
	addi $t1, $t1, -10
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)
	
	#for top of bomb
	addi $t1, $t1, 1
	lb $t7, ($t1)
	addi $t7, $t7, 1
	sb $t7, ($t1)


	j inc_col
	
			
set_bomb_32:
	move $t1, $t8		#Resets pointer in array
	li $t2, 32		#Holds 32 to set bombs
	li $t4, 0		#Counter

bomb_loop:
	lb $t3, ($t8)		#Loads cell pointer of array
	bgt $t3, 32, bomb_is_32		#If the cell data is greater than 32, set it to 32
	beq $t4, 100, success_in_load	#if counter = 100, end loop
	addi $t8, $t8, 1		#Increment pointer
	addi $t4, $t4, 1		#Increment counter
	j bomb_loop
	
bomb_is_32:
	sb $t2, ($t8)			#Stores 32 into bomb
	beq $t4, 100, success_in_load	#Also checks if counter - 100
	addi $t8, $t8, 1		#Increment pointer
	addi $t4, $t4, 1		#Increment counter
	j bomb_loop
	
success_in_load:
	li $v0, 0		#Load_map was successful and end	
	j end_load	
	
error_in_load: 
	li $v0, -1		#Load_map failed and end.
	
end_load:
	lw $t0, cursor_row		#Loads the cursors into the registers and sets them to 0.
	lw $t1, cursor_col
	li $t0, 0
	li $t1, 0
	sw $t0, cursor_row
	sw $t1, cursor_col
    	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

init_display:
       	la $t0, 0xffff0000 # Holds the ascii register for the first cell. 
   	la $t1, 0xffff0001 # Holds the color register for the first cell.
   	la $t2, 0xffff00c7 # Holds the last byte if the last cell
   	li $t3, 119	#Holds the grey background, grey foreground color
   	li $t4, '\0'
   	
grey_cells:
	bgt $t0,$t2, make_cursor # This loops turns all of the cells blank with the color grey
	sb $t3, ($t1) 
	addi $t0, $t0, 2
	addi $t1, $t1, 2
	j grey_cells
	
make_cursor:
	la $t0, 0xffff0000 # Holds the ascii register for the first cell. 
   	la $t1, 0xffff0001 # Holds the color register for the first cell.
	la $t3, cursor_row	#Saves the address of cursor_row
	la $t4, cursor_col	#Saves the address of cursor_col
	lb $t5, ($t3)		#Loads the row into $t5
	lb $t6, ($t4)		#Loads the column into $t6
	li $t5, 0	#Add 1 to turn row_cursor to 0
	li $t6, 0	#Add 1 to turn col_cursor to 0
	
	li $t7, 10	
	li $t8, 0xb7		#Holds yellow background and grey background 
	li $t9, '\0'
	
	mul $t5, $t5, $t7	
	add $t5, $t5, $t6	#Calculates row x 10 + col
	 
	add $t0, $t0, $t5	#Goes to address of cursor	
	sb $t8, ($t1)		#Puts yellow background and grey background in color byte
    
  	jr $ra
  	
  	
  	

set_cell:
	move $t0, $a0		#Loads row num into $t0
	move $t1, $a1		#Loads col num into $t1
	
	bgt $t0, 9, set_cells_invalid  #Checks if row is in 0-9
	blt $t0, 0, set_cells_invalid
	
	bgt $t1, 9, set_cells_invalid	#Checks if col is in 0-9
	blt $t1, 0, set_cells_invalid
	
	li $t2, 10		#Loads immiediate 10
	mul $t0, $t0, $t2
	add $t0, $t0, $t1	#location = row x 10 + col
	li $t2, 2		#Loads immidiate 2
	
	mul $t0, $t0, $t2	#Multiply location by 2 b/c each cell is 2 bytes
	la $t1, 0xffff0000	#Loads initial location of cell into $t1
	add $t1, $t1, $t0	#Puts pointer of array into the beginning 
	
	sb $a2, ($t1)		#Stores character from $a2 into ascii bit of the cell
	addi $t1, $t1, 1	#Pushes pointer to the color bit of the cell
	
	move $t2, $a3		#Loads foreground color from $a3
	
	bgt $t2, 15, set_cells_invalid	#Checks if foreground is in 0 - 15
	blt $t2, 0, set_cells_invalid
	
 	lw $t3, 0($sp)		#Loads background color from STACK
 	
 	bgt $t3, 15, set_cells_invalid	#Checks if background is in 0-15
	blt $t3, 0, set_cells_invalid
	
	li $t5, 16		#Loads 16 to get hexadecimal
	
	mul $t3, $t3, $t5	#color = background x 16
	add $t3, $t3, $t2	#color = color + foreground
	
	sb $t3, ($t1)		#Stores color byte into the cell.
	j set_cells_valid

set_cells_invalid:
	li $v0, -1	#if there is an error in the parameters, load -1 into $v0
	jr $ra

set_cells_valid:
	li $v0, 0	#if parameters are all valid, load 0.
	jr $ra




reveal_map:
    	beq $a0, 1, end_game     #if input is 1, end game with smiley face
    	beq $a0, 0, continue_game	#If input is 0, pass through
    	beq $a0, -1, lose_game	 #If input is -1, show everything on the board and the exploded bomb.
    	
continue_game:
	jr $ra		#Passes through the method
    	
end_game:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	jal smiley
	lw $ra, ($sp)
	jr $ra

lose_game:
	la $t0, 0xffff0000	#Loads the address of the array onto $t0
	move $t1 , $a1 		#Moves address onto $t1
	li $t4, 0		#Counter
	li $t5, 10		#10 constant
	

lose_game_loop:
	beq $t4, 100, reveal_end		#If counter == 100, end loop
	lb $t2, ($t1)				#Load value in array onto $t2
	addi $t1, $t1, 1			#Increments offset for next run
	beq $t2, 0, make0			#Checks if the value equals any of these numbers
	beq $t2, 1, make1
	beq $t2, 2, make2
	beq $t2, 3, make3
	beq $t2, 4, make4
	beq $t2, 5, make5  
	beq $t2, 6, make6
	beq $t2, 7, make7
	beq $t2, 8, make8
	beq $t2, 32, make_bomb
	beq $t2, 48, make_green_flag
	blt $t2, 25, make_red_flag
	addi $t4, $t4, 1			#Increments counter	
	j lose_game_loop
	

make0:	
	div $t4, $t5				#Puts 0 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7 
	li $a2, 0
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make1:
	div $t4, $t5				#Puts 1 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '1'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make2:
	div $t4, $t5					#Puts 2 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '2'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
	
make3:
	div $t4, $t5					#Puts 3 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '3'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
	
make4:
	div $t4, $t5					#Puts 4 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '4'
	li $a3, 13
	li $t8, 0
		addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
	
make5:
	div $t4, $t5					#Puts 5 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '5'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make6:	
	div $t4, $t5					#Puts 6 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '6'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make7:
	div $t4, $t5					#Puts 7 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '7'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make8:
	div $t4, $t5					#Puts 8 in cell with grey background
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, '8'
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make_bomb:
	div $t4, $t5					#Puts bomb in cell 
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2,'b'
	li $a3, 7
	li $t8, 0
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
make_green_flag:
	div $t4, $t5					#Puts green flag in cell 
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, 'f'
	li $a3, 12
	li $t8, 10
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop

make_red_flag:
	div $t4, $t5					#Puts red flag in cell 
	mfhi $t7
	mflo $t6
	move $a0, $t6
	move $a1, $t7
	li $a2, 'f'
	li $a3, 12
	li $t8, 9
	addi $sp, $sp, -36
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $ra, 32($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	addi $t4, $t4, 1
	j lose_game_loop
	

reveal_end:
	lw $t0, cursor_row			#Loads cursor onto 2 different registers
	lw $t1, cursor_col
	
	move $a0, $t0				#Where ever cursor is located, it puts an exploded bomb at that spot.
	move $a1, $t1
	li $a2, 'e'
	li $a3, 15
	li $t2, 9
	addi $sp, $sp, 8
	sw $t2, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw $t2, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, -8

    	jr $ra
	

##############################
# PART 4 FUNCTIONS
##############################

perform_action:
    move $t0, $a0   #Moves the array address into $t0.
    move $t1, $a1   #Moves command onto $t1
    

    
    beq $t1, 'w', W_Action
    beq $t1, 'W', W_Action
    beq $t1, 'a', A_Action
    beq $t1, 'A', A_Action
    beq $t1, 's', S_Action
    beq $t1, 'S', S_Action
    beq $t1, 'd', D_Action
    beq $t1, 'D', D_Action
    beq $t1, 'r', R_Action
    beq $t1, 'R', R_Action
    beq $t1, 'F', F_Action
    beq $t1, 'f', F_Action
    j end_perform_action
    
W_Action:
  	lb $t2, cursor_row
   	lb $t3, cursor_col
   	beq $t2, 0, invalid_move
    	li $t4, 10
	
   	mul $t5, $t2, $t4
    	add $t5, $t5, $t3
   	add $t0, $t0, $t5
	
   	lb $t6, ($t0)
   	blt $t6, 16, W_not_flag
   	beq $t6, 32, W_not_flag
   	beq $t6, 48, W_is_flag
   	blt $t6, 31, W_is_flag
   	bgt $t6, 63, W_is_revealed
   	
W_is_revealed:
	addi $t7, $t6, -64
	andi $t8, $t6, 15 #Gets the last 4 bits of t4
	bnez $t8, not_zero_w
	li $t7, '\0'
	j is_zero_w
	not_zero_w:
	addi $t7, $t7, '0'  
	is_zero_w:
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	j W_Move
   	
   	
W_not_flag:
	addi $t7, $t6, '0'
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 7
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	
	j W_Move
	
W_is_flag:
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40

W_Move:	  
	addi $t2, $t2, -1
	sb $t2, cursor_row
	sb $t3, cursor_col
	addi $t0, $t0, -10
	lb $t6, ($t0)
	
	blt $t6, 16, cursor_over_hidden
	beq $t6, 32, cursor_over_hidden
	bgt $t6, 63, cursor_over_revealed
	blt $t6, 49, cursor_over_flag

A_Action:
	lb $t2, cursor_row
   	lb $t3, cursor_col
   	beq $t3, 0, invalid_move
    	li $t4, 10
	
   	mul $t5, $t2, $t4
    	add $t5, $t5, $t3
   	add $t0, $t0, $t5
	
   	lb $t6, ($t0)
   	blt $t6, 16, A_not_flag
   	beq $t6, 32, A_not_flag
   	beq $t6, 48, A_is_flag
   	blt $t6, 31, A_is_flag
   	bgt $t6, 63, A_is_revealed
   	
A_is_revealed:
	addi $t7, $t6, -64
	andi $t8, $t6, 15 #Gets the last 4 bits of t4
	bnez $t8, not_zero_a
	li $t7, '\0'
	j is_zero_a
	not_zero_a:
	addi $t7, $t7, '0'  
	is_zero_a:
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	j A_Move
   	
A_not_flag:
	addi $t7, $t6, '0'
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 7
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	
	j A_Move
	
A_is_flag:
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40

A_Move:	  
	addi $t3, $t3, -1
	sb $t2, cursor_row
	sb $t3, cursor_col
	addi $t0, $t0, -1
	lb $t6, ($t0)
	
	blt $t6, 16, cursor_over_hidden
	beq $t6, 32, cursor_over_hidden
	bgt $t6, 63, cursor_over_revealed
	blt $t6, 49, cursor_over_flag
	

S_Action:
	lb $t2, cursor_row
   	lb $t3, cursor_col
   	beq $t2, 9, invalid_move
    	li $t4, 10
	
   	mul $t5, $t2, $t4
    	add $t5, $t5, $t3
   	add $t0, $t0, $t5
	
   	lb $t6, ($t0)
   	blt $t6, 16, S_not_flag
   	beq $t6, 32, S_not_flag
   	beq $t6, 48, S_is_flag
   	blt $t6, 31, S_is_flag
   	bgt $t6, 63, S_is_revealed
   	
S_is_revealed:
	addi $t7, $t6, -64
	andi $t8, $t6, 15 #Gets the last 4 bits of t4
	bnez $t8, not_zero_s
	li $t7, '\0'
	j is_zero_s
	not_zero_s:
	addi $t7, $t7, '0'  
	is_zero_s:
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	j S_Move
   	
S_not_flag:
	addi $t7, $t6, '0'
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 7
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	
	j S_Move
	
S_is_flag:
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40

S_Move:	  
	addi $t2, $t2, 1
	sb $t2, cursor_row
	sb $t3, cursor_col
	addi $t0, $t0, 10
	lb $t6, ($t0)
	
	blt $t6, 16, cursor_over_hidden
	beq $t6, 32, cursor_over_hidden
	bgt $t6, 63, cursor_over_revealed
	blt $t6, 49, cursor_over_flag
	

D_Action:
	lb $t2, cursor_row
   	lb $t3, cursor_col
   	beq $t3, 9, invalid_move
    	li $t4, 10
	
   	mul $t5, $t2, $t4
    	add $t5, $t5, $t3
   	add $t0, $t0, $t5
	
   	lb $t6, ($t0)
   	blt $t6, 16, D_not_flag
   	beq $t6, 32, D_not_flag
   	beq $t6, 48, D_is_flag
   	blt $t6, 31, D_is_flag
   	bgt $t6, 63, D_is_revealed
   	
D_is_revealed:
	addi $t7, $t6, -64
	andi $t8, $t6, 15 #Gets the last 4 bits of t4
	bnez $t8, not_zero_d
	li $t7, '\0'
	j is_zero_d
	not_zero_d:
	addi $t7, $t7, '0'  
	is_zero_d:
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 13
	li $t8, 0
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	j D_Move
   	
D_not_flag:
	addi $t7, $t6, '0'
	move $a0, $t2
	move $a1, $t3
	move $a2, $t7
	li $a3, 7
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40
	
	j D_Move
	
D_is_flag:
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 7
	addi $sp, $sp, -40
	sw $t8, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $ra, 36($sp)
	jal set_cell
	lw $t8, ($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40

D_Move:	  
	addi $t3, $t3, 1
	sb $t2, cursor_row
	sb $t3, cursor_col
	addi $t0, $t0, 1
	lb $t6, ($t0)
	
	blt $t6, 16, cursor_over_hidden
	beq $t6, 32, cursor_over_hidden
	bgt $t6, 63, cursor_over_revealed
	blt $t6, 49, cursor_over_flag

R_Action:
	lb $t2, cursor_row
	lb $t3, cursor_col
	li $t4, 10
	mul $t5, $t2, $t4
	add $t5, $t5, $t3
	add $t0, $t0, $t5
	lb $t6, ($t0)
	bgt $t6, 63, invalid_move
	beq $t6, 32, revealed_a_bomb
	beq $t6, 48, revealed_a_bomb_with_flag
	beq $t6, 0, reveal_blank
	blt $t6, 15, reveal_this_cell
	blt $t6, 32, reveal_cell_with_flag 

revealed_a_bomb:
 	addi $t6, $t6, 64
 	sb $t6, ($t0)
 	j end_perform_action
 	
reveal_blank:
	move $a1, $t2
 	move $a2, $t3
 	addi $sp, $sp, -4
 	sw $ra, ($sp)
 	jal search_cells
 	lw $ra, ($sp)
 	addi $sp, $sp, 4
 	j end_perform_action
revealed_a_bomb_with_flag:
 	addi $t6, $t6, 48
 	sb $t6, ($t0)
 	j end_perform_action
 	
reveal_cell_with_flag:
	addi $t6, $t6, -16
  
reveal_this_cell:
	addi $t6, $t6, '0'  
	move $a0, $t2
	move $a1, $t3
	move $a2, $t6
	li $a3, 13
	li $t8, 11
	addi $sp, $sp, -12
	sw  $t8, ($sp)
	sw $t0, 4($sp)
	sw $ra, 8($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $t0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	addi $t6, $t6, -48
	addi $t6, $t6, 64
	sb $t6, ($t0)
	j end_perform_action
		

F_Action:
	lb $t2, cursor_row
	lb $t3, cursor_col
	li $t4, 10
	mul $t5, $t2, $t4
	add $t5, $t5, $t3
	add $t0, $t0, $t5
	lb $t6, ($t0)
	bgt $t6, 63, invalid_move
	blt $t6, 16, add_flag
	beq $t6, 32, add_flag
	blt $t6, 49, remove_flag
	
add_flag:
	addi $t6, $t6, 16
	sb $t6, ($t0)
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	j end_perform_action

remove_flag:
	addi $t6, $t6, -16
	sb $t6, ($t0)
	move $a0, $t2
	move $a1, $t3
	li $a2, '\0'
	li $a3, 11
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	j end_perform_action
	

cursor_over_hidden:
	move $a0, $t2
	move $a1, $t3
	li $a2, '\0'
	li $a3, 7
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	j end_perform_action
	
cursor_over_flag:
	move $a0, $t2
	move $a1, $t3
	li $a2, 'f'
	li $a3, 12
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	j end_perform_action

cursor_over_revealed:
	addi $t9, $t6, -64
	andi $t8, $t6, 15 #Gets the last 4 bits of t4
	bnez $t8, not_zero_c
	li $t9, '\0'
	j is_zero_c
	not_zero_c:
	addi $t9, $t9, '0'  
	is_zero_c: 
	move $a0, $t2
	move $a1, $t3
	move $a2, $t9
	li $a3, 13
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	j end_perform_action

invalid_move:
	li $v0, -1
	jr $ra
    	    
end_perform_action:
	li $v0, 0
   	jr $ra

game_status:
 	move $t0, $a0
 	lb $t1, cursor_row
 	lb $t2, cursor_col
 	li $t4, 10
 	mul $t5, $t1, $t4
 	add $t5, $t5, $t2
 	add $t0, $t0, $t5
 	lb $t4, ($t0)
 	andi $t6, $t4, 96
 	beq $t6, 96, game_status_exploded_bomb 
 	move $t0, $a0
 	li $t1, 0
 check_all_cells:
 	beq $t1, 100, game_won
 	lb $t2, ($t0)
 	addi $t1, $t1, 1
 	addi $t0, $t0, 1
 	andi $t3, $t2, 16
 	beq $t3, 16, is_Flag
 	andi $t3, $t2, 32
  	beq $t3, 32, is_Bomb
 	j check_all_cells 
  is_Flag:
  	andi $t3, $t2, 32
  	beq $t3, 32, check_all_cells
  	j cont_game
  is_Bomb:
  	andi $t3, $t2, 16
  	beq $t3, 16, check_all_cells
  	j cont_game
  	
 	
game_status_exploded_bomb:
	li $v0, -1
	j game_status_end
cont_game:	
	li $v0, 0
	j game_status_end

game_won:
	li $v0, 1

game_status_end: 
        jr $ra

##############################
# PART 5 FUNCTIONS
##############################

search_cells:
    addi $sp, $sp, -8
    sw $a1, ($sp)
    sw $a2, 4($sp)
    move $fp, $sp
    move $t9, $a0  #$t9 holds array address
    addi $sp, $sp, -8
    sw $a1, ($sp)
    sw $a2, 4($sp)
    
search_loop:
    beq $fp, $sp, end_this_search_loop
    move $t9, $a0
    lw $t0, ($sp)	#t0 = row
    lw $t1, 4($sp)	#t1 = col
    addi $sp, $sp, 8
    li $t2, 10
    mul $t3,$t0, $t2
    add $t3, $t3, $t1
    add $t9, $t9, $t3
    lb $t4, ($t9)
    andi $t5, $t4, 16
    beq $t5, 16, this_is_not_flag
	
	addi $sp , $sp, -32
	li $t8, 0
	sw $t8, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $t4, 12($sp)
	sw $a0, 16($sp)
	
	andi $t4, $t4, 15 #Gets the last 4 bits of t4
	bnez $t4, not_zero
	addi $t4, $t4, '\0'
	j is_zero
not_zero:
	addi $t4, $t4, '0'  
is_zero:
	move $a0, $t0
	move $a1, $t1
	move $a2, $t4
	li $a3, 13
	#addi $sp, $sp, -12
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	sw $ra, 28($sp)
	
	jal set_cell
	
	lw  $t8, ($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $t4, 12($sp)
	lw $a0, 16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	
	lb $t4, ($t9)
	ori $t4, $t4, 64
	sb $t4, ($t9)
	
	andi $t4, $t4, 15 #Gets the last 4 bits of t4
	
		
this_is_not_flag:
	li $t2, 10 
	bnez $t4, search_loop
	addi $t5, $t0, 1 #new row
	addi $t8, $t1, 0
	blt $t5, 10, check_row_and_1_hidden
	j second_case
check_row_and_1_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t1
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, second_case
    	
check_row_and_1_flag:
	andi $t6, $t4, 16
	beq $t6, 16, second_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t1, 4($sp)
	
second_case:
	addi $t5, $t0, 0 #new row
	addi $t8, $t1, 1 #new col
	blt $t8, 10, check_col_and_1_hidden
	j third_case
check_col_and_1_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, third_case
    	
check_col_and_1_flag:
	andi $t6, $t4, 16
	beq $t6, 16, third_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)
	
third_case:
	addi $t5, $t0,-1 #new row
	addi $t8, $t1, 0 #new col
	bge $t5, 0, check_row_less_1_hidden
	j fourth_case
check_row_less_1_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, fourth_case
check_row_less_1_flag:
	andi $t6, $t4, 16
	beq $t6, 16, fourth_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)    		



fourth_case:
	addi $t5, $t0, 0 #new row
	addi $t8, $t1, -1 #new col
	bge $t8, 0, check_col_less_1_hidden
	j fifth_case
check_col_less_1_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, fifth_case
    	
check_col_less_1_flag:
	andi $t6, $t4, 16
	beq $t6, 16, fifth_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)

	
		
				
fifth_case:
	addi $t5, $t0, -1 #new row
	addi $t8, $t1, -1 #new col
	bge $t8, 0, check_row
	j sixth_case
	
check_row:
	bge $t5, 0, check_col_less_row_less_hidden
	j sixth_case
check_col_less_row_less_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, sixth_case
    	
check_col_less_row_less_flag:
	andi $t6, $t4, 16
	beq $t6, 16, sixth_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)
	
sixth_case:
	addi $t5, $t0, -1 #new row
	addi $t8, $t1, 1 #new col
	blt $t8, 10, check_row_2
	j seventh_case
check_row_2:
	bge $t5, 0, check_col_and_row_less_hidden
	j seventh_case
check_col_and_row_less_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, seventh_case
check_col_and_row_less_flag:
	andi $t6, $t4, 16
	beq $t6, 16, seventh_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)
	
seventh_case:
	addi $t5, $t0, 1 #new row
	addi $t8, $t1, -1 #new col
	bge $t8, 0, check_row_3
	j eighth_case
check_row_3:
	blt $t5, 10, check_col_and_and_row_less_less_hidden
	j eighth_case
check_col_and_and_row_less_less_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, eighth_case
    	
check_col_and_and_row_less_less__flag:
	andi $t6, $t4, 16
	beq $t6, 16, eighth_case
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)

eighth_case:
	addi $t5, $t0, 1 #new row
	addi $t8, $t1, 1 #new col
	blt $t8, 10, check_row_4
	j search_loop
check_row_4:
	blt $t5, 10, check_colrow_less_hidden
	j search_loop
check_colrow_less_hidden:
	move $t9, $a0
	mul $t3,$t5, $t2
    	add $t3, $t3, $t8
    	add $t9, $t9, $t3
    	lb $t4, ($t9)
    	andi $t6, $t4, 64
    	beq $t6, 64, search_loop
    	
check_colrow_less_less__flag:
	andi $t6, $t4, 16
	beq $t6, 16, search_loop
	addi $sp, $sp, -8
	sw $t5, ($sp)
	sw $t8, 4($sp)
	j search_loop
      
end_this_search_loop:
	lw $a0, ($sp)
	lw $a1, 4($sp)	 ########################################
	addi $sp, $sp, 8
	li $a2, '\0'
	li $a3, 13
	li $t8, 11
	addi $sp, $sp, -8
	sw  $t8, ($sp)
	sw $ra, 4($sp)
	jal set_cell
	lw  $t8, ($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
		
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
input_buffer: .space 1
cursor_row: .word -1
cursor_col: .word -1

#place any additional data declarations here

