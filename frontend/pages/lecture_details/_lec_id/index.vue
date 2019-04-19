<template>
  <v-layout>
    <v-flex
      xs12
      sm6
      md4
      lg3
      align-center 
      offset-sm3
    >
      <v-card>
        <v-card-title class="subheading font-weight-bold">
          {{ lecture.title }}
        </v-card-title>

        <v-divider />

        <v-list dense>
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
        <v-card-actions>
          <v-btn flat color="orange">
            Attendence Sheet
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
export default {
  data: () => ({
    lecture: {}
  }),
  mounted() {
    const lecId = this.$route.params.lec_id
    // eslint-disable-next-line no-console
    console.log(lecId)
    if (localStorage.getItem(lecId)) {
      this.lecture = JSON.parse(localStorage.getItem(lecId))
    }
  }
}
</script>
