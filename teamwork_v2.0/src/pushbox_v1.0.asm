.text
# gp+0 : me.x
# gp+4 : me.y
# gp+8 : number of box not at dest
# main
 addi $gp,$0,0x1800
 addi $sp,$0,0x3ffc
 sw $0,8($gp)
 addi $k0,$0,0 # $k0 current x
display_x:
 addi $k1,$0,0 # $k1 current y
display_y:
 sll $t0,$k0,4
 add $t0,$t0,$k1
 sll $t0,$t0,2
 lw $a2,0($t0) # state at x, y
 beq $a2,$0,display_skip # skip ground
 addi $t0,$0,3
 bne $a2,$t0,display_next
 # box++
 lw $t0,8($gp)
 addi $t0,$0,1
 sw $t0,8($gp)
 ##
display_next:
 add $a0,$0,$k0
 add $a1,$0,$k1
 jal display
display_skip:
 addi $k1,$k1,1
 addi $t0,$0,16
 bne $k1,$t0,display_y
 addi $k0,$k0,1
 addi $t0,$0,16
 bne $k0,$t0,display_x
loop:
 j loop
 addi $v0,$0,0x32
 syscall

# func display(x, y, type)
# use $s0,$s1,$s2,$s3,$s4,$t0
display:
 addi $sp,$sp,24 # func display(x, y, type)
 sw $t0,0($sp)
 sw $s0,-4($sp)
 sw $s1,-8($sp)
 sw $s2,-12($sp)
 sw $s3,-16($sp)
 sw $s4,-20($sp)
 beq $a2,$0,type_0 # ground
 addi $t0,$0,1
 beq $a2,$t0,type_1 # wall
 addi $t0,$0,2
 beq $a2,$t0,type_2 # me
 addi $t0,$0,3
 beq $a2,$t0,type_3 # box
 addi $t0,$0,4
 beq $a2,$t0,type_4 # dest
 addi $t0,$0,5
 beq $a2,$t0,type_5 # box_at_dest
 addi $t0,$0,6
 beq $a2,$t0,type_2 # me_at_dest
 lw $t0,0($sp)
 addi $sp,$sp,-24
 jr $ra # unknown
type_0:
 #addi $s0,$0,0x0 # Black
 addi $s0,$0,0x0
 j draw
type_1:
 #addi $s0,$0,0x1ce7c # Lavender
 addi $s0,$0,0x739f
 sll $s0,$s0,2
 j draw
type_2:
 sw $a0,0($gp) # update me.x
 sw $a1,4($gp) # update me.y
 #addi $s0,$0,0x1b11c #	Crimson
 addi $s0,$0,0x6c47
 sll $s0,$s0,2
 j draw
type_3:
 #addi $s0,$0,0x1fd00 # Gold
 addi $s0,$0,0x7f40
 sll $s0,$s0,2
 j draw
type_4:
 #addi $s0,$0,0x8e68 # 	Turquoise
 addi $s0,$0,0x239a
 sll $s0,$s0,2
 j draw
type_5:
 #addi $s0,$0,0x15f94 # GreenYellow
 addi $s0,$0,0x57e5
 sll $s0,$s0,2
draw:
 sll $s1,$a0,3 # $s1 current x
 addi $s2,$s1,8
draw_x:
 sll $s3,$a1,3 # $s3 current y
 addi $s4,$s3,8
draw_y:
 add $a0,$0,$s0
 sll $t0,$s1,18
 add $a0,$a0,$t0
 sll $t0,$s3,25
 add $a0,$a0,$t0
 addi $v0,$0,0x147
 syscall
 addi $s3,$s3,1
 bne $s3,$s4,draw_y
 addi $s1,$s1,1
 bne $s1,$s2,draw_x
 lw $t0,0($sp)
 lw $s0,-4($sp)
 lw $s1,-8($sp)
 lw $s2,-12($sp)
 lw $s3,-16($sp)
 lw $s4,-20($sp)
 addi $sp,$sp,-24
 jr $ra

