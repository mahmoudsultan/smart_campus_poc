<template>
  <v-layout>
    <v-flex xs12>
      <v-card>
        <v-card-title class="justify-center display-3 font-weight-black">
          {{ lecture.title }}
        </v-card-title>

        <v-divider />

        <v-list>
          <v-list-tile>
            <v-list-tile-content>Code:</v-list-tile-content>
            <v-list-tile-content class="align-end">
              {{ lecture.code }}
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile>
            <v-list-tile-content>Building:</v-list-tile-content>
            <v-list-tile-content class="align-end">
              {{ lecture.building_name }}
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile>
            <v-list-tile-content>Class:</v-list-tile-content>
            <v-list-tile-content class="align-end">
              {{ lecture.klass_name }}
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile>
            <v-list-tile-content>Start Slot:</v-list-tile-content>
            <v-list-tile-content class="align-end">
              {{ lecture.start_timeslot }}
            </v-list-tile-content>
          </v-list-tile>

          <v-list-tile>
            <v-list-tile-content>End Slot:</v-list-tile-content>
            <v-list-tile-content class="align-end">
              {{ lecture.end_timeslot }}
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
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
            <td class="text-xs-left">
              <v-btn color="primary" fab small dark>
                <v-icon>edit</v-icon>
              </v-btn>
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
      },
      { text: 'Attendence Sheet' }
    ]
  }),
  mounted() {
    const lecId = this.$route.params.lec_id
    // eslint-disable-next-line no-console
    console.log(lecId)
    if (localStorage.getItem(lecId)) {
      this.lecture = JSON.parse(localStorage.getItem(lecId))
    }
    this.$axios.get(`/lecture_instances/${lecId}`).then(res => {
      // eslint-disable-next-line no-console
      console.log(res.data)
      res.data.forEach(li => {
        const d = new Date(li.date)
        this.lecture_instances.push({
          week_number: li.week_number,
          date: `${d.getDate()}/${d.getMonth()}/${d.getFullYear()}`
        })
      })
    })
  }
}
</script>
