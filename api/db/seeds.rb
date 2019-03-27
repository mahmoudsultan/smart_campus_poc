# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'faker'
# # include Faker
# I18n.reload!

# seed courses
courses = ActiveSupport::JSON.decode(File.read('db/seeds/courses.json'))

courses.each do |a|
  Course.create!(a)
end


# seed course offerings
years = (2017..2019).to_a
terms = %i[fall spring summer]

years.each do |year| 
  terms.each do |term|
    Course.all.each do |course|
      offering = {:course=>course, :term=>term, :year=>year}
      CourseOffering.create!(offering)
    end
  end
end


# seed groups
CourseOffering.includes(:course).all.each do |offering|
  Group.create!(:course_offering=>offering, :name=>"group" + offering.course.title )
end


# seed buildings
buildings = ["Preparatory Building", "Electricity Building", "Mechanical Building", "SSP Building", "Administrative Building"]

buildings.each do |building|
  Building.create!(:name=>building)
end


# seed klasses
klasses = ActiveSupport::JSON.decode(File.read('db/seeds/klass.json'))
caps = [60,30]
klasses.each do |klass|
  klass[:capacity] = caps[rand(2)]
  building_offset = rand(Building.count)
  rand_build = Building.offset(building_offset).first
  klass[:building] = rand_build
  Klass.create!(klass)
end

# seed users
users = ActiveSupport::JSON.decode(File.read('db/seeds/user.json'))

users.each_with_index do |a,i|
  a[:email] = "aaaaa#{i}@gmail.com"
  a[:password] = '123456789'
  a[:role] = if rand(1)==1 then "professor" else "student" end
  User.create!(a)
end


# seed lectures
days = %i[saturday sunday monday tuesday wednesday thrusday friday]
slots = (1..9)
slot_size = (0..4)

days.each do |day|
  i = 0
  slots.step(3).each do |slot|
    Klass.all.each do |klass|
      rand_group = Group.offset(i).first
      lecture = {:course_offering=>rand_group.course_offering, :klass=>klass, :group=>rand_group, :day=>day, :start_timeslot=>slot, :end_timeslot=>slot+3}
      i+=1
      Lecture.create!(lecture)
    end
  end
end


# seed assigning of users to groups
profs = User.where(role: "professor")

Group.all.each do |g|
  prof_offset = rand(profs.all.to_a.count)
  rand_prof = profs.offset(prof_offset).first
  GroupUser.create!(:user=>rand_prof, :group=>g)
end
