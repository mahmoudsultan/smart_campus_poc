<template>
  <v-app>
    <template v-if="isAuthenticated">
      <v-navigation-drawer
        v-model="drawer"
        app
        clipped
        fixed
        hide-overlay
      >
        <v-list expand>
          <v-list-tile
            avatar
          >
            <v-list-tile-avatar
              color="white"
            >
              <v-img
                src="https://source.unsplash.com/600x320/?face,human"
                contain
              />
            </v-list-tile-avatar>
            <v-list-tile-title>
              {{ user.name | user.role }}
            </v-list-tile-title>
          </v-list-tile>

          <v-list-tile
            v-for="item in items"
            :to="item.to"
            :key="item.title"
            no-action
          >
            <v-list-tile-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-tile-action>
            <v-list-tile-title
              v-text="item.title"
            />
          </v-list-tile>
        </v-list>
      </v-navigation-drawer>
    </template>

    <v-toolbar
      app
      clipped-left
      fixed
      color="primary white--text"
    >
      <v-toolbar-side-icon v-if="isAuthenticated" @click.stop="drawer = !drawer" color="white--text" />
      <v-toolbar-title
        class="font-weight-thin"
      >
        {{ title }}
      </v-toolbar-title>

      <v-spacer />

      <v-btn v-if="isAuthenticated" @click="logOutWrapper" small color="primary">
        Log out
      </v-btn>
    </v-toolbar>
    <v-content>
      <v-container fluid>
        <nuxt />
      </v-container>
    </v-content>
    <v-footer
      app
      color="secondaryDark"
      inset
    >
      <v-flex
        text-xs-center
        white--text
        xs12
        class="font-weight-thin"
      >
        &copy;{{ currentYear }} — <strong>Faculty of Engineering</strong>
      </v-flex>
    </v-footer>
  </v-app>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
export default {
  data() {
    return {

      drawer: true,
      items: [
        {
          icon: 'person',
          title: 'Home',
          to: '/'
        },
        {
          icon: 'event',
          title: 'Timetable',
          to: '/timetable'
        }
      ],
      title: 'University System'
    }
  },
  computed: {
    currentYear() {
      return new Date().getFullYear()
    },
    user: function () {
      // eslint-disable-next-line no-console
      console.log(this.$store.state.auth.user)
      return this.$store.state.auth.user
    },
    ...mapGetters({ isAuthenticated: 'auth/isAuthenticated' })
  },
  methods: {
    ...mapActions({ logOut: 'auth/logout' }),

    logOutWrapper() {
      this.logOut().then(() => {
        this.$router.push('/')
      })
    }
  }
}

</script>
