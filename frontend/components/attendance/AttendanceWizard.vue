<template>
  <div>
    <attendance-image
      key="attendance-wizard"
      :image="image"
      :faceBoxes="faceBoxes"
      :drawMode="addingNewAttendance"
      @facebox-click="handleClickedFaceBox"
      @facebox-drawn="receiveFaceBoxCoordinates"
      @facebox-canceled="cancelFaceBoxCoordinates"
      ref="attendanceImage"
    />
    <v-divider></v-divider>

    <v-layout row wrap class="pa-1 mt-4">
      <v-flex xs12 sm6>
        <span class="headline font-weight-light">
          Number of FaceBoxes: {{ numberOfFaceBoxes }}
        </span>
      </v-flex>
      <v-spacer></v-spacer>
      <v-flex xs12 sm2>
        <v-btn v-if="!addingNewAttendance" block color="success" @click="startAddingNewAttendance">
          <v-icon>add</v-icon>
          <span>Add FaceBox</span>
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
        <v-btn
          v-if="addingNewAttendance"
          color="error"
          block
          @click="cancelAddingNewAttendance"
        >
          Cancel
        </v-btn>
      </v-flex>
    </v-layout>
    <v-layout row justify-start align-start class="pa-1" v-if="numberOfNotRecognized">
      <v-flex xs12 class="text-xs-center">
        <v-icon color="warning" x-large left light>warning</v-icon>
        <p class="subheading text-uppercase font-weight-light">
          There are {{ numberOfNotRecognized }} unrecognized students...
          <v-btn @click="showManualIdentifyWizard = true" flat color="primary">Manual Identification</v-btn>
        </p>
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
            <v-btn
              dark
              icon
              small
              color="red">
              <v-icon @click="startDelete(props.item.faceBoxIndex)" small>delete</v-icon>
            </v-btn>
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
          @click="emitSaveEvent"
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
        @delete="deleteFaceBoxOpened"
      />
    </v-dialog>

    <v-dialog
      v-model="showManualIdentifyWizard"
      scrollable
      fullscreen
      persistent
      :overlay="false"
      transition="dialog-bottom-transition"
    >
      <manual-identify-wizard
        v-if="showManualIdentifyWizard"
        :faceBoxes="manualIndentifyFaceBoxes"
        :students="students"
        :nearestStudentsInfo="nearestStudentsInfo"
        @close="showManualIdentifyWizard = false"
        @assign="assignStudentFromManualWizardToFaceBox"
      />
    </v-dialog>

    <v-dialog
      v-model="deleteDialog.display"
      persistent
      max-width="500px"
      transition="dialog-transition"
    >
      <v-card>
        <v-card-title primary-title>
          Are you sure you want to delete this item ?
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="resetDeleteDialog" color="primary">Cancel</v-btn>
          <v-btn @click="confirmDelete" color="error">Yes</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import _ from 'lodash'

