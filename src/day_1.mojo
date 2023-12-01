""" Done in Mojo 0.5.0 

String handling in Mojo is a bit tricky, so had to create some structs to deal with it.

The SplitString struct is a simple parser that basically does what the split() function does in Python.
I have a feeling I will be using that one a bunch for AoC. 

The ReplaceNumbers struct is used to just replace the spelled out numbers with their numerical counterparts.
Well, not exactly numerical counterparts. I ran straight into the eightwo trap, so did the ugly thing of doing e.g.:
eight8eight.

I am really missing having a built in dict. 

"""

def day_1_part_1() -> None:

    with open("input/day_1.txt", "r") as input_file:
        file_content = input_file.read()
        # Split string on newlines into a "List" of Strings
        string_list = SplitString(file_content)
        size = string_list.__len__()
        sum_calibration_values = 0

        for i in range(size):
            # Add the concatenation of first and last numbers to the sum
            sum_calibration_values += find_first_and_last_int(string_list[i])

        print("The sum of numerical calibration values is: ", sum_calibration_values)



def day_1_part_2() -> None:

    with open("input/day_1.txt", "r") as input_file:
        file_content = input_file.read()  
        # Split string on newlines into a "List" of Strings
        string_list = SplitString(file_content)
        size = string_list.__len__()
        sum_calibration_values = 0

        # Initialize the ReplaceNumbers struct
        replace_numbers = ReplaceNumbers()

        for i in range(size):
            # Replace spelled out numbers with their numerical counterparts
            fixed_string = replace_numbers.replace_numbers(string_list[i])
            # Add the concatenation of first and last numbers to the sum
            sum_calibration_values += find_first_and_last_int(fixed_string)

        print("The sum of numerical and alphabetical calibration values is: ", sum_calibration_values)
        
        

def main():
    day_1_part_1()
    day_1_part_2()


struct ReplaceNumbers:
    """ 
    This struct is used to replace spelled out numbers with their numerical counterparts.

    I wrote it as a struct so I wouldn't have to pass the two SplitString structs around, but could have done that and wrote just a function instead.
    """
    var nums : SplitString
    var nums_strs : SplitString


    fn __init__(inout self) raises -> None:
        """Slightly ugly way of getting the data I want."""
        # Would have liked to use a dictionary here, but they are not implemented yet. 
        self.nums = SplitString("one\ntwo\nthree\nfour\nfive\nsix\nseven\neight\nnine\nzero")
        self.nums_strs = SplitString("one1one\ntwo2two\nthree3three\nfour4four\nfive5five\nsix6six\nseven7seven\neight8eight\nnine9nine\nzero0zero")
        

    fn replace_numbers(self, in_string: String) raises -> String:
        """Take a string and replace spelled out numbers with their numerical counterparts."""
        var out_string = in_string

        for i in range(self.nums.__len__()):
            out_string = out_string.replace(self.nums[i], self.nums_strs[i])

        return out_string

fn find_first_and_last_int(in_string: String) raises -> Int:
    """Take a string and return the concatenation of the first and last numbers in the string."""
    var first = -1
    var last = -1
    var joined_string = String("")

    for i in range(len(in_string)):
        
        # Check if the character is a digit. Ord turns string to char. 
        if isdigit(ord(in_string[i])):
            if first == -1:
                first = i
            last = i

    joined_string = joined_string.join(in_string[first], in_string[last])

    # Convert to Int and return.
    return atol(joined_string)

# Inspired by https://mzaks.medium.com/simple-csv-parser-in-mojo-3555c13fb5c8
struct SplitString:
    """
    Struct to basically replicate the split() function in Python.

    Takes in a long string and splits it on newlines, and allows you to index the contents.  
    """
    var orig_string: String
    var starts: DynamicVector[Int]
    var ends: DynamicVector[Int]
    

    fn __init__(inout self, owned input_string: String) -> None:
        """Initialize the containers and parse the given String."""
        self.orig_string = input_string
        self.starts = DynamicVector[Int](10)
        self.ends = DynamicVector[Int](10)
        self.parse()

    
    fn parse(inout self) -> None:
        """Parse the string and store the start and end indices of each line."""
        var start_index = 0
        var end_index = self.orig_string.find("\n")
        var search_index = 0

        while search_index != -1:
            self.starts.push_back(start_index)
            self.ends.push_back(end_index)
            start_index = end_index + 1
            search_index = self.orig_string[start_index:].find("\n")
            end_index = start_index + search_index

        # Add the last line        
        self.starts.push_back(start_index)
        self.ends.push_back(len(self.orig_string))
            
    fn __len__(self) -> Int:
        """Return the number of lines in the string."""
        return len(self.starts)

    fn __getitem__(self, index: Int) -> String:
        """Return the line at the given index."""
        return self.orig_string[self.starts[index]:self.ends[index]]