# exception go_up
# use $t0,$t1,$t2,$s0,$s1,$s2,$s3,$s4,$a0,$a1,$a2
go_up:
 addi $sp,$sp,44 # exception go_up
 sw $t0,0($sp)
 sw $t1,-4($sp)
 sw $t2,-8($sp)
 sw $s0,-12($sp)
 sw $s1,-16($sp)
 sw $s2,-20($sp)
 sw $s3,-24($sp)
 sw $s4,-28($sp)
 sw $a0,-32($sp)
 sw $a1,-36($sp)
 sw $a2,-40($sp)
 lw $s0,0($gp) # me.x
 lw $s1,4($gp) # me.y
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s2,0($t0) # state at me.x, me.y
 addi $t1,$s0,-1
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s3,0($t0) # state at me.x-1, me.y
 beq $s3,$0,go_up_type0 # ground
 addi $t0,$0,1
 beq $s3,$t0,go_up_not_move # wall
 addi $t0,$0,3
 beq $s3,$t0,go_up_type3 # box
 addi $t0,$0,4
 beq $s3,$t0,go_up_type4 # dest
 addi $t0,$0,5
 beq $s3,$t0,go_up_type5 # box at dest
go_up_type0:
 # set state at me.x-1, me.y to 2
 addi $t2,$0,2
 ##
 j go_up_move
go_up_type3:
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x-2, me.y
 beq $s4,$0,go_up_type30 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_up_type34 # behind box is dest
 j go_up_not_move
go_up_type30:
 # set state at me.x-2, me.y to 3
 addi $t2,$0,3
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x-1, me.y to 2
 addi $t2,$0,2
 ##
 j go_up_move
go_up_type34:
 # box--
 lw $t0,8($gp)
 addi $t0,$0,-1
 sw $t0,8($gp)
 ##
 # set state at me.x-2, me.y to 5
 addi $t2,$0,5
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x-1, me.y to 2
 addi $t2,$0,2
 ##
 j go_up_move
go_up_type4:
 # set state at me.x-1, me.y to 6
 addi $t2,$0,6
 ##
 j go_up_move
 ##
go_up_type5:
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x-2, me.y
 beq $s4,$0,go_up_type50 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_up_type54 # behind box is dest
 j go_up_not_move
go_up_type50:
 # box++
 lw $t0,8($gp)
 addi $t0,$0,1
 sw $t0,8($gp)
 ##
 # set state at me.x-2, me.y to 3
 addi $t2,$0,3
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x-1, me.y to 6
 addi $t2,$0,6
 ##
 j go_up_move
go_up_type54:
 # set state at me.x-2, me.y to 5
 addi $t2,$0,5
 addi $t1,$s0,-2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x-1, me.y to 6
 addi $t2,$0,6
 ##
go_up_move:
 # set state at me.x-1, me.y to $t2
 addi $t1,$s0,-1
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 addi $t0,$0,6
 beq $s2,$t0,go_up_at_dest
 # set state at me.x, me.y to 0
 addi $t2,$0,0
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
go_up_at_dest:
 # set state at me.x, me.y to 4
 addi $t2,$0,4
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
go_up_not_move:
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
 
# exception go_down
# use $t0,$t1,$t2,$s0,$s1,$s2,$s3,$s4
go_down:
 addi $sp,$sp,44 # exception go_down
 sw $t0,0($sp)
 sw $t1,-4($sp)
 sw $t2,-8($sp)
 sw $s0,-12($sp)
 sw $s1,-16($sp)
 sw $s2,-20($sp)
 sw $s3,-24($sp)
 sw $s4,-28($sp)
 sw $a0,-32($sp)
 sw $a1,-36($sp)
 sw $a2,-40($sp)
 lw $s0,0($gp) # me.x
 lw $s1,4($gp) # me.y
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s2,0($t0) # state at me.x, me.y
 addi $t1,$s0,1
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s3,0($t0) # state at me.x+1, me.y
 beq $s3,$0,go_down_type0
 addi $t0,$0,1
 beq $s3,$t0,go_down_not_move # wall
 addi $t0,$0,3
 beq $s3,$t0,go_down_type3 # box
 addi $t0,$0,4
 beq $s3,$t0,go_down_type4 # dest
 addi $t0,$0,5
 beq $s3,$t0,go_down_type5 # box at dest
go_down_type0:
 # set state at me.x+1, me.y to 2
 addi $t2,$0,2
 ##
 j go_down_move
go_down_type3:
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x+2, me.y
 beq $s4,$0,go_down_type30 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_down_type34 # behind box is dest
 j go_down_not_move
go_down_type30:
 # set state at me.x+2, me.y to 3
 addi $t2,$0,3
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x+1, me.y to 2
 addi $t2,$0,2
 ##
 j go_down_move
