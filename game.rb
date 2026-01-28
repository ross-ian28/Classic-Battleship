
require './board'
require './cell'
require './ship'
class Game
    attr_accessor :computer_board, :player_board

    def initialize()
        @computer_board = Board.new()
        @player_board = Board.new()
        game_start()

    end

    def game_start()
        print "Welcome to BATTLESHIP\n"
        print "Enter p to play. Enter q to quit.\n"
        play_option = gets.chomp

        if play_option == "p" 
            main_game()
        elsif play_option == "q"
            exit
        else
            game_start()
        end
    end

    def main_game()
        # player and computer place ships
        setup(@computer_board, @player_board)

        # start loop of player fires then computer fires 
        game_loop(@computer_board, @player_board)
    end

    def setup(computer_board, player_board)
        # computer places ships
        place_cruiser(computer_board)
        place_submarine(computer_board)

        # players places ships
        print "I have laid out my ships on the grid. \nYou now need to lay out your two ships..\n"
        print "The Cruiser is three units long and the Submarine is two units long.\n"
        print player_board.render(true)

        print "Enter the squares for the Cruiser (3 spaces):\n"
        player_place_cruiser(player_board)

        print "Enter the squares for the Submarine (2 spaces):\n"
        player_place_submarine(player_board)
    end

    def place_cruiser(computer_board)
        # generate a 3 length cruiser 
        cruiser = Ship.new("Cruiser", 3)
        array_of_cells= ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
        random_coord = rand(15)
        initial_cell = array_of_cells[random_coord] 
        # generate direction (vertical, horizontal)
        fifty_fifty_chance = rand(1..2)
        if (fifty_fifty_chance == 1)
            #vertical
            second_cell = "#{initial_cell[0]}#{initial_cell[1].to_i + 1}"
            third_cell = "#{initial_cell[0]}#{initial_cell[1].to_i + 2}"
            coord_placement = [initial_cell, second_cell, third_cell]
        else 
            #horizontal
            # if horizontal create two more objects with ordinal values + 1 and + 2 then reverted back to string value from ordinal
            second_letter = initial_cell[0].ord.to_i + 1
            third_letter = initial_cell[0].ord.to_i + 2
            second_cell = "#{second_letter.chr}#{initial_cell[1]}"
            third_cell = "#{third_letter.chr}#{initial_cell[1]}"
            coord_placement = [initial_cell, second_cell, third_cell]
        end

        # validate coordinate if false choose new coordinate and direction
        if computer_board.valid_placement?(cruiser, coord_placement)
            # if true, place ship and continue to submarine 
            computer_board.place(cruiser, coord_placement)
        else
            place_cruiser(computer_board)
        end
    end

    def place_submarine(computer_board)
        # generate a 3 length cruiser 
        submarine = Ship.new("Submarine", 2)
        array_of_cells= ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
        random_coord = rand(15)
        initial_cell = array_of_cells[random_coord] 
        # generate direction (vertical, horizontal)
        fifty_fifty_chance = rand(1..2)
        if (fifty_fifty_chance == 1)
            #vertical
            second_cell = "#{initial_cell[0]}#{initial_cell[1].to_i + 1}"
            coord_placement = [initial_cell, second_cell]
        else 
            #horizontal
            # if horizontal create two more objects with ordinal values + 1 and + 2 then reverted back to string value from ordinal
            second_letter = initial_cell[0].ord.to_i + 1
            second_cell = "#{second_letter.chr}#{initial_cell[1]}"
            coord_placement = [initial_cell, second_cell]
        end

        # validate coordinate if false choose new coordinate and direction
        if computer_board.valid_placement?(submarine, coord_placement)
            # if true, place ship and continue to submarine 
            computer_board.place(submarine, coord_placement)
        else
            place_submarine(computer_board)
        end
    end

    def player_place_cruiser(player_board)
        cruiser = Ship.new("Cruiser", 3)

        cruiser_coordinates = gets.chomp.split

        if player_board.valid_placement?(cruiser, cruiser_coordinates)
            player_board.place(cruiser, cruiser_coordinates)
            print player_board.render(true)
        else
            print "Those are invalid coordinates. Please try again:\n"
            player_place_cruiser(player_board)
        end
    end

    def player_place_submarine(player_board)
        submarine = Ship.new("Submarine", 2)

        submarine_coordinates = gets.chomp.split

        if player_board.valid_placement?(submarine, submarine_coordinates)
            player_board.place(submarine, submarine_coordinates)
            print player_board.render(true)
        else
            print "Those are invalid coordinates. Please try again:\n"
            player_place_cruiser(player_board)
        end
    end


    def game_loop(computer_board, player_board)
        # display both boards
        print "=============COMPUTER BOARD=============\n"
        print computer_board.render()
        print "==============PLAYER BOARD==============\n"
        print player_board.render(true)

        # player choose coordinate to fire one
        print "Enter the coordinate for your shot:\n"
        loop do 
            player_coordinate = gets.chomp

            if !computer_board.valid_coordinate?(player_coordinate)
                print "Please enter a valid coordinate:\n"
                next
            end

            if computer_board.cells[player_coordinate].fired_upon?
                print "You already fired on that coordinate. Try again:\n"
                next
            end

            if computer_board.valid_coordinate?(player_coordinate)
                computer_board.cells[player_coordinate].fire_upon
                if computer_board.cells[player_coordinate].empty?
                    print "Your shot on #{player_coordinate} was a miss.\n"
                else 
                    print "Your shot on #{player_coordinate} was a hit.\n"
                end
                break
            end
        end

        # computer choose coordinate
        loop do 
            array_of_cells= ["A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4", "C1", "C2", "C3", "C4", "D1", "D2", "D3", "D4"]
            random_coord = rand(15)
            computer_coordinate = array_of_cells[random_coord]

            if !player_board.valid_coordinate?(computer_coordinate)
                print "Please enter a valid coordinate:\n"
                next
            end

            if player_board.cells[computer_coordinate].fired_upon?
                print "You already fired on that coordinate. Try again:\n"
                next
            end

            if player_board.valid_coordinate?(computer_coordinate)
                player_board.cells[computer_coordinate].fire_upon
                if player_board.cells[computer_coordinate].empty?
                    print "My shot on #{computer_coordinate} was a miss.\n"
                else 
                    print "My shot on #{computer_coordinate} was a hit.\n"
                end
                break
            end
        end

        if computer_board.all_ships_sunk?
            puts "You won! Press Enter to Continue\n"
            pause = gets.chomp
            #reset player and computer board
            game_start()
        elsif player_board.all_ships_sunk?
            puts "I won! Press Enter to Continue\n"
            #reset player and computer board
            game_start()
        end
        game_loop(computer_board, player_board)
    end
end

Game.new

# When submarine coordinates are invalid, valid ones don't work