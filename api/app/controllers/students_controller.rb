# frozen_string_literal: true

class StudentsController < ApplicationController
  before_action :set_student, only: %i[show update destroy]

  # GET /students
  def index
    @students = User.student.all

    render json: @students
  end

  # GET /students/1
  def show
    render json: @student
  end

  # POST /students
  def create
    @student = User.student.new(student_params)

    if @student.save
      render json: @student, status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student =  if params[:id]
      User.student.find(params[:id])
    elsif params[:student_id]
      User.student.find_by student_id: params[:student_id]
    end
  end

  # Only allow a trusted parameter "white list" through.
  def student_params
    params.require(:student).permit(%i[name email department student_id password])
  end
end
