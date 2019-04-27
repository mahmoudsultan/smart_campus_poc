<template>
    <v-card>
      <v-toolbar dark color="primary">
        <v-btn icon dark @click="$emit('close')">
          <v-icon>close</v-icon>
        </v-btn>
        <v-toolbar-title>Manual Identification</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-toolbar-items>
          <v-btn dark flat @click="dialog = false">Save</v-btn>
        </v-toolbar-items>
      </v-toolbar>
      <v-card-text>
        <v-layout row wrap>
          <v-flex xs12 md6>
            <v-subheader>Unidentified Students:</v-subheader>
            <v-layout auto-height row wrap justify-center align-center>
              <v-flex xs1>
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
              <v-flex xs1>
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
          </v-flex>
          <v-flex xs12 md6>
            <v-subheader>Or Choose by Image: </v-subheader>
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
    students: Object
  },
  data() {
    return {
      showDialog: true,
      onFocusFaceBoxIndex: 0,
      choosedStudentIndex: -1
    }
  },
  computed: {
    onFocusFaceBoxImage() {
      return this.faceBoxes[this.onFocusFaceBoxIndex].image
    },
    isChoosedStudent() {
      return this.choosedStudentIndex > -1
    },
    choosedStudent() {
      return this.students[this.choosedStudentIndex]
    },
    choosedStudentImage() {
      return this.$axios.defaults.baseURL + this.students[this.choosedStudentIndex].image.url
    },
    currentOnFocusFaceBoxIsLeftEdge() {
      return this.onFocusFaceBoxIndex - 1 < 0
    },
    currentOnFocusFaceBoxIsRightEdge() {
      return (this.onFocusFaceBoxImage + 1) >= this.faceBoxes.length
    }
  },
  methods: {
    chooseStudentByImage(faceBoxIndex) {
      this.choosedStudentIndex = faceBoxIndex
    },
    assignChoosedStudentToOnFocusFaceBox() {
      console.error('Not Yet Implemented') // eslint-disable-line
    },
    moveOnFocusFaceBox(move) {
      this.onFocusFaceBoxIndex += move
    },
    moveOnFocusFaceBoxRight() {
      this.moveOnFocusFaceBox(1)
    },
    moveOnFocusFaceBoxLeft() {
      this.moveOnFocusFaceBox(-1)
    }
  }
}
</script>

<style scoped>
  .student-image {
    cursor: pointer;
  }
</style>
