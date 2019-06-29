<template>
   <div>
    <v-container v-if="user.role==='professor'" grid-list-xs>
      <v-layout row wrap>
        <v-flex xs12 sm8>
          <v-card>
            <v-card-title>
              <span class="display-1 font-weight-light">Timetable</span>
            </v-card-title>
            <v-card-text>
              <v-layout row wrap>
                <v-flex>
                  <v-layout
                    column
                    align-start
                  >
                    <div class="caption grey--text text-uppercase">
                      Courses
                    </div>
                    <div>
                      <span
                        class="display-2 font-weight-black"
                        v-text="numberOfCourses"
                      ></span>
                    </div>
                  </v-layout>
                </v-flex>
                <v-flex>
                  <v-layout
                    column
                    align-start
                  >
                    <div class="caption grey--text text-uppercase">
                      Lectures
                    </div>
                    <div>
                      <span
                        class="display-2 font-weight-black"
                        v-text="numberOfLectures"
                      ></span>
                    </div>
                  </v-layout>
                </v-flex>
                <v-flex>
                  <v-layout
                    column
                    align-start
                  >
                    <div class="caption grey--text text-uppercase">
                      Students
                    </div>
                    <div>
                      <span
                        class="display-2 font-weight-black"
                        v-text="numberOfStudents"
                      ></span>
                    </div>
                  </v-layout>
                </v-flex>
              </v-layout>
              <v-spacer></v-spacer>
              <v-divider class="mt-4"></v-divider>
              <v-layout row wrap>
                <v-flex xs12 class="pa-0 ma-0">
                  <Timetable />
                </v-flex>
              </v-layout>
            </v-card-text>
          </v-card>
        </v-flex>
        <v-flex xs12 sm4>
          <v-layout align-center row wrap>
              <v-flex fill-height xs12>
                <v-card href="/issues" color="primary" dark>
                  <v-card-title>
                    <span class="headline font-weight-light">Attendance Issues</span>
                  </v-card-title>
                  <v-card-text>
                    <p class="text-xs-center">
                      <v-icon
                        size="90"
                      >
                        error
                      </v-icon>
                    </p>
                  </v-card-text>
                </v-card>
              </v-flex>
              <v-flex fill-height xs12>
                <v-card href="/profile" color="secondaryDark" dark>
                  <v-card-title>
                    <span class="headline font-weight-light">Update Profile</span>
                  </v-card-title>
                  <v-card-text>
                    <p class="text-xs-center">
                      <v-icon size="90">person</v-icon>
                    </p>
                  </v-card-text>
                </v-card>
              </v-flex>
            </v-layout>
          </v-flex>
      </v-layout>
      <v-layout class="mt-4" row wrap>
        <v-flex xs12>
          <v-card>
            <v-card-title class="mb-0">
              <span class="display-1 font-weight-light">Attendance Analytics</span>
              <v-spacer></v-spacer>
              <v-flex xs4>
                <v-select
                  :items="courses"
                  value="selectedCourseForAnalytics"
                  label="Choose Course"
                  outline
                ></v-select>
              </v-flex>
            </v-card-title>
            <v-card-text class="mt-0">
              <v-sheet
                color="cyan"
                elevation="10"
                max-width="calc(100%)"
              >
                <v-sparkline
                  :labels="labels"
                  :value="value"
                  color="white"
                  line-width="1"
                  padding="16"
                  auto-draw
                  auto-line-width
                  show-labels
                  label-size="3"
                ></v-sparkline>
              </v-sheet>
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
    <update-profile v-else />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import _ from 'lodash'

import Timetable from '@/components/profile/Timetable'
import UpdateProfile from '@/components/profile/UpdateProfile'

export default {
  components: {
    Timetable,
    UpdateProfile
  },
  data() {
    return {
      statistics: {},
      labels: [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10'
      ],
      value: [
        200,
        675,
        410,
        390,
        310,
        200,
        675,
        410,
        390,
        310
      ],
      selectedCourseForAnalytics: null,
      courses: []
    }
  },
  computed: {
    ...mapGetters({ 'user': 'auth/user' }),
    numberOfCourses() {
      if (this.statistics.courses === undefined) {
        return '-'
      } else {
        return this.statistics.courses
      }
    },
    numberOfLectures() {
      if (this.statistics.lectures === undefined) {
        return '-'
      } else {
        return this.statistics.lectures
      }
    },
    numberOfStudents() {
      if (this.statistics.students === undefined) {
        return '-'
      } else {
        return this.statistics.students
      }
    }
  },
  watch: {
    selectedCourseForAnalytics: async (course) => {
      const response = (await this.$axios.get(`course/${course}/attendance_statistics`)).data
      this.values = response.values
      this.labels = response.labels
    }
  },
  async mounted() {
    if (this.user.role === 'professor') {
      // Get Statistics
      const statisticsRequest = this.$axios.get('users/statistics')
      const coursesRequest = this.$axios.get('users/courses')

      await Promise.all([statisticsRequest, coursesRequest]).then(([statisticsResponse, coursesResponse]) => {
        this.statistics = statisticsResponse.data
        this.courses = _.map(coursesResponse.data.courses, (c) => { return c.title })
      })
    }
  }
}
</script>

<style scoped>
</style>
