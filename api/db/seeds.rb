# frozen_string_literal: true

# seed courses
courses = ActiveSupport::JSON.decode(File.read('db/seeds/courses.json'))

puts 'Courses Being Seeded'
courses.each do |a|
  Course.create!(a)
end
puts 'Courses are created!'

# seed course offerings
years = (2017..2019).to_a
terms = %i[fall spring summer]

puts 'Years being created'
years.each do |year|
  terms.each do |term|
    Course.all.each do |course|
      offering = { course: course, term: term, year: year }
      CourseOffering.create!(offering)
    end
  end
end
puts 'Course Offerings are created! Wow !'

# seed groups
puts 'Course offerings are being created'
CourseOffering.includes(:course).all.each do |offering|
  Group.create!(course_offering: offering, name: 'group' + offering.course.title)
end

# seed buildings
buildings = ['Preparatory Building', 'Electricity Building', 'Mechanical Building', 'SSP Building', 'Administrative Building']

buildings.each do |building|
  Building.create!(name: building)
end
puts 'Course offerings and Building both are created! this is AMAZING!'

# seed klasses
klasses = ActiveSupport::JSON.decode(File.read('db/seeds/klass.json'))
caps = [60, 30]
klasses.each do |klass|
  klass[:capacity] = caps[rand(2)]
  building_offset = rand(Building.count)
  rand_build = Building.offset(building_offset).first
  klass[:building] = rand_build
  Klass.create!(klass)
end
puts 'And you know what? Klasses are created too!'

# seed users
users = ActiveSupport::JSON.decode(File.read('db/seeds/user.json'))

users.each_with_index do |a, i|
  a[:email] = "aaaaa#{i}@gmail.com"
  a[:password] = '123456789'
  a[:role] = (rand(2) == 1 ? 'professor' : 'student')
  User.create!(a)
end
puts "At this point I don't have to tell you that everything is going smooth."

# seed lectures
days = %i[saturday sunday monday tuesday wednesday thrusday friday]
slots = (1..9)
slot_size = (0..4)

days.each do |day|
  i = 0
  slots.step(3).each do |slot|
    Klass.all.each do |klass|
      rand_group = Group.offset(i).first
      lecture = { course_offering: rand_group.course_offering, klass: klass, group: rand_group, day: day, start_timeslot: slot, end_timeslot: slot + 3 }
      i += 1
      Lecture.create!(lecture)
    end
  end
end
puts 'Oh my days! Lectures... Lectures are indeed created! '

# seed lecture_instances

def rand_time(from, to = Time.now)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
  end

week_numbers = (1..14)

Lecture.all.each do |lecture|
  week_numbers.each do |week|
    lecture_date = rand_time((14 - week).days.ago)
    lecture_instance = { lecture: lecture, date: lecture_date, week_number: week }
    LectureInstance.create!(lecture_instance)
  end
end
puts 'And their lecture instances with a random period!'

# seed group_users

all_groups = Group.all

User.all.each do |user|
  offset = rand(Group.count)
  group = Group.offset(offset).first
  group_user = { group_id: group.id, user_id: user.id }
  GroupUser.create!(group_user)
end
puts 'Users enters the system, Prepare for Errors!'
puts 'This was fun... Goodbye, Visit Soon when you get stuck and need to drop the database!'