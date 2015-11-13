class Cell < ActiveRecord::Base
  belongs_to :life

  validates_uniqueness_of :x, scope: [:life_id, :y]

  validate :x_inside_life
  validate :y_inside_life

  ## SCOPES
  scope :alive, -> {
    where(dead: false)
  }
  scope :find_cell_scope, -> (x,y){
      where(x: x, y: y)
  }
  scope :get_neighbours, -> (x,y,id){
      where("x >= ? && x <= ? && y >= ? && y <= ? && id !=? ", x-1, x+1, y-1, y+1, id )
  }

  def self.find_cell(x,y)
    cell_scope = find_cell_scope(x,y)
    if cell_scope.length > 1
      raise StandardError.new "more then one cell was found at #{x}, #{y}"
    end

    cell = cell_scope.first
    if cell.nil?
      raise ArgumentError.new "cound not find cell at #{x}, #{y}"
    end

    cell
  end


  # Returns the amount of a live cells neighbors current cell
  # @return [Fixnum] number of cells that are neighbors
  def neighbours
    # a query that limits the cells to a box around the cell and removes itself from that box
    life.cells.alive.get_neighbours(x,y, self.id).count
  end


  private
  def x_inside_life
    if x > life.width
      self.errors[:x] << "X is outside of lifes width"
    end
  end

  def y_inside_life
    if y > life.width
      self.errors[:y] << "Y is outside of lifes height"
    end
  end
end
