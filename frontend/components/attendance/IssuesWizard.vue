<template>
  <div>
    <v-expansion-panel expand focusable>
      <v-expansion-panel-content>
        <div slot="header" class="title text-md-center">View Image</div>

        <attendance-image
          key="issues-wizard"
          :image="image"
          :faceBoxes="faceBoxes"
          allColor="rgba(247, 202, 24, 1)"
        />
      </v-expansion-panel-content>
    </v-expansion-panel>
    <v-card v-if="imageLoaded">
      <v-layout row wrap>
        <v-card max-width="200" v-for="issue in pendingIssues" :key="issue.id">
          <v-layout row wrap>
            <v-flex xs12>
              <v-container grid-list-xs>
                <v-layout row wrap justify-center align-center max-height="100">
                  <v-flex xs6>
                    <v-img :src="getFaceBoxImageForIssue(issue)" />
                  </v-flex>
                  <v-flex xs6>
                    <v-img :src="getStudentImageForIssue(issue)" />
                  </v-flex>
                </v-layout>
                <v-layout row wrap>
                  <v-btn @click="resolveIssue(issue)" flat color="success" block>resolve</v-btn>
                  <v-btn @click="rejectIssue(issue)" flat color="error" block>reject</v-btn>
                </v-layout>
              </v-container>
            </v-flex>
          </v-layout>
        </v-card>
      </v-layout>
    </v-card>
  </div>
</template>

<script>
import _ from 'lodash'

import AttendanceImage from '@/components/attendance/AttendanceImage'
import { AttendanceImageMixin } from '@/mixins/AttendanceImageMixin.js'

export default {
  components: {
    AttendanceImage
  },
  mixins: [AttendanceImageMixin],
  props: {
    students: Object,
    issues: Array,
    image: String
  },
  data() {
    return {
      imageObj: null,
      imageLoaded: false,
      loading: {}
    }
  },
  computed: {
    faceBoxes() {
      return _.map(this.pendingIssues, (issue) => { return issue.face_box })
    },
    pendingIssues() {
      return _.filter(this.issues, (issue) => { return issue.state === 'pending' })
    }
  },
  methods: {
    getFaceBoxImageForIssue(issue) {
      const faceBoxDimensions = this.faceBoxDimensions(issue.face_box)
      return this.getFaceBoxImageBase64(this.imageObj, ...faceBoxDimensions)
    },
    getStudentImageForIssue(issue) {
      return this.students[issue.face_box.student_id].image
    },
    rejectIssue(issue) {
      this.$axios.post(`lecture_instances/${this.$route.params.id}/attendance_issues/${issue.id}/resolve`)
        .then(() => {
          issue.state = 'rejected'
        }).catch((err) => {
          console.error(err) // eslint-disable-line
        })
    },
    resolveIssue(issue) {
      this.$axios.post(`lecture_instances/${this.$route.params.id}/attendance_issues/${issue.id}/resolve`)
        .then(() => {
          issue.state = 'resolved'
          this.$emit('updatecount')
        }).catch((err) => {
          console.error(err) // eslint-disable-line
        })
    }
  },
  mounted: async function () {
    const imageObj = await this.loadImageObject(this.image)
    const canvas = document.createElement('canvas')
    const context = canvas.getContext('2d')

    canvas.width = imageObj.width
    canvas.height = imageObj.height
    imageObj.crossOrigin = 'Anonymous'

    context.drawImage(imageObj, 0, 0)
    this.imageObj = await this.loadImageObject(canvas.toDataURL('image/png'))

    this.imageLoaded = true
  }
}
</script>

<style scoped>

</style>
