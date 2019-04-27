<template>
    <v-card>
      <v-toolbar dark color="primary">
        <v-btn icon dark @click="dialog = false">
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
                <v-icon x-large>arrow_left</v-icon>
              </v-flex>
              <v-flex xs10>
                <v-img src="https://randomuser.me/api/portraits/men/1.jpg" />
              </v-flex>
              <v-flex xs1>
                <v-icon x-large>arrow_right</v-icon>
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
            <v-list dark three-line>
              <v-list-tile color="success" avatar>
                <v-list-tile-avatar size="50">
                  <img src="https://randomuser.me/api/portraits/men/1.jpg">
                </v-list-tile-avatar>
                <v-list-tile-content>
                  <v-list-tile-title>John Doe</v-list-tile-title>
                  <v-list-tile-sub-title>ID: 5666</v-list-tile-sub-title>
                </v-list-tile-content>
                <v-list-tile-action>
                  <v-btn color="success">Assign</v-btn>
                </v-list-tile-action>
              </v-list-tile>
            </v-list>
          </v-flex>
          <v-flex xs12 md6>
            <v-subheader>Or Choose by Image: </v-subheader>
            <v-container fullscreen style="max-height: 90vh; overflow: scroll;"  fluid grid-list-sm>
              <v-layout row wrap>
                <v-flex v-for="i in 36" :key="i" xs4>
                  <img
                    @click="chooseStudentByImage"
                    :src="`https://randomuser.me/api/portraits/men/${i + 20}.jpg`"
                    class="student-image"
                    alt="lorem"
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
      onFocusFaceBoxIndex: -1,
      choosedStudentIndex: -1
    }
  },
  computed: {
    onFocusFaceBoxImage() {
      return this.faceBoxes[this.onFocusFaceBoxImage].image
    }
  },
  methods: {
    chooseStudentByImage() {
      console.error('Not yet implemented') // eslint-disable-line
    }
  }
}
</script>

<style scoped>
  .student-image {
    cursor: pointer;
  }
</style>
