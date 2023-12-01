from python import Python
from python import PythonObject

def day_1_part_1():

    with open("input/day_1.txt", "r") as input_file:
        file_content = input_file.read()
        string_list = SplitString(file_content)
        size = string_list.__len__()
        sum_calibration_values = 0

        for i in range(size):
            sum_calibration_values += find_first_and_last_int(string_list[i])

        print("The sum of numerical calibration values is: ", sum_calibration_values)



def day_1_part_2():

    with open("input/day_1.txt", "r") as input_file:
        file_content = input_file.read()
        string_list = SplitString(file_content)
        size = string_list.__len__()
        sum_calibration_values = 0

        replace_numbers = ReplaceNumbers()

        for i in range(size):
            fixed_string = replace_numbers.replace_numbers(string_list[i])
            sum_calibration_values += find_first_and_last_int(fixed_string)

        print("The sum of numerical calibration values is: ", sum_calibration_values)
        
        

def main():
    day_1_part_1()
    day_1_part_2()


struct ReplaceNumbers:
    var nums : PythonObject
    var nums_strs : PythonObject
    var builtins: PythonObject

    fn __init__(inout self) raises -> None:
        # Would have liked to use a dictionary here, but they are not implemented yet
        self.builtins = Python.import_module("builtins")
        self.nums = self.builtins.list(["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "zero"])
        self.nums_strs = self.builtins.list(["one1one", "two2two", "three3three", "four4four", "five5five", "six6six", "seven7seven", "eight8eight", "nine9nine", "zero0zero"])
        

    fn replace_numbers(self, in_string: String) raises -> String:
        var out_string = in_string

        for i in range(self.nums.__len__()):
            out_string = out_string.replace(self.nums[i].to_string(), self.nums_strs[i].to_string())

        return out_string

fn find_first_and_last_int(in_string: String) raises -> Int:
    var first = -1
    var last = -1
    var joined_string = String("")

    for i in range(len(in_string)):
        
        if isdigit(ord(in_string[i])):
            if first == -1:
                first = i
            last = i

    joined_string = joined_string.join(in_string[first], in_string[last])

    return atol(joined_string)

# Inspired by https://mzaks.medium.com/simple-csv-parser-in-mojo-3555c13fb5c8
struct SplitString:
    var orig_string: String
    var starts: DynamicVector[Int]
    var ends: DynamicVector[Int]
    

    fn __init__(inout self, owned input_string: String):
        self.orig_string = input_string
        self.starts = DynamicVector[Int](10)
        self.ends = DynamicVector[Int](10)
        self.parse()

    
    fn parse(inout self):
        var start_index = 0
        var end_index = self.orig_string.find("\n")
        var search_index = 0

        while search_index != -1:
            self.starts.push_back(start_index)
            self.ends.push_back(end_index)
            start_index = end_index + 1
            search_index = self.orig_string[start_index:].find("\n")
            end_index = start_index + search_index
        
        self.starts.push_back(start_index)
        self.ends.push_back(len(self.orig_string))
            
    fn __len__(self) -> Int:
        return len(self.starts)

    fn __getitem__(self, index: Int) -> String:
        return self.orig_string[self.starts[index]:self.ends[index]]
