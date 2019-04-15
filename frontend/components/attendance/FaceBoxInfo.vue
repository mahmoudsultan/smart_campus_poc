<template>
  <v-card>
    <v-toolbar dark color="primary">
      <v-btn icon dark @click="closeDialog">
        <v-icon>close</v-icon>
      </v-btn>
      <v-toolbar-title>{{ studentName }} - {{ studentId }}</v-toolbar-title>
      <v-spacer></v-spacer>
    </v-toolbar>
    <v-card-text>
      <v-layout row wrap>
        <v-flex xs6>
          <v-img :src="image" />
        </v-flex>
        <v-flex xs6>
          <v-img :src="studentImage" />
        </v-flex>
      </v-layout>
    </v-card-text>
    <v-card-actions>
      <v-layout row wrap justify-end>
        <v-btn
          depressed
          ripple
          color="primary"
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
    studentImage: String,
    studentName: String,
    studentId: Number
  },
  methods: {
    closeDialog() {
      this.$emit('close')
    }
  }
}
</script>

<style scoped>

</style>
