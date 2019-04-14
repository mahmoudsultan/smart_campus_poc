<template>
  <div>
    <v-breadcrumbs :items="breadCrumbItems" divider=" > "></v-breadcrumbs>
    <v-card>
      <v-stepper alt-labels v-model="step">
        <v-stepper-header>
          <v-stepper-step editable :complete="step > 1" step="1">Confirm Location</v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step editable :complete="step > 2" step="2">Confirm Attendance Sheet</v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step :complete="step > 3" step="3">Save Attendance Sheet</v-stepper-step>
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
            ></v-text-field>
            <v-divider></v-divider>
            <v-layout row wrap justify-end align-content-end>
              <v-progress-linear v-if="loading" :indeterminate="true"></v-progress-linear>
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
            <attendance-image
              v-if="step == 2"
              :image="image"
              :faceBoxes="faceBoxes"
              :drawMode="addingNewAttendance"
              @facebox-click="handleClickedFaceBox"
              @facebox-drawn="receiveFaceBoxCoordinates"
              @facebox-canceled="cancelFaceBoxCoordinates"
            />
          </v-stepper-content>
        </v-stepper-items>
      </v-stepper>
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
      lectureLocation: 'C11',
      image: null,
      faceBoxes: [],
      addingNewAttendance: false
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

      // Request Attendance on complete Unset Loading and Set Attendance Image
      // and Faceboxes
      this.$axios.get('http://localhost:8080').then((response) => {
        const attendanceObj = response.data
        this.image = attendanceObj.image
        this.faceBoxes = attendanceObj.face_boxes
        this.loading = false
        this.step = 2
      }).catch((err) => {
        // TODO:
        // eslint-disable-next-line
        console.error(err)
      })
    },
    handleClickedFaceBox() {
      // TODO
      // eslint-disable-next-line
      console.error('Not Yet Implemented')
    },
    receiveFaceBoxCoordinates(boxStartCorner, boxEndCorner) {
      // TODO
      // eslint-disable-next-line
      console.error('Not Yet Implemented')
    },
    cancelFaceBoxCoordinates(faceBoxIndex, clickedPartImage) {
      // TODO
      // eslint-disable-next-line
      console.error('Not Yet Implemented')
    }
  }
}
</script>

<style scoped>
</style>
