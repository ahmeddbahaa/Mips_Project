.data 
	 MainMessage : .asciiz "Enter a Valid Number of the Menus \n1- Search for Request by Priority \n2- Delete all Requests of same Priority \n3- Process all Requests of same Priority \n4- Empty All lists \n5- Insert Requests \n6- print All \n-1 to end the program\n"
	firstMessage : .asciiz "Enter The Request Priority that you wish to search : "
	secondMessage : .asciiz ""
	thirdMessage : .asciiz "Not Found\n"
	fourthMessage : .asciiz "Enter The Request Priority that you wish to Delete \n"
	fifthMessage : .asciiz "Enter The Request Priority that you wish to Process \n"
	sixthMessage : .asciiz "Please Enter Valid menu\n"
	message: .asciiz "Binary Search Value "
	equal:.asciiz "Inside Equal "
	smaller:.asciiz "Inside smaller "
	greater:.asciiz "Inside Greater "
	innerBinaryMessage:.asciiz "Paramter passed "
	sizeOfListsArray: .word 0
			  .word 4
		     	  .word 4
		     	  .word 4
	#request size is 20 byte and each row contain 20 request then each row will be 400 byte to cover all requests we need
	# 4 rows cause we have 4 lists
	array:  .space 12
		.space 12
		.space 12
		.space 12

	colNumber: .word 4 #number of cols in 2d array
 	rowNumber: .word 1 #number of rows in 2d array
	.eqv requestSize 12 #size of one request
	prompt: .asciiz "enter request: "  #message that display when user enter request
	end: .asciiz "All lists are empty"
	message2: .asciiz "enter number :"
	newLine: .asciiz "\n" #new line
	space: .asciiz  " " #space
	binarySearchMessage:.asciiz "The Index of Search value is "
.text 
	main :
	la $s2 array #load array addresse in s
 	lw $s0 , colNumber #load cols number in s0
 	lw $s1 , rowNumber #load row number in s1
 	#printing meneu
	li $v0,4
	la $a0,MainMessage
	syscall
	
	#Getting User Input value
	li $v0,5
	syscall
	
	#Store the result in $t0
	move $t0,$v0
	
	addi $t1 , $zero , -1
	addi $t2 , $zero , 1
	addi $t3 , $zero , 2
	addi $t4 , $zero , 3
	addi $t5 , $zero , 4
	addi $t6 , $zero , 5	
	addi $t7 , $zero , 6
	
	while :
		beq $t0 , $t1 , exit
		beq $t0 , $t2 , ifStatement1
		beq $t0 , $t3 , ifStatement2
		beq $t0 , $t4 , ifStatement3
		beq $t0 , $t5 , ifStatement4
		beq $t0 , $t6 , ifStatement5
		beq $t0 , $t7 , ifStatement6
		j Else
		
		j printMainMessage
		
		li $v0,5
		syscall
		
		j while
		
	exit :
	li $v0,10
	syscall
	
	
	ifStatement1 : 
		#Call binary Search and return result WIth Message
		li $v0 ,4
		la $a0, firstMessage
		syscall
		
		li $v0 , 5
		syscall
		move $a0, $v0
		
		jal binarySearch
		move $t0, $v0 #get the return value
		#print message
		li $v0, 4
		la $a0, binarySearchMessage
		syscall
		#print the result
		li $v0,1
		move $a0, $t0
		syscall
		#print new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		j main
		
	ifStatement2 :
		li $v0,4
		la $a0,fourthMessage
		syscall
		li $v0,5
		jal Delete_all
		
		#li $v0,10
		#syscall
		
	ifStatement3 :
		li $v0,4
		la $a0,fifthMessage
		syscall
		li $v0,5
		jal Process_all
		#li $v0,10
		#syscall
		
	ifStatement4 : 
		jal Emptyall
		#jr $ra
		#li $v0 , 10
		#syscall
		
	ifStatement5 :
		jal inputArray
		#j while
		#jr $ra
		#li $v0,10
		#syscall
	ifStatement6 :
		jal printArray #function call
	Else : 
		li $v0 , 4
		la $a0 , sixthMessage
		syscall
	
	printMainMessage :
		li $v0,4
		la $a0,MainMessage
		syscall
		

	
	
