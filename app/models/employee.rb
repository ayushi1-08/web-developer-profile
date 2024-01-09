class Employee < ApplicationRecord
	validates_presence_of :employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary
	validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
	validates :phone_number, length: { maximum: 10 }, format: { with: /\A\d{1,10}\z/ }
end
