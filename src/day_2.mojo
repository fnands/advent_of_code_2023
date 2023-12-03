"""
The SplitString struct I wrote for day one is coming in handy, so I added it a library. 

I wanted to add a __iter__ method to SplitString, but Mojo does not (yet) support Python style iterators. 
https://docs.modular.com/mojo/roadmap.html#no-python-style-generator-functions

I tried adding an iterator by manually implementing the __next__ method, but I when called it errored.
It complains about String not having an __iter__method, despite not trying to iterate over a String. 
"""


from aoc_lib.string_utils import SplitString    



def day_2_part_1() -> None:

    # Define cubte limits. This is probably a better way to define a dict in 
    # Mojo, but I this works. 
    cube_limits = SillyDict(red_limit = 12, green_limit = 13, blue_limit= 14)
    sum_possible = 0

    with open("input/day_2.txt", "r") as input_file:
        file_content = input_file.read()
        # Split string on newlines into a "List" of Strings
        string_list = SplitString(file_content)

        # Iterate over the lines of the file
        for line_index in range(string_list.__len__()):
            # Assume the game is possible, until proven otherwise
            game_possible = True
            # Split into game name and draws
            game_line = SplitString(string_list[line_index], ":")
            game_name = game_line[0]
            # Split the game into a list of draws
            game_draws = SplitString(game_line[1], ";")

            # Iterate over the draws
            for draw_index in range(game_draws.__len__()):
                # Split the draw into a list of cubes
                draw_line = SplitString(game_draws[draw_index], ",")
                
                # Iterate over the cubes
                for cube_index in range(draw_line.__len__()):
                    # Parse out the number of cubes and the colour
                    number_of_cubes = atol(draw_line[cube_index][0:3].replace(" ", ""))
                    cube_colour = draw_line[cube_index][3:].replace(" ", "")
                    # If the number of cubes is greater than the limit, the game is not possible
                    if number_of_cubes > cube_limits.get_limit(cube_colour):
                        game_possible = False

            if game_possible:
                sum_possible += atol(game_name[4:].replace(" ", ""))



    print("The sum of possible games IDs is: ", sum_possible)


def day_2_part_2() -> None:

    sum_powers = 0

    with open("input/day_2.txt", "r") as input_file:
        file_content = input_file.read()
        # Split string on newlines into a "List" of Strings
        string_list = SplitString(file_content)

        # Iterate over the lines of the file
        for line_index in range(string_list.__len__()):
            # Initialize a GamePower struct
            game_power = GamePower()
            # Split into game name and draws
            game_line = SplitString(string_list[line_index], ":")
            game_name = game_line[0]
            # Split the game into a list of draws
            game_draws = SplitString(game_line[1], ";")

            # Iterate over the draws
            for draw_index in range(game_draws.__len__()):
                # Split the draw into a list of cubes
                draw_line = SplitString(game_draws[draw_index], ",")
                
                # Iterate over the cubes
                for cube_index in range(draw_line.__len__()):
                    # Parse out the number of cubes and the colour
                    number_of_cubes = atol(draw_line[cube_index][0:3].replace(" ", ""))
                    cube_colour = draw_line[cube_index][3:].replace(" ", "")
                    # Add the cube to the GamePower struct
                    game_power.add_cube(cube_colour, number_of_cubes)

            sum_powers += game_power.get_power()



    print("The sum of game powers is : ", sum_powers)



def main():
    day_2_part_1()
    day_2_part_2()


struct SillyDict:
    var red_limit: Int
    var green_limit: Int
    var blue_limit: Int

    fn __init__(inout self, red_limit: Int, green_limit: Int, blue_limit: Int):
        self.red_limit = red_limit
        self.green_limit = green_limit
        self.blue_limit = blue_limit

    fn get_limit(self, colour: String) raises -> Int:
        """This hurts, but there is no enum/dict in Mojo yet."""
        if colour == "red":
            return self.red_limit
        elif colour == "green":
            return self.green_limit
        elif colour == "blue":
            return self.blue_limit
        else:
            print(colour)
            raise("Colour not found in SillyDict")


struct GamePower: 
    var min_red: Int
    var min_green: Int
    var min_blue: Int

    fn __init__(inout self):
        self.min_red = 0
        self.min_green = 0
        self.min_blue = 0

    fn add_cube(inout self, colour: String, number_of_cubes: Int) raises -> None:
        if colour == "red":
            if number_of_cubes > self.min_red:
                self.min_red = number_of_cubes
        elif colour == "green":
            if number_of_cubes > self.min_green:
                self.min_green = number_of_cubes
        elif colour == "blue":
            if number_of_cubes > self.min_blue:
                self.min_blue = number_of_cubes
        else:
            raise("Colour not found in GamePower")

    fn get_power(self) -> Int:
        """Calculate power."""
        return self.min_red * self.min_green * self.min_blue
