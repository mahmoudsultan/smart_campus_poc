class AttendancesController < ApplicationController

    def get
        results = Attendance::GetAttendanceService.new(params).execute
        results
    end

end
