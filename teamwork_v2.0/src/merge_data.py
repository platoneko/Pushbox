zeros = ["0\n"]*64
with open("pushbox_data_v2.0.hex", "w") as wf:
    wf.write("v2.0 raw\n")
    wf.writelines(zeros) # ground +0
    with open("wall.png.hex", "r") as rf:
        wf.writelines(rf.readlines()[1:]) # +64
    with open("me.png.hex", "r") as rf:
        wf.writelines(rf.readlines()[1:]) # +128
    with open("box.png.hex", "r") as rf:
        wf.writelines(rf.readlines()[1:]) # +192
    with open("dest.png.hex", "r") as rf: 
        wf.writelines(rf.readlines()[1:]) # +256
    with open("box_at_dest.png.hex", "r") as rf:
        wf.writelines(rf.readlines()[1:]) # +320
    wf.writelines(zeros) # +384
    wf.writelines(zeros) # +448
    with open("pushbox_data_v1.0.hex", "r") as rf:
        wf.writelines(rf.readlines()[1:]) # +512