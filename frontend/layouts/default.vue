<template>
  <v-app>
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
            {{ user.name }}
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
    <v-toolbar
      app
      clipped-left
      fixed
      color="primary white--text"
    >
      <v-toolbar-side-icon @click.stop="drawer = !drawer" color="white--text" />
      <v-toolbar-title
        class="font-weight-thin"
      >
        {{ title }}
      </v-toolbar-title>

      <v-spacer />

      <v-btn @click="logOut" small color="primary">
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
        &copy;2018 — <strong>Faculty of Engineering</strong>
      </v-flex>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  data() {
    return {

      drawer: true,
      user: {
        name: ''
      },
      items: [
        {
          icon: 'apps',
          title: 'Welcome',
          to: '/'
        },
        {
          icon: 'bubble_chart',
          title: 'timetable',
          to: '/timetable'
        }
      ],
      title: 'University System'
    }
  },
  watch: {
    $route() {
      if (this.$store.state.user) {
        this.user.name = this.$store.state.user.name
      }
    }
  },
  methods: {
    logOut() {
      this.$axios.delete('/auth/sign_out')
        .then((response) => {
          this.$store.commit('auth', {})
          this.$store.commit('user', null)
          this.$axios.setHeader('access-token', '')
          this.$axios.setHeader('uid', '')
          this.$axios.setHeader('client', '')
          this.$router.push('/')
        })
    }
  }
}

</script>
