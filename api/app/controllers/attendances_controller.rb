class AttendancesController < ApplicationController

    def get
        results = Attendance::GetAttendanceService.new(params).execute
        render json: results.body
    end

end
