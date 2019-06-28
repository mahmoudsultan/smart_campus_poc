<template>
  <div id="app">
    <v-app id="inspire">
      <v-content>
        <v-container fluid fill-height>
          <v-layout align-center justify-center>
            <v-flex xs12 sm8 md4>
              <v-card class="elevation-12">
                <v-toolbar dark color="primary">
                  <v-toolbar-title>{{ formTitle }}</v-toolbar-title>
                  <v-spacer />
                </v-toolbar>
                <v-card-text>
                  <v-form ref="form">
                    <v-text-field
                      v-model="email"
                      :rules="rules"
                      label="E-mail"
                      required
                    />
                    <v-text-field
                      v-model="password"
                      :append-icon="showPassword ? 'visibility' : 'visibility_off'"
                      :type="showPassword ? 'text' : 'password'"
                      @click:append="()=>{showPassword = !showPassword}"
                      name="password"
                      required
                      label="Password"
                    />

                    <v-text-field
                      v-if="newUser"
                      v-model="name"
                      label="Name"
                      required
                    />

                    <v-text-field
                      v-if="newUser"
                      v-model="department"
                      label="Department"
                      required
                    />

                    <v-select
                      v-if="newUser"
                      v-model="chosenRole"
                      :items="roles"
                      required
                      label="Role"
                    />
                  </v-form>
                </v-card-text>
                <v-card-actions>
                  <v-spacer />
                  <v-btn v-if="!newUser" @click="signIn">
                    sign in
                  </v-btn>

                  <v-btn v-if="newUser" @click="signUp">
                    sign up
                  </v-btn>

                  <v-btn @click="()=>newUser=!newUser" flat small color="primary">
                    {{ signUpToggleText }}
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </v-content>
      <v-snackbar
        v-model="wrongCredentials"
        :color="'error'"
      >
        Wrong email or password
        <v-btn
          @click="wrongCredentials = false"
          dark
          flat
        >
          Close
        </v-btn>
      </v-snackbar>
    </v-app>
  </div>
</template>

<script>
export default {

  data: () => ({
    wrongCredentials: false,
    showPassword: false,
    name: '',
    password: '',
    email: '',
    department: '',
    roles: ['professor', 'student'],
    chosenRole: '',
    newUser: false
  }),
  computed: {
    signUpToggleText() {
      return this.newUser ? 'already a user? sign in' : 'new user? sign up'
    },
    formTitle() {
      return this.newUser ? 'Sign Up' : 'Sign In'
    },
    rules() {
      const rules = []
      const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      const emailRule = e => re.test(e.toLowerCase()) || 'invalid email format'
      rules.push(emailRule)
      return rules
    }
  },
  methods: {
    signIn() {
      this.$refs.form.validate()
      this.$store.dispatch('auth/signIn', { app: this,
        email: this.email,
        password: this.password
      }).then(() => {
        this.$router.push('/')
      }).catch((err) => {
        this.wrongCredentials = true
        this.email = ''
        this.password = ''
        // eslint-disable-next-line no-console
        console.error(err)
      })
    },

    signUp() {
      this.$store.dispatch('auth/signUp', { app: this,
        email: this.email,
        password: this.password,
        name: this.name,
        department: this.department,
        role: this.chosenRole }).then(() => {
        this.$router.push('/')
      })
    }

  }
}
</script>

<style>

</style>