go_down_type34:
 # box--
 lw $t0,8($gp)
 addi $t0,$0,-1
 sw $t0,8($gp)
 ##
 # set state at me.x+2, me.y to 5
 addi $t2,$0,5
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x+1, me.y to 2
 addi $t2,$0,2
 ##
 j go_down_move
go_down_type4:
 # set state at me.x+1, me.y to 6
 addi $t2,$0,6
 ##
 j go_down_move
go_down_type5:
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x+2, me.y
 beq $s4,$0,go_down_type50 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_down_type54 # behind box is dest
 j go_down_not_move
go_down_type50:
 # box++
 lw $t0,8($gp)
 addi $t0,$0,1
 sw $t0,8($gp)
 ##
 # set state at me.x+2, me.y to 3
 addi $t2,$0,3
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x+1, me.y to 6
 addi $t2,$0,6
 ##
 j go_down_move
go_down_type54:
 # set state at me.x+2, me.y to 5
 addi $t2,$0,5
 addi $t1,$s0,2
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x+1, me.y to 6
 addi $t2,$0,6
 ##
go_down_move:
 # set state at me.x+1, me.y to $t2
 addi $t1,$s0,1
 sll $t0,$t1,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$t1
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 addi $t0,$0,6
 beq $s2,$t0,go_down_at_dest
 # set state at me.x, me.y to 0
 addi $t2,$0,0
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
go_down_at_dest:
 # set state at me.x, me.y to 4
 addi $t2,$0,4
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
go_down_not_move:
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
 
# exception go_left
# use $t0,$t1,$t2,$s0,$s1,$s2,$s3,$s4
go_left:
 addi $sp,$sp,44 # exception go_left
 sw $t0,0($sp)
 sw $t1,-4($sp)
 sw $t2,-8($sp)
 sw $s0,-12($sp)
 sw $s1,-16($sp)
 sw $s2,-20($sp)
 sw $s3,-24($sp)
 sw $s4,-28($sp)
 sw $a0,-32($sp)
 sw $a1,-36($sp)
 sw $a2,-40($sp)
 lw $s0,0($gp) # me.x
 lw $s1,4($gp) # me.y
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s2,0($t0) # state at me.x, me.y
 sll $t0,$s0,4
 addi $t1,$s1,-1
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s3,0($t0) # state at me.x, me.y-1
 beq $s3,$0,go_left_type0 # ground
 addi $t0,$0,1
 beq $s3,$t0,go_left_not_move # wall
 addi $t0,$0,3
 beq $s3,$t0,go_left_type3 # box
 addi $t0,$0,4
 beq $s3,$t0,go_left_type4 # dest
 addi $t0,$0,5
 beq $s3,$t0,go_left_type5 # box at dest
go_left_type0:
 # set state at me.x, me.y-1 to 2
 addi $t2,$0,2
 ##
 j go_left_move 
go_left_type3:
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x, me.y-2
 beq $s4,$0,go_left_type30 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_left_type34 # behind box is dest
 j go_left_not_move
go_left_type30:
 # set state at me.x, me.y-2 to 3
 addi $t2,$0,3
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y-1 to 2
 addi $t2,$0,2
 ##
 j go_left_move
go_left_type34:
 # box--
 lw $t0,8($gp)
 addi $t0,$0,-1
 sw $t0,8($gp)
 ##
 # set state at me.x, me.y-2 to 5
 addi $t2,$0,5
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y-1 to 2
 addi $t2,$0,2
 ##
 j go_left_move
go_left_type4:
 # set state at me.x, me.y-1 to 6
 addi $t2,$0,6
 ##
 j go_left_move
 ##
go_left_type5:
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x, me.y-2
 beq $s4,$0,go_left_type50 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_left_type54 # behind box is dest
 j go_left_not_move
go_left_type50:
 # box++
 lw $t0,8($gp)
 addi $t0,$0,1
 sw $t0,8($gp)
 ##
 # set state at me.x, me.y-2 to 3
 addi $t2,$0,3
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y-1 to 6
 addi $t2,$0,6
 ##
 j go_left_move
go_left_type54:
 # set state at me.x, me.y-2 to 5
 addi $t2,$0,5
 sll $t0,$s0,4
 addi $t1,$s1,-2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y-1 to 6
 addi $t2,$0,6
 ##
