class Post < ApplicationRecord
  has_many :elements

  # Overrides find method for better urls
  def self.find(id)
    find_by!(created: id)
  end

  # Overrides the main param for better urls
  def to_param
    created
  end
end