#put input in array
 	inputArray:
 	 li $t2 , 0 #index for row
 	 li $t4 , 0 # index for col
 	 loop3:
 	 bge $t2 ,$s1 end3 #counter greater than or equal number of rows
 	 loop4:
 	 bge $t4 ,$s0 end4 #counter  greater than or equal number of cols
 	 	#formla to loop in 2d array 
 		 mul $t3 , $t2 , $s0
 	         add $t3 ,$t3 , $t4
 		 mul $t3 , $t3 , requestSize
 	 	add $t3 ,$t3 ,$s2
 	 	
 	 	#print prompt message
		li $v0 ,4
		la $a0 , prompt
		syscall
 	 	
 	 	#take priorty from user
		li $v0 , 5
		syscall
		#move value of priorty from vo to t0
		move $t0, $v0
		#sw $t0, integer
		sb $t0,0($t3)
		
		#add 4 bytes to addresse in t3 to go to index that will hold input data
		addi $t3 , $t3 ,4
		#input User Data text
		li $v0, 8
		la $a0, ($t3)
		li $a1, 8 #maximum number of character user can input
		syscall
 	 	
 	 	
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop4 # go back to loop4 branch
 	 end4: #end of loop4 
 	 addi $t2 , $t2 ,1 #first loop counter
 	 li $t4 , 0 #reset second loop to 0
 	 j loop3 # go back to loop3 branch
 	 end3: #end of loop3
 	 j main #return to main program
 	######################
 	Process_all:
 	   #print prompt message
		li $v0 ,4
		la $a0 , message2
		syscall
 	 	#take priorty from user
		li $v0 , 5
		syscall
 	  move $t0, $v0
 	 li $t2 , 0 #index for row
 	 li $t4 , 0 # index for col
 	 addi $t3 ,$t3 , 0
 	 loop1: #frist loop
 	 bge $t2 ,$s1 end1 #counter greater than or equal number of rows
 	 loop2: #second loop
 	# beq $t3,$zero,jump
 	 bge $t4 ,$s0 end2 #counter greater than or equal number of cols
 	 	#formla to loop in 2d array
 		 mul $t3 , $t2 , $s0
 	         add $t3 ,$t3 , $t4
 		 mul $t3 , $t3 , requestSize
 	 	add $t3 ,$t3 ,$s2
 	 	#load $t3 in $a0
 	 	lb $a0, ($t3)
 	 	# branch to check request
 	 	beq $a0,$t0,jump
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop2 #go to loop2 branch
 	 	# print request
 	 	jump:	 	
 	 	 #print prority
 	 	 lb $a0, ($t3)
		 li $v0, 1
		 syscall
		 
		#print space
		li $v0 , 4
		la $a0 , space
		syscall
		 
		 #print data
		 #addi $t3 ,$t3 ,10 #add 10 to current bit to get data form the index
		 addi $t3 ,$t3 ,4
		#load the data part
		la $a0, ($t3)
		#print the data part
		li $v0, 4
		syscall
		
		#print new line
		li $v0 , 4
		la $a0 , newLine
		syscall
	addi $t4 , $t4 ,1 #second loop counter ++
  	j loop2 #go to loop2 branch
 	 
 	 end2: #end of loop2
 	 addi $t2 , $t2 ,1
 	 li $t4 , 0
 	 j loop1 #go to loop1 branch
 	 end1:
 	  j main 
 	 
 	 Emptyall:
 	 li $t2 , 0 #index for row
 	 li $t4 , 0 # index for col
 	 addi $t3 ,$t3 , 0
 	 loop5: #frist loop
 	 bge $t2 ,$s1 end5 #counter greater than or equal number of rows
 	 loop6: #second loop
 	 bge $t4 ,$s0 end6 #counter greater than or equal number of cols
 	 	#formla to loop in 2d array
 		 mul $t3 , $t2 , $s0
 	         add $t3 ,$t3 , $t4
 		 mul $t3 , $t3 , requestSize
 	 	add $t3 ,$t3 ,$s2
 	 	#delete prority
 	 	 sb $zero, 0($t3)
 	 	 #lw $a0, ($t3)
	#	 addi $a0,$zero,0
		
		 
		 #delete data
		 #addi $t3 ,$t3 ,4 #add 4 to current bit to get data form the index
		 addi $t3 ,$t3 ,4
		#load the data part
		sb $zero, 0($t3)
	#	la $a0, ($t3)
	#	addi $a0,$zero,0
		
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop6 #go to loop2 branch
 	 end6: #end of loop2
 	 addi $t2 , $t2 ,1
 	 li $t4 , 0
 	 j loop5 #go to loop1 branch
 	 end5:
 	li $v0 , 4
        la $a0, end
        syscall
         j main 
 ########################################	
	Delete_all:
	
	#print prompt message
		li $v0 ,4
		la $a0 , message2
		syscall
 	 	#take priorty from user
		li $v0 , 5
		syscall
 	  move $t0, $v0
 	  li $t5, 0
 	 li $t2 , 0 #index for row
 	 li $t4 , 0 # index for col
 	 addi $t3 ,$t3 , 0
 	 loop11: #frist loop
 	 bge $t2 ,$s1 end11 #counter greater than or equal number of rows
 	 loop22: #second loop
 	 bge $t4 ,$s0 end22 #counter greater than or equal number of cols
 	 	#formla to loop in 2d array
 		 mul $t3 , $t2 , $s0
 	         add $t3 ,$t3 , $t4
 		 mul $t3 , $t3 , requestSize
 	 	add $t3 ,$t3 ,$s2
 	 	#load $t3 in $a0
 	 	lb $a0, ($t3)
 	 	# branch to check request
 	 	beq $a0,$t0,jump1
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop22 #go to loop2 branch
 	 	# print request
 	 	jump1:	 	
 	 	 #delete prority
 	 	sb $t5, 0($t3)
 	 	 #lw $a0, ($t3)
	#	 addi $a0,$zero,0
		 
		 #delete data
		 #addi $t3 ,$t3 ,4 #add 4 to current bit to get data form the index
		 addi $t3 ,$t3 ,4
		#load the data part
		sb $t5, 0($t3)
	#	la $a0, ($t3)
	#	addi $a0,$zero,0
		
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop22 #go to loop2 branch	 
 	 end22: #end of loop2
 	 addi $t2 , $t2 ,1
 	 li $t4 , 0
 	 j loop11 #go to loop1 branch
 	 end11:
 	  j main 
 #########################	 
	printArray:
 	 li $t2 , 0 #index for row
 	 li $t4 , 0 # index for col
 	 addi $t3 ,$t3 , 0
 	 loop10: #frist loop
 	 bge $t2 ,$s1 end10 #counter greater than or equal number of rows
 	 loop20: #second loop
 	 bge $t4 ,$s0 end20 #counter greater than or equal number of cols
 	 	#formla to loop in 2d array
 		 mul $t3 , $t2 , $s0
 	         add $t3 ,$t3 , $t4
 		 mul $t3 , $t3 , requestSize
 	 	add $t3 ,$t3 ,$s2
 	 	#print prority
 	 	 lb $a0, ($t3)
		 li $v0, 1
		 syscall
		 
		#print space
		li $v0 , 4
		la $a0 , space
		syscall
		 
		 #print data
		 #addi $t3 ,$t3 ,10 #add 10 to current bit to get data form the index
		 addi $t3 ,$t3 ,4
		#load the data part
		la $a0, ($t3)
		#print the data part
		li $v0, 4
		syscall
		
		#print new line
		li $v0 , 4
		la $a0 , newLine
		syscall
		
 	 	addi $t4 , $t4 ,1 #second loop counter ++
 	 	j loop20 #go to loop2 branch
 	 end20: #end of loop2
 	 addi $t2 , $t2 ,1
 	 li $t4 , 0
 	 j loop10 #go to loop1 branch
 	 end10:
 	  j main 
 	
