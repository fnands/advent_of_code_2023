
# Inspired by https://mzaks.medium.com/simple-csv-parser-in-mojo-3555c13fb5c8
struct SplitString:
    """
    Struct to basically replicate the split() function in Python.

    Takes in a long string and splits it on newlines, and allows you to index the contents.
    """

    var orig_string: String
    var starts: DynamicVector[Int]
    var ends: DynamicVector[Int]
    var separator: String
    var pos: Int


    fn __init__(inout self, owned input_string: String, separator: String="\n") -> None:
        """Initialize the containers and parse the given String."""
        self.orig_string = input_string
        self.separator = separator
        self.starts = DynamicVector[Int](10)
        self.ends = DynamicVector[Int](10)
        self.pos = 0
        self.parse()
        

    fn parse(inout self) -> None:
        """Parse the string and store the start and end indices of each line."""

        if self.orig_string.count(self.separator) == 0:
            self.starts.push_back(0)
            self.ends.push_back(len(self.orig_string))
            return

        var start_index = 0
        var end_index = self.orig_string.find(self.separator)
        var search_index = 0

        while search_index != -1:           
            self.starts.push_back(start_index)
            self.ends.push_back(end_index)
            start_index = end_index + 1
            search_index = self.orig_string[start_index:].find(self.separator)
            end_index = start_index + search_index

        # Add the last line
        self.starts.push_back(start_index)
        self.ends.push_back(len(self.orig_string))

    fn __len__(self) -> Int:
        """Return the number of lines in the string."""
        return len(self.starts)

    fn __getitem__(self, index: Int) -> String:
        """Return the line at the given index."""
        return self.orig_string[self.starts[index] : self.ends[index]]

    fn __next__(inout self) raises -> String:
        """Yield the next string in the list"""
        if self.pos < self.__len__():
            self.pos += 1
            return self.__getitem__(self.pos - 1)
        else:
            raise Error("No more lines in the string.")

    fn __iter__(inout self) raises -> String:
        """Yield the next string in the list"""
        if self.pos < self.__len__():
            return self.__next__()
        else:
            raise Error("No more lines in the string.")
