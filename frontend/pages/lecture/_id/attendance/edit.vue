<template>
  <div>
    <v-breadcrumbs :items="breadCrumbItems" divider=" > "></v-breadcrumbs>
    <v-card>
      Hello
    </v-card>
  </div>
</template>

<script>
import _ from 'lodash'

export default {
  data() {
    return {
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
          text: 'Edit Attendance Sheet',
          disabled: true
        }
      ],
      loading: true,
      image: '',
      faceBoxes: [],
      studentsInfoObj: {}
    }
  },
  mounted: async function () {
    const attendanceSheetRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/attendance_sheet`)
    const studentsInfoRequest = this.$axios.get(`lecture_instances/${this.$route.params.id}/students`)

    await Promise.all([attendanceSheetRequest, studentsInfoRequest]).then(([attendanceSheetRequestResponse, studentsInfoResponse]) => {
      /*
        Parse students data to the form:
        student_id: {
          id: '',
          name: '',
          student_id: '',
          image: 'full url'
        }
      */
      this.image = this.$axios.defaults.baseURL + attendanceSheetRequestResponse.data.image.url
      // this.image = attendanceSheetRequestResponse.data.image.url
      this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes
      // this.faceBoxes = attendanceSheetRequestResponse.data.face_boxes.map((faceBox, index) => {
      //   return { ...faceBox, ...{ id: index } }
      // })

      const studentsInfo = _.each(studentsInfoResponse.data, (studentInfo) => {
        studentInfo.image = this.$axios.defaults.baseURL + studentInfo.image.url
      })
      const studentIds = _.map(studentsInfo, (studentInfo) => {
        return studentInfo.student_id
      })

      this.studentsInfoObj = _.zipObject(studentIds, studentsInfo)

      this.loading = false
    }).catch((err) => {
      console.error(err) // eslint-disable-line
    })
  }
}
</script>

<style scoped>

</style>
