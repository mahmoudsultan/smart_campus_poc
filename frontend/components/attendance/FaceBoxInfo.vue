<template>
  <v-card>
    <v-toolbar dark color="primary">
      <v-btn icon dark @click="closeDialog">
        <v-icon>close</v-icon>
      </v-btn>
      <v-toolbar-title> {{ toolBarTitle }} </v-toolbar-title>
      <v-spacer></v-spacer>
    </v-toolbar>
    <v-card-text>
      <v-layout row wrap v-if="showImage">
        <v-flex xs6>
          <v-img :src="image" />
        </v-flex>
        <v-flex xs6>
          <v-img :src="studentImage" />
        </v-flex>
      </v-layout>
      <v-layout
        v-else
        row
        wrap
        align-content-space-around
        justify-center
        fill-height
      >
        <v-stepper v-model="searchStep" class="pa-0 ma-0">
          <v-stepper-content step="1">
            <v-text-field
                v-model="searchStudentId"
                name="search"
                append-icon="search"
                label="Student ID"
                single-line
                hide-details
              ></v-text-field>
              <v-btn color="info" @click="searchAndProceed" :loading="searchLoading" block>Search</v-btn>
          </v-stepper-content>
          <v-stepper-content step="2">
            <v-img
              :src="`https://picsum.photos/500/300?image=${10}`"
              :lazy-src="`https://picsum.photos/10/6?image=${10}`"
              aspect-ratio="1"
              class="grey lighten-2"
            />
            <p class="headline ma-2">
              {{ recievedStudentAfterSearch.studentId }} - {{ recievedStudentAfterSearch.studentName }}
            </p>
            <v-layout column wrap>
              <v-btn xs12 sm6 @click="assignStudent" color="success">Assign</v-btn>
              <v-btn xs12 sm6 @click="rebeatSearch" color="gray lighten-2">Retry</v-btn>
            </v-layout>
          </v-stepper-content>
        </v-stepper>
      </v-layout>
    </v-card-text>
    <v-card-actions>
      <v-layout row wrap justify-end>
        <v-btn
          depressed
          ripple
          @click="triggerDeleteFaceBox"
          color="error"
        >
          <v-icon small left dark>delete</v-icon>
          delete
        </v-btn>
        <v-btn
          depressed
          ripple
          color="primary"
          @click="enableEdit"
        >
          <v-icon small left dark>edit</v-icon>
          <span>edit</span>
        </v-btn>
      </v-layout>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    image: String,
    studentImage: {
      type: String,
      required: false
    },
    studentName: {
      type: String,
      required: false
    },
    studentId: {
      type: String,
      required: false
    }
  },
  data() {
    return {
      editStudentId: false,
      searchStep: 1,
      searchLoading: false,
      searchStudentId: null,
      recievedStudentAfterSearch: {
        studentId: '',
        studentName: '',
        studentImage: ''
      },
      studentFound: false
    }
  },
  methods: {
    closeDialog() {
      this.$emit('close')
    },
    enableEdit() {
      this.studentFound = false
      this.editStudentId = true
      this.searchStep = 1
    },
    searchAndProceed() {
      this.searchLoading = true

      // Send request to fetch user
      this.$axios.get(`/students/sid/${this.searchStudentId}`).then((response) => {
        this.recievedStudentAfterSearch.studentId = response.data.student_id
        this.recievedStudentAfterSearch.studentName = response.data.name
        // TODO
        this.recievedStudentAfterSearch.studentImage = response.data.image

        this.studentFound = true
        this.searchLoading = false
        this.searchStep = 2
      }).catch((err) => {
        this.studentFound = false
        this.searchLoading = false
        // eslint-disable-next-line
        console.err(err)
      })
    },
    defaultSearchStudentObj() {
      return {
        studentId: '',
        studentName: '',
        studentImage: ''
      }
    },
    rebeatSearch() {
      this.studentFound = false
      this.searchStep = 1
      this.recievedStudentAfterSearch = this.defaultSearchStudentObj()
    },
    assignStudent() {
      this.$emit('assign', this.recievedStudentAfterSearch.studentId)
    },
    triggerDeleteFaceBox() {
      this.$emit('delete')
    }
  },
  computed: {
    toolBarTitle() {
      if (this.studentId) {
        return `${this.studentName} - ${this.studentId}`
      } else {
        return 'Face not recognized.'
      }
    },
    showImage() {
      return this.studentId && !this.editStudentId
    }
  }
}
</script>

<style scoped>

</style>
