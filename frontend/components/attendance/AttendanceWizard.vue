<template>
  <div>
    <attendance-image
      ref="attendanceImage"
      :image="image"
      :faceBoxes="faceBoxes"
      :drawMode="addingNewAttendance"
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
        <v-btn v-if="!addingNewAttendance" block color="success" @click="startAddingNewAttendance">
          <v-icon>add</v-icon>
          <span>Add Attendee</span>
        </v-btn>
        <v-btn
          v-else
          block
          color="success"
          :disabled="!newFaceBox"
          @click="confirmNewFaceBoxLocation"
        >
          Confirm
        </v-btn>
      </v-flex>
    </v-layout>
    <v-data-table
      :headers="attendanceTableHeaders"
      :items="attendanceItems"
      :loading="attendanceItemsLoading"
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
          @click="callInjectedSaveMethod"
        >
          Confirm
        </v-btn>
      </v-flex>
    </v-layout>

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
import _ from 'lodash'

import AttendanceImage from '@/components/attendance/AttendanceImage'
import FaceBoxInfo from '@/components/attendance/FaceBoxInfo'

export default {
  props: {
    faceBoxes: {
      type: Array,
      required: true
    },
    students: {
      type: Object,
      required: true
    },
    image: {
      type: String,
      required: true
    }
  },
  inject: ['confirmAttendanceSheet'],
  components: {
    AttendanceImage,
    FaceBoxInfo
  },
  data() {
    return {
      addingNewAttendance: false,
      attendanceItemsLoading: false,
      attendanceItems: [],
      newFaceBox: {},
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
      ],
      showFaceBoxDialog: {
        display: false,
        imagePart: '',
        studentName: '',
        studentId: '',
        studentImage: '',
        faceBoxIndex: -1
      },
      loading: false
    }
  },
  computed: {
    numberOfAttendess() {
      return this.faceBoxes.length
    }
  },
  methods: {
    handleClickedFaceBox(faceBoxIndex, clickedPartImage) {
      console.err('Not yet refactored') // eslint-disable-line
      this.showFaceBoxDialog.faceBoxIndex = faceBoxIndex
      this.showFaceBoxDialog.imagePart = clickedPartImage
      const studentId = this.faceBoxes[faceBoxIndex].student_id
      this.showFaceBoxDialog.studentId = studentId

      // Fetch Student data if id is given (recognized)
      if (studentId) {
        // TODO: the data is passed
        this.$axios.get(`/students/sid/${studentId}`).then((response) => {
          this.showFaceBoxDialog.studentName = response.data.name
          this.showFaceBoxDialog.studentImage = `${this.$axios.defaults.baseURL}${response.data.image.url}`
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
      // this.redrawCanvasTrigger = true
      this.$refs.attendanceImage.drawCanvas()
      this.updateTable()
    },
    startAddingNewAttendance() {
      this.addingNewAttendance = true
      this.newFaceBox = null
    },
    receiveFaceBoxCoordinates(boxStartCorner, boxEndCorner) {
      this.newFaceBox = {
        boundaries: `${boxStartCorner[0]},${boxStartCorner[1]},${boxEndCorner[0]},${boxEndCorner[1]}`,
        student_id: null
      }
    },
    cancelFaceBoxCoordinates() {
      this.newFaceBox = null
    },
    confirmNewFaceBoxLocation() {
      // Save the facebox and redraw
      // TODO: Make the edit dialog opens up automatically
      this.faceBoxes.push(this.newFaceBox)
      // this.redrawCanvasTrigger = true
      this.$refs.attendanceImage.drawCanvas()
      this.addingNewAttendance = false
    },
    async updateTable() {
      this.attendanceItemsLoading = true
      let studentName = ''
      this.attendanceItems = await Promise.all(_.map(this.faceBoxes, async (faceBox) => {
        if (faceBox.student_id) {
          studentName = await this.$axios.get(`/students/sid/${faceBox.student_id}`).then((response) => {
            return response.data.name
          })
        } else {
          studentName = 'Not Recognized'
        }

        return {
          studentId: faceBox.student_id,
          studentName: studentName
        }
      }))
      this.attendanceItemsLoading = false
    },
    callInjectedSaveMethod() {
      this.confirmAttendanceSheet(this.faceBoxes)
    }
  },
  watch: {
    faceBoxes: async function () {
      await this.updateTable()
    }
  }
}
</script>

<style scoped>

</style>
