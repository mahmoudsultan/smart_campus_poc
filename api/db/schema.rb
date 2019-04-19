# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_418_202_015) do
  create_table 'activity_logs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.datetime 'date'
    t.integer 'state'
    t.bigint 'klass_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['klass_id'], name: 'index_activity_logs_on_klass_id'
  end

  create_table 'admins', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'provider', default: 'email', null: false
    t.string 'uid', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.boolean 'allow_password_change', default: false
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'name'
    t.string 'nickname'
    t.string 'image'
    t.string 'email'
    t.text 'tokens'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['confirmation_token'], name: 'index_admins_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_admins_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_admins_on_reset_password_token', unique: true
    t.index %w[uid provider], name: 'index_admins_on_uid_and_provider', unique: true
  end

  create_table 'attendance_issues', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'face_box_id'
    t.bigint 'attendance_sheet_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['attendance_sheet_id'], name: 'index_attendance_issues_on_attendance_sheet_id'
    t.index ['face_box_id'], name: 'index_attendance_issues_on_face_box_id'
    t.index ['user_id'], name: 'index_attendance_issues_on_user_id'
  end

  create_table 'attendance_sheets', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.bigint 'lecture_instance_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['lecture_instance_id'], name: 'index_attendance_sheets_on_lecture_instance_id'
  end

  create_table 'buildings', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'count_logs', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.datetime 'date'
    t.integer 'count'
    t.bigint 'klass_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['klass_id'], name: 'index_count_logs_on_klass_id'
  end

  create_table 'course_offerings', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'term'
    t.integer 'year'
    t.bigint 'course_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['course_id'], name: 'index_course_offerings_on_course_id'
  end

  create_table 'courses', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'code'
    t.string 'title'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'face_boxes', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'state'
    t.string 'boundaries'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'attendance_sheet_id'
    t.bigint 'user_id'
    t.index ['attendance_sheet_id'], name: 'index_face_boxes_on_attendance_sheet_id'
    t.index ['user_id'], name: 'index_face_boxes_on_user_id'
  end

  create_table 'group_users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.bigint 'group_id'
    t.bigint 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['group_id'], name: 'index_group_users_on_group_id'
    t.index ['user_id'], name: 'index_group_users_on_user_id'
  end

  create_table 'groups', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.bigint 'course_offering_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['course_offering_id'], name: 'index_groups_on_course_offering_id'
  end

  create_table 'klass_requests', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'required_capacity'
    t.boolean 'projector'
    t.integer 'state', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'klass_id'
    t.index ['klass_id'], name: 'index_klass_requests_on_klass_id'
  end

  create_table 'klasses', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'floor'
    t.integer 'capacity'
    t.boolean 'projector'
    t.bigint 'building_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['building_id'], name: 'index_klasses_on_building_id'
  end

  create_table 'lecture_instances', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'week_number'
    t.datetime 'date'
    t.bigint 'lecture_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['lecture_id'], name: 'index_lecture_instances_on_lecture_id'
  end

  create_table 'lectures', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.integer 'start_timeslot'
    t.integer 'end_timeslot'
    t.integer 'day'
    t.bigint 'course_offering_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'klass_id'
    t.bigint 'group_id'
    t.index ['course_offering_id'], name: 'index_lectures_on_course_offering_id'
    t.index ['group_id'], name: 'index_lectures_on_group_id'
    t.index ['klass_id'], name: 'index_lectures_on_klass_id'
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'department'
    t.integer 'role'
    t.string 'provider', default: 'email', null: false
    t.string 'uid', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.boolean 'allow_password_change', default: false
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'confirmation_token'
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email'
    t.string 'nickname'
    t.string 'image'
    t.string 'email'
    t.text 'tokens'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'student_id'
    t.index ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index %w[uid provider], name: 'index_users_on_uid_and_provider', unique: true
  end

  add_foreign_key 'attendance_sheets', 'lecture_instances'
  add_foreign_key 'count_logs', 'klasses'
  add_foreign_key 'course_offerings', 'courses'
  add_foreign_key 'face_boxes', 'attendance_sheets'
  add_foreign_key 'face_boxes', 'users'
  add_foreign_key 'group_users', 'groups'
  add_foreign_key 'group_users', 'users'
  add_foreign_key 'groups', 'course_offerings'
  add_foreign_key 'klass_requests', 'klasses'
  add_foreign_key 'klasses', 'buildings'
  add_foreign_key 'lecture_instances', 'lectures'
  add_foreign_key 'lectures', 'course_offerings'
  add_foreign_key 'lectures', 'groups'
  add_foreign_key 'lectures', 'klasses'
end