##################	
quicksort:				

	addi $sp, $sp, -16		# Create stack for 4 bytes

	sw $a0, 0($sp)			#store address in stack
	sw $a1, 4($sp)			#store low in stack	
	sw $a2, 8($sp)			#store high in stack
	sw $ra, 12($sp)			#store return address in stack

	move $t0, $a2			#saving high in t0
	
	
		slt $t1, $a1, $t0		# t1=1 if low < high, else 0
		beq $t1, $zero, end_check		# if low >= high, endcheck
		
		#handling prameters to partion function
		la $a0 , 0($sp) #array address
		lw $a1  ,4($sp) # get low index from stack
		lw $a2  ,8($sp) #get high index from stack
		jal partition			# call partition 
		
		move $s0, $v0			# pivot, s0= v0
		
		la $a0 ,0($sp)
		lw $a1, 4($sp)			#a1 = low
		addi $a2, $s0, -1		#a2 = pi -1
		jal quicksort			#call quicksort

		la $a0 ,0($sp)
		addi $a1, $s0, 1		#a1 = pi + 1
		lw $a2, 8($sp)			#a2 = high
		jal quicksort			#call quicksort
		
	end_check:
	lw $a0, 0($sp)			#restore a0
 	lw $a1, 4($sp)			#restore a1
 	lw $a2, 8($sp)			#restore $a2
	lw $ra, 12($sp)			#load return adress into ra
	addi $sp, $sp, 16		#restore stack
	jr $ra				#return to $ra
	
	
