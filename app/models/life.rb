class Life < ActiveRecord::Base
  ## Validations
  validates_presence_of :name

  validates_numericality_of :width, :height, greater_than_or_equal_to: 0

  has_many :cells


  ## Attributes

  # the precentage of the life
  RANDOM_NUMBER_SEED=0.18

  # ability not to seed the game
  attr_accessor :no_seed


  ## HOOKS
  after_create :seed_cells, unless: :no_seed

  # Simulates a singe cycle of life
  # Updates the cells status based on the rules of life
  def cycle!
    cells_to_die = []
    cells_to_be_born = []
    # Iterates through all possible fields of the life surface
    width.times do |x|
      height.times do |y|
        current_cell = cells.find_cell(x,y)
        if current_cell.dead?
          #Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
          if current_cell.neighbours ==3
            cells_to_be_born << current_cell
          end
        else
          # Any live cell with two or three live neighbours lives on to the next generation.
          #no changes will be made to those cells

          # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
          if (current_cell.neighbours < 2)
            cells_to_die << current_cell
          end

          # Any live cell with more than three live neighbours dies, as if by over-population.
          if (current_cell.neighbours > 3 )
            cells_to_die << current_cell
          end
        end
      end
    end

    # kills the cells
    cells_to_die.each do |cell|
      cell.dead = true
      cell.save
    end

    # born the cell
    cells_to_be_born.each do |cell|
      cell.dead = false
      cell.save
    end
  end

  private
  def seed_cells

    width.times do |w|
      height.times do |h|
        cells.create(x: w, y: h, dead: rand > RANDOM_NUMBER_SEED)
      end
    end
  end
end
