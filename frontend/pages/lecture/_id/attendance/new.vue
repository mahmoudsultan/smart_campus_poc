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
              :redraw="redrawCanvasTrigger"
              @facebox-click="handleClickedFaceBox"
              @facebox-drawn="receiveFaceBoxCoordinates"
              @facebox-canceled="cancelFaceBoxCoordinates"
            />
            <v-divider></v-divider>

            <v-layout row wrap class="pa-1 mt-4">
              <v-flex xs12 sm6>
                <span class="headline font-weight-light">
                  Number of Attendees: {{ numberOfAttendess }}
                </span>
              </v-flex>
              <v-spacer></v-spacer>
              <v-flex xs12 sm2>
                <v-btn block color="success">
                  <v-icon>add</v-icon>
                  <span>Add Attendee</span>
                </v-btn>
              </v-flex>
            </v-layout>
            <v-data-table
              :headers="attendanceTableHeaders"
              :items="attendanceItems"
              hide-actions
              class="elevation-1"
              item-key="student_id"
            >
              <template slot="items" slot-scope="props">
                <tr>
                  <td class="text-xs-left">{{ props.item.studentId }}</td>
                  <td class="text-xs-left">{{ props.item.studentName }}</td>
                  <td class="text-xs-right">
                    <v-flex xs12>
                      <v-btn round small xs6 sm4 color="info">
                        <v-icon small>edit</v-icon>
                        <v-spacer></v-spacer>
                        <span>Edit</span>
                      </v-btn>
                      <v-btn
                        dark
                        small
                        round
                        xs6
                        sm4
                        color="red">
                        <v-icon small>delete</v-icon>
                        <v-spacer></v-spacer>
                        <span>delete</span>
                      </v-btn>
                    </v-flex>
                  </td>
                </tr>
              </template>
            </v-data-table>
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
                  Confirm
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
        @assign="assignStudentToFaceBox"
      />
    </v-dialog>
  </div>
</template>

<script>
import AttendanceImage from '@/components/attendance/AttendanceImage'
import FaceBoxInfo from '@/components/attendance/FaceBoxInfo'
import _ from 'lodash'

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
      image: null,
      faceBoxes: [],
      lectureLocation: '',
      redrawCanvasTrigger: false,
      addingNewAttendance: false,
      showFaceBoxDialog: {
        display: false,
        imagePart: '',
        studentName: '',
        studentId: '',
        studentImage: '',
        faceBoxIndex: -1
      },
      downloadLoading: false,
      saved: false,
      attendanceTableHeaders: [
        {
          text: 'ID',
          sortable: false
        }, {
          text: 'Name',
          sortable: false
        }, {
          text: '',
          sortable: false
        }
      ]
    }
  },
  computed: {
    lectureHref() {
      return `/lecture/${this.$route.params.id}`
    },
    attendanceItems() {
      return _.map(this.faceBoxes, (faceBox) => {
        // TODO:
        return { studentId: faceBox.student_id, studentName: 'John Doe' }
      })
    },
    numberOfAttendess() {
      return this.faceBoxes.length
    }
  },
  methods: {
    requestAttendanceAndMoveStepper() {
      // Move Stepper and Set Loading
      this.loading = true

      // Request Attendance on complete Unset Loading and Set Attendance Image
      // and Faceboxes
      console.log(this.$route) //eslint-disable-line
      this.$axios.post('attendance/new', { lecture_instance_id: this.$route.params.id, class_id: this.lectureLocationId }).then((response) => {
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
      this.showFaceBoxDialog.faceBoxIndex = faceBoxIndex
      this.showFaceBoxDialog.imagePart = clickedPartImage
      const studentId = this.faceBoxes[faceBoxIndex].student_id
      this.showFaceBoxDialog.studentId = studentId

      // Fetch Student data if id is given (recognized)
      if (studentId) {
        this.$axios.get(`/students/sid/${studentId}`).then((response) => {
          this.showFaceBoxDialog.studentName = response.data.name
          this.showFaceBoxDialog.studentImage = response.data.image
          this.showFaceBoxDialog.display = true
        }).catch((err) => {
          // eslint-disable-next-line
          console.log(err)
        })
      } else {
        this.showFaceBoxDialog.display = true
      }
    },
    assignStudentToFaceBox(studentId) {
      this.faceBoxes[this.showFaceBoxDialog.faceBoxIndex].student_id = studentId
      this.showFaceBoxDialog.display = false
      this.redrawCanvasTrigger = true
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
  },
  mounted: async function () {
    await this.$axios.get('/place/1').then((response) => {
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