##############################
 	getAddress:
 	addi $sp, $sp, -16		#Make stack of 3 bytes
	sw $a0, 0($sp)			#Store $a0 array address
	sw $a1, 4($sp)			#Store $a1 row number
	sw $a2, 8($sp)			#Store $a2 col number
	sw $ra ,12($sp)
 	
 	move $s2 , $a0
 	move $s3 , $a1
 	move $s4 , $a2
 	
 	addi $s0 ,$0 ,5 #change it later
 		 mul $t8 , $s3 , $s0
 	         add $t8 ,$t8 , $s4
 		 mul $t8 , $t8 , requestSize
 	 	add $t8 ,$t8 ,$s2
 	 	
 	 	move $v1 , $t8
 	 	
 	 	
 	 	
 	 	lw $ra , 12($sp)
 		addi $sp,$sp,16			#restore stack
		jr $ra				#return to $ra

  swap:
	addi $sp, $sp, -16		#Make stack of 3 bytes
	sw $a0, 0($sp)			#Store $a0
	sw $a1, 4($sp)			#Store $a1
	sw $a2, 8($sp)			#Store $a2
	sw $ra ,12($sp)
	
	lw $s6 , 4($sp)
	lw $s5 , 8($sp)
	
	#swap the prioty
	lw $t6, 0($s6)			#$t6=array[left]
	lw $t7, 0($s5)			#$t7=array[right]
	
	sw $t6, 0($s5)			#array[right]=$t6
	sw $t7, 0($s6)			#array[left]=$t7
	
	#swap the data
	addi $t6 ,$s6 , 4
	addi $t7 ,$s5 , 4
	add $s0,$zero,$zero # i = 0 + 0
     L1:
	add $t1,$s0,$t6 # address of y[i] in $t1
	lbu $t2, 0($t1) # $t2 = y[i]
	
	add $t9,$s0,$t7 # address of y[i] in $t1
	lbu $t4, 0($t9) # $t2 = y[i]
	
	sb $t2, 0($t9) # x[i] = y[i] 
	sb $t4, 0($t1) # x[i] = y[i]
	
	beq $t2,$zero,check2 # if y[i] == 0, go to L2
	check2:
	beq $t4,$zero,L2
	
	addi $s0, $s0,1 # i = i + 1
 	j L1 # go to L1
	
	L2:
	lw $ra , 12($sp)
 	jr $ra # return
	
	
	
	
	addi $sp,$sp,12			#restore stack
	jr $ra				#return to $ra

 #################
 partition:
	addi $sp, $sp, -16
	sw $a0, 0($sp)			#address of array
	sw $a1, 4($sp)			#low
	sw $a2, 8($sp)			#high
	sw $ra, 12($sp)			#Return address
	#mul $t0, $a1, 4			#$t0 = 4*low to get array indix in mips
	#add $t1, $t0, $a0		#$t1 = address of array plus $t0 to get addresse of first index of array
	
	move $s0, $a1			#first insex = low array index in zero based indexing
	move $s1, $a2			#last index = high index of last element in array
	#functioin to get frist index addresse
	la $a0, array
 	li $a1 ,0
 	li $a2 ,0	
 	jal getAddress 
 	move $t1 , $v1
	lw $s3, 0($t1)			#load piroty of first index in s3
	lw $t3, 0($sp)			#$t3 = address of array
	
	while10:
		bge $s0, $s1, endwhile #if s0(low index) greater than s1(high index) exit loop and go to endWhile 
		while1:
			#mul $t2, $s1, 4			#$t2= right *4
			#formal to get last index from array and every time index  decrease 
			 		
 	 		la $a0, array
 			li $a1 ,0
 			move $a2 ,$s1	
 			jal getAddress 		  	 		 
			move $s6 , $v1			#move adderss to s6		
			lw $s4, 0($s6)			#load index priorty in s4	
			ble $s4,$s3, endwhile1		#end while1 if index priorty <= pivot(first index priorty)
			subi $s1,$s1,1			#decrease s1 by 1 to go next index
			j while1
		endwhile1:
		
		while2:
			#mul $t4, $s0, 4			#$t4 = left*4
			#formal to get frist index from array and every time index  decrease 
			la $a0, array
 			li $a1 ,0
 			move $a2 ,$s0	
 			jal getAddress 
 				
			move $s7, $v1		#move adderss to s7		
			lw $s5, 0($s7)		#load index priorty in s5		
			bge $s0, $s1, endwhile2		#branch if left>=right (j>i)to endwhile2
			bgt $s5, $s3, endwhile2		#branch if index prioty >pivot(first index priorty) to endwhile2
			addi $s0,$s0,1			#increase s0 by one to go next index
			j while2
		endwhile2:
		
		if:
			bge $s0, $s1, end_if		#if left>=right  (j>=i)branch to end_if
			#handling parameters to swap
			move $a0, $t3			#move $t3 to $a0
			move $a1, $s7			#move array[left] into $a1
			move $a2, $s6			#move array[right] into $a2
			jal swap			#jump and link swap
			
			
		end_if:
		
		j while10
		
	endwhile:	
	
		move $a0, $t3			
		move $a1, $s6			
		move $a2, $t1			
		jal swap			

		move $v0, $s1				#set $v0 to new pivot index
		
	lw $ra ,12($sp)					#restore $ra
	addi $sp, $sp,16				#restore stack
	jr $ra	
	
	#################################### 	
 #Binary Search on one LIST
 	binarySearch:
 	move $s4 , $a0 # Get the Target Priority
 	
 	#Print Passed Value
 	li $v0, 4
 	la $a0, innerBinaryMessage
 	syscall
 	
 	li $v0, 1
 	move $a0, $s4
 	syscall
 
 	li $v0, 4
 	la $a0, newLine
 	syscall
 	
 	
 	la $s7, array #load the 2d Array in s7
 	li $t0, 0 #index for row
 	li $s1, 3 #index for end Of List
 	li $s2, 0 #start of list

		whileStillExitElements:
				bge $s2, $s1, endBinarySearch #Branch if st >= end ie no elements in search RAnge
				add $t3, $s2, $s1 #get sum to get middle in next instruction
				div $t3, $t3, 2 #calculate middle in t3
				move $s5, $t3 # move the indx of middle
				mul $t4, $t0, 4 #rowidx * colm size and store in t4 for further calcu
				add $t4, $t3, $zero #add the colm indx which is the middle 
				mul $t4, $t4, requestSize #add the Strutcure size
				add $t4, $t4, $s7 #add the bass addresss of array
				##print the middle
				li $v0, 1
				lw $a0, 0($t4)
				syscall
				#print space
				li $v0, 4
				la $a0, newLine
				syscall
				#Load the priority of Middle
				lw $s6, 0($t4)
				beq $s6, $s4, ifEqual # t7 contain the target priority
				blt $s6, $s4, ifSmaller #branch if Target,priorty < middle.priorty
				bgt $s6, $s4, ifGreater # branch if target.priorty > middle.priorty
				 
	
	endBinarySearch:
	#getting the results in v0
	move $v0, $s1 #start or end will stop when they equal each other
 	jr $ra
 	
 	ifEqual:
 	add $s1, $s5, $zero #make Start of list at the current middle

 			#print element
				li $v0, 4
				la $a0, equal
				syscall
				####
 				li $v0, 1
				move $a0, $s2
				syscall
				#print space
				li $v0, 4
				la $a0, space
				syscall
				li $v0, 1
				move $a0, $s1
				syscall
				#print space
				li $v0, 4
				la $a0, newLine
				syscall
 	j endBinarySearch #return to binarySearch
 	ifGreater:
 	sub $s1, $s5, $1 #make end of list equal mid - 1
 	#print element
				li $v0, 4
				la $a0, greater
				syscall
				####

 				li $v0, 1
				move $a0, $s2
				syscall
				#print space
				li $v0, 4
				la $a0, space
				syscall
				li $v0, 1
				move $a0, $s1
				syscall
				#print space
				li $v0, 4
				la $a0, newLine
				syscall
 	j whileStillExitElements #return to binarySearch
 	ifSmaller:
 	add $s2, $s5, 1 #make start of list = mid + 1
 	#print element
				li $v0, 4
				la $a0, smaller
				syscall
				####
 				li $v0, 1
				move $a0, $s2
				syscall
				#print space
				li $v0, 4
				la $a0, space
				syscall
				li $v0, 1
				move $a0, $s1
				syscall
				#print space
				li $v0, 4
				la $a0, newLine
				syscall
 	j whileStillExitElements #return to binarySearch
 	

 	
 ######################End Binary Search
 	
 	#Find First Free List
 	FFFL:
 	#try to intialize t2,t4 with the number of list
 	
 	la $s6, sizeOfListsArray
 	li $s3, 0
 	Loop:
 		sll $t1, $s3, 2 #multipy 4 by left shift 2
		add $t1, $t1, $s6 #add index address to base address
		lw $s2,0($t1) # load the Address after adding to the base
		blt $s2, 4, exit2# branch if less than 20 desired list 
		addi $s3, $s3, 1#else add idx + 1
		j Loop #jump to loop while not found list less than 20 element
	#take the arguments and return to caller idx of list and the current size of the first free list
 	exit2:
 	move $v0,$s3
 	move $v1, $s2
 	#restore all values used in fffl
	lw $t1, 0($sp)
	lw $s6, 4($sp)
	lw $s3, 8($sp)
	lw $s2, 12($sp)
	#return to caller adderres
 	jr $ra
 ################################## #end of function
 

		
	
	
	
