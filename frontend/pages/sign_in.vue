<template>
  <v-layout wrap align-center>
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

      <v-btn v-if="!newUser" @click="signIn">
        sign in
      </v-btn>

      <v-btn v-if="newUser" @click="signUp">
        sign up
      </v-btn>

      <v-btn @click="()=>newUser=!newUser" flat small color="primary">
        {{ newUser?'already a user? sign in':'new user? sign up' }}
      </v-btn>
    </v-form>
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
  </v-layout>
</template>

<script>
import { setAuthState } from '@/utils/auth'
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
    rules() {
      const rules = []
      const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      const emailRule = e => re.test(e.toLowerCase()) || 'invalid email format'
      rules.push(emailRule)
      return rules
    }
  },
  methods: {
    updateHeadersAndSetUser(response) {
      setAuthState(this, response)
      this.$router.push('/')
    },

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
        console.log(err)
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
