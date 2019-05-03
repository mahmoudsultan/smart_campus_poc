<template>
  <v-layout wrap align-center>
    <form>
      <v-text-field
        v-model="email"
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
    </form>
  </v-layout>
</template>

<script>
import { setAuthState } from '@/utils/auth'

export default {
  data: () => ({
    showPassword: false,
    name: '',
    password: '',
    email: '',
    department: '',
    roles: ['professor', 'student'],
    chosenRole: '',
    newUser: false
  }),
  methods: {
    updateHeadersAndSetUser(response) {
      setAuthState(this, response)
      this.$router.push('/')
    },

    signIn() {
      this.$store.dispatch('auth/signIn', { app: this,
        email: this.email,
        password: this.password
      }).then(() => {
        // eslint-disable-next-line no-console
        console.log(this.$ability)

        this.$router.push('/')
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
