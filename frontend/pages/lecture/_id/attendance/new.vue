<template>
  <div>
    <v-breadcrumbs :items="breadCrumbItems" divider=" > "></v-breadcrumbs>
    <v-card>
      <v-stepper alt-labels v-model="step">
        <v-stepper-header>
          <v-stepper-step :editable="!saved" :complete="step > 1" step="1">Choose Location</v-stepper-step>

          <v-divider></v-divider>

          <v-stepper-step :editable="!saved" :complete="step > 2" step="2">Confirm Attendance Sheet</v-stepper-step>

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
                  @click="confirmAttendanceSheet"
                >
                  Next
                </v-btn>
              </v-flex>
            </v-layout>
          </v-stepper-content>
          <v-stepper-content step="3">
            <v-alert
              :value="true"
              type="success"
            >
              Attendance is Saved Successfully.
            </v-alert>
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
          </v-stepper-content>
        </v-stepper-items>
      </v-stepper>
    </v-card>

    <v-dialog
      v-model="showFaceBoxDialog.display"
      :overlay="false"
      persistent
      width="500"
      height="300"
      transition="dialog-transition"
    >
      <face-box-info
        v-if="showFaceBoxDialog.display"
        :image="showFaceBoxDialog.imagePart"
        :studentName="showFaceBoxDialog.studentName"
        :studentId="showFaceBoxDialog.studentId"
        :studentImage="showFaceBoxDialog.studentImage"
        @close="showFaceBoxDialog.display = false"
      />
    </v-dialog>
  </div>
</template>

<script>
import AttendanceImage from '@/components/attendance/AttendanceImage'
import FaceBoxInfo from '@/components/attendance/FaceBoxInfo'

export default {
  components: {
    AttendanceImage,
    FaceBoxInfo
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
      addingNewAttendance: false,
      showFaceBoxDialog: {
        display: false,
        imagePart: '',
        studentName: '',
        studentId: '',
        studentImage: ''
      },
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
    confirmAttendanceSheet() {
      this.loading = true
      setTimeout(() => {
        this.step = 3
        this.saved = true
      }, 2000)
    },
    handleClickedFaceBox(faceBoxIndex, clickedPartImage) {
      // TODO
      this.showFaceBoxDialog.imagePart = clickedPartImage
      this.showFaceBoxDialog.studentId = this.faceBoxes[faceBoxIndex].student_id
      this.showFaceBoxDialog.studentName = 'John Doe'
      this.showFaceBoxDialog.studentImage = clickedPartImage

      this.showFaceBoxDialog.display = true
    },
    receiveFaceBoxCoordinates(boxStartCorner, boxEndCorner) {
      // TODO
      // eslint-disable-next-line
      console.error('Not Yet Implemented')
    },
    cancelFaceBoxCoordinates() {
      // TODO
      // eslint-disable-next-line
      console.error('Not Yet Implemented')
    }
  }
}
</script>

<style scoped>
</style>
