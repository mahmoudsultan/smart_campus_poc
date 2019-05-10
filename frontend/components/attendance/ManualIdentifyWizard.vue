<template>
    <v-card>
      <v-toolbar dark color="primary">
        <v-btn icon dark @click="$emit('close')">
          <v-icon>close</v-icon>
        </v-btn>
        <v-toolbar-title>Manual Identification</v-toolbar-title>
        <v-spacer></v-spacer>
      </v-toolbar>
      <v-card-text>
        <v-layout row wrap>
          <v-flex xs12>
            <v-alert
              :value="showSuccess"
              type="success"
              outline
            >
              {{ successMessage }}
            </v-alert>
          </v-flex>
        </v-layout>
        <v-layout row wrap>
          <v-flex xs12 md6>
            <v-subheader>Unidentified Students:</v-subheader>
            <v-layout auto-height row wrap justify-center align-center>
              <v-flex xs1 class="arrow-flex">
                <v-icon
                  color="primary"
                  :disabled="currentOnFocusFaceBoxIsLeftEdge"
                  @click="moveOnFocusFaceBoxLeft"
                  x-large
                >
                  arrow_left
                </v-icon>
              </v-flex>
              <v-flex xs10>
                <v-img :src="onFocusFaceBoxImage" />
              </v-flex>
              <v-flex xs1 class="arrow-flex">
                <v-icon
                  color="primary"
                  :disabled="currentOnFocusFaceBoxIsRightEdge"
                  @click="moveOnFocusFaceBoxRight"
                  x-large
                >
                  arrow_right
                </v-icon>
              </v-flex>
            </v-layout>
            <v-divider class="mt-3"></v-divider>
            <v-subheader>Search By ID: </v-subheader>
            <v-text-field
              name="search"
              append-icon="search"
              label="Student ID"
              solo
            ></v-text-field>
            <v-divider></v-divider>
            <div id="chosen_student">
              <v-list v-if="isChoosedStudent" dark three-line>
                <v-list-tile color="success" avatar>
                  <v-list-tile-avatar size="50">
                    <img :src="choosedStudentImage">
                  </v-list-tile-avatar>
                  <v-list-tile-content>
                    <v-list-tile-title>{{ choosedStudent.name }}</v-list-tile-title>
                    <v-list-tile-sub-title>ID: {{ choosedStudent.student_id }} </v-list-tile-sub-title>
                  </v-list-tile-content>
                  <v-list-tile-action>
                    <v-btn @click="assignChoosedStudentToOnFocusFaceBox" color="success">Assign</v-btn>
                  </v-list-tile-action>
                </v-list-tile>
              </v-list>
            </div>
          </v-flex>
          <v-flex xs12 md6>
            <v-subheader>Or Choose by Image: </v-subheader>
              <v-container fullscreen style="max-height: 90vh; overflow: scroll;"  fluid grid-list-sm>
              <v-layout row wrap>
                <v-flex v-for="student in choosedStudentNeighbors" :key="student.student_id" xs4>
                  <img
                    @click="chooseStudentByImage(student)"
                    :src="student.image"
                    class="student-image"
                    :alt="student.name"
                    width="100%"
                    height="100%"
                  >
                </v-flex>
              </v-layout>
            </v-container>
            <v-container fullscreen style="max-height: 90vh; overflow: scroll;"  fluid grid-list-sm>
              <v-layout row wrap>
                <v-flex v-for="student in students" :key="student.student_id" xs4>
                  <img
                    @click="chooseStudentByImage(student)"
                    :src="student.image"
                    class="student-image"
                    :alt="student.name"
                    width="100%"
                    height="100%"
                  >
                </v-flex>
              </v-layout>
            </v-container>
          </v-flex>
        </v-layout>
        <v-spacer class="mt-3"></v-spacer>
      </v-card-text>
    </v-card>
</template>

<script>
export default {
  props: {
    faceBoxes: Array,
    students: Object,
    nearestStudentsInfo: Object
  },
  data() {
    return {
      showDialog: true,
      onFocusFaceBoxIndex: 0,
      choosedStudent: null,
      choosedStudentNeighbors: null,
      showSuccess: false,
      successMessage: ''
    }
  },
  computed: {
    onFocusFaceBox() {
      if (this.onFocusFaceBoxIndex < this.faceBoxes.length) {
        return this.faceBoxes[this.onFocusFaceBoxIndex]
      } else {
        return null
      }
    },
    onFocusFaceBoxImage() {
      if (this.onFocusFaceBoxIndex < this.faceBoxes.length) {
        return this.faceBoxes[this.onFocusFaceBoxIndex].image
      } else {
        return null
      }
    },
    isChoosedStudent() {
      return Boolean(this.choosedStudent)
    },
    choosedStudentImage() {
      return this.choosedStudent.image
    },
    currentOnFocusFaceBoxIsLeftEdge() {
      return this.onFocusFaceBoxIndex - 1 < 0
    },
    currentOnFocusFaceBoxIsRightEdge() {
      return (this.onFocusFaceBoxImage + 1) >= this.faceBoxes.length
    }
  },
  methods: {
    showSucessAssignmentMessage({ name }) {
      this.showSuccess = true
      this.successMessage = `Facebox assigned to ${name} successfully.`
    },
    chooseStudentByImage(student) {
      this.choosedStudent = student
      this.choosedStudentNeighbors = this.getNearestStudentsInfo(student)
      this.$vuetify.goTo('#chosen_student')
    },
    assignChoosedStudentToOnFocusFaceBox() {
      const faceBoxIndex = this.onFocusFaceBox.index
      const studentId = this.choosedStudent.student_id

      this.$emit('assign', { faceBoxIndex, studentId })

      this.showSucessAssignmentMessage(this.choosedStudent)
      this.moveOnFocusFaceBoxLeft()
      this.choosedStudent = null
      this.choosedStudentNeighbors = null
    },
    moveOnFocusFaceBox(move) {
      this.onFocusFaceBoxIndex = (this.onFocusFaceBoxIndex + move) % this.faceBoxes.length
    },
    moveOnFocusFaceBoxRight() {
      this.moveOnFocusFaceBox(1)
    },
    moveOnFocusFaceBoxLeft() {
      this.moveOnFocusFaceBox(-1)
    },
    getNearestStudentsInfo(student) {
      const studentId = student.student_id
      const nearestStudentsIds = this.nearestStudentsInfo.studentId

      const nearStudentsInfo = this.nearestStudentsIds.map(nearID => {
        return this.students.nearID
      })

      return nearStudentsInfo
    }
  },
  watch: {
    faceBoxes: function () {
      if (this.faceBoxes.length === 0) {
        this.$emit('close')
      }
    }
  }
}
</script>

<style scoped>
  .student-image {
    cursor: pointer;
  }
  .arrow-flex {
    height: 100%;
    border-radius: 5px;
  }
</style>
