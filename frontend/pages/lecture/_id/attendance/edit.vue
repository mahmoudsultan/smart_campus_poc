<template>
  <div>
    <v-breadcrumbs :items="breadCrumbItems" divider=" > "></v-breadcrumbs>
    <v-card>
      <v-container grid-list-xs>
        <v-layout row wrap>
          <v-flex xs12 justify-center>
            <v-progress-circular
              v-if="loading || updateRequestLoading"
              :size="50"
              color="primary"
              indeterminate
            ></v-progress-circular>
          </v-flex>
        </v-layout>
        <attendance-wizard
          v-if="!loading"
          editMode
          :image="this.image"
          :faceBoxes="this.faceBoxes"
          :students="this.studentsInfoObj"
          @save="confirmAttendanceSheetEdit"
        />
        </v-container>
    </v-card>
  </div>
</template>

<script>
import _ from 'lodash'
import AttendanceWizard from '@/components/attendance/AttendanceWizard'

export default {
  components: {
    AttendanceWizard
  },
  data() {
    return {
      breadCrumbItems: [
        {
          text: 'Dashboard',
          href: '/'
        },
        {
          text: 'Lecture Week #3',
          href: this.lectureHref
        },
        {
          text: 'Edit Attendance Sheet',
          disabled: true
        }
      ],
      loading: true,
      updateRequestLoading: false,
      image: '',
      faceBoxes: [],
      studentsInfoObj: {}
    }
  },
  methods: {
    confirmAttendanceSheetEdit(faceBoxes, deletedFaceBoxes) {
      // Filter new and edited faceBoxes using faceBox.id
      const newFaceBoxes = _.filter(faceBoxes, (faceBox) => { return !faceBox.id })
      const editedFaceBoxes = _.filter(faceBoxes, (faceBox) => { return faceBox.id })

      this.updateRequestLoading = true

      this.$axios.post('attendance/update', {
        lecture_instance_id: this.$route.params.id,
        new_face_boxes: newFaceBoxes,
        edited_face_boxes: editedFaceBoxes,
        deleted_face_boxes: deletedFaceBoxes
      }).then(() => {
        console.log('Hello World') // eslint-disable-line
        this.updateRequestLoading = false
      }).catch((err) => {
        console.log(err) // eslint-disable-line
      })
    }
  },
  mounted: async function () {
    const attendanceSheetRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_sheet`)
    const studentsInfoRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/students`)

    await Promise.all([attendanceSheetRequest, studentsInfoRequest]).then(([attendanceSheetRequestResponse, studentsInfoResponse]) => {
      /*
        Parse students data to the form:
        student_id: {
          id: '',
          name: '',
          student_id: '',
          image: 'full url'
        }
      */
      this.image = this.$axios.defaults.baseURL + attendanceSheetRequestResponse.data.image.url
      this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes

      const studentsInfo = _.each(studentsInfoResponse.data, (studentInfo) => {
        studentInfo.image = this.$axios.defaults.baseURL + studentInfo.image.url
      })
      const studentIds = _.map(studentsInfo, (studentInfo) => {
        return studentInfo.student_id
      })

      this.studentsInfoObj = _.zipObject(studentIds, studentsInfo)

      this.loading = false
    }).catch((err) => {
      console.error(err) // eslint-disable-line
    })
  }
}
</script>

<style scoped>

</style>
