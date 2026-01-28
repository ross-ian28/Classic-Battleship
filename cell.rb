class Cell
    attr_accessor :coordinate, :ship

    def initialize(coordinate)
      @coordinate = coordinate
      @ship = nil
      @fired_upon = false
    end

    def empty?
        @ship.nil?
    end

    def place_ship(ship)
        @ship = ship
    end

    def fired_upon?
        @fired_upon
    end
      
    def fire_upon
        @fired_upon = true
        @ship.hit if @ship
    end

    def render(show_cell = false)
        if !fired_upon?
            return "S" if show_cell && !empty? 
            return "."
        end
        if empty?
            return "M"
        elsif @ship.sunk?
            return "X"
        else 
            return "H"
        end
    end
  end

