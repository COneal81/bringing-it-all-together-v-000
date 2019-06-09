class Dog 
  attr_accessor :id, :name, :breed 
  
  def initialize(attributes)
    attributes.each {|key,value| self.send(("#{key}="), value)}
    self.id ||= nil
  end
    
  def self.create_table
    sql=<<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL 
      DROP TABLE dogs
    SQL
    DB[:conn].execute(sql)
  end
  
  def save
    sql= <<-SQL 
      INSERT INTO dogs(name,breed)
      VALUES(?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    self
  end
  
  def self.create(hash_of_attributes)
    dog = Dog.new(hash_of_attributes)
    dog.save
    dog
  end
  
  def self.find_by_id(num)
    sql= <<-SQL
      SELECT * FROM dogs 
      WHERE num = ?
    SQL
    DB[:conn].execute(sql, id).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?, breed = ?")
      if !dog.empty?
        dog_data = dog[0]
        dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
      else
        dog = self.create()
  end
end 