<template>
  <v-dialog :fullscreen="$vuetify.breakpoint.xs" v-model="show" width="500" transition="dialog-bottom-transition">
    <v-card>
      <v-toolbar dark color="primary">
        <v-btn @click="show = false" icon dark>
          <v-icon>close</v-icon>
        </v-btn>
        <v-toolbar-title>Select an Avatar</v-toolbar-title>
        <v-spacer />
      </v-toolbar>
      <v-layout v-if="avatars" row wrap>
        <v-flex
          v-for="avatar in avatars"
          :key="avatar.id"
          xs4
          sm3
          d-flex
        >
          <v-card tile flat class="d-flex">
            <v-card-text class="d-flex">
              <v-avatar
                @click="selectAvatar(avatar)"
                :class="{ 'current': avatar.id === currentAvatar }"
                size="96"
                class="avatar-picker-avatar"
              >
                <img :src="'/avatars/' + (avatar.path)">
              </v-avatar>
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapGetters } from 'vuex'
export default {
  props: {
    currentAvatar: {
      type: String,
      required: true
    },
    value: Boolean
  },

  computed: {
    ...mapGetters({ 'user': 'auth/user' }),
    avatars() {
      return this.user.image.url
    },

    show: {
      get() {
        return this.value
      },
      set(value) {
        this.$emit('input', value)
      }
    }
  },

  async mounted() {
    await this.$store.dispatch('fetchAvatars')
  },

  methods: {
    selectAvatar(avatar) {
      this.$emit('selected', avatar.id)
      this.show = false
    }
  }
}
</script>
