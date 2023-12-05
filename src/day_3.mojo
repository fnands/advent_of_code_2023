""" Done in Mojo 0.5.0 

Again happy I wrote the SplitString struct. 

I parsed the input into a tensor, and then iterated over the tensor, 
this makes indexing adjacent rows easy. 

Indexing using the index utils is... interesting. 
"""

from tensor import Tensor, TensorSpec, TensorShape
from utils.index import Index

from aoc_lib.string_utils import SplitString


def day_3_part_1():
    sum_valid = 0

    var file_content: String = ""
    with open("input/day_3.txt", "r") as input_file:
        file_content = input_file.read()
    string_list = SplitString(file_content)

    # Declare tensor sizes.
    # We pad top, bottom, left, and right by row/col.
    let pad = 1
    let width = len(string_list[0]) + 2 * pad
    let height = string_list.__len__() + 2 * pad

    # Declare the schematic tensor.
    # By default Tensors in Mojo are intialized with zeros.
    var schematic = Tensor[DType.uint16](height, width)

    # Fill the schematic tensor with the input data.
    for i in range(string_list.__len__()):
        for j in range(len(string_list[0])):
            item = string_list[i][j]
            # Plus one to account for padding
            if isdigit(ord(item)):
                schematic[Index(i + 1, j + 1)] = atol(item)
            elif item == ".":
                schematic[Index(i + 1, j + 1)] = 10
            else:
                schematic[Index(i + 1, j + 1)] = ord(item)

    # Iterate over all items in schematic
    for i in range(height):  # Columns
        j = 0
        while j < width:  # Rows
            j += 1
            # Start of a number, i.e. 1-9
            if schematic[Index(i, j)] > 0 and schematic[Index(i, j)] < 10:
                still_number = True
                start_row = j

                number = String(schematic[Index(i, j)])

                # Keep going until either end of number or end of line
                while still_number and j < width - 2:
                    j += 1
                    # If we are still in the number, now 0 is allowed.
                    if schematic[Index(i, j)] >= 0 and schematic[Index(i, j)] < 10:
                        number += String(schematic[Index(i, j)])
                    else:
                        still_number = False
                is_an_id = False
                # Number has now ended, now we check for adjacent symbols
                for x in range(i - 1, i + 2):
                    for y in range(start_row - 1, j + 1):
                        if schematic[Index(x, y)] > 10:
                            is_an_id = True

                if is_an_id:
                    sum_valid += atol(number)

    print("Sum valid: ", sum_valid)


def main():
    day_3_part_1()
