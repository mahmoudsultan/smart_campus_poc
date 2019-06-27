# # frozen_string_literal: true
# require 'net/http'
# # seed courses
# courses = ActiveSupport::JSON.decode(File.read('db/seeds/courses.json'))

# puts 'Courses Being Seeded'
# courses.each do |a|
#   Course.create!(a)
# end
# puts 'Courses are created!'

# # seed course offerings
# years = (2017..2019).to_a
# terms = %i[fall spring summer]

# puts 'Years being created'
# years.each do |year|
#   terms.each do |term|
#     Course.all.each do |course|
#       offering = { course: course, term: term, year: year }
#       CourseOffering.create!(offering)
#     end
#   end
# end
# puts 'Course Offerings are created! Wow !'

# # seed groups
# puts 'Course offerings are being created'
# CourseOffering.includes(:course).all.each do |offering|
#   Group.create!(course_offering: offering, name: 'group' + offering.course.title)
# end

# # seed buildings
# buildings = ['Preparatory Building', 'Electricity Building', 'Mechanical Building', 'SSP Building', 'Administrative Building', 'Hogwarts']

# buildings.each do |building|
#   Building.create!(name: building)
# end
# puts 'Course offerings and Building both are created! this is AMAZING!'

# # seed klasses
# klasses = ActiveSupport::JSON.decode(File.read('db/seeds/klass.json'))
# caps = [60, 30]
# klasses.each do |klass|
#   klass[:capacity] = caps[rand(2)]
#   building_offset = rand(Building.count)
#   rand_build = Building.offset(building_offset).first
#   klass[:building] = rand_build
#   Klass.create!(klass)
# end

# # seed klass_topic_maps
# topic_name = 'vid1'
# Klass.all.each do |klass|
#   KlassTopicMap.create!(klass_id: klass.id, topic: topic_name)
# end

# puts 'And you know what? Klasses are created too!'

# # seed users
# users = ActiveSupport::JSON.decode(File.read('db/seeds/user.json'))
# student_id=0
# users.each_with_index do |a, i|
#   a[:email] = "aaaaa#{i}@gmail.com"
#   a[:password] = '123456789'
#   a[:role] = (rand(2) == 1 ? 'professor' : 'student')
#   if a[:role] == 'student'
#     a[:student_id] = student_id
#     student_id+=1
#   end
#   User.create!(a)
# end
# puts "At this point I don't have to tell you that everything is going smooth."

# # seed lectures
# days = %i[saturday sunday monday tuesday wednesday thrusday friday]
# slots = (1..9)
# slot_size = (0..4) 

# days.each do |day|
#   i = 0
#   slots.step(3).each do |slot|
#     Klass.all.each do |klass|
#       rand_group = Group.offset(i).first
#       lecture = { course_offering: rand_group.course_offering, klass: klass, group: rand_group, day: day, start_timeslot: slot, end_timeslot: slot + 3 }
#       i += 1
#       Lecture.create!(lecture)
#     end
#   end
# end
# puts 'Oh my days! Lectures... Lectures are indeed created! '

# # seed lecture_instances

def rand_time(from, to = Time.now)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
  rand * (to - from) + from
end

# week_numbers = (1..7)

# Lecture.all.each do |lecture|
#   week_numbers.each do |week|
#     lecture_date = rand_time((7 - week).weeks.ago)
#     lecture_instance = { lecture: lecture, date: lecture_date, week_number: week }
#     LectureInstance.create!(lecture_instance)
#   end
# end
# puts 'And their lecture instances with a random period!'

# # seed group_users

# all_groups = Group.all

# User.all.each do |user|
#   offset = rand(Group.count)
#   group = Group.offset(offset).first
#   group_user = { group_id: group.id, user_id: user.id }
#   GroupUser.create!(group_user)
# end
# puts 'Users enters the system, Prepare for Errors!'

