require 'rails_helper'

RSpec.describe Life, type: :model do
 context "initialization" do
   let(:valid_attributes) {
     {
         name: "test",
         width: 10,
         height: 10
     }
   }
   it "should create a cells when object is created" do
     life = Life.create! valid_attributes
     #creates a cell for each point in a matrix
     expect(life.cells.count).to be(100)
   end
 end
  context "cycle" do
    let(:life) {
      life= Life.new(name:"test", width: 3, height: 3)
      life.no_seed = true
      life.save
      life
    }
    let(:life_2x2) {
      life= Life.new(name:"test", width: 2, height: 2)
      life.no_seed = true
      life.save
      life
    }
    it "Any live cell with fewer than two live neighbours dies, as if caused by under-population." do
      life_2x2.cells.create(x: 0, y: 0, dead: false)
      life_2x2.cells.create(x: 0, y: 1, dead: true)
      life_2x2.cells.create(x: 1, y: 0, dead: true)
      life_2x2.cells.create(x: 1, y: 1, dead: true)
      life_2x2.cycle!
      expect(life_2x2.cells.alive).to be_empty
    end

    it "Any live cell with two or three live neighbours lives on to the next generation." do
      life_2x2.cells.create(x: 0, y: 0, dead: false)
      life_2x2.cells.create(x: 0, y: 1, dead: false)
      life_2x2.cells.create(x: 1, y: 0, dead: false)
      life_2x2.cells.create(x: 1, y: 1, dead: false)
      life_2x2.cycle!
      expect(life_2x2.cells.alive.length).to eq 4
    end

    it "Any live cell with more than three live neighbours dies, as if by over-population." do
      life.cells.create(x: 0, y: 0, dead: false)
      life.cells.create(x: 0, y: 1, dead: false)
      life.cells.create(x: 0, y: 2, dead: false)

      life.cells.create(x: 1, y: 0, dead: false)
      life.cells.create(x: 1, y: 1, dead: false)
      life.cells.create(x: 1, y: 2, dead: false)

      life.cells.create(x: 2, y: 0, dead: false)
      life.cells.create(x: 2, y: 1, dead: false)
      life.cells.create(x: 2, y: 2, dead: false)

      life.cycle!

      expect(life.cells.alive.length).to eq 4

      expect(life.cells.find_cell(0,0).dead?).to be false
      expect(life.cells.find_cell(0,2).dead?).to be false
      expect(life.cells.find_cell(2,0).dead?).to be false
      expect(life.cells.find_cell(2,2).dead?).to be false


      expect(life.cells.find_cell(1,1).dead?).to be true
      expect(life.cells.find_cell(0,1).dead?).to be true
      expect(life.cells.find_cell(1,0).dead?).to be true
      expect(life.cells.find_cell(1,2).dead?).to be true
      expect(life.cells.find_cell(2,1).dead?).to be true

    end

    it "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do
      life_2x2.cells.create(x: 0, y: 0, dead: false)
      life_2x2.cells.create(x: 0, y: 1, dead: false)
      life_2x2.cells.create(x: 1, y: 0, dead: false)
      life_2x2.cells.create(x: 1, y: 1, dead: true)

      life_2x2.cycle!

      expect(life_2x2.cells.alive.length).to eq 4
    end
  end
end
