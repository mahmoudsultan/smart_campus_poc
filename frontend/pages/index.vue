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
                md12
              >
                <avatar-picker
                  :avatars="user.avatars"
                  @select="selectAvatar"
                  @load="loadAvatar"
                  @remove="removeAvatar"
                />
              </v-flex>

              <v-flex
                xs12
                text-xs-right
              >
                <v-btn
                  @click="sendUpdates"
                  color="info"
                >
                  Update Profile
                </v-btn>
              </v-flex>
            </v-layout>
          </v-container>
        </v-form>
      </v-flex>
      <v-flex
        xs12
        md4
      >
        <v-avatar
          slot="offset"
          class="mx-auto d-block"
          size="130"
          color="indigo"
        >
          <img
            v-if="mainAvatar"
            :src="mainAvatar.image"
          >
          <v-icon v-else dark size="130">
            account_circle
          </v-icon>
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
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex'
// import AvatarPicker from '~/components/AvatarPicker'
// import VueBase64FileUpload from '@/components/VueBase64FileUpload'
import AvatarPicker from '@/components/AvatarPicker'
export default {
  components: { AvatarPicker },
  data: function () {
    return {
      mainAvatar: ''
    }
  },

  computed: {
    ...mapGetters({ 'user': 'auth/user' })

  },
  mounted() {
    this.fetchAvatars()
    // eslint-disable-next-line no-console
    console.log(this.user)
    this.mainAvatar = (!this.user.avatars.length && this.user.avatars[0])
  },
  methods: {
    ...mapMutations({ 'addAvatar': 'auth/addAvatar', 'deleteAvatar': 'auth/deleteAvatar' }),
    ...mapActions({ 'sendUpdates': 'auth/sendUpdates', 'fetchAvatars': 'auth/fetchAvatars' }),
    loadAvatar(dataUri) {
      this.addAvatar(dataUri)
      // this.avatars = this.user.avatars
    },
    removeAvatar(id) {
      this.deleteAvatar(id)
      // this.avatars = this.user.avatars
    },
    selectAvatar(id) {
      this.mainAvatar = this.user.avatars.filter(a => id === a.id)[0]
    }
  }

}
</script>
