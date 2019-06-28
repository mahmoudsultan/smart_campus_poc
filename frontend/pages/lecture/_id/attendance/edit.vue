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
          <v-alert xs12 type="success" :value="showUpdatedMessage">
            Attendance Sheet updated successfully!
          </v-alert>
        </v-layout>
        <v-tabs
          centered
          color="primary"
          dark
          icons-and-text
          @change="updateEditTab"
        >
          <v-tabs-slider color="yellow"></v-tabs-slider>
          <v-tab href="#tab-1" @click="tab = 1">
            Edit
            <v-icon>edit</v-icon>
          </v-tab>

          <v-tab href="#tab-2" @click="tab = 2">
            Issues
            <v-badge color="info">
              <span slot="badge" dark>{{ numberOfIssues }}</span> <!--slot can be any component-->
              <v-icon>warning</v-icon>
            </v-badge>
          </v-tab>

          <v-tab-item value="tab-1">
            <attendance-wizard
              v-if="!loading && tab === 1"
              editMode
              :image="this.image"
              :faceBoxes="this.faceBoxes"
              :students="this.studentsInfoObj"
              @save="confirmAttendanceSheetEdit"
            />
          </v-tab-item>

          <v-tab-item value="tab-2">
            <issues-wizard
              v-if="!loading && tab === 2"
              :image="image"
              :students="studentsInfoObj"
              :issues="issues"
              @updatecount="updateIssuesCount"
            />
          </v-tab-item>
        </v-tabs>
        </v-container>
    </v-card>
  </div>
</template>

<script>
import _ from 'lodash'
import AttendanceWizard from '@/components/attendance/AttendanceWizard'
import IssuesWizard from '@/components/attendance/IssuesWizard'

export default {
  components: {
    AttendanceWizard,
    IssuesWizard
  },
  data() {
    return {
      loading: true,
      updateRequestLoading: false,
      image: '',
      faceBoxes: [],
      studentsInfoObj: {},
      issues: [],
      tab: 1,
      numberOfIssues: 0,
      lectureWeek: 0,
      lectureInstance: null,
      lectureId: 0,
      showUpdatedMessage: false
    }
  },
  computed: {
    breadCrumbItems() {
      return [
        {
          text: 'Dashboard',
          href: '/'
        },
        {
          text: `Lecture Week #${this.lectureWeek}`,
          href: this.lectureHref
        },
        {
          text: 'Take Attendance',
          disabled: true
        }]
    },
    lectureHref() {
      return `/lecture_details/${this.lectureId}`
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
        this.updateRequestLoading = false
        this.showUpdatedMessage = true
        setTimeout(() => {
          this.showUpdatedMessage = false
        }, 1000)
      }).catch((err) => {
        console.log(err) // eslint-disable-line
      })
    },
    updateEditTab(e) {
      if (e === 'tab-1') {
        this.loading = true
        this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_sheet`)
          .then((attendanceSheetRequestResponse) => {
            this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes
            this.issues = attendanceSheetRequestResponse.data.issues
            this.loading = false
          })
      }
    },
    updateIssuesCount(count) {
      this.numberOfIssues = count
    }
  },
  mounted: async function () {
    const attendanceSheetRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_sheet`)
    const studentsInfoRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/students`)
    await this.$axios.get(`lecture_instances/${this.$route.params.id}/info`).then((response) => {
      this.lectureWeek = response.data.week_number
      this.lectureId = response.data.lecture_id
      this.lectureInstance = response.data
    }).catch((err) => {
      // eslint-disable-next-line
      console.error(err)
    })
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
      // this.image = this.$axios.defaults.baseURL + attendanceSheetRequestResponse.data.image.url
      this.image = attendanceSheetRequestResponse.data.image_base64
      this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes
      this.issues = attendanceSheetRequestResponse.data.issues
      this.numberOfIssues = _.filter(this.issues, (issue) => { return issue.state === 'pending' }).length

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