go_left_move:
 # set state at me.x, me.y-1 to $t2
 sll $t0,$s0,4
 addi $t1,$s1,-1
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 addi $t0,$0,6
 beq $s2,$t0,go_left_at_dest
 # set state at me.x, me.y to 0
 addi $t2,$0,0
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
go_left_at_dest:
 # set state at me.x, me.y to 4
 addi $t2,$0,4
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
go_left_not_move:
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
 
# exception go_right
# use $t0,$t1,$t2,$s0,$s1,$s2,$s3,$s4
go_right:
 addi $sp,$sp,44 # exception go_right
 sw $t0,0($sp)
 sw $t1,-4($sp)
 sw $t2,-8($sp)
 sw $s0,-12($sp)
 sw $s1,-16($sp)
 sw $s2,-20($sp)
 sw $s3,-24($sp)
 sw $s4,-28($sp)
 sw $a0,-32($sp)
 sw $a1,-36($sp)
 sw $a2,-40($sp)
 lw $s0,0($gp) # me.x
 lw $s1,4($gp) # me.y
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 lw $s2,0($t0) # state at me.x, me.y
 sll $t0,$s0,4
 addi $t1,$s1,1
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s3,0($t0) # state at me.x, me.y+1
 beq $s3,$0,go_right_type0 # ground
 addi $t0,$0,1
 beq $s3,$t0,go_right_not_move # wall
 addi $t0,$0,3
 beq $s3,$t0,go_right_type3 # box
 addi $t0,$0,4
 beq $s3,$t0,go_right_type4 # dest
 addi $t0,$0,5
 beq $s3,$t0,go_right_type5 # box at dest
go_right_type0:
 # set state at me.x, me.y+1 to 2
 addi $t2,$0,2
 ##
 j go_right_move 
go_right_type3:
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x, me.y+2
 beq $s4,$0,go_right_type30 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_right_type34 # behind box is dest
 j go_right_not_move
go_right_type30:
 # set state at me.x, me.y+2 to 3
 addi $t2,$0,3
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y+1 to 2
 addi $t2,$0,2
 ##
 j go_right_move
go_right_type34:
 # box--
 lw $t0,8($gp)
 addi $t0,$0,-1
 sw $t0,8($gp)
 ##
 # set state at me.x, me.y+2 to 5
 addi $t2,$0,5
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y+1 to 2
 addi $t2,$0,2
 ##
 j go_right_move
go_right_type4:
 # set state at me.x, me.y+1 to 6
 addi $t2,$0,6
 ##
 j go_right_move
 ##
go_right_type5:
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 lw $s4,0($t0) # state at me.x, me.y+2
 beq $s4,$0,go_right_type50 # behind box is ground
 addi $t0,$0,4
 beq $s4,$t0,go_right_type54 # behind box is dest
 j go_right_not_move
go_right_type50:
 # box++
 lw $t0,8($gp)
 addi $t0,$0,1
 sw $t0,8($gp)
 ##
 # set state at me.x, me.y+2 to 3
 addi $t2,$0,3
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y+1 to 6
 addi $t2,$0,6
 ##
 j go_right_move
go_right_type54:
 # set state at me.x, me.y+2 to 5
 addi $t2,$0,5
 sll $t0,$s0,4
 addi $t1,$s1,2
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 # set state at me.x, me.y+1 to 6
 addi $t2,$0,6
 ##
go_right_move:
 # set state at me.x, me.y+1 to $t2
 sll $t0,$s0,4
 addi $t1,$s1,1
 add $t0,$t0,$t1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$t1
 add $a2,$0,$t2
 jal display
 ##
 addi $t0,$0,6
 beq $s2,$t0,go_right_at_dest
 # set state at me.x, me.y to 0
 addi $t2,$0,0
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
go_right_at_dest:
 # set state at me.x, me.y to 4
 addi $t2,$0,4
 sll $t0,$s0,4
 add $t0,$t0,$s1
 sll $t0,$t0,2
 sw $t2,0($t0)
 add $a0,$0,$s0
 add $a1,$0,$s1
 add $a2,$0,$t2
 jal display
 ##
go_right_not_move:
 lw $t0,0($sp)
 lw $t1,-4($sp)
 lw $t2,-8($sp)
 lw $s0,-12($sp)
 lw $s1,-16($sp)
 lw $s2,-20($sp)
 lw $s3,-24($sp)
 lw $s4,-28($sp)
 lw $a0,-32($sp)
 lw $a1,-36($sp)
 lw $a2,-40($sp)
 addi $sp,$sp,-44
 eret
