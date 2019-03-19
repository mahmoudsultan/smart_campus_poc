# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
include Faker

15.times do
    Course.create!(
        title: Faker::Name.title,
        code: Faker::Code.code
    )
    CourseOffering.create!(
        term: Faker::Number.term,
        year: Faker::Number.year
    )
    Group.create!(
        name: Faker::Name.name
    )
    User.create!(
        name: Faker::Name.name,
        department: Faker::Name.department
    )
    Lecture.create!(
        day: Faker::Number.day,
        start_timeslot: Faker::Number.start_timeslot,
        end_timeslot: Faker::Number.end_timeslot
    )
    Klass.create!(
        name: Faker::Name.name,
        floor: Faker::Number.floor(1)
        capacity: Faker::Number.capacity,
        projector: Faker::Boolean.projector
    )
end