# puts 'And here we seed some faceboxes'
# # seed attendance sheets
# states = %i[recognized detected alleged]
# LectureInstance.all.each do |inst|
#   users = LectureInstance.joins({lecture: {group: {group_users: :user}}}).where(id: inst.id,users: {role: User.roles[:student]}).select('users.id')
#   sheet = AttendanceSheet.create(lecture_instance_id: inst.id)
#   users.each do |user|
#     FaceBox.create!(user_id: user.id, attendance_sheet:sheet, state:states.sample, boundaries: '(1,1)')
#   end
# end
# puts 'This was fun... Goodbye, Visit Soon when you get stuck and need to drop the database!'


# For Demo's Sake
# Lecture.transaction do 
#   a = {}
#   a[:email] = "professor0@gmail.com"
#   a[:password] = '123456789'
#   a[:role] = 'professor'
#   a[:department] = "Magic"
#   a[:name] = "Dumbeldore"
#   prof = User.create!(a)

#   course = Course.create!(title: "Defense Against The Dark Arts", code: "CC490N")

#   years = (2017..2019).to_a
#   terms = %i[fall spring summer]
#   years.each do |year|
#     terms.each do |term|
#       offering = { course: course, term: term, year: year }
#       CourseOffering.create!(offering)
#     end
#   end


#   days = %i[saturday sunday monday tuesday wednesday thrusday friday]
#   slots = (1..9)
#   slot_size = (0..4) 

#   groups = CourseOffering.includes(:course).all.map do |offering|
#     Group.create!(course_offering: offering, name: 'group' + offering.course.title)
#   end

#   students_names = ['magdy', 'ezz', 'aly', 'amr', 'taw2am', 'nada', 'rana', 'menna', 'fatma']

#   students = students_names.map do |student|
#     a = {}
#     a[:email] = student + '@gmail.com'
#     a[:password] = '123456789'
#     a[:role] = 'student'
#     a[:department] = "Computer"
#     a[:name] = student
#     a[:student_id] = student
#     User.create!(a)
#   end

# building = Building.where(name: "Hogwarts")[0]
# klass = Klass.create({name: "Great Hall", floor: 0, capacity: 1000, projector: true, building_id: building.id})
# KlassTopicMap.create!(klass_id: klass.id, topic: 'vid1')
#   groups.each do |group|
#     group_user = { group_id: group.id, user_id: prof.id }
#     GroupUser.create!(group_user)
#     students.each do |student|
#       group_user = { group_id: group.id, user_id: student.id }
#       GroupUser.create!(group_user)
#     end
#   end

#   lectures = []
#   week_numbers = (1..7)

#   days.each do |day|
#     i = 0
#     slots.step(3).each do |slot|
#       groups.each do |group|
#         rand_group = group
#         lecture = { course_offering: rand_group.course_offering, klass: klass, group: rand_group, day: day, start_timeslot: slot, end_timeslot: slot + 3 }
#         i += 1
#         lectures << Lecture.create!(lecture)
#       end
#     end
#   end

#   lectures.each do |lecture|
#     week_numbers.each do |week|
#       lecture_date = rand_time((7 - week).days.ago)
#       lecture_instance = { lecture: lecture, date: lecture_date, week_number: week }
#       LectureInstance.create!(lecture_instance)
#     end
#   end
# end


# names = ['amr', 'ezz', 'fatma', 'magdy', 'menna', 'nada', 'rana', 'aly', 'taw2am']
# names.each do |name|
  
#   id = User.where(student_id: name).ids[0]
#   image_encoded = Base64.encode64(File.read(Rails.root.join('db/seeds/' + name + '.jpg')))
#   image_encoded = "data:image/jpeg;base64," + image_encoded
  
#   uri= URI('http://localhost:3000/users/' + id.to_s + '/image')
  
#   http = Net::HTTP.new(uri.host, uri.port)
#   req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
  
#   req.body = {image: image_encoded}.to_json
#   res = http.request(req)

#   puts "response #{res.body}"
  
# end