import AttendanceImage from '@/components/attendance/AttendanceImage'
import FaceBoxInfo from '@/components/attendance/FaceBoxInfo'
import ManualIdentifyWizard from '@/components/attendance/ManualIdentifyWizard'

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
    nearestStudentsInfo: {
      type: Object,
      required: false
    },
    image: {
      type: String,
      required: true
    },
    editMode: {
      type: Boolean,
      default: false
    }
  },
  components: {
    AttendanceImage,
    FaceBoxInfo,
    ManualIdentifyWizard
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
      loading: false,
      showManualIdentifyWizard: false,
      deleteDialog: {
        display: false,
        index: null
      },
      deletedFaceBoxes: []
    }
  },
  computed: {
    numberOfFaceBoxes() {
      return this.faceBoxes.length
    },
    numberOfNotRecognized() {
      return _.filter(this.faceBoxes, (faceBox) => { return !faceBox.student_id }).length
    },
    manualIndentifyFaceBoxes() {
      return _.chain(this.faceBoxes)
        .map((faceBox, index) => {
          return { ...faceBox, ...{ index: index } }
        })
        .filter((faceBox) => { return !faceBox.student_id })
        .map((faceBox) => {
          const faceBoxImage = this.getFaceBoxImage(faceBox)
          return { ...faceBox, ...{ image: faceBoxImage } }
        })
        .value()
    }
  },
  methods: {
    getFaceBoxImage(faceBox) {
      const faceBoxDimensions = this.faceBoxDimensions(faceBox)
      return this.$refs.attendanceImage.getFaceBoxImageBase64(...faceBoxDimensions)
    },
    handleClickedFaceBox(faceBoxIndex, clickedPartImage) {
      this.showFaceBoxDialog.faceBoxIndex = faceBoxIndex
      this.showFaceBoxDialog.imagePart = clickedPartImage
      const studentId = this.faceBoxes[faceBoxIndex].student_id
      this.showFaceBoxDialog.studentId = studentId

      // Fetch Student data if id is given (recognized)
      if (studentId) {
        const student = this.students[studentId]
        this.showFaceBoxDialog.studentName = student.name
        this.showFaceBoxDialog.studentImage = student.image
        this.showFaceBoxDialog.display = true
      } else {
        this.showFaceBoxDialog.display = true
      }
    },
    updateAfterFaceBoxesChange() {
      this.$refs.attendanceImage.drawCanvas()
      this.updateTable()
    },
    assignStudentToFaceBox(studentId) {
      this.faceBoxes[this.showFaceBoxDialog.faceBoxIndex].student_id = studentId
      this.showFaceBoxDialog.display = false
      // this.redrawCanvasTrigger = true
      this.updateAfterFaceBoxesChange()
    },
    startAddingNewAttendance() {
      this.addingNewAttendance = true
      this.newFaceBox = null
    },
    cancelAddingNewAttendance() {
      this.addingNewAttendance = false
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
      this.$refs.attendanceImage.drawCanvas()
      this.addingNewAttendance = false
    },
    updateTable() {
      this.attendanceItemsLoading = true
      let studentName = ''
      let studentImage = null
      this.attendanceItems = _.map(this.faceBoxes, (faceBox, index) => {
        if (faceBox.student_id) {
          studentName = this.students[faceBox.student_id].name
          studentImage = this.students[faceBox.student_id].image
        } else {
          studentName = 'Not Recognized'
        }

        return {
          studentId: faceBox.student_id,
          faceBoxIndex: index,
          studentName,
          studentImage
        }
      })
      this.attendanceItemsLoading = false
    },
    emitSaveEvent() {
      this.$emit('save', this.faceBoxes, this.deletedFaceBoxes)
    },
    faceBoxDimensions(faceBox) {
      console.log('faceBoxDimension()', faceBox) // eslint-disable-line
      const [x1, y1, x2, y2] = _.map(faceBox.boundaries.split(','), (v) => {
        return Number.parseInt(v)
      })
      const width = x2 - x1
      const height = y2 - y1
      return [x1, y1, width, height]
    },
    assignStudentFromManualWizardToFaceBox({ faceBoxIndex, studentId }) {
      this.faceBoxes[faceBoxIndex].student_id = studentId
      this.updateAfterFaceBoxesChange()
    },
    deleteFaceBoxOpened() {
      this.startDelete(this.showFaceBoxDialog.faceBoxIndex)
      this.showFaceBoxDialog.display = false
    },
    startDelete(index) {
      this.deleteDialog.display = true
      this.deleteDialog.index = index
    },
    resetDeleteDialog() {
      this.deleteDialog.display = false
      this.deleteDialog.index = null
    },
    confirmDelete() {
      const deletedFaceBox = this.faceBoxes.splice(this.deleteDialog.index, 1)

      if (this.editMode) {
        // keep track of this deletion if in edit mode
        this.deletedFaceBoxes.push(deletedFaceBox[0])
      }

      this.resetDeleteDialog()
      this.updateAfterFaceBoxesChange()
    }
  },
  mounted() {
    this.$nextTick(function () {
      this.updateTable()
    })
  }
}
</script>

<style scoped>

</style>
