<template>
  <v-layout>
    <v-flex xs12 sm6 offset-sm3>
      <v-card>
        <v-card-title primary-title>
          <div>
            <h3 class="headline mb-0">
              {{ lecture.title }}
            </h3>

            <ul>
              <li>code: {{ lecture.code }}</li>
              <li>building: {{ lecture.building_name }}</li>
              <li>class: {{ lecture.klass_name }}</li>
              <li>start slot: {{ lecture.start_timeslot }}</li>
              <li>end slot: {{ lecture.end_timeslot }}</li>  
            </ul>
          </div>
        </v-card-title>

        <v-card-actions>
          <v-btn flat color="orange">
            Attendence Sheet
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-flex>
  </v-layout>
</template>


<template>
<v-flex
          xs12
          sm6
          md4
          lg3
        >
          <v-card>
            <v-card-title class="subheading font-weight-bold">{{ lecture.title }}</v-card-title>

            <v-divider></v-divider>

            <v-list dense>
              <v-list-tile>
                <v-list-tile-content>Code:</v-list-tile-content>
                <v-list-tile-content class="align-end">{{ lecture.code }}</v-list-tile-content>
              </v-list-tile>

              <v-list-tile>
                <v-list-tile-content>Building:</v-list-tile-content>
                <v-list-tile-content class="align-end">{{ lecture.building }}</v-list-tile-content>
              </v-list-tile>

              <v-list-tile>
                <v-list-tile-content>Class:</v-list-tile-content>
                <v-list-tile-content class="align-end">{{ lecture.klass_name }}</v-list-tile-content>
              </v-list-tile>

              <v-list-tile>
                <v-list-tile-content>Start Slot:</v-list-tile-content>
                <v-list-tile-content class="align-end">{{ lecture.start_timeslot }}</v-list-tile-content>
              </v-list-tile>

              <v-list-tile>
                <v-list-tile-content>End Slot:</v-list-tile-content>
                <v-list-tile-content class="align-end">{{ lecture.end_timeslot }}</v-list-tile-content>
              </v-list-tile>

            </v-list>
          <v-card-actions>
          <v-btn flat color="orange">
            Attendence Sheet
          </v-btn>
        </v-card-actions>
          </v-card>
        </v-flex>  


</template>




<script>
export default {
  data: () => ({
    lecture: {}
  }),
  mounted() {
    // eslint-disable-next-line no-console
    console.log(this.$route.params.lec)
    this.lecture = this.$route.params.lec
    // this.$axios
    //   .$get(`http://localhost:5000/lectures/${this.$route.params.lec_id}`)
    //   .then(lec => {
    //     this.lecture = lec
    //   })
  }
}
</script>
