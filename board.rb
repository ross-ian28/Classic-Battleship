class Board
    attr_accessor :cells

    def initialize()
      @cells = {}

      collumns = ["A", "B", "C", "D"]
      rows = [1, 2, 3, 4]

      rows.each do |row|
          collumns.each do |col|
            coordinate = "#{col}#{row}"
            @cells[coordinate] = Cell.new(coordinate)
          end
      end
    end

    def valid_coordinate?(coord)
        return @cells.include?(coord)
    end

    def valid_placement?(ship, coords)
        # all cords are valid
        
        coords.any? { |coord| return false if !(valid_coordinate?(coord)) }

        # cords array length should be same as ship length 
        return false if coords.length != ship.length
        
        # coords can't be diagonal
        nums = []
        letters = []
        coords.each do |coord|
           letters.push(coord[0])
           nums.push(coord[1].to_i)
        end
        return false if (nums.uniq.length != 1) && (letters.uniq.length != 1)

        # make sure cords are consecutive
        if letters.uniq.length != 1
            return false if !(letters.map(&:ord).each_cons(2).all? {|a, b| b == a + 1 })
        end

        # no ship should already exist on cell 
        coords.each do |coord|
            return false unless @cells[coord].empty?
        end
          
        return true
    end

    def place(ship, coords)
        return false if !(valid_placement?(ship, coords))

        coords.map do |coord|
            return false if !(valid_coordinate?(coord))
            # find cell from coord
            cell = @cells.select {|cell| cell == coord }
            # if valid placement then cell.place ship
            cell[coord].place_ship(ship)
        end
    end

    def render(display = false)
        header = "  1 2 3 4 \n"
        rowA = "A #{cells["A1"].render(display)} #{cells["A2"].render(display)} #{cells["A3"].render(display)} #{cells["A4"].render(display)}\n"
        rowB = "B #{cells["B1"].render(display)} #{cells["B2"].render(display)} #{cells["B3"].render(display)} #{cells["B4"].render(display)}\n"
        rowC = "C #{cells["C1"].render(display)} #{cells["C2"].render(display)} #{cells["C3"].render(display)} #{cells["C4"].render(display)}\n"
        rowD = "D #{cells["D1"].render(display)} #{cells["D2"].render(display)} #{cells["D3"].render(display)} #{cells["D4"].render(display)}\n"
        return header + rowA + rowB + rowC + rowD
    end

    def all_ships_sunk?
        ships = []

        @cells.values.each do |cell|
            ships << cell.ship if cell.ship

            ships.uniq.all? { |ship| ship.sunk? }
        end
    end
  end

