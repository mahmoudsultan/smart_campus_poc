<template>
  <v-layout>
    <v-flex xs12>
      <v-card>
        <v-card-title class="card-title-bg white--text justify-center display-3 font-weight-black">
          {{ lecture.title }}
        </v-card-title>

        <v-divider />
        <v-layout row wrap>
          <v-flex xs12 sm6>
            <v-list>
              <v-list-tile>
                <v-layout row wrap>
                  <v-flex xs6>
                    <v-list-tile-content class="font-weight-bold">Code:</v-list-tile-content>
                  </v-flex>
                  <v-flex xs6>
                    <v-list-tile-content class="align-content-start">
                      {{ lecture.code }}
                    </v-list-tile-content>
                  </v-flex>
                </v-layout>
              </v-list-tile>

              <v-list-tile>
                <v-layout row wrap>
                  <v-flex xs6>
                    <v-list-tile-content class="font-weight-bold">Building:</v-list-tile-content>
                  </v-flex>
                  <v-flex xs6>
                    <v-list-tile-content class="align-content-start">
                      {{ lecture.building_name }}
                    </v-list-tile-content>
                  </v-flex>
                </v-layout>
              </v-list-tile>

              <v-list-tile>
                <v-layout row wrap>
                  <v-flex xs6>
                    <v-list-tile-content class="font-weight-bold">Class:</v-list-tile-content>
                  </v-flex>
                  <v-flex xs6>
                    <v-list-tile-content class="align-content-start">
                      {{ lecture.klass_name }}
                    </v-list-tile-content>
                  </v-flex>
                </v-layout>
              </v-list-tile>
            </v-list>
          </v-flex>
          <v-flex xs12 sm6>
            <v-list>
              <v-list-tile>
                <v-layout row wrap>
                  <v-flex xs6>
                    <v-list-tile-content class="font-weight-bold">Start Slot:</v-list-tile-content>
                  </v-flex>
                  <v-flex xs6>
                    <v-list-tile-content class="align-content-start">
                      {{ lecture.start_timeslot }}
                    </v-list-tile-content>
                  </v-flex>
                </v-layout>
              </v-list-tile>

              <v-list-tile>
                <v-layout row wrap>
                  <v-flex xs6>
                    <v-list-tile-content class="font-weight-bold">End Slot:</v-list-tile-content>
                  </v-flex>
                  <v-flex xs6>
                    <v-list-tile-content class="align-content-start">
                      {{ lecture.end_timeslot }}
                    </v-list-tile-content>
                  </v-flex>
                </v-layout>
              </v-list-tile>
            </v-list>
          </v-flex>
        </v-layout>
        <v-divider />

        <v-data-table
          :headers="headers"
          :items="lecture_instances"
          class="elevation-1"
        >
          <template v-slot:items="props">
            <td class="text-xs-left">
              {{ props.item.week_number }}
            </td>
            <td class="text-xs-left">
              {{ props.item.date }}
            </td>
            <td class="text-xs-center">
                <v-btn
                  :href="'/lecture/' + props.item.id + '/attendance/new'"
                  color="blue"
                  fab
                  small
                  dark
                  v-if="user.role==='professor'">
                  <v-icon>add</v-icon>
                </v-btn>
                <v-btn
                  :href="'/lecture/' + props.item.id + '/attendance/edit'"
                  color="green"
                  fab
                  small
                  :disabled='isEditDisabled(props.item.id)'
                  v-if="user.role==='professor'">
                  <v-icon>edit</v-icon>
                </v-btn>
              <template v-if="user.role==='student'">
                {{ props.item.state }}
                <v-btn
                  :href="'/lecture/' + props.item.id + '/attendance/issue'"
                  color="green"
                  fab
                  small
                  :disabled='isEditDisabled(props.item.id)'
                >
                  <v-icon>edit</v-icon>
                </v-btn>
              </template>
            </td>
          </template>
        </v-data-table>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
export default {
  data: () => ({
    lecture: {},
    user: {},
    lecture_instances: [],
    headers: [
      {
        text: 'Week',
        align: 'left',
        sortable: true,
        value: 'week_number'
      },
      {
        text: 'Date',
        align: 'left',
        sortable: true,
        value: 'date'
      }
    ],
    attendance_sheets_info: []
  }),
  async mounted() {
    const lecId = this.$route.params.lec_id
    if (localStorage.getItem(lecId)) {
      this.lecture = JSON.parse(localStorage.getItem(lecId))
    }
    this.lecture.id = lecId
    const lectureInstances = (await this.$axios.get(`/lecture_instances/${lecId}`)).data
    // attendanceSheetInfo = {}
    lectureInstances.forEach(async (li) => {
      const d = new Date(li.date)
      const result = Object.assign({}, li)
      delete result.date
      result.date = `${d.getDate()}/${d.getMonth()}/${d.getFullYear()}`
      this.lecture_instances.push(result)
      const attendanceSheet = (await this.$axios.get(`/lecture_instances/${li.id}/attendance_sheet`)).data
      if (attendanceSheet !== null) {
        this.attendance_sheets_info.push(li.id)
      }
    })

    this.user = this.$store.state.auth.user

    if (this.user.role === 'student') {
      this.headers.push({
        text: 'State',
        align: 'left',
        sortable: true,
        value: 'state'
      })
    } else {
      this.headers.push(
        { text: 'Attendence Sheet', sortable: false, align: 'center' })
    }
  },
  methods: {
    isEditDisabled: function (lectureInstanceId) {
      return !this.attendance_sheets_info.includes(lectureInstanceId)
    }
  }
}
</script>

<style scoped>
.card-title-bg {
  background-color: #16d6cf;
  background-image: linear-gradient(147deg, #16d6cf 0%, #435bb9 74%);
}
</style>
