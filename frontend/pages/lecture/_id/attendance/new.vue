<template>
  <div>
    <v-breadcrumbs :items="breadCrumbItems" divider=" > "></v-breadcrumbs>
    <v-card>
      <v-stepper alt-labels v-model="step">
        <v-stepper-header>
          <v-stepper-step :editable="!saved" :complete="step > 1" step="1">Choose Location</v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step :complete="step > 2" step="2">Confirm Attendance Sheet</v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step :complete="step == 3" step="3">Save Attendance Sheet</v-stepper-step>
        </v-stepper-header>
        <v-stepper-items>
          <v-stepper-content step="1">
            <v-card dark color="info">
              <v-card-text class="">
                <v-icon>info</v-icon>
                <span class="body-2 text-uppercase font-weight-black">THE DEFAULT VALUE OF THis INPUT IS THE REGISTERED LOCATION FOR THIS LECTURE.</span>
              </v-card-text>
            </v-card>
            <v-text-field
              solo
              v-model="lectureLocation"
              label="Lecture Location (e.g. C11, K1)"
              prepend-inner-icon="place"
              loading=true
            ></v-text-field>
            <v-divider></v-divider>
            <v-layout row wrap justify-end align-content-end>
              <v-progress-linear v-if="loading" :indeterminate="true"></v-progress-linear>
              <v-progress-linear v-if="lectureLocationLoading" :indeterminate="true"></v-progress-linear>
              <v-flex xs12 sm3>
                <v-btn
                  :disabled="loading"
                  depressed
                  ripple
                  block
                  color="primary"
                  @click="requestAttendanceAndMoveStepper"
                >
                  Next
                </v-btn>
              </v-flex>
            </v-layout>
          </v-stepper-content>
          <v-stepper-content step="2">
            <attendance-wizard
              v-if="step === 2"
              :image="this.image"
              :faceBoxes="this.faceBoxes"
              :students="this.studentsInfoObj"
            />
          </v-stepper-content>
          <v-stepper-content step="3">
            <v-alert
              :value="true"
              type="success"
            >
              Attendance is Saved Successfully.
            </v-alert>
            <v-layout row reverse wrap>
              <v-flex xs12 sm6 class="pa-1">
                <v-btn
                  ripple
                  block
                  depressed
                  :loading="downloadLoading"
                  color="primary"
                >
                  <v-icon left dark>cloud_download</v-icon>
                  Download
                </v-btn>
              </v-flex>
              <v-flex xs12 sm6 class="pa-1">
                <v-btn
                  ripple
                  block
                  depressed
                  color="grey lighten-2"
                >
                  <v-icon left>chevron_left</v-icon>
                  Back to Lecture
                </v-btn>
              </v-flex>
            </v-layout>
          </v-stepper-content>
        </v-stepper-items>
      </v-stepper>
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
  provide() {
    return {
      confirmAttendanceSheet: this.confirmAttendanceSheet
    }
  },
  data() {
    return {
      step: 1,
      loading: false,
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
          text: 'Take Attendance',
          disabled: true
        }
      ],
      lectureLocation: '',
      lectureLocationLoading: true,
      image: '',
      faceBoxes: [],
      studentsInfoObj: {},
      downloadLoading: false,
      saved: false
    }
  },
  computed: {
    lectureHref() {
      return `/lecture/${this.$route.params.id}`
    }
  },
  methods: {
    requestAttendanceAndMoveStepper() {
      // Move Stepper and Set Loading
      this.loading = true

      /*
        Request two things:
        1- Attendance on the given location
        2- Students data of this course offering

        Then pass those data to the AttendanceWizard component
      */

      // this.$axios.post('attendance/new', { lecture_instance_id: this.$route.params.id, class_id: this.lectureLocationId }).then((response) => {
      const attendanceRequest = this.$axios.get('http://localhost:8080')
      const studentsInfoRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/students`)

      Promise.all([attendanceRequest, studentsInfoRequest]).then(([attendanceResponse, studentsInfoResponse]) => {
        /*
          Parse students data to the form:
          student_id: {
            id: '',
            name: '',
            student_id: '',
            image: 'full url'
          }
        */
        this.image = attendanceResponse.data.image
        this.faceBoxes = attendanceResponse.data.face_boxes

        const studentsInfo = studentsInfoResponse.data
        const studentIds = _.map(studentsInfo, (studentInfo) => {
          return studentInfo.student_id
        })

        this.studentsInfoObj = _.zipObject(studentIds, studentsInfo)

        this.loading = false
        this.step = 2
      }).catch((err) => {
        console.error(err) // eslint-disable-line
      })
    },
    confirmAttendanceSheet(faceBoxes) {
      console.log('called') // eslint-disable-line
      this.loading = true
      this.$axios.post('attendance/save', { lecture_instance_id: this.$route.params.id, face_boxes: faceBoxes }).then((response) => {
        this.step = 3
      }).catch((err) => {
        // TODO:
        // eslint-disable-next-line
        console.error(err)
      })
    }
  },
  mounted: async function () {
    await this.$axios.get(`lecture_instances/${this.$route.params.id}/place`).then((response) => {
      this.lectureLocation = response.data.name
      this.lectureLocationId = response.data.id
      this.lectureLocationLoading = false
    }).catch((err) => {
      // TODO:
      // eslint-disable-next-line
      console.error(err)
    })
  }
}
</script>

<style scoped>
</style>
