class Favorite
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents ||= Hash.new
  end

  def total_count
    @contents.values.sum
  end

  def add_pet(id)
    @contents[id.to_s] = count_of(id) + 1
  end

  def count_of(id)
    @contents[id.to_s].to_i
  end

  def favorite_pets #{pet.id => 1} ....use id to find pet object
    @contents.keys.map do |id|
      Pet.find(id)
    end
  end
end
