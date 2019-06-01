<template>
  <v-container
    fill-height
    fluid
    grid-list-xl
  >
    <v-layout
      justify-center
      wrap
    >
      <v-flex
        xs12
        md8
      >
        <v-form>
          <v-container py-0>
            <v-layout wrap>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.department"
                  label="Department"
                  disabled
                />
              </v-flex>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.name"
                  label="Name"
                />
              </v-flex>
              <v-flex
                xs12
                md4
              >
                <v-text-field
                  :value="user.email"
                  label="Email"
                />
              </v-flex>

              <v-flex
                xs12
                text-xs-right
              >
                <v-btn
                  class="mx-0 font-weight-light"
                  color="success"
                >
                  Update Profile
                </v-btn>
              </v-flex>
            </v-layout>
          </v-container>
        </v-form>
        </material-card>
      </v-flex>
      <v-flex
        xs12
        md4
      >
        <material-card class="v-card-profile">
          <v-avatar
            slot="offset"
            class="mx-auto d-block"
            size="130"
          >
            <img
              src="https://demos.creative-tim.com/vue-material-dashboard/img/marc.aba54d65.jpg"
            >
          </v-avatar>
          <v-card-text class="text-xs-center">
            <h4 class="card-title font-weight-light">
              {{ user.name }}
            </h4>
            <h4 class="category text-gray font-weight-light">
              {{ user.role }}
            </h4>
            <h4 class="category text-gray font-weight-light">
              {{ user.department }}
            </h4>
          </v-card-text>
        </material-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters({ 'user': 'auth/user' })
  },
  mounted() {
    // eslint-disable-next-line no-console
    console.log(this.user)
  }

}
</script>
