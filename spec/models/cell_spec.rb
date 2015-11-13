require 'rails_helper'

RSpec.describe Cell, type: :model do
  let(:life){
    life= Life.new(name:"test", width: 3, height: 3)
    life.no_seed = true
    life
  }
  context "#neighbors" do
    it "should have 1 neighbor" do
      cell1 = Cell.create(x:1, y:1, dead: false, life: life)
      cell2 = Cell.create(x:0, y:1, dead: false, life: life)

      expect(cell1.neighbours).to be 1
    end

    it "should have 8 neighbor" do
      cell00 = Cell.create(x:0, y:0, dead: false, life: life)
      cell01 = Cell.create(x:0, y:1, dead: false, life: life)
      cell02 = Cell.create(x:0, y:2, dead: false, life: life)

      cell10 = Cell.create(x:1, y:0, dead: false, life: life)
      cell11 = Cell.create(x:1, y:1, dead: false, life: life)
      cell12 = Cell.create(x:1, y:2, dead: false, life: life)

      cell20 = Cell.create(x:2, y:0, dead: false, life: life)
      cell21 = Cell.create(x:2, y:1, dead: false, life: life)
      cell22 = Cell.create(x:2, y:2, dead: false, life: life)


      expect(cell11.neighbours).to be 8
      expect(cell00.neighbours).to be 3
    end
  end

  context "utility methods" do
    it "#find_cell" do
      cell1 = Cell.create(x:0, y:0, dead: false, life: life)
      expect(Cell.find_cell(0,0)).to eq(cell1)
    end

    it "#find_cell should raise an error if nothing is found" do
      cell1 = Cell.create(x:0, y:0, dead: false, life: life)
      expect { Cell.find_cell(1,0) }.to raise_error(ArgumentError)
    end
  end

  context "validations" do

    it "should only create cell in life params" do
      cell1 = Cell.new(x:10, y:0, life: life)
      cell2 = Cell.new(x:0, y:10, life: life)
      cell3 = Cell.new(x:10, y:10, life: life)
      expect(cell1.save).to be false
      expect(cell2.save).to be false
      expect(cell3.save).to be false
    end

    it "should prevent creating of a cell on the same location" do
      cell1 = Cell.create(x:0, y:1, life: life)
      cell2 = Cell.new(x:0, y:1, life: life)

      expect(cell2.save).to be false
    end
  end
end
