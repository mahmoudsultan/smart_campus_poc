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
              <li>class: {{ lecture.class_name }}</li>
              <li>start slot: {{ lecture.start_slot }}</li>
              <li>end slot: {{ lecture.end_slot }}</li>  
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

<script>
export default {
  data: () => ({
    lecture: {}
  }),
  mounted() {
    this.$axios
      .$get(`http://localhost:5000/lectures/${this.$route.params.lec_id}`)
      .then(lec => {
        this.lecture = lec
      })
  }
}
</script>
