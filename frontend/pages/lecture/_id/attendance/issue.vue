<template>
  <div>
    <v-card>
    <v-container grid-list-xs>
      <v-layout row wrap>
        <v-flex xs12 justify-center>
          <v-progress-circular
            v-if="loading || savingIssueRequestLoading"
            :size="50"
            color="primary"
            indeterminate
          ></v-progress-circular>
        </v-flex>
      </v-layout>
      <v-layout v-if="saved" row wrap>
        <v-flex xs12>
          <v-card color="success">
            <v-card-text class="">
              <v-icon>info</v-icon>
              <span class="body-2 text-uppercase font-weight-black">
                Attendance Issue is created successfully, Lecturer will be notified.
              </span>
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
      <div v-else>
        <v-layout v-if="issueMade" row wrap>
          <v-flex xs12>
            <v-card :color="(issueMade.state === 'resolved') ? 'success' : 'warning'">
              <v-card-text class="">
                <v-icon>info</v-icon>
                <span class="body-2 text-uppercase font-weight-black">
                  You've already made an issue in this Attendance sheet
                  Issue Status: {{ issueMade.state }}
                </span>
              </v-card-text>
            </v-card>
          </v-flex>
        </v-layout>
        <v-layout v-else row wrap justify-end>
          <v-flex xs12>
            <v-card dark color="info">
              <v-card-text class="">
                <v-icon>info</v-icon>
                <span class="body-2 text-uppercase font-weight-black">
                  if you were, mistakenly, unrecognized or undetected in the attendance image you can mark the appropriate location in the image and create an issue to notify the lecturer.
                </span>
              </v-card-text>
            </v-card>
          </v-flex>
          <v-flex xs12>
            <attendance-image
              v-if="!loading"
              :image="image"
              :faceBoxes="faceBoxes"
              :drawMode="drawing"
              @facebox-drawn="receiveFaceBoxCoordinates"
              @facebox-canceled="cancelFaceBoxCoordinates"
            />
          </v-flex>
          <v-flex xs12 sm6 md4>
            <v-btn v-if="!drawing" color="primary" block @click="drawing = true">
              <v-icon left>add</v-icon>
              Mark Issue
            </v-btn>
            <v-btn v-if="drawing" block color="success" @click="confirmIssue">Confirm</v-btn>
            <v-btn v-if="drawing" block color="error" @click="cancelIssue">Cancel</v-btn>
          </v-flex>
        </v-layout>
      </div>
    </v-container>
    </v-card>
  </div>
</template>

<script>
import AttendanceImage from '@/components/attendance/AttendanceImage'

export default {
  components: {
    AttendanceImage
  },
  data() {
    return {
      loading: true,
      faceBoxes: [],
      issueFaceBox: null,
      drawing: false,
      savingIssueRequestLoading: false,
      issueMade: null,
      saved: false
    }
  },
  computed: {
    studentId() {
      // TODO: set student id here.
      return 4
    }
  },
  methods: {
    receiveFaceBoxCoordinates(boxStartCorner, boxEndCorner) {
      this.issueFaceBox = {
        boundaries: `${boxStartCorner[0]},${boxStartCorner[1]},${boxEndCorner[0]},${boxEndCorner[1]}`,
        student_id: this.studentId
      }
    },
    cancelFaceBoxCoordinates() {
      this.issueFaceBox = null
    },
    confirmIssue() {
      this.savingIssueRequestLoading = true
      this.$axios.post(`lecture_instances/${this.$route.params.id}/attendance_issues`, {
        face_box: this.issueFaceBox
      }).then((response) => {
        this.saved = true
        this.savingIssueRequestLoading = false
      }).catch((err) => {
        console.error(err) // eslint-disable-line
      })
    },
    cancelIssue() {
      this.drawing = false
      this.issueFaceBox = null
    }
  },
  mounted: async function () {
    const attendanceSheetRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_sheet`)
    const attendanceIssueByStudent = this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_issues`)

    await Promise.all([attendanceSheetRequest, attendanceIssueByStudent]).then(([attendanceSheetRequestResponse, attendanceIssueByStudentResponse]) => {
      if (attendanceIssueByStudentResponse.data.length) {
        this.issueMade = attendanceIssueByStudentResponse.data[0]
      }

      this.image = this.$axios.defaults.baseURL + attendanceSheetRequestResponse.data.image.url
      this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes

      this.loading = false
    })
  }
}
</script>

<style scoped>

</style>
